import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/features/auth/presentation/views/signup_view.dart';

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
              color: Color(0xFFAAA49B),
              fontSize: 14,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              foregroundColor: EditorialPalette.cream,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, SignUpView.routeName);
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: EditorialPalette.cream,
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
