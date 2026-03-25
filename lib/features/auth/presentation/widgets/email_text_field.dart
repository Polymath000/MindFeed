// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mind_feed/core/widgets/custom_text_field.dart';

class EmailTextField extends StatelessWidget {
  EmailTextField({Key? key, this.onChanged, this.controller}) : super(key: key);
  final ValueChanged<String>? onChanged;
  TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'Email',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        } else {
          return null;
        }
      },
      onChanged: onChanged,
      textEditingController: controller,
    );
  }
}
