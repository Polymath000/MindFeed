import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/features/collections/presentation/views/downloaded_articles_view.dart';
import 'package:mind_feed/features/collections/presentation/views/favorite_movies_view.dart';
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
              decoration: BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(Assets.assetsImagesLogo),
            ),
            ListTile(
              iconColor: currentRoute == HomeView.routeName
                  ? AppColors.amber
                  : AppColors.white,
              textColor: currentRoute == HomeView.routeName
                  ? AppColors.amber
                  : AppColors.white,
              onTap: () {
                final bool isHome = currentRoute == HomeView.routeName;
                if (!isHome) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
                advancedDrawerController.hideDrawer();
              },
              leading: Icon(AppIcons.home),
              title: Text('Home'),
            ),
            ListTile(
              iconColor: currentRoute == DownloadedArticlesView.routeName
                  ? AppColors.amber
                  : AppColors.white,
              textColor: currentRoute == DownloadedArticlesView.routeName
                  ? AppColors.amber
                  : AppColors.white,
              onTap: () {
                final bool isDownload =
                    currentRoute == DownloadedArticlesView.routeName;
                if (!isDownload) Navigator.pushNamed(context, AppRoutes.downloadedArticles);
                advancedDrawerController.hideDrawer();
              },
              leading: Icon(AppIcons.download),
              title: Text('Downloads'),
            ),
            ListTile(
              iconColor: currentRoute == FavoriteMoviesView.routeName
                  ? AppColors.amber
                  : AppColors.white,
              textColor: currentRoute == FavoriteMoviesView.routeName
                  ? AppColors.amber
                  : AppColors.white,
              onTap: () {
                final bool isFav = currentRoute == FavoriteMoviesView.routeName;
                if (!isFav) Navigator.pushNamed(context, AppRoutes.favoriteMovies);
                advancedDrawerController.hideDrawer();
              },
              leading: Icon(AppIcons.favorite),
              title: Text('Favourites'),
            ),
            ListTile(
              iconColor: currentRoute == SettingsView.routeName
                  ? AppColors.amber
                  : AppColors.white,
              textColor: currentRoute == SettingsView.routeName
                  ? AppColors.amber
                  : AppColors.white,
              onTap: () {
                final bool isFav = currentRoute == SettingsView.routeName;
                if (!isFav) Navigator.pushNamed(context, AppRoutes.settings);
                advancedDrawerController.hideDrawer();
              },
              leading: Icon(AppIcons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
