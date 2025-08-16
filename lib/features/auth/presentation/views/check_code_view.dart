import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/presentation/widgets/check_code_view_body.dart';

class CheckCodeView extends StatelessWidget {
  const CheckCodeView({super.key, required this.email});
  final String email;
  static const String routeName = 'checkcode';
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CheckCodeViewBody(email: email));
  }
}
