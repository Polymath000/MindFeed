import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/core/widgets/custom_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class CheckCodeViewBody extends StatefulWidget {
  const CheckCodeViewBody({super.key, required this.email});
  final String email;

  @override
  State<CheckCodeViewBody> createState() => _CheckCodeViewBodyState();
}

class _CheckCodeViewBodyState extends State<CheckCodeViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

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
                child: Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          EditorialIconButton(
                            icon: Icons.arrow_back_rounded,
                            label: 'Back',
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Check Code',
                            style: TextStyle(
                              color: AppColors.softCream,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'We sent a verification code to\n${widget.email}',
                        style: const TextStyle(
                          color: AppColors.greyText,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Verification Code',
                        style: TextStyle(
                          color: AppColors.softCream,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: 'Enter 6-digit code',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the verification code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      CustomButton(
                        buttonText: 'Verify Code',
                        onTap: () {
                          if (formKey.currentState?.validate() ?? false) {
                            FocusScope.of(context).unfocus();
                            Navigator.pushNamed(context, AppRoutes.changePassword, arguments: widget.email);
                          } else {
                            setState(() {
                              autovalidateMode = AutovalidateMode.always;
                            });
                          }
                        },
                      ),
                    ],
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
