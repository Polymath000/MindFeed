import 'package:flutter/cupertino.dart'
// show CupertinoColors, CupertinoThemeData
;
import 'package:flutter/material.dart'
    show
        AppBarTheme,
        Brightness,
        Color,
        ColorScheme,
        Colors,
        DynamicSchemeVariant,
        TargetPlatform,
        ThemeData,
        immutable;

// import '../../helpers/get_setting.dart' show getSetting;
import 'app_colors.dart' show AppColors;
import 'app_theme_data.dart' show AppThemeData;

@immutable
final class ThemeConfig {
  const ThemeConfig();

  ThemeData? get light => _themeData();

  ThemeData? get dark => _themeData(Brightness.dark);

  ThemeData? _themeData([final Brightness brightness = Brightness.light]) {
    const getSetting = SettingsEntity();

    final isAppleDevice =
        getSetting.platform == TargetPlatform.iOS ||
        getSetting.platform == TargetPlatform.macOS;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: getSetting.seedColor,
      brightness: brightness,
      dynamicSchemeVariant: getSetting.dynamicSchemeVariant,
      surface: (getSetting.isAmoledSelected)
          ? brightness == Brightness.dark
                ? Colors.black
                : Colors.white
          : null,
    );

    final appBarTheme = isAppleDevice
        ? const AppBarTheme(
            shadowColor: CupertinoColors.darkBackgroundGray,
            surfaceTintColor: AppColors.transparent,
            scrolledUnderElevation: .1,
            toolbarHeight: 44,
            actionsPadding: EdgeInsets.only(left: 8),
          )
        : const AppBarTheme(actionsPadding: EdgeInsets.only(right: 8));

    final textTheme = isAppleDevice
        ? AppThemeData.text.copyWith(
            headlineMedium: const CupertinoTextThemeData()
                .navLargeTitleTextStyle
                .copyWith(
                  letterSpacing: -1.5,
                  fontFamily: 'Cairo',
                  fontFamilyFallback: const <String>['Cairo', 'Roboto'],
                ),
            titleLarge: const CupertinoTextThemeData().navTitleTextStyle
                .copyWith(
                  fontFamily: 'Cairo',
                  fontFamilyFallback: const <String>['Cairo', 'Roboto'],
                ),
          )
        : AppThemeData.text;

    return ThemeData(
      inputDecorationTheme: AppThemeData.inputDecoration,
      platform: getSetting.platform,
      useMaterial3: getSetting.useMaterial3,
      useSystemColors: true,
      colorScheme: colorScheme,
      brightness: brightness,
      // colorSchemeSeed: getSetting.seedColor,
      fontFamily: 'Cairo',
      fontFamilyFallback: const <String>['Cairo', 'Roboto'],
      textTheme: textTheme,
      appBarTheme: appBarTheme,
      cardTheme: AppThemeData.card,
      checkboxTheme: AppThemeData.checkbox,
      chipTheme: AppThemeData.chip,
      dialogTheme: AppThemeData.dialog,
      dropdownMenuTheme: AppThemeData.dropdownMenu,
      filledButtonTheme: AppThemeData.filledButton,
      floatingActionButtonTheme: AppThemeData.floatingActionButton,
      iconButtonTheme: AppThemeData.iconButton,
      navigationBarTheme: AppThemeData.navigationBar,
      outlinedButtonTheme: AppThemeData.outlinedButton,
      progressIndicatorTheme: AppThemeData.progressIndicator,
      searchBarTheme: AppThemeData.searchBar,
      snackBarTheme: AppThemeData.snackBar,
      textButtonTheme: AppThemeData.textButton,
    );
  }
}

class SettingsEntity {
  const SettingsEntity({
    this.seedColor = Colors.blue,
    this.useMaterial3,
    this.platform,
    this.dynamicSchemeVariant = DynamicSchemeVariant.content,
    this.isAmoledSelected = false,
  });
  final Color seedColor;
  final bool? useMaterial3;
  final TargetPlatform? platform;
  final DynamicSchemeVariant dynamicSchemeVariant;
  final bool isAmoledSelected;
}
