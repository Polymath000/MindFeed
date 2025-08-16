import 'package:flutter/material.dart';
import 'package:mind_feed/features/auth/presentation/widgets/send_code_view_body.dart';

class SendCodeView extends StatelessWidget {
  const SendCodeView({super.key});
  static const String routeName = 'sendcode';
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SendCodeViewBody());
  }
}
