import 'package:flutter/material.dart'
    show BuildContext, Color, ColorScheme, Colors, Theme, ThemeData, immutable;

@immutable
sealed class AppColors {
  const AppColors();

  static late ThemeData _theme;

  static ThemeData init(final BuildContext context) =>
      _theme = Theme.of(context);

  // Color scheme
  static ColorScheme get _scheme => _theme.colorScheme;

  // Primary color
  static Color get primary => _scheme.primary; // 0xff4F46E5
  static Color get primaryContainer => _scheme.primaryContainer;
  static Color get primaryFixed => _scheme.primaryFixed;
  static Color get primaryFixedDim => _scheme.primaryFixedDim;
  static Color get onPrimary => _scheme.onPrimary;
  static Color get onPrimaryContainer => _scheme.onPrimaryContainer;
  static Color get onPrimaryFixed => _scheme.onPrimaryFixed;
  static Color get onPrimaryFixedVariant => _scheme.onPrimaryFixedVariant;
  static Color get inversePrimary => _scheme.inversePrimary;

  // Secondary color
  static Color get secondary => _scheme.secondary; // 0xFF0284C7
  static Color get secondaryContainer => _scheme.secondaryContainer;
  static Color get secondaryFixed => _scheme.secondaryFixed;
  static Color get secondaryFixedDim => _scheme.secondaryFixedDim;
  static Color get onSecondary => _scheme.onSecondary;
  static Color get onSecondaryContainer => _scheme.onSecondaryContainer;
  static Color get onSecondaryFixed => _scheme.onSecondaryFixed;
  static Color get onSecondaryFixedVariant => _scheme.onSecondaryFixedVariant;

  // Tertiary color
  static Color get tertiary => _scheme.tertiary;
  static Color get tertiaryContainer => _scheme.tertiaryContainer;
  static Color get tertiaryFixed => _scheme.tertiaryFixed;
  static Color get tertiaryFixedDim => _scheme.tertiaryFixedDim;
  static Color get onTertiary => _scheme.onTertiary;
  static Color get onTertiaryContainer => _scheme.onTertiaryContainer;
  static Color get onTertiaryFixed => _scheme.onTertiaryFixed;
  static Color get onTertiaryFixedVariant => _scheme.onTertiaryFixedVariant;

  // Error color
  static Color get error => _scheme.error; // 0xFFB00020
  static Color get errorContainer => _scheme.errorContainer;
  static Color get onError => _scheme.onError;
  static Color get onErrorContainer => _scheme.onErrorContainer;

  // Surface color
  /// Equivalent to 'background' color scheme
  static Color get surface => _scheme.surface;
  static Color get surfaceBright => _scheme.surfaceBright;
  static Color get surfaceContainer => _scheme.surfaceContainer;
  static Color get surfaceContainerHigh => _scheme.surfaceContainerHigh;

  /// Equivalent to 'surfaceVariant' color scheme
  static Color get surfaceContainerHighest => _scheme.surfaceContainerHighest;
  static Color get surfaceContainerLow => _scheme.surfaceContainerLow;
  static Color get surfaceContainerLowest => _scheme.surfaceContainerLowest;
  static Color get surfaceDim => _scheme.surfaceDim;
  static Color get surfaceTint => _scheme.surfaceTint;

  /// Equivalent to 'onBackground' color scheme
  static Color get onSurface => _scheme.onSurface;
  static Color get onSurfaceVariant => _scheme.onSurfaceVariant;
  static Color get inverseSurface => _scheme.inverseSurface;
  static Color get onInverseSurface => _scheme.onInverseSurface;

  // Other colors
  static Color get outline => _scheme.outline;
  static Color get outlineVariant => _scheme.outlineVariant;
  static Color get scrim => _scheme.scrim;
  static Color get shadow => _scheme.shadow;

  // Normal colors
  static const Color amber = Colors.amber;
  static const Color black = Colors.black;
  static const Color blue = Colors.blue;
  static const Color brown = Colors.brown;
  static const Color cyan = Colors.cyan;
  static const Color darkBlue = Color(0xFF1E88E5);
  static const Color darkGrey = Color(0xFF4B5563); // 0xff334155
  static const Color grey = Colors.grey;
  static const Color green = Colors.green;
  static const Color indigo = Colors.indigo;
  static const Color lightBlue = Color(0xFF0284C7);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color mediumBrown = Color(0xFF7F5112);
  static const Color navyBlue = Color(0xFF1E88E5);
  static const Color orange = Colors.orange;
  static const Color pickledBluewood = Color(0xFF334155);
  static const Color pink = Colors.pink;
  static const Color purple = Colors.purple;
  static const Color red = Colors.red;
  static const Color topaz = Color(0xFF14B8A6);
  static const Color transparent = Colors.transparent;
  static const Color waterBlue = Color(0xFF0284C7);
  static const Color white = Colors.white;

  // Custom colors
  static const Color success = Color(0xFF3B9A1E);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF1E88E5);
  static const Color facebook = Color(0xFF0864ff);
  static const Color lightRed = Color.fromARGB(255, 231, 106, 106);
}
