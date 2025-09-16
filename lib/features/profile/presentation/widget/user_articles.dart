import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/features/profile/presentation/widget/custom_article_card_of_profile.dart';

class UserArticles extends StatelessWidget {
  const UserArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Articles',
                  style: AppTextStyles.titleLarge!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text('120 articles'),
              ],
            ),
            Column(
              children: List.generate(
                10,
                (index) => CustomArticleCardOfProfile(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
