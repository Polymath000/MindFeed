import 'package:flutter/material.dart';
import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/features/home/presentation/widgets/add_to_favorite_article_card.dart';
import 'package:mind_feed/features/home/presentation/widgets/article_card_image.dart';
import 'package:mind_feed/features/home/presentation/widgets/custom_popup_menu_button_for_home.dart';

class ArticleCardOfAuthor extends StatelessWidget {
  ArticleCardOfAuthor({
    super.key,
    required this.title,
    required this.imagePath,
    this.isDwonload = false,
    this.isFav = false,
  });

  final String title;
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
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.35,
                    child: ArticleCardImage(imagePath: imagePath),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).height * 0.18,
                        child: Text(
                          title,
                          style: AppTextStyles.titleLarge?.copyWith(
                            color: isDark ? AppColors.white : AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          AddToFavoriteArticleCard(isFav: isFav),
                          CustomPopupMenuButtonForHomeView(
                            isDwonload: isDwonload,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
