import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/presentation/views/signup_view.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(
              color: AppColors.greyText,
              fontSize: 14,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              foregroundColor: AppColors.cream,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, SignUpView.routeName);
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: AppColors.cream,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
