import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/widgets/custom_text_field.dart';

class CheckCodeOtpBoxes extends StatelessWidget {
  final TextEditingController controller;

  const CheckCodeOtpBoxes({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verification Code',
          style: TextStyle(
            color: AppColors.softCream,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          textEditingController: controller,
          hintText: 'Enter 6-digit code',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter the verification code';
            }
            if (value.trim().length < 6) {
              return 'Verification code must be 6 digits';
            }
            return null;
          },
        ),
      ],
    );
  }
}
