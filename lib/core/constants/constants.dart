class AppConstants {
  AppConstants._();
  static const String appName = "MindFeed";
  static const double page = 20.0;
  static const double compact = 12.0;
  static const double roomy = 24.0;
  static const String themeModeKey = 'themeMode';
  static const String tokenKey = "token";
  static const String userKey = "user";
  static const String supabaseUrl = String.fromEnvironment('PROJECT_URL');
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
}
