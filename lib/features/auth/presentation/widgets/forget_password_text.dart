import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_colors.dart';

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            AppRoutes.sendCode(context);
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
