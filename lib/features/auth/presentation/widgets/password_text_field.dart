import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/constants/borders.dart';

class PasswordTextField extends StatefulWidget {
  PasswordTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
  });
  final String hintText;
  final ValueChanged<String>? onChanged;
  TextEditingController? controller;
  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isObscured = true;
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
      obscureText: isObscured,
      obscuringCharacter: '*',
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
        } else {
          return null;
        }
      },
      style: TextStyle(color: AppColors.white),
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: AppColors.white),
        labelText: widget.hintText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isObscured = !isObscured;
            });
          },
          icon: Icon(
            isObscured ? Icons.visibility_off : Icons.visibility,
            color: AppColors.white,
          ),
        ),
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
