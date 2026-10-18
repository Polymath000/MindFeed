import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_field_helpers.dart';

class ArticleCategorySelector extends StatelessWidget {
  const ArticleCategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddArticleCubit, AddArticleState>(
      buildWhen: (previous, current) =>
          previous.selectedCategoryId != current.selectedCategoryId ||
          previous.categories != current.categories ||
          previous.formErrors.categoryError != current.formErrors.categoryError,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ArticleSectionHeader(
              title: 'Category',
              counter: 'Select 1',
              isCounterError: false,
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              key: const Key('article_category_field'),
              initialValue: state.selectedCategoryId,
              isExpanded: true,
              dropdownColor: AppColors.whiteLight,
              decoration: articleInputDecoration(
                hintText: 'Select a primary category',
                errorText: state.formErrors.categoryError,
              ),
              items: state.categories.map((cat) {
                return DropdownMenuItem<String>(
                  value: cat.id,
                  child: Text(
                    cat.name,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) =>
                  context.read<AddArticleCubit>().onCategorySelected(val),
            ),
          ],
        );
      },
    );
  }
}
