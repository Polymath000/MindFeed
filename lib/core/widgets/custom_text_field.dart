import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/constants/borders.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.hintText,
    this.validator,
    this.onChanged,
    this.textEditingController,
  });
  final String hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  TextEditingController? textEditingController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onChanged: onChanged,
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      validator: validator,
      style: TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(color: AppColors.white),
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
