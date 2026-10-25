import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';
import 'package:mind_feed/core/articles/domain/repos/articles_repo.dart';
import 'package:mind_feed/core/articles/domain/usecases/get_downloaded_articles_use_case.dart';
import 'package:mind_feed/core/networking/api_result.dart';
import 'package:mind_feed/core/services/supabase_storage_service.dart';
import 'package:mind_feed/features/article/domain/usecases/download_article_text_use_case.dart';
import 'package:mind_feed/features/settings/domain/usecases/get_archive_cache_size_use_case.dart';

class _FakeOfflineArticlesRepository implements OfflineArticlesRepository {
  final Map<String, DownloadedArticleEntity> storage = {};

  @override
  Future<void> saveDownloadedArticle(DownloadedArticleEntity article) async {
    storage[article.id] = article;
  }

  @override
  Future<List<DownloadedArticleEntity>> getDownloadedArticles() async {
    return storage.values.toList();
  }

  @override
  Future<DownloadedArticleEntity?> getDownloadedArticleById(String id) async {
    return storage[id];
  }

  @override
  Future<void> deleteDownloadedArticle(String id) async {
    storage.remove(id);
  }

  @override
  Future<void> clearAllDownloadedArticles() async {
    storage.clear();
  }
}

void main() {
  group('SupabaseStorageService', () {
    group('resolveAvatarUrl', () {
      test('returns null for null, empty string, or assets/... paths', () {
        expect(SupabaseStorageService.resolveAvatarUrl(null), isNull);
        expect(SupabaseStorageService.resolveAvatarUrl(''), isNull);
        expect(SupabaseStorageService.resolveAvatarUrl('   '), isNull);
        expect(
          SupabaseStorageService.resolveAvatarUrl('assets/images/avatar.png'),
          isNull,
        );
      });

      test('returns full https:// URL as-is', () {
        const fullUrl = 'https://images.unsplash.com/photo-12345';
        expect(SupabaseStorageService.resolveAvatarUrl(fullUrl), equals(fullUrl));
      });

      test('resolves relative bucket path to public avatars bucket URL', () {
        final resolved =
            SupabaseStorageService.resolveAvatarUrl('user-1/avatar.png');
        expect(
          resolved,
          contains('/storage/v1/object/public/avatars/user-1/avatar.png'),
        );

        final resolvedWithBucketPrefix =
            SupabaseStorageService.resolveAvatarUrl('avatars/user-1/avatar.png');
        expect(
          resolvedWithBucketPrefix,
          contains('/storage/v1/object/public/avatars/user-1/avatar.png'),
        );
      });
    });

    group('resolveArticleMediaUrl', () {
      test('returns null for null, empty string, or assets/... paths', () {
        expect(SupabaseStorageService.resolveArticleMediaUrl(null), isNull);
        expect(SupabaseStorageService.resolveArticleMediaUrl(''), isNull);
        expect(SupabaseStorageService.resolveArticleMediaUrl('   '), isNull);
        expect(
          SupabaseStorageService.resolveArticleMediaUrl('assets/images/cover.jpg'),
          isNull,
        );
      });

      test('returns full https:// URL as-is', () {
        const fullUrl = 'https://images.unsplash.com/photo-cover-123';
        expect(
          SupabaseStorageService.resolveArticleMediaUrl(fullUrl),
          equals(fullUrl),
        );
      });

      test('resolves relative bucket path to public article-media bucket URL', () {
        final resolved =
            SupabaseStorageService.resolveArticleMediaUrl('user-1/cover.jpg');
        expect(
          resolved,
          contains('/storage/v1/object/public/article-media/user-1/cover.jpg'),
        );

        final resolvedWithPrefix = SupabaseStorageService.resolveArticleMediaUrl(
          'article-media/user-1/cover.jpg',
        );
        expect(
          resolvedWithPrefix,
          contains('/storage/v1/object/public/article-media/user-1/cover.jpg'),
        );
      });
    });

    group('isDefaultAvatar', () {
      test('returns true for null, empty, defaultAvatar.png, and public url to default avatar', () {
        expect(SupabaseStorageService.isDefaultAvatar(null), isTrue);
        expect(SupabaseStorageService.isDefaultAvatar(''), isTrue);
        expect(SupabaseStorageService.isDefaultAvatar('defaultAvatar.png'), isTrue);
        expect(
          SupabaseStorageService.isDefaultAvatar(
            'https://tsqruoqiajkbrdhprfxa.supabase.co/storage/v1/object/public/avatars/defaultAvatar.png',
          ),
          isTrue,
        );
        expect(
          SupabaseStorageService.isDefaultAvatar(
            'https://tsqruoqiajkbrdhprfxa.supabase.co/storage/v1/object/public/avatars/defaultAvatar.png?v=123',
          ),
          isTrue,
        );
      });

      test('returns false for custom user avatar URL', () {
        expect(
          SupabaseStorageService.isDefaultAvatar(
            'https://tsqruoqiajkbrdhprfxa.supabase.co/storage/v1/object/public/avatars/u1/avatar_123.png',
          ),
          isFalse,
        );
      });
    });

    group('extractBucketPath', () {
      test('extracts bucket path from public Supabase URL', () {
        final extracted = SupabaseStorageService.extractBucketPath(
          'https://tsqruoqiajkbrdhprfxa.supabase.co/storage/v1/object/public/avatars/u1/avatar_123.png',
          SupabaseStorageService.avatarsBucket,
        );
        expect(extracted, equals('u1/avatar_123.png'));
      });

      test('returns null for null, empty, assets, or non-matching external URLs', () {
        expect(
          SupabaseStorageService.extractBucketPath(
            null,
            SupabaseStorageService.avatarsBucket,
          ),
          isNull,
        );
        expect(
          SupabaseStorageService.extractBucketPath(
            '',
            SupabaseStorageService.avatarsBucket,
          ),
          isNull,
        );
        expect(
          SupabaseStorageService.extractBucketPath(
            'assets/images/logo.png',
            SupabaseStorageService.avatarsBucket,
          ),
          isNull,
        );
        expect(
          SupabaseStorageService.extractBucketPath(
            'https://external.com/photo.png',
            SupabaseStorageService.avatarsBucket,
          ),
          isNull,
        );
      });
    });
  });

  group('Offline image caching in DownloadArticleTextUseCase and GetArchiveCacheSizeUseCase', () {
    test('downloads cover and avatar bytes, persists them, and calculates cache size accurately', () async {
      final fakeRepo = _FakeOfflineArticlesRepository();
      final coverBytes = Uint8List.fromList([1, 2, 3, 4, 5]); // 5 bytes
      final avatarBytes = Uint8List.fromList([10, 20, 30]); // 3 bytes

      final downloadUseCase = DownloadArticleTextUseCase(
        fakeRepo,
        imageDownloader: (url) async {
          if (url.contains('cover')) return coverBytes;
          if (url.contains('avatar')) return avatarBytes;
          return null;
        },
      );

      final article = DownloadedArticleEntity(
        id: 'article_offline_1',
        title: 'Title', // 5 bytes
        excerpt: 'Excerpt', // 7 bytes
        content: 'Content', // 7 bytes
        authorName: 'Jane Doe',
        authorRole: 'Senior Editor',
        authorAvatar: 'https://example.com/avatar.jpg',
        coverImageUrl: 'https://example.com/cover.jpg',
        categoryId: 'cat_1',
        categorySlug: 'tech',
        tags: const ['AI'],
        publishedAt: DateTime(2026, 1, 1),
        readingTimeMinutes: 5,
        downloadedAt: DateTime(2026, 1, 2),
      );

      await downloadUseCase(article);

      final persisted = await fakeRepo.getDownloadedArticleById('article_offline_1');
      expect(persisted, isNotNull);
      expect(persisted!.coverImageBytes, equals(coverBytes));
      expect(persisted.authorAvatarBytes, equals(avatarBytes));

      final getDownloadedUseCase = GetDownloadedArticlesUseCase(fakeRepo);
      final cacheSizeUseCase = GetArchiveCacheSizeUseCase(getDownloadedUseCase);

      final cacheResult = await cacheSizeUseCase();
      expect(cacheResult, isA<Success<double>>());

      // 5 (title) + 7 (excerpt) + 7 (content) + 5 (cover) + 3 (avatar) = 27 bytes
      const expectedMb = 27 / (1024 * 1024);
      cacheResult.when(
        success: (sizeMb) => expect(sizeMb, closeTo(expectedMb, 0.000001)),
        failure: (f) => fail('Expected success, got $f'),
      );
    });
  });
}
