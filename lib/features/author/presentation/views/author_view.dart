import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_mock_data.dart';
import 'package:mind_feed/features/author/presentation/views/author_personal_info.dart';
import 'package:mind_feed/features/author/presentation/widgets/author_app_bar.dart';
import 'package:mind_feed/features/profile/presentation/widget/custom_article_card_of_profile.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class AuthorView extends StatelessWidget {
  const AuthorView({super.key});
  static const String routeName = 'author';

  @override
  Widget build(BuildContext context) {
    final authorArticles = EditorialMockData.stories
        .where((s) => s.authorName == 'Wade Warren')
        .toList();

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: CustomScrollView(
            slivers: [
              const AuthorAppBar(),
              const AuthorPersonalInfo(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Published Stories',
                            style: TextStyle(
                              color: AppColors.softCream,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.6,
                            ),
                          ),
                          Text(
                            '${authorArticles.length} stories',
                            style: const TextStyle(
                              color: AppColors.greyText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ...authorArticles.map(
                        (item) => CustomArticleCardOfProfile(
                          item: item,
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
