import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
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
          const Text(
            'New Password',
            style: TextStyle(
              color: EditorialPalette.softCream,
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
              color: EditorialPalette.softCream,
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
            onTap: () {
              if (formKey.currentState?.validate() ?? false) {
                if (password != confirmPassword &&
                    password.isNotEmpty &&
                    confirmPassword.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                } else {
                  FocusScope.of(context).unfocus();
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password updated successfully')),
                  );
                }
              } else {
                setState(() {
                  autovalidateMode = AutovalidateMode.always;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
