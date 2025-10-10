import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/features/collections/presentation/widgets/downloaded_articles_view_body.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/home/presentation/widgets/custom_drawer.dart';
import 'package:mind_feed/features/home/presentation/widgets/custombackground_for_the_drawer_in_home_page.dart';

class DownloadedArticlesView extends StatelessWidget {
  const DownloadedArticlesView({super.key});
  static const routeName = 'downloadedArticlesView';
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
        body: DownloadedArticlesViewBody(),
        backgroundColor: isDark ? AppColors.lightBlack : AppColors.white,
      ),
    );
  }
}
