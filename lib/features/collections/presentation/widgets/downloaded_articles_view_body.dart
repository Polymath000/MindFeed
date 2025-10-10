import 'package:flutter/material.dart' hide SearchBar;
import 'package:mind_feed/core/utls/app_images.dart';
import 'package:mind_feed/core/widgets/custom_app_bar.dart';
import 'package:mind_feed/core/widgets/search_bar.dart';
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
                CustomSearchBar(),
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
