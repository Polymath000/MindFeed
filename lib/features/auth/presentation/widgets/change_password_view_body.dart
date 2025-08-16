import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/change_password_form.dart';
import 'package:mind_feed/features/auth/presentation/widgets/security_tip_text.dart';

class ChangePasswordViewBody extends StatelessWidget {
  ChangePasswordViewBody({super.key, required this.email});
  final String email;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          AppRoutes.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.lightGrey,
                        ),
                      ),
                      Text(
                        'Change Password',
                        style: AppTextStyles.headlineSmall!.copyWith(
                          color: AppColors.lightGray,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60.0),
                    child: Center(
                      child: Text(
                        'Keep your account secure by updating your password regularly',
                        style: AppTextStyles.bodyLarge!.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  ChangePasswordForm(email: email),
                  SizedBox(height: 32),
                  Align(alignment: Alignment.center, child: SecurityTipText()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
