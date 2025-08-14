import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/sign_up_form.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        authBackground(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SafeArea(child: SingleChildScrollView(child: SignUpForm())),
        ),
      ],
    );
  }
}
