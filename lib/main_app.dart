import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/script/upgrade_all_dependencies.dart';
import 'package:mind_feed/config/extensions/string_extension.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/config/themes/theme_config.dart';
import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/core/services/shared_preferences_singleton.dart';
import 'package:mind_feed/features/main/presentation/views/main_view.dart';
import 'package:mind_feed/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:mind_feed/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:mind_feed/l10n/generated/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute:
              (SharedPreferencesSingleton.getString(tokenKey) == null
                  ? true
                  : SharedPreferencesSingleton.getString(tokenKey)!.isEmpty)
              ? OnboardingView.routeName
              : MainView.routeName,
          onGenerateRoute: onGenerateRoute,
          theme: const ThemeConfig().light,
          darkTheme: const ThemeConfig().dark,
          themeMode:
              SharedPreferencesSingleton.getString(
                themeModeKey,
              )?.toEnum(ThemeMode.values) ??
              ThemeMode.system,
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
