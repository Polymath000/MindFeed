import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/utls/app_images.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(title: Text('MindFeed')),
            backgroundColor: AppColors.lightGray,
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text('For You', style: AppTextStyles.headlineMedium),
                  ),
                  ArticleCard(
                    title:
                        "The Future of AI: How Machine Learning is Transforming Industries",
                    author: "Sarah Johnson",
                    date: "2 hours ago",
                    imagePath: Assets.assetsImagesJustTest,
                  ),
                  ArticleCard(
                    title:
                        "The Future of AI: How Machine Learning is Transforming Industries",
                    author: "Sarah Johnson",
                    date: "2 hours ago",
                    imagePath: Assets.assetsImagesJustTest,
                  ),
                  ArticleCard(
                    title:
                        "The Future of AI: How Machine Learning is Transforming Industries",
                    author: "Sarah Johnson",
                    date: "2 hours ago",
                    imagePath: Assets.assetsImagesJustTest,
                  ),
                  ArticleCard(
                    title:
                        "The Future of AI: How Machine Learning is Transforming Industries",
                    author: "Sarah Johnson",
                    date: "2 hours ago",
                    imagePath: Assets.assetsImagesJustTest,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
