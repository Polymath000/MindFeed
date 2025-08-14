import 'package:flutter/material.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/features/auth/presentation/widgets/email_text_field.dart';
import 'package:mind_feed/features/auth/presentation/widgets/forget_password_text.dart';
import 'package:mind_feed/features/auth/presentation/widgets/logo.dart';
import 'package:mind_feed/features/auth/presentation/widgets/no_account_text.dart';
import 'package:mind_feed/features/auth/presentation/widgets/password_text_field.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: autovalidateMode,
      key: formKey,
      child: Column(
        children: [
          Logo(),
          EmailTextField(),
          SizedBox(height: 16.0),
          PasswordTextField(hintText: 'Password'),
          SizedBox(height: 16.0),
          ForgetPasswordText(),
          SizedBox(height: 16.0),
          CustomButton(
            buttonText: 'Login',
            onTap: () {
              if (formKey.currentState?.validate() ?? false) {
                FocusScope.of(context).unfocus();
                // TODO: Handle login logic here
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Login successful')));
              } else {
                autovalidateMode = AutovalidateMode.always;
              }
            },
          ),
          SizedBox(height: 16.0),
          NoAccountText(),
        ],
      ),
    );
  }
}
