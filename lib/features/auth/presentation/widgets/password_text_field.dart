import 'package:mind_feed/core/constants/borders.dart';
import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      obscureText: _isObscured,
      obscuringCharacter: '•',
      focusNode: _passwordFocusNode,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        } else if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
          return 'Password must contain at least one uppercase letter';
        } else if (!RegExp(r'[0-9]').hasMatch(value)) {
          return 'Password must contain at least one number';
        } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
          return 'Password must contain at least one special character';
        }
        return null;
      },
      style: const TextStyle(
        color: AppColors.softCream,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: AppColors.greyText,
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.greyText,
          size: 20,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
          icon: Icon(
            _isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.greyText,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: AppColors.charcoal,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: const OutlineInputBorder(
          borderRadius: AppBorders.control,
          borderSide: BorderSide(color: AppColors.borderDark, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppBorders.control,
          borderSide: BorderSide(color: AppColors.borderDark, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppBorders.control,
          borderSide: BorderSide(color: AppColors.cream, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorders.control,
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppBorders.control,
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
      ),
    );
  }
}
