import 'dart:async';

import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';

class CurrentUserSnapshot {
  final String? id;
  final String? email;
  final String? displayName;
  final String? avatarUrl;

  const CurrentUserSnapshot({
    this.id,
    this.email,
    this.displayName,
    this.avatarUrl,
  });
}

sealed class CurrentUserSession {
  static CurrentUserSnapshot? resolveCurrentUser() {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return null;
      final meta = user.userMetadata ?? const <String, dynamic>{};
      final rawName =
          (meta['display_name'] ?? meta['full_name'] ?? meta['username'])
              ?.toString()
              .trim();
      final emailPrefix = user.email?.split('@').first;
      final cachedUser = resolveCachedUserEntity();
      final rawAvatar =
          meta['avatar_url']?.toString() ?? cachedUser?.avatarUrl;
      return CurrentUserSnapshot(
        id: user.id,
        email: user.email,
        displayName:
            (rawName != null && rawName.isNotEmpty) ? rawName : emailPrefix,
        avatarUrl: SupabaseStorageService.resolveAvatarUrl(rawAvatar),
      );
    } catch (_) {
      return null;
    }
  }

  static String? get currentUserId => resolveCurrentUser()?.id;

  static StreamSubscription<dynamic>? listenToAuthEvents({
    required void Function(String accessToken) onSignedIn,
    required void Function() onPasswordRecovery,
  }) {
    try {
      return Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        final token = data.session?.accessToken;
        if (data.event == AuthChangeEvent.signedIn &&
            token != null &&
            token.isNotEmpty) {
          onSignedIn(token);
        } else if (data.event == AuthChangeEvent.passwordRecovery) {
          onPasswordRecovery();
        }
      });
    } catch (_) {
      return null;
    }
  }

  static UserEntity? resolveCachedUserEntity() {
    try {
      if (Hive.isBoxOpen(AppConstants.userKey)) {
        return Hive.box<UserEntity>(AppConstants.userKey)
            .get(AppConstants.userKey);
      }
    } catch (_) {}
    return null;
  }

  static Future<void> cacheUserCategories(List<String> categoryNames) async {
    try {
      if (Hive.isBoxOpen(AppConstants.userKey)) {
        final box = Hive.box<UserEntity>(AppConstants.userKey);
        final current = box.get(AppConstants.userKey);
        if (current != null) {
          await box.put(
            AppConstants.userKey,
            current.copyWith(categories: categoryNames),
          );
        }
      }
    } catch (_) {}
  }

  static Future<void> cacheUserAvatarUrl(String avatarUrl) async {
    try {
      if (Hive.isBoxOpen(AppConstants.userKey)) {
        final box = Hive.box<UserEntity>(AppConstants.userKey);
        final current = box.get(AppConstants.userKey);
        if (current != null) {
          await box.put(
            AppConstants.userKey,
            current.copyWith(avatarUrl: avatarUrl),
          );
        }
      }
    } catch (_) {}
  }
}
