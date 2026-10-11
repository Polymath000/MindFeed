import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:mind_feed/features/home/presentation/widgets/home_view_body.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = 'home';
  @override
  Widget build(BuildContext context) =>
      const Scaffold(backgroundColor: AppColors.ink, body: HomeViewBody());
}

final AdvancedDrawerController advancedDrawerController =
    AdvancedDrawerController();
