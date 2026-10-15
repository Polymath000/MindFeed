import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/core/widgets/custom_loading_indecator.dart';
import 'package:mind_feed/core/widgets/custom_text_field.dart';
import 'package:mind_feed/features/auth/domain/usecases/update_password_use_case.dart';
import 'package:mind_feed/features/auth/domain/usecases/verify_recovery_otp_use_case.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_requirements.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_text_field.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key, required this.email});
  final String email;

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String password = '';
  String confirmPassword = '';
  bool _isLoading = false;

  bool get _isAuthenticated =>
      Supabase.instance.client.auth.currentUser != null;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handlePasswordUpdate() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
      return;
    }

    if (password != confirmPassword) {
      customShowSnackBar(
        message: 'Passwords do not match',
        context: context,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    if (!_isAuthenticated) {
      final otp = _otpController.text.trim();
      final recoveryResult = await getIt<VerifyRecoveryOtpUseCase>().call(
        email: widget.email,
        token: otp,
      );

      bool recoveryFailed = false;
      String? errorMessage;

      recoveryResult.when(
        success: (_) {},
        failure: (failure) {
          recoveryFailed = true;
          errorMessage = failure.message;
        },
      );

      if (recoveryFailed) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        customShowSnackBar(
          message: errorMessage ?? 'Invalid recovery code',
          context: context,
        );
        return;
      }
    }

    final updateResult = await getIt<UpdatePasswordUseCase>().call(
      newPassword: password.trim(),
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    updateResult.when(
      success: (_) {
        customShowSnackBar(
          message: 'Password updated successfully',
          context: context,
        );
        if (_isAuthenticated) {
          Navigator.pop(context);
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
      },
      failure: (failure) {
        customShowSnackBar(
          message: failure.message,
          context: context,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final requiresOtp = !_isAuthenticated;

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: const CustomLoadingIndecator(),
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (requiresOtp) ...[
              const Text(
                'Recovery Code',
                style: TextStyle(
                  color: AppColors.softCream,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter 6-digit recovery code from email',
                textEditingController: _otpController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(
                  AppIcons.lock,
                  color: AppColors.greyText,
                  size: 20,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter the recovery code';
                  }
                  if (val.trim().length < 6) {
                    return 'Recovery code must be at least 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'New Password',
              style: TextStyle(
                color: AppColors.softCream,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            PasswordTextField(
              hintText: 'Enter new password',
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Confirm New Password',
              style: TextStyle(
                color: AppColors.softCream,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            PasswordTextField(
              hintText: 'Re-enter new password',
              onChanged: (value) {
                setState(() {
                  confirmPassword = value;
                });
              },
            ),
            const SizedBox(height: 20),
            PasswordRequirements(password: password),
            const SizedBox(height: 24),
            CustomButton(
              buttonText: 'Update Password',
              onTap: _handlePasswordUpdate,
            ),
          ],
        ),
      ),
    );
  }
}
