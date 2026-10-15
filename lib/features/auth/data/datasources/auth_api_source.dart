import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/params/signup_params.dart';
import 'package:mind_feed/features/auth/domain/entities/auth_result_entity.dart';

class AuthApiSource {
  static const String authConfirmRedirectUrl =
      'https://tsqruoqiajkbrdhprfxa.supabase.co/functions/v1/auth-confirm';

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

  Future<AuthResultEntity> signUp({required SignupParams params}) async {
    final baseUsername =
        params.displayName.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    final response = await _client.auth.signUp(
      email: params.email,
      password: params.password,
      emailRedirectTo: authConfirmRedirectUrl,
      data: {
        'display_name': params.displayName,
        'username': baseUsername,
      },
    );

    final session = response.session;
    final hasActiveSession = session != null && session.accessToken.isNotEmpty;

    return AuthResultEntity(
      hasActiveSession: hasActiveSession,
      email: params.email,
      accessToken: hasActiveSession ? session.accessToken : null,
      userId: response.user?.id,
    );
  }

  Future<String> verifyOtp({
    required String email,
    required String token,
  }) async {
    final response = await _client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );

    final accessToken = response.session?.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      throw const AuthException('Verification succeeded but no session was established');
    }

    return accessToken;
  }

  Future<void> resendOtp({required String email}) async {
    await _client.auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: authConfirmRedirectUrl,
    );
  }

  Future<bool> signInWithGoogle() async {
    return await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'mindfeed://login-callback',
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: authConfirmRedirectUrl,
    );
  }

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;
}
