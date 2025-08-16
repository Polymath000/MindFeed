import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/login_form.dart';
import 'package:mind_feed/features/auth/presentation/widgets/no_account_text.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        authBackground(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  LoginForm(),
                  SizedBox(height: 16.0),
                  NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
