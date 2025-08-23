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
            backgroundColor: AppColors.lightGray,
            actionsPadding: EdgeInsets.symmetric(horizontal: 32),
            title: Text('MindFeed', style: AppTextStyles.headlineMedium),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.settings),
              ),
              CircleAvatar(),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Text('For You', style: AppTextStyles.headlineMedium),
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [ChoiceChip(label: Text('All'), selected: false)],
            ),
          ),
          SliverPadding(padding: EdgeInsets.all(16), sliver: ArticlesForTest()),
        ],
      ),
    );
  }
}

class ArticlesForTest extends StatelessWidget {
  const ArticlesForTest({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    );
  }
}
