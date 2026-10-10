import 'package:flutter/material.dart';
import 'package:mind_feed/core/widgets/custom_text_field.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    this.onChanged,
    this.controller,
  });

  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'Email address',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(
        Icons.mail_outline_rounded,
        color: AppColors.greyText,
        size: 20,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onChanged: onChanged,
      textEditingController: controller,
    );
  }
}
