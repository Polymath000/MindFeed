import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/params/signup_params.dart';

class AuthApiSource {
  final SupabaseClient? _supabaseClient;

  AuthApiSource({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient;

  SupabaseClient get _client => _supabaseClient ?? Supabase.instance.client;

  Future<String> login({required LoginParams params}) async {
    final response = await _client.auth.signInWithPassword(
      email: params.email,
      password: params.password,
    );

    final token = response.session?.accessToken;
    if (token == null || token.isEmpty) {
      throw const AuthException('Failed to retrieve authentication token');
    }

    return token;
  }

  Future<Response<dynamic>> signUp({required SignupParams params}) async {
    final baseUsername = params.displayName.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    final response = await _client.auth.signUp(
      email: params.email,
      password: params.password,
      data: {
        'display_name': params.displayName,
        'username': baseUsername,
      },
    );

    final token = response.session?.accessToken ?? response.user?.id ?? '';

    return Response(
      requestOptions: RequestOptions(path: '/auth/v1/signup'),
      data: <String, dynamic>{
        'idToken': token,
        'email': params.email,
        'displayName': params.displayName,
        'user': response.user?.toJson(),
      },
      statusCode: 200,
    );
  }

  Future<bool> signInWithGoogle() async {
    return await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.mindfeed://login-callback/',
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;
}
