import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';

class PasswordRequirements extends StatefulWidget {
  const PasswordRequirements({super.key, required this.password});
  final String password;
  @override
  State<PasswordRequirements> createState() => _PasswordRequirementsState();
}

class _PasswordRequirementsState extends State<PasswordRequirements> {
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
                isValid: widget.password.length >= 8,
              ),
              const SizedBox(height: 4),
              _buildRequirementRow(
                icon: Icons.check,
                text: 'One uppercase letter',
                isValid: widget.password.contains(RegExp(r'[A-Z]')),
              ),
              const SizedBox(height: 4),
              _buildRequirementRow(
                icon: Icons.check,
                text: 'One number',
                isValid: widget.password.contains(RegExp(r'[0-9]')),
              ),
              const SizedBox(height: 4),
              _buildRequirementRow(
                icon: Icons.check,
                text: 'One special character',
                isValid: widget.password.contains(
                  RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementRow({
    required IconData icon,
    required String text,
    required bool isValid,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: isValid ? AppColors.success : AppColors.textGray),
        const SizedBox(width: 8.5),
        Text(
          text,
          style: TextStyle(
            color: isValid ? AppColors.success : AppColors.textGray,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
