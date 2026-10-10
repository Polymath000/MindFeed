import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key, required this.password});
  final String password;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF262422),
        border: Border.all(color: const Color(0xFF383530)),
        borderRadius: EditorialRadii.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password requirements:',
            style: TextStyle(
              color: EditorialPalette.softCream,
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
          color: isValid ? const Color(0xFF10B981) : const Color(0xFF8E8E93),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isValid ? const Color(0xFF10B981) : const Color(0xFF8E8E93),
            fontSize: 12,
            fontWeight: isValid ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
