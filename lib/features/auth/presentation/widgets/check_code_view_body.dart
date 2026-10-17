import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/check_code_actions_section.dart';
import 'package:mind_feed/features/auth/presentation/widgets/check_code_controller.dart';
import 'package:mind_feed/features/auth/presentation/widgets/check_code_otp_boxes.dart';

class CheckCodeViewBody extends StatefulWidget {
  const CheckCodeViewBody({
    super.key,
    required this.email,
    this.isPasswordReset = false,
  });

  final String email;
  final bool isPasswordReset;

  @override
  State<CheckCodeViewBody> createState() => _CheckCodeViewBodyState();
}

class _CheckCodeViewBodyState extends State<CheckCodeViewBody> {
  late final CheckCodeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CheckCodeController(
      context: context,
      email: widget.email,
      isPasswordReset: widget.isPasswordReset,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ValueListenableBuilder<AutovalidateMode>(
                  valueListenable: _controller.autovalidateMode,
                  builder: (context, mode, _) => Form(
                    key: _controller.formKey,
                    autovalidateMode: mode,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckCodeHeader(
                          email: widget.email,
                          errorMessageListenable: _controller.errorMessage,
                        ),
                        const SizedBox(height: 28),
                        CheckCodeOtpBoxes(controller: _controller.codeController),
                        const SizedBox(height: 28),
                        CheckCodeActionsSection(
                          isLoadingListenable: _controller.isLoading,
                          resendCooldownListenable: _controller.resendCooldown,
                          onVerify: _controller.handleVerify,
                          onResend: _controller.handleResend,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
