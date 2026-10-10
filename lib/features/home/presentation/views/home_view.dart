import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:mind_feed/features/home/presentation/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = 'home';
  @override
  Widget build(BuildContext context) =>
      const Scaffold(backgroundColor: Color(0xFF171614), body: HomeViewBody());
}

final AdvancedDrawerController advancedDrawerController =
    AdvancedDrawerController();
