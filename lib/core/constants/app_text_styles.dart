import 'package:flutter/material.dart'
    show
        BuildContext,
        Color,
        FontWeight,
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
}
