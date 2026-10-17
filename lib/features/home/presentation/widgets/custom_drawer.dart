import 'package:flutter/material.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/features/collections/presentation/views/articles_saved.dart';
import 'package:mind_feed/features/collections/presentation/views/downloaded_articles_view.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/settings/presentation/views/settings_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.routeName});
  final String routeName;

  @override
  Widget build(BuildContext context) {
    final String currentRoute = routeName;
    return SafeArea(
      child: ListTileTheme(
        textColor: AppColors.white,
        iconColor: AppColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 128.0,
              height: 128.0,
              margin: const EdgeInsets.only(top: 24.0, bottom: 64.0),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                Assets.assetsImagesMindFeedLogo,
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              iconColor: (currentRoute == HomeView.routeName ||
                      currentRoute == AppRoutes.main ||
                      currentRoute == AppRoutes.home)
                  ? AppColors.amber
                  : AppColors.white,
              textColor: (currentRoute == HomeView.routeName ||
                      currentRoute == AppRoutes.main ||
                      currentRoute == AppRoutes.home)
                  ? AppColors.amber
                  : AppColors.white,
              onTap: () {
                final bool isHome = currentRoute == HomeView.routeName ||
                    currentRoute == AppRoutes.main ||
                    currentRoute == AppRoutes.home;
                if (!isHome) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.main, (route) => false);
                }
                advancedDrawerController.hideDrawer();
              },
              leading: const Icon(AppIcons.home),
              title: const Text('Home'),
            ),
            ListTile(
              iconColor: (currentRoute == AppRoutes.addArticle ||
                      currentRoute == 'Add Article')
                  ? AppColors.amber
                  : AppColors.white,
              textColor: (currentRoute == AppRoutes.addArticle ||
                      currentRoute == 'Add Article')
                  ? AppColors.amber
                  : AppColors.white,
              onTap: () {
                final bool isWrite = currentRoute == AppRoutes.addArticle ||
                    currentRoute == 'Add Article';
                if (!isWrite) {
                  Navigator.pushNamed(context, AppRoutes.addArticle);
                }
                advancedDrawerController.hideDrawer();
              },
              leading: const Icon(AppIcons.edit),
              title: const Text('Write Article'),
            ),
            ListTile(
              iconColor: (currentRoute == AppRoutes.drafts ||
                      currentRoute == 'drafts')
                  ? AppColors.amber
                  : AppColors.white,
              textColor: (currentRoute == AppRoutes.drafts ||
                      currentRoute == 'drafts')
                  ? AppColors.amber
                  : AppColors.white,
              onTap: () {
                final bool isDrafts = currentRoute == AppRoutes.drafts ||
                    currentRoute == 'drafts';
                if (!isDrafts) {
                  Navigator.pushNamed(context, AppRoutes.drafts);
                }
                advancedDrawerController.hideDrawer();
              },
              leading: const Icon(AppIcons.fileOpen),
              title: const Text('My Drafts'),
            ),
            ListTile(
              iconColor: (currentRoute == ArticlesSaved.routeName ||
                      currentRoute == AppRoutes.articlesSaved)
                  ? AppColors.amber
                  : AppColors.white,
              textColor: (currentRoute == ArticlesSaved.routeName ||
                      currentRoute == AppRoutes.articlesSaved)
                  ? AppColors.amber
                  : AppColors.white,
              onTap: () {
                final bool isSaved =
                    currentRoute == ArticlesSaved.routeName ||
                        currentRoute == AppRoutes.articlesSaved;
                if (!isSaved) {
                  Navigator.pushNamed(context, AppRoutes.articlesSaved);
                }
                advancedDrawerController.hideDrawer();
              },
              leading: const Icon(AppIcons.bookmarkBorderRounded),
              title: const Text('Saved Stories'),
            ),
            ListTile(
              iconColor: (currentRoute == DownloadedArticlesView.routeName ||
                      currentRoute == AppRoutes.downloadedArticles)
                  ? AppColors.amber
                  : AppColors.white,
              textColor: (currentRoute == DownloadedArticlesView.routeName ||
                      currentRoute == AppRoutes.downloadedArticles)
                  ? AppColors.amber
                  : AppColors.white,
              onTap: () {
                final bool isDownload =
                    currentRoute == DownloadedArticlesView.routeName ||
                        currentRoute == AppRoutes.downloadedArticles;
                if (!isDownload) {
                  Navigator.pushNamed(context, AppRoutes.downloadedArticles);
                }
                advancedDrawerController.hideDrawer();
              },
              leading: const Icon(AppIcons.download),
              title: const Text('Downloads'),
            ),
            ListTile(
              iconColor: (currentRoute == SettingsView.routeName ||
                      currentRoute == AppRoutes.settings)
                  ? AppColors.amber
                  : AppColors.white,
              textColor: (currentRoute == SettingsView.routeName ||
                      currentRoute == AppRoutes.settings)
                  ? AppColors.amber
                  : AppColors.white,
              onTap: () {
                final bool isSettings =
                    currentRoute == SettingsView.routeName ||
                        currentRoute == AppRoutes.settings;
                if (!isSettings) {
                  Navigator.pushNamed(context, AppRoutes.settings);
                }
                advancedDrawerController.hideDrawer();
              },
              leading: const Icon(AppIcons.settings),
              title: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
