import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

// import '../../helpers/get_setting.dart' show getSetting;
import 'app_theme_data.dart' show AppThemeData;

@immutable
final class ThemeConfig {
  const ThemeConfig();

  ThemeData get light => _themeData();

  ThemeData get dark => _themeData(Brightness.dark);

  ThemeData _themeData([final Brightness brightness = Brightness.light]) {
    const getSetting = SettingsEntity();

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.butter,
      brightness: brightness,
      surface: brightness == Brightness.dark
          ? AppColors.ink
          : AppColors.softCream,
    );

    return ThemeData(
      inputDecorationTheme: AppThemeData.inputDecoration,
      platform: getSetting.platform,
      useMaterial3: getSetting.useMaterial3,
      useSystemColors: false,
      colorScheme: colorScheme,
      brightness: brightness,
      // colorSchemeSeed: getSetting.seedColor,
      fontFamily: 'Arial',
      fontFamilyFallback: const <String>['Roboto', 'sans-serif'],
      textTheme: AppThemeData.text,
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
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
