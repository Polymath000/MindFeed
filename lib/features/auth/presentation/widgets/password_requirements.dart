import 'package:mind_feed/core/constants/borders.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key, required this.password});
  final String password;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        border: Border.all(color: AppColors.borderDark),
        borderRadius: AppBorders.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password requirements:',
            style: TextStyle(
              color: AppColors.softCream,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _buildRequirementRow(
            text: 'At least 8 characters',
            isValid: password.length >= 8,
          ),
          const SizedBox(height: 6),
          _buildRequirementRow(
            text: 'One uppercase letter',
            isValid: password.contains(RegExp(r'[A-Z]')),
          ),
          const SizedBox(height: 6),
          _buildRequirementRow(
            text: 'One number',
            isValid: password.contains(RegExp(r'[0-9]')),
          ),
          const SizedBox(height: 6),
          _buildRequirementRow(
            text: 'One special character (!@#\$%^&*)',
            isValid: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementRow({
    required String text,
    required bool isValid,
  }) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          size: 14,
          color: isValid ? AppColors.successGreen : AppColors.greyIcon,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isValid ? AppColors.successGreen : AppColors.greyIcon,
            fontSize: 12,
            fontWeight: isValid ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
