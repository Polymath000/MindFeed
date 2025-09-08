import 'package:flutter/material.dart';
import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/features/auth/presentation/widgets/categories_view_body.dart';

class AriclesByCategoriesView extends StatelessWidget {
  const AriclesByCategoriesView({Key? key}) : super(key: key);
  static const String routeName = 'ariclesByCategories';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.lightCyan,
                            AppColors.cyan,
                            AppColors.lightBlue,
                            AppColors.darkBlue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: AppBorders.xxs,
                      ),
                      child: Center(
                        child: Text(
                          categories[index][0],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
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
      ),
    );
  }
}
