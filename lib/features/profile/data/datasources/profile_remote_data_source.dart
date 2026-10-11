import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> getProfile(String userId);
  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  });
  Future<List<Map<String, dynamic>>> getCategories();
  Future<List<Map<String, dynamic>>> getFavoriteCategories(String userId);
  Future<void> setFavoriteCategories({
    required String userId,
    required List<String> categoryIds,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient? _supabaseClient;

  ProfileRemoteDataSourceImpl({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient;

  SupabaseClient get _client => _supabaseClient ?? Supabase.instance.client;

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
    final response = await _client
        .from('profile_favorite_categories')
        .select('category_id, categories(*)')
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> setFavoriteCategories({
    required String userId,
    required List<String> categoryIds,
  }) async {
    await _client
        .from('profile_favorite_categories')
        .delete()
        .eq('user_id', userId);

    if (categoryIds.isNotEmpty) {
      final rows = categoryIds
          .map((catId) => {'user_id': userId, 'category_id': catId})
          .toList();
      await _client.from('profile_favorite_categories').insert(rows);
    }
  }
}
