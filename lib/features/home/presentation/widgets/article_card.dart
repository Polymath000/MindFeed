import 'package:flutter/material.dart';
import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/features/home/presentation/widgets/add_to_favorite_article_card.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_card_image.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_card_information.dart';
import 'package:mind_feed/features/home/presentation/widgets/custom_popup_menu_button_for_home.dart';

class ArticleCard extends StatelessWidget {
  ArticleCard({
    super.key,
    required this.title,
    required this.author,
    required this.date,
    required this.imagePath,
    this.isDwonload = false,
    this.isFav = false,
  });

  final String title;
  final String author;
  final String date;
  final String imagePath;
  final bool isDwonload;
  final bool isFav;
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ZoomIn(
      config: BaseAnimationConfig(
        delay: Duration(microseconds: 320),
        child: GestureDetector(
          onTap: () {
            AppRoutes.articleView(context);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.spaceBlack : AppColors.lightGray,
              borderRadius: AppBorders.xxxs,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArticleCardImage(imagePath: imagePath),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ArticleCardInformation(
                        title: title,
                        author: author,
                        date: date,
                      ),
                      Column(
                        children: [
                          AddToFavoriteArticleCard(isFav: isFav),
                          CustomPopupMenuButtonForHomeView(
                            isDwonload: isDwonload,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
