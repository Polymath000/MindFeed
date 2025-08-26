import 'package:flutter/material.dart';
import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/utls/app_images.dart';
import 'package:mind_feed/features/articles_save/presentation/widgets/custom_popup_menu_button_for_saved_articles_view.dart';

class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.isleft});
  final bool isleft;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: isleft
          ? SlideInLeft(config: ListCardBody())
          : SlideInRight(config: ListCardBody()),
    );
  }

  BaseAnimationConfig ListCardBody() {
    return BaseAnimationConfig(
      delay: Duration(microseconds: 50),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: AppBorders.xxxs,
          border: Border.all(color: AppColors.grey),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Reading list',
                      style: AppTextStyles.titleLarge,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('6 Articles saved', style: AppTextStyles.bodyLarge),
                      CustomPopupMenuButtonForSavedArticlesView(),
                    ],
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Image(
                    height: 100,
                    image: AssetImage(Assets.assetsImagesJustTest),
                  ),
                  Image(
                    height: 100,
                    image: AssetImage(Assets.assetsImagesJustTest),
                  ),
                  Image(
                    height: 100,
                    image: AssetImage(Assets.assetsImagesJustTest),
                  ),
                  Image(
                    height: 100,
                    image: AssetImage(Assets.assetsImagesJustTest),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
