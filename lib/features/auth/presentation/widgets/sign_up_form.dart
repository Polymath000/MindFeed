import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/core/widgets/custom_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/email_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_requirements.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/security_tip_text.dart';
import 'package:mind_feed/features/auth/presentation/widgets/there_is_an_account_text.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 85.0),
            Text(
              'Create Account',
              style: AppTextStyles.displaySmall!.copyWith(
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Join thousands of readers worldwide',
              style: AppTextStyles.bodyMedium!.copyWith(
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 50.0),
            CustomTextField(
              hintText: 'Username',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            EmailTextField(),
            SizedBox(height: 16.0),
            PasswordTextField(hintText: 'Password'),
            SizedBox(height: 16.0),
            PasswordTextField(hintText: 'Confirm Password'),
            SizedBox(height: 22.0),
            PasswordRequirements(),
            SizedBox(height: 22.0),
            CustomButton(buttonText: 'Sign Up', onTap: () {}),
            SizedBox(height: 22.0),
            SecurityTipText(),
            ThereIsAnAccountText(),
          ],
        ),
      ),
    );
  }
}
