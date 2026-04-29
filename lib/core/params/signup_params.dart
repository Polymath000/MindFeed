class SignupParams {
  final String email;
  final String password;
  final String displayName;

  const SignupParams({
    required this.email,
    required this.password,
    required this.displayName,
  });

  Map<String, dynamic> toJson() => toSignUpJson();

  Map<String, dynamic> toSignUpJson() {
    return {'email': email, 'password': password, 'returnSecureToken': true};
  }

  Map<String, dynamic> toUpdateDisplayNameJson({required String idToken}) {
    return {
      'idToken': idToken,
      'displayName': displayName,
      'returnSecureToken': true,
    };
  }
}
