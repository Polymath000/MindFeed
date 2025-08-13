import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxConstraints,
        CardThemeData,
        CheckboxThemeData,
        ChipThemeData,
        Colors,
        DialogThemeData,
        DropdownMenuThemeData,
        EdgeInsets,
        EdgeInsetsDirectional,
        FilledButton,
        FilledButtonThemeData,
        FloatingActionButtonThemeData,
        FontWeight,
        IconButton,
        IconButtonThemeData,
        InputDecorationTheme,
        MenuStyle,
        NavigationBarThemeData,
        NavigationDestinationLabelBehavior,
        OutlineInputBorder,
        OutlinedButton,
        OutlinedButtonThemeData,
        ProgressIndicatorThemeData,
        Radius,
        RoundedSuperellipseBorder,
        SearchBarThemeData,
        Size,
        SnackBarBehavior,
        SnackBarThemeData,
        TextButton,
        TextButtonThemeData,
        TextOverflow,
        TextStyle,
        TextTheme,
        WidgetStatePropertyAll,
        immutable;
import 'package:mind_feed/core/constants/borders.dart';

@immutable
sealed class AppThemeData {
  const AppThemeData();

  static const InputDecorationTheme inputDecoration = InputDecorationTheme(
    // labelStyle: TextStyle(overflow: TextOverflow.fade),
    // helperStyle: TextStyle(overflow: TextOverflow.fade),
    // hintStyle: TextStyle(overflow: TextOverflow.fade),
    // errorStyle: TextStyle(overflow: TextOverflow.fade),
    // floatingLabelAlignment: FloatingLabelAlignment.center,
    iconColor: Colors.grey,
    border: OutlineInputBorder(borderRadius: AppBorders.xs),

    alignLabelWithHint: true,
    // constraints: BoxConstraints(minHeight: 80 + 4),
    // 4 is the padding of the text error.
  );

  static const TextTheme text = TextTheme(
    displayLarge: TextStyle(overflow: TextOverflow.fade),
    displayMedium: TextStyle(overflow: TextOverflow.fade),
    displaySmall: TextStyle(overflow: TextOverflow.fade),
    headlineLarge: TextStyle(overflow: TextOverflow.fade),
    headlineMedium: TextStyle(overflow: TextOverflow.fade),
    headlineSmall: TextStyle(overflow: TextOverflow.fade),
    titleLarge: TextStyle(overflow: TextOverflow.fade),
    titleMedium: TextStyle(overflow: TextOverflow.fade),
    titleSmall: TextStyle(overflow: TextOverflow.fade),
    bodyLarge: TextStyle(overflow: TextOverflow.fade),
    bodyMedium: TextStyle(overflow: TextOverflow.fade),
    bodySmall: TextStyle(overflow: TextOverflow.fade),
    labelLarge: TextStyle(overflow: TextOverflow.fade),
    labelMedium: TextStyle(overflow: TextOverflow.fade),
    labelSmall: TextStyle(overflow: TextOverflow.fade),
  );

  static const CardThemeData card = CardThemeData(
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedSuperellipseBorder(borderRadius: AppBorders.xxxs),
  );

  static const checkbox = CheckboxThemeData(
    shape: RoundedSuperellipseBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
  );

  static const chip = ChipThemeData(
    shape: RoundedSuperellipseBorder(borderRadius: AppBorders.xxs),
  );

  static const DialogThemeData dialog = DialogThemeData(
    elevation: 0,
    shape: RoundedSuperellipseBorder(borderRadius: AppBorders.m),
    actionsPadding: EdgeInsetsDirectional.only(bottom: 16, end: 16, start: 16),
    insetPadding: EdgeInsets.all(16),
  );

  static const dropdownMenu = DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      // floatingLabelAlignment: FloatingLabelAlignment.center,
      border: OutlineInputBorder(borderRadius: AppBorders.xs),
      alignLabelWithHint: true,
      constraints: BoxConstraints(
        minHeight: 80 + 4,
        // 4 is the padding of the text error.
      ),
    ),
    menuStyle: MenuStyle(
      shape: WidgetStatePropertyAll<RoundedSuperellipseBorder>(
        RoundedSuperellipseBorder(borderRadius: AppBorders.xs),
      ),
      padding: WidgetStatePropertyAll<EdgeInsets?>(EdgeInsets.zero),
    ),
  );

  static final FilledButtonThemeData filledButton = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      minimumSize: const Size.fromHeight(56),
      shape: const RoundedSuperellipseBorder(borderRadius: AppBorders.xs),
    ),
  );

  static const FloatingActionButtonThemeData floatingActionButton =
      FloatingActionButtonThemeData(
        elevation: 0,
        shape: RoundedSuperellipseBorder(borderRadius: AppBorders.s),
      );

  static final IconButtonThemeData iconButton = IconButtonThemeData(
    style: IconButton.styleFrom(
      shape: const RoundedSuperellipseBorder(borderRadius: AppBorders.xxs),
    ),
  );

  static const NavigationBarThemeData navigationBar = NavigationBarThemeData(
    elevation: 0,
    indicatorShape: RoundedSuperellipseBorder(borderRadius: AppBorders.xxxs),
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
  );

  static final OutlinedButtonThemeData outlinedButton = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      minimumSize: const Size.fromHeight(56),
      shape: const RoundedSuperellipseBorder(borderRadius: AppBorders.xs),
    ),
  );

  static const ProgressIndicatorThemeData progressIndicator =
      ProgressIndicatorThemeData(borderRadius: AppBorders.xxs);

  static const SearchBarThemeData searchBar = SearchBarThemeData(
    shape: WidgetStatePropertyAll<RoundedSuperellipseBorder>(
      RoundedSuperellipseBorder(borderRadius: AppBorders.xs),
    ),
    elevation: WidgetStatePropertyAll<double?>(0),
    padding: WidgetStatePropertyAll<EdgeInsets?>(EdgeInsets.zero),
  );

  static const SnackBarThemeData snackBar = SnackBarThemeData(
    elevation: 0,
    shape: RoundedSuperellipseBorder(borderRadius: AppBorders.xxs),
    behavior: SnackBarBehavior.floating,
  );

  static final textButton = TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: const RoundedSuperellipseBorder(borderRadius: AppBorders.xxs),
    ),
  );
}
