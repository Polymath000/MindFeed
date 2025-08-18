import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/utls/app_images.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/category_card.dart';

class CategoriesViewBody extends StatelessWidget {
  const CategoriesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        authBackground(),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Your Favorite Categories',
                    style: AppTextStyles.headlineMedium!.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Select topics you\'re interested in',
                    style: AppTextStyles.bodyLarge!.copyWith(
                      color: AppColors.lightGray,
                    ),
                  ),
                  SizedBox(height: 16),
                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 22,
                    crossAxisSpacing: 22,
                    childAspectRatio: 1.8,
                    children: List.generate(
                      categories.length,
                      (index) => CategoryCard(category: categories[index]),
                    ),
                  ),
                  SizedBox(height: 32),
                  CustomButton(buttonText: 'Continue', onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// TODO: It just for test untill API finished
List<List<String>> categories = [
  ["Technology", Assets.assetsImagesTechnologyIcon],
  ["Business", Assets.assetsImagesBusinessIcon],
  ["Education", Assets.assetsImagesEducationIcon],
  ["Science", Assets.assetsImagesScienceIcon],
];
