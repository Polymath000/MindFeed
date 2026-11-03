import 'package:flutter/material.dart';

import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/errors/failures.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';

export 'article_reader_tags_wrap.dart';

class ArticleReaderMarkdownBody extends StatelessWidget {
  const ArticleReaderMarkdownBody({
    super.key,
    this.content,
    required this.excerpt,
    required this.title,
    this.fontScale,
    this.serifMode,
  });

  final String? content;
  final String excerpt;
  final String title;
  final String? fontScale;
  final bool? serifMode;

  static final Map<(String, bool), MarkdownStyleSheet> _styleSheetCache = {};

  static String _readStoredFontScale() {
    try {
      return SharedPreferencesSingleton.getString(AppConstants.fontScaleKey) ??
          AppConstants.defaultFontScale;
    } catch (_) {
      debugPrint(const CacheFailure(AppConstants.genericErrorMessage).message);
      return AppConstants.defaultFontScale;
    }
  }

  static bool _readStoredSerifMode() {
    try {
      return SharedPreferencesSingleton.getBool(AppConstants.serifModeKey) ??
          true;
    } catch (_) {
      debugPrint(const CacheFailure(AppConstants.genericErrorMessage).message);
      return true;
    }
  }

  static double resolveFontSizeFactor(String scale) {
    return switch (scale) {
      'Compact' => 0.90,
      'Editorial' => 1.08,
      'Large' => 1.18,
      _ => 1.0,
    };
  }

  static MarkdownStyleSheet _buildStyleSheet({
    required String scale,
    required bool isSerif,
  }) {
    final factor = resolveFontSizeFactor(scale);
    final String? fontFamily = isSerif ? 'serif' : null;

    final pStyle = AppTextStyles.readerBodyParagraph.copyWith(
      fontSize: (AppTextStyles.readerBodyParagraph.fontSize ?? 16.0) * factor,
      fontFamily: fontFamily,
    );

    return MarkdownStyleSheet(
      p: pStyle,
      h1: AppTextStyles.readerHeading1.copyWith(
        fontSize: (AppTextStyles.readerHeading1.fontSize ?? 24.0) * factor,
      ),
      h2: AppTextStyles.readerHeading2.copyWith(
        fontSize: (AppTextStyles.readerHeading2.fontSize ?? 20.0) * factor,
      ),
      h3: AppTextStyles.readerHeading3.copyWith(
        fontSize: (AppTextStyles.readerHeading3.fontSize ?? 17.0) * factor,
      ),
      a: AppTextStyles.readerLink,
      blockquote: pStyle.copyWith(
        color: AppColors.mutedInk,
      ),
      blockquoteDecoration: const BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.mutedInk, width: 3)),
      ),
      code: AppTextStyles.readerCode.copyWith(
        fontSize: (AppTextStyles.readerCode.fontSize ?? 14.0) * factor,
      ),
      codeblockDecoration: const BoxDecoration(
        color: AppColors.blackAlpha12,
        borderRadius: AppBorders.control,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = content != null && content!.trim().isNotEmpty;
    final markdownData = hasContent ? content! : excerpt;
    final scale = fontScale ?? _readStoredFontScale();
    final isSerif = serifMode ?? _readStoredSerifMode();
    final factor = resolveFontSizeFactor(scale);
    final styleSheet = _styleSheetCache.putIfAbsent(
      (scale, isSerif),
      () => _buildStyleSheet(scale: scale, isSerif: isSerif),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasContent && excerpt.isNotEmpty) ...[
          Text(
            excerpt,
            style: AppTextStyles.readerExcerpt.copyWith(
              fontSize: (AppTextStyles.readerExcerpt.fontSize ?? 16.0) * factor,
              fontFamily: isSerif ? 'serif' : null,
            ),
          ),
          const SizedBox(height: 20),
        ],
        MarkdownBody(
          data: markdownData.isNotEmpty ? markdownData : title,
          selectable: false,
          styleSheet: styleSheet,
        ),
      ],
    );
  }
}
