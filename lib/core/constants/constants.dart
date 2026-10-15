class AppConstants {
  AppConstants._();
  static const String appName = "MindFeed";
  static const double page = 20.0;
  static const double compact = 12.0;
  static const double roomy = 24.0;
  static const String themeModeKey = 'themeMode';
  static const String tokenKey = "token";
  static const String userKey = "user";
  static const String supabaseUrl = String.fromEnvironment(
    'PROJECT_URL',
    defaultValue: 'https://tsqruoqiajkbrdhprfxa.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_7xjZ0nwY5lZkjUHGW2OCSA_4zcC8jkQ',
  );
}
