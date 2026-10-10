import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_mock_data.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/profile/presentation/widget/custom_article_card_of_profile.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class UserArticles extends StatefulWidget {
  const UserArticles({super.key});

  @override
  State<UserArticles> createState() => _UserArticlesState();
}

class _UserArticlesState extends State<UserArticles> {
  late List<EditorialNewsItem> _articles;

  @override
  void initState() {
    super.initState();
    _articles = List.from(EditorialMockData.userArticles);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Articles',
                  style: TextStyle(
                    color: EditorialPalette.softCream,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Text(
                    '${_articles.length} published',
                    style: const TextStyle(
                      color: EditorialPalette.cream,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (_articles.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: Text(
                    'No published articles yet',
                    style: TextStyle(color: AppColors.greyText, fontSize: 14),
                  ),
                ),
              )
            else
              ..._articles.map(
                (item) => CustomArticleCardOfProfile(
                  item: item,
                  onDelete: () {
                    setState(() {
                      _articles.removeWhere((a) => a.id == item.id);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text('Removed: ${item.title.split('\n').first}'),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
