import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_feed/features/add_article/domain/helpers/article_validator.dart';

void main() {
  group('ArticleValidator.countWords', () {
    test('returns 0 for empty or whitespace-only strings', () {
      expect(ArticleValidator.countWords(''), 0);
      expect(ArticleValidator.countWords('   \n\t  '), 0);
    });

    test('counts words separated by spaces, tabs, and newlines', () {
      expect(ArticleValidator.countWords('hello world'), 2);
      expect(ArticleValidator.countWords('one   two\nthree\tfour'), 4);
    });
  });

  group('ArticleValidator.validateTitle', () {
    test('rejects empty title', () {
      expect(ArticleValidator.validateTitle(''), isNotNull);
      expect(ArticleValidator.validateTitle(null), isNotNull);
      expect(ArticleValidator.validateTitle('   '), isNotNull);
    });

    test('accepts titles with 1 to 12 words', () {
      expect(ArticleValidator.validateTitle('Single'), isNull);
      expect(
        ArticleValidator.validateTitle(
          'One two three four five six seven eight nine ten eleven twelve',
        ),
        isNull,
      );
    });

    test('rejects titles with more than 12 words', () {
      final error = ArticleValidator.validateTitle(
        'One two three four five six seven eight nine ten eleven twelve thirteen',
      );
      expect(error, isNotNull);
      expect(error, contains('12 words'));
    });
  });

  group('ArticleValidator.validateDraftTitle', () {
    test('rejects null or empty draft title', () {
      expect(ArticleValidator.validateDraftTitle(null), isNotNull);
      expect(ArticleValidator.validateDraftTitle(''), isNotNull);
      expect(ArticleValidator.validateDraftTitle('   '), isNotNull);
    });

    test('accepts non-empty draft title', () {
      expect(ArticleValidator.validateDraftTitle('Draft Title'), isNull);
    });
  });

  group('ArticleValidator.validateContent', () {
    test('rejects empty content', () {
      expect(ArticleValidator.validateContent(null), isNotNull);
      expect(ArticleValidator.validateContent(''), isNotNull);
      expect(ArticleValidator.validateContent('   '), isNotNull);
    });

    test('rejects content under 300 words', () {
      final shortContent = List.filled(299, 'word').join(' ');
      final error = ArticleValidator.validateContent(shortContent);
      expect(error, isNotNull);
      expect(error, contains('300 words'));
    });

    test('accepts content with 300 words or more', () {
      final exactContent = List.filled(300, 'word').join(' ');
      expect(ArticleValidator.validateContent(exactContent), isNull);

      final longContent = List.filled(350, 'word').join(' ');
      expect(ArticleValidator.validateContent(longContent), isNull);
    });
  });

  group('ArticleValidator.validateCoverImageUrlFormat', () {
    test('rejects empty or null URLs', () {
      expect(ArticleValidator.validateCoverImageUrlFormat(null), isNotNull);
      expect(ArticleValidator.validateCoverImageUrlFormat(''), isNotNull);
      expect(ArticleValidator.validateCoverImageUrlFormat('   '), isNotNull);
    });

    test('rejects invalid schemes or non-URLs', () {
      expect(
        ArticleValidator.validateCoverImageUrlFormat(
          'ftp://example.com/img.png',
        ),
        isNotNull,
      );
      expect(
        ArticleValidator.validateCoverImageUrlFormat('not a url'),
        isNotNull,
      );
    });

    test('accepts valid http and https URLs', () {
      expect(
        ArticleValidator.validateCoverImageUrlFormat(
          'https://images.unsplash.com/photo-1234.jpg',
        ),
        isNull,
      );
      expect(
        ArticleValidator.validateCoverImageUrlFormat(
          'http://example.com/banner.png',
        ),
        isNull,
      );
    });
  });

  group('ArticleValidator.validateCoverImageDimensions', () {
    test('rejects when resolver returns null', () async {
      final error = await ArticleValidator.validateCoverImageDimensions(
        'https://example.com/image.jpg',
        resolver: (url, {timeout = const Duration(seconds: 5)}) async => null,
      );
      expect(error, 'Unable to verify cover image dimensions');
    });

    test('rejects portrait image', () async {
      final error = await ArticleValidator.validateCoverImageDimensions(
        'https://example.com/image.jpg',
        resolver: (url, {timeout = const Duration(seconds: 5)}) async =>
            const Size(800, 1200),
      );
      expect(error, contains('Cover image must be landscape'));
    });

    test('rejects square image', () async {
      final error = await ArticleValidator.validateCoverImageDimensions(
        'https://example.com/image.jpg',
        resolver: (url, {timeout = const Duration(seconds: 5)}) async =>
            const Size(800, 800),
      );
      expect(error, contains('Cover image must be landscape'));
    });

    test('accepts landscape image', () async {
      final error = await ArticleValidator.validateCoverImageDimensions(
        'https://example.com/image.jpg',
        resolver: (url, {timeout = const Duration(seconds: 5)}) async =>
            const Size(1200, 800),
      );
      expect(error, isNull);
    });
  });

  group('ArticleValidator.validateCategory', () {
    test('rejects null or empty category', () {
      expect(
        ArticleValidator.validateCategory(null, ['cat-1', 'cat-2']),
        isNotNull,
      );
      expect(
        ArticleValidator.validateCategory('', ['cat-1', 'cat-2']),
        isNotNull,
      );
    });

    test('rejects category not in available categories list', () {
      expect(
        ArticleValidator.validateCategory('unknown', ['cat-1', 'cat-2']),
        isNotNull,
      );
    });

    test('accepts valid category', () {
      expect(
        ArticleValidator.validateCategory('cat-1', ['cat-1', 'cat-2']),
        isNull,
      );
    });
  });

  group('ArticleValidator.validateTags', () {
    final allowedTags = ['tech', 'flutter', 'dart', 'news', 'ai', 'mobile'];

    test('rejects empty tags', () {
      expect(ArticleValidator.validateTags([], allowedTags), isNotNull);
    });

    test('rejects more than 5 tags', () {
      final tags = ['tech', 'flutter', 'dart', 'news', 'ai', 'mobile'];
      expect(ArticleValidator.validateTags(tags, allowedTags), isNotNull);
    });

    test('rejects duplicate tags', () {
      expect(
        ArticleValidator.validateTags(['tech', 'tech'], allowedTags),
        isNotNull,
      );
    });

    test('rejects tags not in allowed list', () {
      expect(
        ArticleValidator.validateTags(['tech', 'crypto'], allowedTags),
        contains("Tag 'crypto' is not in the allowed tags list"),
      );
    });

    test('accepts 1 to 5 valid unique tags', () {
      expect(ArticleValidator.validateTags(['tech'], allowedTags), isNull);
      expect(
        ArticleValidator.validateTags([
          'tech',
          'flutter',
          'dart',
          'news',
          'ai',
        ], allowedTags),
        isNull,
      );
    });
  });

  group('ArticleValidator.generateSlug', () {
    test('creates hyphenated lower-case slug with suffix', () {
      final slug = ArticleValidator.generateSlug(
        'My First Article in MindFeed!',
      );
      expect(slug, startsWith('my-first-article-in-mindfeed-'));
      expect(slug.contains('!'), isFalse);
    });

    test('handles empty or special character titles', () {
      final slug = ArticleValidator.generateSlug('???');
      expect(slug, startsWith('article-'));
    });
  });

  group('ArticleValidator.computeReadingTime', () {
    test('computes max(1, ceil(words / 200))', () {
      expect(ArticleValidator.computeReadingTime('word'), 1);
      final twoHundredWords = List.filled(200, 'word').join(' ');
      expect(ArticleValidator.computeReadingTime(twoHundredWords), 1);
      final twoHundredOneWords = List.filled(201, 'word').join(' ');
      expect(ArticleValidator.computeReadingTime(twoHundredOneWords), 2);
      final sixHundredWords = List.filled(600, 'word').join(' ');
      expect(ArticleValidator.computeReadingTime(sixHundredWords), 3);
    });
  });

  group('ArticleValidator.generateExcerpt', () {
    test('cleans markdown symbols and truncates to 160 characters', () {
      const markdown = '# Hello World\n**This is bold** and _italic_ text.';
      final excerpt = ArticleValidator.generateExcerpt(markdown);
      expect(excerpt.contains('#'), isFalse);
      expect(excerpt.contains('*'), isFalse);
      expect(excerpt.contains('_'), isFalse);
    });

    test('limits length to at most 160 characters', () {
      final longText = List.filled(100, 'word').join(' ');
      final excerpt = ArticleValidator.generateExcerpt(longText);
      expect(excerpt.length, lessThanOrEqualTo(160));
    });
  });

  group('ArticleValidator.validateForPublish', () {
    test('returns all field errors when fields are invalid', () async {
      final errors = await ArticleValidator.validateForPublish(
        title: '',
        content: '',
        coverImageUrl: 'invalid',
        categoryId: null,
        availableCategoryIds: ['cat-1'],
        tags: [],
        allowedTagNames: ['tech'],
      );

      expect(errors.hasErrors, isTrue);
      expect(errors.titleError, isNotNull);
      expect(errors.contentError, isNotNull);
      expect(errors.coverImageUrlError, isNotNull);
      expect(errors.categoryError, isNotNull);
      expect(errors.tagsError, isNotNull);
    });

    test(
      'returns no errors when all fields are valid and image is landscape',
      () async {
        final body = List.filled(300, 'word').join(' ');
        final errors = await ArticleValidator.validateForPublish(
          title: 'Valid Story Headline',
          content: body,
          coverImageUrl: 'https://example.com/cover.jpg',
          categoryId: 'cat-1',
          availableCategoryIds: ['cat-1'],
          tags: ['tech'],
          allowedTagNames: ['tech'],
          dimensionResolver:
              (url, {timeout = const Duration(seconds: 5)}) async =>
                  const Size(1200, 630),
        );

        expect(errors.hasErrors, isFalse);
      },
    );
  });
}
