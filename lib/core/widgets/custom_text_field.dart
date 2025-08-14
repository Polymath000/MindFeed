import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/constants/borders.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.hintText, this.validator});
  final String hintText;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      validator: validator,
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: AppBorders.xxxs,
          borderSide: BorderSide(color: AppColors.white, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorders.xxxs,
          borderSide: BorderSide(color: AppColors.white, width: 2.0),
        ),
      ),
    );
  }
}
