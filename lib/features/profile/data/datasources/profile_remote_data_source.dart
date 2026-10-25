import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';

abstract class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> getProfile(String userId);
  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  });
  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? previousAvatarUrl,
  });
  Future<List<Map<String, dynamic>>> getCategories();
  Future<List<Map<String, dynamic>>> getFavoriteCategories(String userId);
  Future<void> setFavoriteCategories({
    required String userId,
    required List<String> categoryIds,
  });
  Future<void> saveFavoriteCategoriesToProfile({
    required String userId,
    required List<String> categories,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient? _supabaseClient;
  final SupabaseStorageService? _storageServiceParam;

  ProfileRemoteDataSourceImpl({
    SupabaseClient? supabaseClient,
    SupabaseStorageService? storageService,
  })  : _supabaseClient = supabaseClient,
        _storageServiceParam = storageService;

  SupabaseClient get _client => _supabaseClient ?? Supabase.instance.client;
  SupabaseStorageService get _storageService =>
      _storageServiceParam ?? SupabaseStorageService(supabaseClient: _client);

  @override
  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? previousAvatarUrl,
  }) async {
    String? effectivePreviousUrl = previousAvatarUrl?.trim();
    if (effectivePreviousUrl == null || effectivePreviousUrl.isEmpty) {
      try {
        final existing = await _client
            .from('profiles')
            .select('avatar_url')
            .eq('id', userId)
            .maybeSingle();
        if (existing != null && existing['avatar_url'] != null) {
          effectivePreviousUrl = existing['avatar_url']?.toString();
        }
      } catch (_) {}
    }

    final newUrl = await _storageService.uploadAvatar(
      userId: userId,
      bytes: bytes,
      fileExtension: fileExtension,
      previousAvatarUrl: effectivePreviousUrl,
    );

    await updateProfile(userId: userId, avatarUrl: newUrl);

    try {
      await _client.auth
          .updateUser(UserAttributes(data: {'avatar_url': newUrl}));
    } catch (_) {}

    try {
      await _client
          .from('articles')
          .update({'author_avatar': newUrl})
          .eq('author_id', userId);
    } catch (_) {}

    try {
      await CurrentUserSession.cacheUserAvatarUrl(newUrl);
    } catch (_) {}

    return newUrl;
  }

  @override
  Future<Map<String, dynamic>> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return Map<String, dynamic>.from(response);
  }

  @override
  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (displayName != null) updates['display_name'] = displayName;
    if (bio != null) updates['bio'] = bio;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    updates['updated_at'] = DateTime.now().toIso8601String();

    final response = await _client
        .from('profiles')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();
    return Map<String, dynamic>.from(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getFavoriteCategories(String userId) async {
    String effectiveId = userId.trim();
    final isUuid = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(effectiveId);

    if (!isUuid) {
      try {
        final currentAuthId = _client.auth.currentUser?.id;
        if (currentAuthId != null && currentAuthId.isNotEmpty) {
          effectiveId = currentAuthId;
        }
      } catch (_) {}
    }

    if (effectiveId.isEmpty) {
      return [];
    }

    // Primary source: check profiles.favorite_categories (text[] array in profiles table)
    try {
      final response = await _client
          .from('profiles')
          .select('favorite_categories')
          .eq('id', effectiveId)
          .maybeSingle();

      if (response != null) {
        final raw = response['favorite_categories'];
        if (raw is List && raw.isNotEmpty) {
          return raw
              .map((item) => {
                    'name': item.toString(),
                    'category_name': item.toString(),
                  })
              .toList();
        }
        // Profile exists and favorite_categories is empty or null: user has no categories
        return [];
      }
    } catch (_) {}

    return [];
  }

  @override
  Future<void> setFavoriteCategories({
    required String userId,
    required List<String> categoryIds,
  }) async {
    await _client.rpc(
      'set_user_favorite_categories',
      params: {'p_category_ids': categoryIds},
    );
  }

  @override
  Future<void> saveFavoriteCategoriesToProfile({
    required String userId,
    required List<String> categories,
  }) async {
    String effectiveId = userId.trim();
    final isUuid = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(effectiveId);

    if (!isUuid) {
      try {
        final currentAuthId = _client.auth.currentUser?.id;
        if (currentAuthId != null && currentAuthId.isNotEmpty) {
          effectiveId = currentAuthId;
        }
      } catch (_) {}
    }

    if (effectiveId.isEmpty) return;

    await _client.from('profiles').update({
      'favorite_categories': categories,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', effectiveId);
  }
}
