import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/constants/borders.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({super.key, required this.hintText});
  final String hintText;
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
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      obscureText: isObscured,
      obscuringCharacter: '*',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        } else {
          return null;
        }
      },
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: widget.hintText,
        suffixIcon: IconButton(
          onPressed: () {
            // _passwordFocusNode.unfocus();
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
