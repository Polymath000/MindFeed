import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/utls/app_images.dart';
import 'package:mind_feed/features/downloaded_articles_view/presentation/views/downloaded_articles_view.dart';
import 'package:mind_feed/features/favoritemovies/presentation/views/favorite_movies_view.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';

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
                if (!isHome) AppRoutes.main(context);
                advancedDrawerController.hideDrawer();
              },
              leading: Icon(FontAwesomeIcons.solidHouse),
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
                if (!isDownload) AppRoutes.downloadedArticlesView(context);
                advancedDrawerController.hideDrawer();
              },
              leading: Icon(FontAwesomeIcons.download),
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
                if (!isFav) AppRoutes.favoriteMoviesView(context);
                advancedDrawerController.hideDrawer();
              },
              leading: Icon(FontAwesomeIcons.solidHeart),
              title: Text('Favourites'),
            ),
            ListTile(
              onTap: () {
                advancedDrawerController.hideDrawer();
              },
              leading: Icon(FontAwesomeIcons.user),
              title: Text('Profile'),
            ),
            ListTile(
              onTap: () {
                advancedDrawerController.hideDrawer();
              },
              leading: Icon(FontAwesomeIcons.gears),
              title: Text('Settings'),
            ),

            // Spacer(),
            // DefaultTextStyle(
            //   style: TextStyle(fontSize: 12, color: Colors.white54),
            //   child: Container(
            //     margin: const EdgeInsets.symmetric(vertical: 16.0),
            //     child: Text('Terms of Service | Privacy Policy'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
