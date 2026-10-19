import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_field_helpers.dart';

class ArticleTitleField extends StatelessWidget {
  final TextEditingController controller;

  const ArticleTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddArticleCubit, AddArticleState>(
      buildWhen: (previous, current) =>
          previous.title != current.title ||
          previous.formErrors.titleError != current.formErrors.titleError,
      builder: (context, state) {
        final titleWordCount = state.titleWordCount;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArticleSectionHeader(
              title: 'Story Title',
              counter: '$titleWordCount / 12 words',
              isCounterError: titleWordCount > 12,
            ),
            const SizedBox(height: 6),
            TextField(
              key: const Key('article_title_field'),
              controller: controller,
              onChanged: (val) =>
                  context.read<AddArticleCubit>().onTitleChanged(val),
              maxLines: 2,
              minLines: 1,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
              decoration: articleInputDecoration(
                hintText: 'Enter an editorial headline (1..12 words)...',
                errorText: state.formErrors.titleError,
              ),
            ),
          ],
        );
      },
    );
  }
}
