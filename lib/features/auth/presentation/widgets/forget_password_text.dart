import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          foregroundColor: AppColors.softCream,
        ),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.sendCode);
        },
        child: const Text(
          'Forgot password?',
          style: TextStyle(
            color: AppColors.greyText,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
