import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/config/themes/theme_config.dart';
import 'package:mind_feed/features/auth/presentation/views/login_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginView.routeName,
      onGenerateRoute: onGenerateRoute,
      theme: const ThemeConfig().light,
      darkTheme: const ThemeConfig().dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      builder: (final context, final child) {
        AppColors.init(context);
        AppTextStyles.init(context);
        return child!;
      },
    );
  }
}
