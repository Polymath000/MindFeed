import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';

class DownloadArticleTextUseCase {
  final OfflineArticlesRepository localDataSource;
  final Future<Uint8List?> Function(String url) _imageDownloader;

  DownloadArticleTextUseCase(
    this.localDataSource, {
    Future<Uint8List?> Function(String url)? imageDownloader,
  }) : _imageDownloader = imageDownloader ?? _defaultImageDownloader;

  static Future<Uint8List?> _defaultImageDownloader(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        return response.bodyBytes;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> call(DownloadedArticleEntity article) async {
    Uint8List? coverBytes = article.coverImageBytes;
    if (coverBytes == null) {
      final resolvedCover =
          SupabaseStorageService.resolveArticleMediaUrl(article.coverImageUrl) ??
              article.coverImageUrl;
      if (resolvedCover != null && resolvedCover.startsWith('http')) {
        coverBytes = await _imageDownloader(resolvedCover);
      }
    }

    Uint8List? avatarBytes = article.authorAvatarBytes;
    if (avatarBytes == null) {
      final resolvedAvatar =
          SupabaseStorageService.resolveAvatarUrl(article.authorAvatar) ??
              article.authorAvatar;
      if (resolvedAvatar.startsWith('http')) {
        avatarBytes = await _imageDownloader(resolvedAvatar);
      }
    }

    final entityToSave = article.copyWith(
      coverImageBytes: coverBytes ?? article.coverImageBytes,
      authorAvatarBytes: avatarBytes ?? article.authorAvatarBytes,
    );

    return localDataSource.saveDownloadedArticle(entityToSave);
  }
}
