import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/utls/app_images.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_card.dart';
import 'package:mind_feed/features/home/presentation/widgets/chip_group.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.lightGray,
          actionsPadding: EdgeInsets.symmetric(horizontal: 32),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Semantics(
                    label: 'Menu',
                    onTapHint: 'expand drawer',
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  ),
                );
              },
            ),
          ),
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
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            top: 32,
            bottom: 8,
          ),
          sliver: SliverToBoxAdapter(
            child: Text('For You', style: AppTextStyles.headlineMedium),
          ),
        ),
        ChipGroup(),
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          sliver: ArticlesForTest(),
        ),
      ],
    );
  }

  void _handleMenuButtonPressed() {
    advancedDrawerController.showDrawer();
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
