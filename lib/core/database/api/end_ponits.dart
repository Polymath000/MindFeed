sealed class EndPoint {
  const EndPoint();
  static const String baseUrl = 'https://api.mindfeed.local';
  static const String loginUrl = '$baseUrl/auth/login';
  static const String signUpUrl = '$baseUrl/auth/signup';
  static const String updateDisplayName = '$baseUrl/auth/update';
}
