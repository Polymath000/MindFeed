import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/utls/app_images.dart';
import 'package:mind_feed/core/widgets/custom_app_bar.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_card.dart';
import 'package:mind_feed/features/home/presentation/widgets/custom_drawer.dart';
import 'package:mind_feed/features/home/presentation/widgets/custombackground_for_the_drawer_in_home_page.dart';

class DownloadedArticlesView extends StatelessWidget {
  const DownloadedArticlesView({super.key});
  static const routeName = 'downloadedArticlesView';
  @override
  Widget build(BuildContext context) {
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
        body: CustomScrollView(
          slivers: [
            CustomAppBar(title: 'Your Downloads'),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                prefixIcon: Icon(Icons.search_rounded),
                                suffixIcon: Icon(Icons.clear),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: AppBorders.xxxs,
                                  borderSide: BorderSide(
                                    color: AppColors.lightBlue,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: AppBorders.xxxs,
                                  borderSide: BorderSide(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.all(14),
                            icon: Icon(Icons.search, color: AppColors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.darkBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppBorders.xxxs,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ArticleCard(
                      title: 'title',
                      author: 'author',
                      date: 'date',
                      imagePath: Assets.assetsImagesJustTest,
                      isDwonload: true,
                    ),
                    ArticleCard(
                      title: 'title',
                      author: 'author',
                      date: 'date',
                      imagePath: Assets.assetsImagesJustTest,
                      isDwonload: true,
                    ),
                    ArticleCard(
                      title: 'title',
                      author: 'author',
                      date: 'date',
                      imagePath: Assets.assetsImagesJustTest,
                      isDwonload: true,
                    ),
                    ArticleCard(
                      title: 'title',
                      author: 'author',
                      date: 'date',
                      imagePath: Assets.assetsImagesJustTest,
                      isDwonload: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
