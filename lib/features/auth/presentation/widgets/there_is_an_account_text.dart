import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class ThereIsAnAccountText extends StatelessWidget {
  const ThereIsAnAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account?',
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
              Navigator.pop(context);
            },
            child: const Text(
              'Sign In',
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
