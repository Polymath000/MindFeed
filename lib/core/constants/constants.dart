import 'package:mind_feed/core/services/app_info_service.dart';

class AppConstants {
  AppConstants._();
  static List<String> get mastheadRotatingWords => [
        AppInfoService.appName,
        'Daily Reads',
        'Deep Insights',
        'Feed Your Mind',
      ];
  static const double page = 20.0;
  static const double compact = 12.0;
  static const double roomy = 24.0;
  static const String themeModeKey = 'themeMode';
  static const String tokenKey = "token";
  static const String hasCompletedCategoriesKey = "hasCompletedCategories";
  static const String userKey = "user";
  static const String isOnboardingSeenKey = "isOnboardingSeen";
  static const String supabaseUrl = String.fromEnvironment(
    'PROJECT_URL',
    defaultValue: String.fromEnvironment('SUPABASE_URL'),
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: String.fromEnvironment('SUPABASE_ANON_KEY'),
  );
  static const String authConfirmRedirectUrl = String.fromEnvironment(
    'AUTH_CONFIRM_REDIRECT_URL',
    defaultValue:
        'https://tsqruoqiajkbrdhprfxa.supabase.co/functions/v1/auth-confirm',
  );
  static const String defaultAvatarUrl =
      'https://tsqruoqiajkbrdhprfxa.supabase.co/storage/v1/object/public/avatars/defaultAvatar.png';
  static const String fontScaleKey = 'pref_font_scale';
  static const String defaultFontScale = 'Standard';
  static const String genericErrorMessage =
      "there's an error, Please try again later";
}

const String isOnboardingSeenKey = AppConstants.isOnboardingSeenKey;
