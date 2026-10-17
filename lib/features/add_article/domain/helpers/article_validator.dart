import 'dart:async';
import 'dart:math' as math;
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

typedef ImageDimensionResolver = Future<Size?> Function(
  String url, {
  Duration timeout,
});

Future<Size?> defaultImageDimensionResolver(
  String url, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  try {
    final uri = Uri.tryParse(url);
    if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
      return null;
    }
    final completer = Completer<Size?>();
    final imageProvider = NetworkImage(url);
    final stream = imageProvider.resolve(ImageConfiguration.empty);
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        final size = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );
        info.image.dispose();
        stream.removeListener(listener);
        if (!completer.isCompleted) {
          completer.complete(size);
        }
      },
      onError: (dynamic error, StackTrace? stackTrace) {
        stream.removeListener(listener);
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      },
    );
    stream.addListener(listener);
    return await completer.future.timeout(
      timeout,
      onTimeout: () {
        stream.removeListener(listener);
        return null;
      },
    );
  } catch (_) {
    return null;
  }
}

class ArticleFormErrors extends Equatable {
  final String? titleError;
  final String? contentError;
  final String? coverImageUrlError;
  final String? categoryError;
  final String? tagsError;
  final String? generalError;

  const ArticleFormErrors({
    this.titleError,
    this.contentError,
    this.coverImageUrlError,
    this.categoryError,
    this.tagsError,
    this.generalError,
  });

  ArticleFormErrors copyWith({
    String? titleError,
    bool clearTitle = false,
    String? contentError,
    bool clearContent = false,
    String? coverImageUrlError,
    bool clearCoverImageUrl = false,
    String? categoryError,
    bool clearCategory = false,
    String? tagsError,
    bool clearTags = false,
    String? generalError,
    bool clearGeneral = false,
  }) {
    return ArticleFormErrors(
      titleError: clearTitle ? null : (titleError ?? this.titleError),
      contentError: clearContent ? null : (contentError ?? this.contentError),
      coverImageUrlError:
          clearCoverImageUrl ? null : (coverImageUrlError ?? this.coverImageUrlError),
      categoryError:
          clearCategory ? null : (categoryError ?? this.categoryError),
      tagsError: clearTags ? null : (tagsError ?? this.tagsError),
      generalError:
          clearGeneral ? null : (generalError ?? this.generalError),
    );
  }

  bool get hasErrors =>
      titleError != null ||
      contentError != null ||
      coverImageUrlError != null ||
      categoryError != null ||
      tagsError != null ||
      generalError != null;

  @override
  List<Object?> get props => [
        titleError,
        contentError,
        coverImageUrlError,
        categoryError,
        tagsError,
        generalError,
      ];
}

class ArticleValidator {
  static int countWords(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }

  static String? validateTitle(String? title) {
    final words = countWords(title ?? '');
    if (words == 0) {
      return 'Article title cannot be empty';
    }
    if (words > 12) {
      return 'Article title cannot exceed 12 words (currently $words)';
    }
    return null;
  }

  static String? validateDraftTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'Title cannot be empty to save a draft';
    }
    return null;
  }

  static String? validateContent(String? content) {
    final words = countWords(content ?? '');
    if (words == 0) {
      return 'Article body cannot be empty';
    }
    if (words < 300) {
      return 'Article body must be at least 300 words (currently $words/300)';
    }
    return null;
  }

  static String? validateCoverImageUrlFormat(String? url) {
    if (url == null || url.trim().isEmpty) {
      return 'Cover image URL is required';
    }
    final trimmed = url.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null ||
        (!uri.isScheme('http') && !uri.isScheme('https')) ||
        uri.host.isEmpty) {
      return 'Cover image must be a valid http(s) URL';
    }
    return null;
  }

  static Future<String?> validateCoverImageDimensions(
    String url, {
    ImageDimensionResolver? resolver,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final formatError = validateCoverImageUrlFormat(url);
    if (formatError != null) return formatError;

    final res = resolver ?? defaultImageDimensionResolver;
    final size = await res(url.trim(), timeout: timeout);
    if (size == null) {
      return 'Unable to verify cover image dimensions';
    }
    if (size.width <= size.height) {
      return 'Cover image must be landscape (width must be greater than height, got ${size.width.toInt()}x${size.height.toInt()})';
    }
    return null;
  }

  static String? validateCategory(
    String? categoryId,
    List<String> availableCategoryIds,
  ) {
    if (categoryId == null || categoryId.trim().isEmpty) {
      return 'Please select a category';
    }
    if (availableCategoryIds.isNotEmpty &&
        !availableCategoryIds.contains(categoryId)) {
      return 'Selected category is not valid';
    }
    return null;
  }

  static String? validateTags(
    List<String> tags,
    List<String> allowedTagNames,
  ) {
    if (tags.isEmpty) {
      return 'Please select between 1 and 5 tags';
    }
    if (tags.length > 5) {
      return 'Cannot select more than 5 tags';
    }
    final uniqueTags = tags.toSet();
    if (uniqueTags.length != tags.length) {
      return 'Tags must be unique';
    }
    if (allowedTagNames.isNotEmpty) {
      for (final tag in tags) {
        if (!allowedTagNames.contains(tag)) {
          return "Tag '$tag' is not in the allowed tags list";
        }
      }
    }
    return null;
  }

  static String generateSlug(String title) {
    final base = title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .trim()
        .replaceAll(RegExp(r'[\s-]+'), '-');
    final safeBase = base.isEmpty ? 'article' : base;
    final suffix = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    return '$safeBase-$suffix';
  }

  static int computeReadingTime(String content) {
    final words = countWords(content);
    return math.max(1, (words / 200).ceil());
  }

  static String generateExcerpt(String content) {
    final clean = content
        .replaceAll(RegExp(r'[#*`_~\[\]]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (clean.length <= 160) return clean;
    return clean.substring(0, 160).trim();
  }

  static Future<ArticleFormErrors> validateForPublish({
    required String title,
    required String content,
    required String coverImageUrl,
    required String? categoryId,
    required List<String> availableCategoryIds,
    required List<String> tags,
    required List<String> allowedTagNames,
    ImageDimensionResolver? dimensionResolver,
  }) async {
    final titleError = validateTitle(title);
    final contentError = validateContent(content);
    final imageError = await validateCoverImageDimensions(
      coverImageUrl,
      resolver: dimensionResolver,
    );
    final categoryError = validateCategory(categoryId, availableCategoryIds);
    final tagsError = validateTags(tags, allowedTagNames);

    return ArticleFormErrors(
      titleError: titleError,
      contentError: contentError,
      coverImageUrlError: imageError,
      categoryError: categoryError,
      tagsError: tagsError,
    );
  }
}
