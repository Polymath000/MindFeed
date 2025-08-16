import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/presentation/widgets/change_password_view_body.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key, required this.email});
  final String email;
  static const String routeName = 'changepassword';
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ChangePasswordViewBody(email: email));
  }
}
