import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_prompt_link.dart';

class ThereIsAnAccountText extends StatelessWidget {
  const ThereIsAnAccountText({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AuthPromptLink(
      promptText: 'Already have an account?',
      actionText: 'Sign In',
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }
}
