import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/features/auth/domain/entities/check_code_args.dart';
import 'package:mind_feed/features/auth/presentation/controllers/forget_password_cubit/forget_password_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/email_text_field.dart';

class SendCodeViewBody extends StatefulWidget {
  const SendCodeViewBody({super.key});

  @override
  State<SendCodeViewBody> createState() => _SendCodeViewBodyState();
}

class _SendCodeViewBodyState extends State<SendCodeViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValueNotifier<AutovalidateMode> _autovalidateMode =
      ValueNotifier<AutovalidateMode>(AutovalidateMode.disabled);
  String _email = '';

  @override
  void dispose() {
    _autovalidateMode.dispose();
    super.dispose();
  }

  void _onSendPressed() {
    if (formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<ForgetPasswordCubit>().sendResetInstructions(
            email: _email.trim(),
          );
    } else {
      _autovalidateMode.value = AutovalidateMode.always;
    }
  }

  void _handleState(BuildContext context, ForgetPasswordState state) {
    if (state is ForgetPasswordSuccess) {
      customShowSnackBar(
        message: 'Password reset instructions sent to your email.',
        context: context,
      );
      Navigator.pushNamed(
        context,
        AppRoutes.checkCode,
        arguments: CheckCodeArgs(
          email: state.email,
          isPasswordReset: true,
        ),
      );
    } else if (state is ForgetPasswordFailure) {
      customShowSnackBar(
        message: state.errorMessage,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        authBackground(),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                  listener: _handleState,
                  builder: (context, state) {
                    final bool isLoading = state is ForgetPasswordLoading;
                    return ValueListenableBuilder<AutovalidateMode>(
                      valueListenable: _autovalidateMode,
                      builder: (context, autovalidateMode, _) {
                        return Form(
                          key: formKey,
                          autovalidateMode: autovalidateMode,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeader(context),
                              const SizedBox(height: 40),
                              _buildInstructions(),
                              const SizedBox(height: 28),
                              _buildEmailField(),
                              const SizedBox(height: 28),
                              CustomButton(
                                buttonText: isLoading ? 'Sending...' : 'Send Instructions',
                                onTap: isLoading ? null : _onSendPressed,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        EditorialIconButton(
          icon: AppIcons.arrowBackRounded,
          label: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Reset Password',
            style: TextStyle(
              color: AppColors.softCream,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return const Text(
      'Enter your registered email address to receive password recovery instructions.',
      style: TextStyle(
        color: AppColors.greyText,
        fontSize: 15,
        height: 1.4,
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            color: AppColors.softCream,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        EmailTextField(
          onChanged: (String value) {
            _email = value;
          },
        ),
      ],
    );
  }
}
