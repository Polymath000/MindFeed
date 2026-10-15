import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_prompt_link.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AuthPromptLink(
      promptText: "Don't have an account?",
      actionText: 'Sign Up',
      onTap: onTap ??
          () {
            FocusScope.of(context).unfocus();
            Navigator.pushNamed(context, AppRoutes.signup);
          },
    );
  }
}
