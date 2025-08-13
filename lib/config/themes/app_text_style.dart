import 'package:flutter/material.dart'
    show BuildContext, TextStyle, TextTheme, Theme, ThemeData, immutable;

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
}
