import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/security_tip_text.dart';
import 'package:mind_feed/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:mind_feed/features/auth/presentation/widgets/there_is_an_account_text.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({super.key});
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
                  SignUpForm(),
                  SizedBox(height: 22.0),
                  SecurityTipText(),
                  ThereIsAnAccountText(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
