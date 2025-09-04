import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/utls/app_images.dart';
import 'package:mind_feed/core/widgets/custom_app_bar.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_card.dart';

class DownloadedArticlesViewBody extends StatelessWidget {
  const DownloadedArticlesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                            suffixIcon: Icon(FontAwesomeIcons.xmark, size: 22),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: AppBorders.xxxs,
                              borderSide: BorderSide(
                                color: AppColors.lightBlue,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: AppBorders.xxxs,
                              borderSide: BorderSide(color: AppColors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.all(14),
                        icon: Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: AppColors.white,
                        ),
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
    );
  }
}
