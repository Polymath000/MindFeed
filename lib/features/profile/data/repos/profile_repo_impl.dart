import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/networking/api_error_handler.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/networking/network_info.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mind_feed/features/profile/domain/repos/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo? networkInfo;
  bool _isReconciling = false;

  ProfileRepoImpl({
    required this.remoteDataSource,
    this.networkInfo,
  });

  NetworkInfo get _effectiveNetworkInfo {
    if (networkInfo != null) return networkInfo!;
    try {
      if (getIt.isRegistered<NetworkInfo>()) {
        return getIt<NetworkInfo>();
      }
    } catch (_) {}
    return NetworkInfoImpl(Connectivity());
  }

  @override
  Future<ApiResult<String>> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? previousAvatarUrl,
  }) async {
    if (await _effectiveNetworkInfo.isConnected) {
      try {
        final result = await remoteDataSource.uploadAvatar(
          userId: userId,
          bytes: bytes,
          fileExtension: fileExtension,
          previousAvatarUrl: previousAvatarUrl,
        );
        return Success(result);
      } catch (e) {
        return FailureResult(ApiErrorHandler.handle(e).toFailure());
      }
    } else {
      return const FailureResult(ServerFailure('You are Offline'));
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile(String userId) async {
    try {
      final profile = await remoteDataSource.getProfile(userId);
      return Success(profile);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final updated = await remoteDataSource.updateProfile(
        userId: userId,
        displayName: displayName,
        bio: bio,
        avatarUrl: avatarUrl,
      );
      return Success(updated);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Success(categories);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getFavoriteCategories(String userId) async {
    try {
      final favorites = await remoteDataSource.getFavoriteCategories(userId);
      try {
        await SharedPreferencesSingleton.setBool(
          AppConstants.hasCompletedCategoriesKey,
          value: favorites.isNotEmpty,
        );
      } catch (_) {}
      return Success(favorites);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> saveLocalCategories({
    required String userId,
    required List<String> categoryNames,
    UserEntity? currentUser,
  }) async {
    try {
      if (Hive.isBoxOpen(AppConstants.userKey)) {
        final box = Hive.box<UserEntity>(AppConstants.userKey);
        final current = box.get(AppConstants.userKey) ?? currentUser;
        final updated = current != null
            ? current.copyWith(categories: categoryNames)
            : UserEntity(
                favoriteCategories: categoryNames,
                email: null,
                userName: null,
                token: null,
              );
        await box.put(AppConstants.userKey, updated);
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> syncFavoriteCategories({
    required String userId,
    required List<String> categoryNames,
  }) async {
    final syncKey = 'pending_category_sync_$userId';
    try {
      await SharedPreferencesSingleton.setBool(syncKey, value: true);
      await SharedPreferencesSingleton.setBool('pending_category_sync', value: true);
    } catch (_) {}

    try {
      // 1. Primary: Save directly to profiles.favorite_categories
      try {
        await remoteDataSource.saveFavoriteCategoriesToProfile(
          userId: userId,
          categories: categoryNames,
        );
      } catch (_) {}

      // 2. Also sync to junction table via RPC if available
      final categoryRows = await remoteDataSource.getCategories();
      final matchingIds = <String>[];
      for (final name in categoryNames) {
        final match = categoryRows.firstWhere(
          (c) =>
              (c['name'] as String? ?? '').toLowerCase().contains(name.toLowerCase()) ||
              (c['slug'] as String? ?? '').toLowerCase().contains(name.toLowerCase()),
          orElse: () => {},
        );
        if (match.isNotEmpty && match['id'] != null) {
          matchingIds.add(match['id'].toString());
        }
      }

      await remoteDataSource.setFavoriteCategories(
        userId: userId,
        categoryIds: matchingIds,
      );

      try {
        await SharedPreferencesSingleton.setBool(syncKey, value: false);
        await SharedPreferencesSingleton.setBool('pending_category_sync', value: false);
        await SharedPreferencesSingleton.setBool(
          AppConstants.hasCompletedCategoriesKey,
          value: categoryNames.isNotEmpty,
        );
      } catch (_) {}

      return const Success(null);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> reconcilePendingCategorySync({String? userId}) async {
    if (_isReconciling) return false;
    _isReconciling = true;
    try {
      userId ??= Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return false;

      final userSyncKey = 'pending_category_sync_$userId';
      final isUserPending = SharedPreferencesSingleton.getBool(userSyncKey) ?? false;

      if (!isUserPending) {
        return false;
      }

      List<String>? desiredCategories;
      if (Hive.isBoxOpen(AppConstants.userKey)) {
        final box = Hive.box<UserEntity>(AppConstants.userKey);
        final user = box.get(AppConstants.userKey);
        desiredCategories = user?.favoriteCategories;
      }

      if (desiredCategories == null) {
        return false;
      }

      final syncResult = await syncFavoriteCategories(
        userId: userId,
        categoryNames: desiredCategories,
      );

      return syncResult is Success;
    } catch (_) {
      return false;
    } finally {
      _isReconciling = false;
    }
  }
}
