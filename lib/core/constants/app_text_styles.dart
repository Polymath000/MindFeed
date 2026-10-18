import 'package:flutter/material.dart'
    show
        BuildContext,
        Color,
        FontWeight,
        TextDecoration,
        TextStyle,
        TextTheme,
        Theme,
        ThemeData,
        immutable;

import 'package:google_fonts/google_fonts.dart';

import 'package:mind_feed/core/constants/app_colors.dart';

@immutable
sealed class AppTextStyles {
  const AppTextStyles();

  static late ThemeData _theme;

  static ThemeData init(final BuildContext context) =>
      _theme = Theme.of(context);

  // Text styles
  static TextTheme get _textTheme => _theme.textTheme;

  // Body
  static TextStyle? get bodyLarge => _textTheme.bodyLarge;
  static TextStyle? get bodyMedium => _textTheme.bodyMedium;
  static TextStyle? get bodySmall => _textTheme.bodySmall;

  // Headline
  static TextStyle? get headlineLarge => _textTheme.headlineLarge;
  static TextStyle? get headlineMedium => _textTheme.headlineMedium;
  static TextStyle? get headlineSmall => _textTheme.headlineSmall;

  // Title
  static TextStyle? get titleLarge => _textTheme.titleLarge;
  static TextStyle? get titleMedium => _textTheme.titleMedium;
  static TextStyle? get titleSmall => _textTheme.titleSmall;

  // Label
  static TextStyle? get labelLarge => _textTheme.labelLarge;
  static TextStyle? get labelMedium => _textTheme.labelMedium;
  static TextStyle? get labelSmall => _textTheme.labelSmall;

  // Display
  static TextStyle? get displayLarge => _textTheme.displayLarge;
  static TextStyle? get displayMedium => _textTheme.displayMedium;
  static TextStyle? get displaySmall => _textTheme.displaySmall;

  // Editorial Home & Reader Styles
  static TextStyle get homeMastheadTitle => GoogleFonts.playfairDisplay(
        color: AppColors.softCream,
        fontSize: 27,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
      );

  static const TextStyle homeSectionTitle = TextStyle(
    color: AppColors.softCream,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
  );

  static const TextStyle homeTopicSelected = TextStyle(
    color: AppColors.ink,
    fontSize: 14.5,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
  );

  static const TextStyle homeTopicUnselected = TextStyle(
    color: AppColors.softCreamAlpha185,
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle homeStoryTitle = TextStyle(
    color: AppColors.softCream,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle homeStoryReadTime = TextStyle(
    color: AppColors.greyText,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static TextStyle homeStoryBadge(Color color) => TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w800,
      );

  static const TextStyle homeEmptyMessage = TextStyle(
    color: AppColors.greyText,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle homeErrorMessage = TextStyle(
    color: AppColors.softCream,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  // Editorial Reader Styles
  static const TextStyle readerHeadline = TextStyle(
    fontSize: 30,
    height: 1.15,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.0,
    color: AppColors.ink,
  );

  static const TextStyle readerUpdatedDate = TextStyle(
    color: AppColors.mutedInk,
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle readerMetadataDot = TextStyle(
    color: AppColors.mutedInk,
  );

  static const TextStyle readerReadingTime = TextStyle(
    color: AppColors.mutedInk,
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle readerAuthorRole = TextStyle(
    fontSize: 11,
    color: AppColors.mutedInk,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle readerAuthorName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );

  static const TextStyle readerAuthorRatingSummary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mutedInk,
  );

  static const TextStyle readerExcerpt = TextStyle(
    fontSize: 16,
    height: 1.55,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  static const TextStyle readerBodyParagraph = TextStyle(
    fontSize: 16,
    height: 1.65,
    color: AppColors.ink,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle readerHeading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: AppColors.ink,
    height: 1.3,
  );

  static const TextStyle readerHeading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
    height: 1.3,
  );

  static const TextStyle readerHeading3 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    height: 1.3,
  );

  static const TextStyle readerLink = TextStyle(
    color: AppColors.redHighlight,
    decoration: TextDecoration.underline,
  );

  static const TextStyle readerCode = TextStyle(
    backgroundColor: AppColors.blackAlpha12,
    color: AppColors.ink,
    fontFamily: 'monospace',
  );

  static const TextStyle readerTag = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const TextStyle readerTopBadge = TextStyle(
    color: AppColors.white,
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
  );

  static const TextStyle readerActionCount = TextStyle(
    color: AppColors.softCream,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle slowScrollButton = TextStyle(
    color: AppColors.softCream,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle paceChipSelected = TextStyle(
    color: AppColors.ink,
    fontSize: 11,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle paceChipUnselected = TextStyle(
    color: AppColors.softCream,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle readerEmptyTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );

  static const TextStyle readerEmptyMessage = TextStyle(
    fontSize: 14,
    color: AppColors.mutedInk,
  );
}
