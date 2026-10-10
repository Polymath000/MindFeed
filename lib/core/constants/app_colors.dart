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
  static const Color lightCyan = Color.fromARGB(255, 39, 220, 244);

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
  static const Color darkerGrey = Color(0xFF111827);

  // Custom colors
  static const Color success = Color(0xFF3B9A1E);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF1E88E5);
  static const Color facebook = Color(0xFF0864ff);
  static const Color lightRed = Color.fromARGB(255, 231, 106, 106);
  static const Color gunmetal = Color(0xFF111827);
  static const Color lightGray = Color(0xFFE5E7EB);
  static const Color mediumGray = Color(0xFFD1D5DB);
  static const Color textGray = Color(0xFF9CA3AF);
  static const Color lightBlack = Color.fromARGB(255, 20, 20, 20);
  static const Color darkSurface = Color.fromARGB(255, 61, 61, 61);
  static const Color darkerEdge = Color.fromARGB(255, 29, 28, 28);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color softShadow = Color(0xFFE0E0E0);
  static const Color spaceBlack = Color(0xff23262b);

  // Refactored constants
  static const Color greyText = Color(0xFFAAA49B);
  static const Color borderDark = Color(0xFF383530);
  static const Color charcoal = Color(0xFF262422);
  static const Color softCream = Color(0xFFFFF8E6);
  static const Color creamDark = Color(0xFFDDD4C0);
  static const Color greyIcon = Color(0xFF8E8E93);
  static const Color ink = Color(0xFF171614);
  static const Color whiteLight = Color(0xFFFFFDF8);
  static const Color creamBorder = Color(0xFFE5DECE);
  static const Color darkTile = Color(0xFF2A2825);
  static const Color successGreen = Color(0xFF10B981);
  static const Color transparentDark = Color(0x0C30281C);
  static const Color cream = Color(0xFFFFF1C6);
  static const Color butter = Color(0xFFFFE8A1);
  static const Color peach = Color(0xFFFFE5D0);
  static const Color yellowHighlight = Color(0xFFFFE388);
  static const Color blush = Color(0xFFFFDDE0);
  static const Color creamLight = Color(0xFFF6F0E4);
  static const Color sand = Color(0xFFF5EEDC);
  static const Color sandLight = Color(0xFFF3EDE2);
  static const Color sandLighter = Color(0xFFF1EBE0);
  static const Color redHighlight = Color(0xFFEF4444);
  static const Color sandDark = Color(0xFFEDE5D4);
  static const Color sandDarker = Color(0xFFE9E2D4);
  static const Color lilac = Color(0xFFE9DEFF);
  static const Color sandDarkest = Color(0xFFE2DAC8);
  static const Color roseRed = Color(0xFFE11D48);
  static const Color powder = Color(0xFFDCEEFF);
  static const Color amberDark = Color(0xFFD97706);
  static const Color mint = Color(0xFFD7F5E8);
  static const Color mintDark = Color(0xFFBCE8D3);
  static const Color greyBrown = Color(0xFFB5ADA0);
  static const Color amberDarker = Color(0xFFB45309);
  static const Color mutedInkDark = Color(0xFF55524C);
  static const Color mutedInk = Color(0xFF514D46);
  static const Color blueMain = Color(0xFF2563EB);
  static const Color charcoalDark = Color(0xFF24221E);
  static const Color charcoalDarker = Color(0xFF23211F);
  static const Color darkBg = Color(0xff1F1F2E);
  static const Color inkDark = Color(0xFF1E1D1A);
  static const Color greenDark = Color(0xFF1B5E20);
  static const Color inkDarker = Color(0xFF191816);
  static const Color inkDarkest = Color(0xFF131210);
  static const Color cyanDark = Color(0xFF0E7490);
  static const Color almostBlack = Color(0xFF0E0D0C);
  static const Color greenDarker = Color(0xFF065F46);
  static const Color greenMain = Color(0xFF059669);
  static const Color greenMedium = Color(0xFF047857);
  static const Color transparentBlack = Color(0x18000000);
}
