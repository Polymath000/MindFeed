import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/features/home/presentation/widgets/custom_drawer.dart';
import 'package:mind_feed/features/home/presentation/widgets/custombackground_for_the_drawer_in_home_page.dart';
import 'package:mind_feed/features/home/presentation/widgets/home_view_body.dart';

AdvancedDrawerController advancedDrawerController = AdvancedDrawerController();

class HomeView extends StatelessWidget {
  HomeView({super.key});
  static const String routeName = 'home';
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AdvancedDrawer(
      backdrop: CustombackgroundForTheDrawerInHomePage(),
      controller: advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: CustomDrawer(routeName: routeName),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.lightBlack : AppColors.white,
        body: HomeViewBody(),
        floatingActionButton: FloatingActionButton(onPressed: () {}),
      ),
    );
  }
}
