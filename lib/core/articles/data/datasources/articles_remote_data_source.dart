import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/core/articles/data/models/article_model.dart';
import 'package:mind_feed/core/articles/data/models/category_model.dart';
import 'package:mind_feed/core/articles/data/models/tag_model.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';

abstract class ArticlesRemoteDataSource {
  Future<List<ArticleModel>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  });
  Future<ArticleModel> getArticleById(String id);
  Future<List<ArticleModel>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  });
  Future<List<ArticleModel>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  });
  Future<List<ArticleModel>> searchArticles(
    String query, {
    int limit = 20,
    int offset = 0,
  });
  Future<List<ArticleModel>> getArticlesByTag(
    String tag, {
    int limit = 20,
    int offset = 0,
  });
  Future<List<CategoryModel>> getCategories();
  Future<List<TagModel>> getFixedTags();
  Future<void> starArticle(String articleId, String userId);
  Future<void> unstarArticle(String articleId, String userId);
  Future<bool> isArticleStarred(String articleId, String userId);
  Future<void> likeArticle(String articleId, String userId);
  Future<void> unlikeArticle(String articleId, String userId);
  Future<bool> isArticleLiked(String articleId, String userId);
  Future<AuthorRatingSummary> rateAuthor({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  });
  Future<AuthorRatingSummary> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  });
  Future<void> saveBookmark(String articleId, String userId);
  Future<void> removeBookmark(String articleId, String userId);
  Future<List<ArticleModel>> getSavedArticles(String userId);
  Future<bool> isArticleSaved(String articleId, String userId);
  Future<ArticleModel> saveDraft(Map<String, dynamic> draftData);
  Future<ArticleModel> publishArticle(String articleId);
  Future<ArticleModel> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  );
  Future<void> deleteArticle(String articleId);
  Future<String> uploadArticleCoverImage({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? previousCoverUrl,
  });
}

class ArticlesRemoteDataSourceImpl implements ArticlesRemoteDataSource {
  static const String _articleSelectQuery = '*';
  final SupabaseClient? _supabaseClient;
  final SupabaseStorageService _storageService;

  ArticlesRemoteDataSourceImpl({
    SupabaseClient? supabaseClient,
    SupabaseStorageService? storageService,
  })  : _supabaseClient = supabaseClient,
        _storageService = storageService ??
            SupabaseStorageService(supabaseClient: supabaseClient);

  SupabaseClient get _client => _supabaseClient ?? Supabase.instance.client;

  @override
  Future<String> uploadArticleCoverImage({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
    String? previousCoverUrl,
  }) {
    return _storageService.uploadArticleCover(
      userId: userId,
      bytes: bytes,
      fileExtension: fileExtension,
      previousCoverUrl: previousCoverUrl,
    );
  }

