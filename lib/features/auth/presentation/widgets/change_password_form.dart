import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
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
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String password = '';
  String confirmPassword = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            'New Password',
            style: AppTextStyles.bodyLarge!.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 16),
          PasswordTextField(
            hintText: 'Enter your new password',
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          SizedBox(height: 16),
          Text(
            'Confirm New Password',
            style: AppTextStyles.bodyLarge!.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 16),
          PasswordTextField(
            hintText: 'Enter your confirm password',
            onChanged: (value) {
              setState(() {});
            },
          ),
          SizedBox(height: 32),
          Align(
            alignment: Alignment.center,
            child: PasswordRequirements(password: password),
          ),
          SizedBox(height: 32),
          CustomButton(
            buttonText: 'Change Password',
            onTap: () {
              if (formKey.currentState?.validate() ?? false) {
                FocusScope.of(context).unfocus();
                // TODO: Handle Change Password logic here (Navigate to home page )
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Success')));
              } else if (password != confirmPassword &&
                  password.isNotEmpty &&
                  confirmPassword.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Passwords do not match')),
                );
              } else {
                autovalidateMode = AutovalidateMode.always;
              }
            },
          ),
        ],
      ),
    );
  }
}
