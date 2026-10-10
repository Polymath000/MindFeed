import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/email_text_field.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class SendCodeViewBody extends StatefulWidget {
  const SendCodeViewBody({super.key});

  @override
  State<SendCodeViewBody> createState() => _SendCodeViewBodyState();
}

class _SendCodeViewBodyState extends State<SendCodeViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String email = '';

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
                            'Reset Password',
                            style: TextStyle(
                              color: AppColors.softCream,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Enter your registered email address to receive password recovery instructions.',
                        style: TextStyle(
                          color: AppColors.greyText,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
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
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      const SizedBox(height: 28),
                      CustomButton(
                        buttonText: 'Send Instructions',
                        onTap: () {
                          if (formKey.currentState?.validate() ?? false) {
                            FocusScope.of(context).unfocus();
                            Navigator.pushNamed(context, AppRoutes.checkCode, arguments: email);
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
