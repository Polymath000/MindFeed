import 'package:flutter/material.dart';
import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';
import 'package:mind_feed/config/routes/on_generate_routes.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/features/auth/presentation/widgets/categories_view_body.dart';

class AriclesByCategories extends StatelessWidget {
  const AriclesByCategories({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3 / 2,
        ),
        itemCount: categories.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          return ZoomIn(
            config: BaseAnimationConfig(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: AppBorders.xxs),
                elevation: 4,
                child: InkWell(
                  borderRadius: AppBorders.xxs,
                  onTap: () {
                    AppRoutes.articlesCategoryView(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? const [
                                AppColors.darkSurface,
                                AppColors.darkerEdge,
                              ]
                            : const [
                                AppColors.lightSurface,
                                AppColors.softShadow,
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppBorders.xxs,
                    ),
                    child: Center(
                      child: Text(
                        categories[index][0],
                        style: AppTextStyles.bodyLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.black,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
