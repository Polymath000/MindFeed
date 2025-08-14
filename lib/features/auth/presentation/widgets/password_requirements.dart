import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 342,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.gunmetal,
            border: Border.all(color: AppColors.lightGray),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password Requirements:',
                style: TextStyle(
                  color: AppColors.mediumGray,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _buildRequirementRow(
                icon: Icons.check,
                text: 'At least 8 characters',
              ),
              const SizedBox(height: 4),
              _buildRequirementRow(
                icon: Icons.check,
                text: 'One uppercase letter',
              ),
              const SizedBox(height: 4),
              _buildRequirementRow(icon: Icons.check, text: 'One number'),
              const SizedBox(height: 4),
              _buildRequirementRow(
                icon: Icons.check,
                text: 'One special character',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textGray),
        const SizedBox(width: 8.5),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textGray,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
