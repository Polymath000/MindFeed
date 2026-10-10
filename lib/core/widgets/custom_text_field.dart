import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.validator,
    this.onChanged,
    this.textEditingController,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  final String hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextEditingController? textEditingController;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onChanged: onChanged,
      autofocus: false,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(
        color: EditorialPalette.softCream,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFAAA49B),
          fontSize: 14,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF262422),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: const OutlineInputBorder(
          borderRadius: EditorialRadii.control,
          borderSide: BorderSide(color: Color(0xFF383530), width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: EditorialRadii.control,
          borderSide: BorderSide(color: Color(0xFF383530), width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: EditorialRadii.control,
          borderSide: BorderSide(color: EditorialPalette.cream, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: EditorialRadii.control,
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: EditorialRadii.control,
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
      ),
    );
  }
}
