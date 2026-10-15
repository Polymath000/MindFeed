import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/constants/app_images.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/presentation/controllers/categories_cubit/categories_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/category_card.dart';

const List<List<String>> categories = [
  ["Technology", Assets.assetsImagesTechnologyIcon],
  ["Business", Assets.assetsImagesBusinessIcon],
  ["Education", Assets.assetsImagesEducationIcon],
  ["Science", Assets.assetsImagesScienceIcon],
];

class CategoriesViewBody extends StatelessWidget {
  const CategoriesViewBody({
    super.key,
    this.userEntity,
  });

  final UserEntity? userEntity;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesCubit, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.main,
            (route) => false,
          );
        } else if (state is CategoriesFailure) {
          customShowSnackBar(
            context: context,
            message: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CategoriesCubit>();
        final isLoading = state is CategoriesLoading;

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
                      const SizedBox(height: 16),
                      Text(
                        'Select topics you\'re interested in',
                        style: AppTextStyles.bodyLarge!.copyWith(
                          color: AppColors.lightGray,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 22,
                        crossAxisSpacing: 22,
                        childAspectRatio: 1.8,
                        children: List.generate(
                          categories.length,
                          (index) {
                            final item = categories[index];
                            final name = item[0];
                            final isSelected = cubit.selectedCategories.contains(name);
                            return CategoryCard(
                              category: item,
                              isSelected: isSelected,
                              onTap: () {
                                cubit.toggleCategory(name);
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        buttonText: isLoading ? 'Saving...' : 'Continue',
                        onTap: isLoading
                            ? null
                            : () {
                                String? userId;
                                try {
                                  userId = Supabase.instance.client.auth.currentUser?.id;
                                } catch (_) {}
                                cubit.saveCategories(
                                  userId: userId,
                                  currentUser: userEntity,
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