  @override
  Future<List<ArticleModel>> getHomeFeed({
    List<String>? preferredCategoryIds,
    int limit = 20,
    int offset = 0,
  }) async {
    if (preferredCategoryIds != null && preferredCategoryIds.isNotEmpty) {
      final preferredResponse = await _client
          .from('articles')
          .select()
          .eq('status', 'published')
          .inFilter('category_id', preferredCategoryIds)
          .order('published_at', ascending: false, nullsFirst: false)
          .range(offset, offset + limit - 1);

      final preferredArticles = (preferredResponse as List)
          .map((e) => ArticleModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      if (preferredArticles.length >= limit) {
        return preferredArticles;
      }

      final remainingLimit = limit - preferredArticles.length;
      final remainingResponse = await _client
          .from('articles')
          .select()
          .eq('status', 'published')
          .not('category_id', 'in', '(${preferredCategoryIds.join(",")})')
          .order('published_at', ascending: false, nullsFirst: false)
          .range(0, remainingLimit - 1);

      final remainingArticles = (remainingResponse as List)
          .map((e) => ArticleModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return [...preferredArticles, ...remainingArticles];
    }

    final response = await _client
        .from('articles')
        .select()
        .eq('status', 'published')
        .order('published_at', ascending: false, nullsFirst: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((e) => ArticleModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<ArticleModel> getArticleById(String id) async {
    final response = await _client
        .from('articles')
        .select()
        .eq('id', id)
        .single();
    return ArticleModel.fromJson(Map<String, dynamic>.from(response));
  }

  @override
  Future<List<ArticleModel>> getArticlesByCategory(
    String categoryId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _client
        .from('articles')
        .select()
        .eq('status', 'published')
        .eq('category_id', categoryId)
        .order('published_at', ascending: false, nullsFirst: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((e) => ArticleModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<ArticleModel>> getArticlesByAuthor(
    String authorId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _client
        .from('articles')
        .select()
        .eq('author_id', authorId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((e) => ArticleModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<ArticleModel>> searchArticles(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _client
        .from('articles')
        .select()
        .eq('status', 'published')
        .or('title.ilike.%$query%,excerpt.ilike.%$query%,content.ilike.%$query%')
        .order('published_at', ascending: false, nullsFirst: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((e) => ArticleModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<ArticleModel>> getArticlesByTag(
    String tag, {
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _client
        .from('articles')
        .select()
        .eq('status', 'published')
        .contains('tags', [tag])
        .order('published_at', ascending: false, nullsFirst: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((e) => ArticleModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .order('name', ascending: true);

    return (response as List)
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<TagModel>> getFixedTags() async {
    final response = await _client
        .from('fixed_tags')
        .select()
        .order('name', ascending: true);

    return (response as List)
        .map((e) => TagModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> starArticle(String articleId, String userId) async {
    await _client.from('article_stars').insert({
      'user_id': userId,
      'article_id': articleId,
    });
  }

  @override
  Future<void> unstarArticle(String articleId, String userId) async {
    await _client
        .from('article_stars')
        .delete()
        .match({'user_id': userId, 'article_id': articleId});
  }

  @override
  Future<bool> isArticleStarred(String articleId, String userId) async {
    final response = await _client
        .from('article_stars')
        .select('article_id')
        .eq('user_id', userId)
        .eq('article_id', articleId)
        .maybeSingle();

    return response != null;
  }

  @override
  Future<void> likeArticle(String articleId, String userId) async {
    final user = _client.auth.currentUser;
    if (user == null || user.id != userId) {
      throw StateError(
        'An authenticated session for the requested user is required.',
      );
    }
    await _client.from('article_likes').upsert(
      {
        'user_id': userId,
        'article_id': articleId,
      },
      onConflict: 'user_id,article_id',
      ignoreDuplicates: true,
    );
  }

  @override
  Future<void> unlikeArticle(String articleId, String userId) async {
    await _client
        .from('article_likes')
        .delete()
        .match({'user_id': userId, 'article_id': articleId});
  }

  @override
  Future<bool> isArticleLiked(String articleId, String userId) async {
    final response = await _client
        .from('article_likes')
        .select('article_id')
        .eq('user_id', userId)
        .eq('article_id', articleId)
        .maybeSingle();

    return response != null;
  }

  @override
  Future<AuthorRatingSummary> rateAuthor({
    required String authorKey,
    required int stars,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    final res = await _client.rpc(
      'rate_author',
      params: {
        'p_author_key': authorKey,
        'p_stars': stars,
        'p_author_id': (authorId != null && authorId.trim().isNotEmpty)
            ? authorId.trim()
            : null,
        'p_author_name': authorName,
      },
    );
    return AuthorRatingSummary.fromJson(Map<String, dynamic>.from(res as Map));
  }

  @override
  Future<AuthorRatingSummary> getAuthorRatingSummary({
    required String authorKey,
    String? authorId,
    String authorName = 'Editorial Staff',
  }) async {
    final res = await _client.rpc(
      'get_author_rating_summary',
      params: {
        'p_author_key': authorKey,
        'p_author_id': (authorId != null && authorId.trim().isNotEmpty)
            ? authorId.trim()
            : null,
        'p_author_name': authorName,
      },
    );
    return AuthorRatingSummary.fromJson(Map<String, dynamic>.from(res as Map));
  }

  @override
  Future<void> saveBookmark(String articleId, String userId) async {
    final user = _client.auth.currentUser;
    if (user == null || user.id != userId) {
      throw StateError(
        'An authenticated session for the requested user is required.',
      );
    }
    await _client.from('saved_articles').upsert(
      {
        'user_id': userId,
        'article_id': articleId,
      },
      onConflict: 'user_id,article_id',
      ignoreDuplicates: true,
    );
  }

  @override
  Future<void> removeBookmark(String articleId, String userId) async {
    await _client
        .from('saved_articles')
        .delete()
        .match({'user_id': userId, 'article_id': articleId});
  }

  @override
  Future<List<ArticleModel>> getSavedArticles(String userId) async {
    final response = await _client
        .from('saved_articles')
        .select('article:articles(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    final list = <ArticleModel>[];
    for (final row in response as List) {
      final articleData = row['article'];
      if (articleData is Map<String, dynamic>) {
        list.add(ArticleModel.fromJson(articleData));
      } else if (articleData is Map) {
        list.add(ArticleModel.fromJson(Map<String, dynamic>.from(articleData)));
      }
    }
    return list;
  }

  @override
  Future<bool> isArticleSaved(String articleId, String userId) async {
    final response = await _client
        .from('saved_articles')
        .select('article_id')
        .eq('user_id', userId)
        .eq('article_id', articleId)
        .maybeSingle();

    return response != null;
  }

  @override
  Future<ArticleModel> saveDraft(Map<String, dynamic> draftData) async {
    final payload = Map<String, dynamic>.from(draftData);
    payload['status'] = 'draft';
    payload.remove('published_at');
    payload.remove('star_count');
    payload.remove('likes_count');
    payload.remove('author_rating_avg');
    payload.remove('author_rating_count');

    try {
      final response = await _client
          .from('articles')
          .insert(payload)
          .select(_articleSelectQuery)
          .single();

      return ArticleModel.fromJson(Map<String, dynamic>.from(response));
    } catch (_) {
      final response = await _client
          .from('articles')
          .insert(payload)
          .select()
          .single();

      return ArticleModel.fromJson(Map<String, dynamic>.from(response));
    }
  }

  @override
  Future<ArticleModel> publishArticle(String articleId) async {
    final response = await _client
        .from('articles')
        .update({'status': 'published'})
        .eq('id', articleId)
        .select()
        .single();

    return ArticleModel.fromJson(Map<String, dynamic>.from(response));
  }

  @override
  Future<ArticleModel> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  ) async {
    final payload = Map<String, dynamic>.from(updates);
    payload.remove('published_at');
    payload.remove('star_count');
    payload.remove('likes_count');
    payload.remove('author_rating_avg');
    payload.remove('author_rating_count');

    final response = await _client
        .from('articles')
        .update(payload)
        .eq('id', articleId)
        .select()
        .single();

    return ArticleModel.fromJson(Map<String, dynamic>.from(response));
  }

  @override
  Future<void> deleteArticle(String articleId) async {
    await _client.from('articles').delete().eq('id', articleId);
  }
}
