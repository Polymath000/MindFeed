import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/features/auth/presentation/controllers/change_password_cubit/change_password_cubit.dart';
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
  final ValueNotifier<AutovalidateMode> _autovalidateMode =
      ValueNotifier<AutovalidateMode>(AutovalidateMode.disabled);
  final ValueNotifier<String> _passwordNotifier = ValueNotifier<String>('');
  String _confirmPassword = '';

  @override
  void dispose() {
    _autovalidateMode.dispose();
    _passwordNotifier.dispose();
    super.dispose();
  }

  void _handleState(BuildContext context, ChangePasswordState state) {
    if (state is ChangePasswordSuccess) {
      customShowSnackBar(
        message: 'Password updated successfully. Please sign in.',
        context: context,
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } else if (state is ChangePasswordFailure) {
      customShowSnackBar(
        message: state.errorMessage,
        context: context,
      );
    }
  }

  void _onSubmit(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      if (_passwordNotifier.value != _confirmPassword) {
        customShowSnackBar(
          message: 'Passwords do not match',
          context: context,
        );
        return;
      }
      FocusScope.of(context).unfocus();
      context.read<ChangePasswordCubit>().updatePassword(
            newPassword: _passwordNotifier.value,
          );
    } else {
      _autovalidateMode.value = AutovalidateMode.always;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: _handleState,
      builder: (context, state) {
        final bool isLoading = state is ChangePasswordLoading;
        return ValueListenableBuilder<AutovalidateMode>(
          valueListenable: _autovalidateMode,
          builder: (context, autovalidateMode, _) {
            return Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNewPasswordField(),
                  const SizedBox(height: 16),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 20),
                  _buildRequirements(),
                  const SizedBox(height: 24),
                  CustomButton(
                    buttonText: 'Update Password',
                    isLoading: isLoading,
                    onTap: isLoading ? null : () => _onSubmit(context),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNewPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          onChanged: (value) => _passwordNotifier.value = value,
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          onChanged: (value) => _confirmPassword = value,
        ),
      ],
    );
  }

  Widget _buildRequirements() {
    return ValueListenableBuilder<String>(
      valueListenable: _passwordNotifier,
      builder: (context, currentPassword, _) {
        return PasswordRequirements(password: currentPassword);
      },
    );
  }
}
