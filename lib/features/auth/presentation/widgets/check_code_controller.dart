import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/core/services/current_user_session.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/domain/usecases/resend_otp_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/verify_otp_use_case.dart';

class CheckCodeController {
  final BuildContext context;
  final String email;
  final bool isPasswordReset;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  final ValueNotifier<AutovalidateMode> autovalidateMode =
      ValueNotifier<AutovalidateMode>(AutovalidateMode.disabled);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);
  final ValueNotifier<int> resendCooldown = ValueNotifier<int>(0);

  Timer? _cooldownTimer;
  StreamSubscription<dynamic>? _authSubscription;
  bool _disposed = false;

  CheckCodeController({
    required this.context,
    required this.email,
    required this.isPasswordReset,
  }) {
    _startListeningToAuthChanges();
  }

  void _startListeningToAuthChanges() {
    _authSubscription = CurrentUserSession.listenToAuthEvents(
      onSignedIn: (token) {
        isPasswordReset
            ? _navigateToReset()
            : _onSuccessfulAuthentication(token);
      },
      onPasswordRecovery: _navigateToReset,
    );
  }

  void _navigateToReset() {
    if (_disposed) return;
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.changePassword,
      arguments: email,
    );
  }

  void _startCooldown() {
    resendCooldown.value = 60;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown.value <= 1) {
        timer.cancel();
        resendCooldown.value = 0;
      } else {
        resendCooldown.value--;
      }
    });
  }

  Future<void> _onSuccessfulAuthentication(String accessToken) async {
    final user = CurrentUserSession.resolveCurrentUser();
    if (_disposed) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.categories,
      (route) => false,
      arguments: UserEntity(
        userName: user?.displayName ?? '',
        email: user?.email ?? email,
        favoriteCategories: const [],
        token: accessToken,
      ),
    );
  }

  Future<void> handleVerify() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      autovalidateMode.value = AutovalidateMode.always;
      return;
    }
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    errorMessage.value = null;

    final result = await getIt<VerifyOtpUseCase>().call(
      email: email,
      token: codeController.text.trim(),
      isPasswordReset: isPasswordReset,
    );

    result.when(
      success: (token) async => isPasswordReset
          ? _navigateToReset()
          : await _onSuccessfulAuthentication(token),
      failure: (failure) {
        isLoading.value = false;
        errorMessage.value = failure.message;
      },
    );
  }

  Future<void> handleResend() async {
    if (resendCooldown.value > 0 || isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = null;

    final result = await getIt<ResendOtpUseCase>().call(
      email: email,
      isPasswordReset: isPasswordReset,
    );

    isLoading.value = false;
    result.when(
      success: (_) {
        _startCooldown();
        customShowSnackBar(
          message: 'A new verification code has been dispatched to your email',
          context: context,
        );
      },
      failure: (failure) => errorMessage.value = failure.message,
    );
  }

  void dispose() {
    _disposed = true;
    _authSubscription?.cancel();
    _cooldownTimer?.cancel();
    codeController.dispose();
    isLoading.dispose();
    errorMessage.dispose();
    resendCooldown.dispose();
    autovalidateMode.dispose();
  }
}
