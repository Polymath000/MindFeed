sealed class EndPoint {
  const EndPoint();
  static const String baseUrl = 'https://identitytoolkit.googleapis.com/v1';
  static const String webApiKey = "AIzaSyCIM21p0mHSdyxtwxoeIP6wITogBcjG-i0";
  static const String loginUrl = '$baseUrl/accounts:signInWithPassword?key=$webApiKey';
  static const String signUpUrl = '$baseUrl/accounts:signUp?key=$webApiKey';
  static const String updateDisplayName = '$baseUrl/accounts:update?key=$webApiKey';
}
