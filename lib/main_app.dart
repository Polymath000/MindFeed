import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/config/themes/theme_config.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:mind_feed/l10n/generated/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode =
            state is ThemeModeDark ? ThemeMode.dark : ThemeMode.light;

        return MaterialApp(
          title: AppConstants.appName,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          theme: const ThemeConfig().light,
          darkTheme: const ThemeConfig().dark,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          builder: (final context, final child) {
            AppColors.init(context);
            AppTextStyles.init(context);
            return child!;
          },
        );
      },
    );
  }
}
