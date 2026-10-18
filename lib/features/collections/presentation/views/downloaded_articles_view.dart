import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/collections/presentation/controllers/downloads/downloads_cubit.dart';
import 'package:mind_feed/features/collections/presentation/widgets/downloaded_articles_view_body.dart';
import 'package:mind_feed/features/home/presentation/widgets/custom_drawer.dart';
import 'package:mind_feed/features/home/presentation/widgets/custombackground_for_the_drawer_in_home_page.dart';

class DownloadedArticlesView extends StatelessWidget {
  const DownloadedArticlesView({super.key, this.cubit});
  static const routeName = 'downloadedArticlesView';
  final DownloadsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final content = AdvancedDrawer(
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
      drawer: const CustomDrawer(routeName: AppRoutes.downloadedArticles),
      child: Scaffold(
        body: const DownloadedArticlesViewBody(),
        backgroundColor: isDark ? AppColors.lightBlack : AppColors.white,
      ),
    );

    if (cubit != null) {
      return BlocProvider<DownloadsCubit>.value(
        value: cubit!,
        child: content,
      );
    }

    return BlocProvider<DownloadsCubit>(
      create: (_) => getIt<DownloadsCubit>()..loadDownloads(),
      child: content,
    );
  }
}
