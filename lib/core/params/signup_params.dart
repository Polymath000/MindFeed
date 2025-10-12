class SignupParams {
     String email;
   String password;
   String displayName;

  SignupParams({required this.email, required this.password, required this.displayName});

  
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, "returnSecureToken": true, "displayName" : displayName};
  }
}