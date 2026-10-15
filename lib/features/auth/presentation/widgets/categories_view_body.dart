import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/core/helpers/custom_show_snack_bar.dart';
import 'package:mind_feed/core/widgets/custom_button.dart';
import 'package:mind_feed/features/auth/domain/entities/user_entity.dart';
import 'package:mind_feed/features/auth/presentation/controllers/categories_cubit/categories_cubit.dart';
import 'package:mind_feed/features/auth/presentation/widgets/auth_background.dart';
import 'package:mind_feed/features/auth/presentation/widgets/category_card.dart';

import 'package:mind_feed/core/constants/category_items.dart';
export 'package:mind_feed/core/constants/category_items.dart';

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
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
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
                          const SizedBox(height: 12),
                          Text(
                            'Select topics you\'re interested in',
                            style: AppTextStyles.bodyLarge!.copyWith(
                              color: AppColors.lightGray,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 8,
                            runSpacing: 10,
                            children: List.generate(
                              categories.length,
                              (index) {
                                final item = categories[index];
                                final isSelected =
                                    state.selectedCategories.contains(item.name);
                                return CategoryCard(
                                  title: item.name,
                                  icon: item.icon,
                                  isSelected: isSelected,
                                  onTap: () {
                                    cubit.toggleCategory(item.name);
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: CustomButton(
                      buttonText: isLoading ? 'Saving...' : 'Continue',
                      onTap: isLoading
                          ? null
                          : () {
                              cubit.saveCategories(
                                currentUser: userEntity,
                              );
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      },
    );
  }
}
