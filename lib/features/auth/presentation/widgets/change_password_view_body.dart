import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/change_password_form.dart';
import 'package:mind_feed/features/auth/presentation/widgets/security_tip_text.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class ChangePasswordViewBody extends StatelessWidget {
  const ChangePasswordViewBody({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        authBackground(),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        EditorialIconButton(
                          icon: AppIcons.arrowBackRounded,
                          label: 'Back',
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                              color: AppColors.softCream,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Keep your MindFeed account secure by choosing a resilient, unique password.',
                      style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ChangePasswordForm(email: email),
                    const SizedBox(height: 24),
                    const SecurityTipText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
