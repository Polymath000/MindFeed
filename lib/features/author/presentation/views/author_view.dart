import 'package:flutter/material.dart';

class AuthorView extends StatelessWidget {
  const AuthorView({super.key});
  static const String routeName = 'author';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [SliverAppBar(actions: [
              
            ],
          )]),
    );
  }
}
