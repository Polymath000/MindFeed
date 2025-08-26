import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/utls/app_images.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                onTap: () {
                  bool isHome =
                      ModalRoute.of(context)!.settings.name ==
                      HomeView.routeName;
                  advancedDrawerController.hideDrawer();
                },
                leading: Icon(Icons.home),
                title: Text('Home'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.download_rounded),
                title: Text('Downloads'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.favorite),
                title: Text('Favourites'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.person),
                title: Text('Profile'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.settings),
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
      ),
    );
  }
}
