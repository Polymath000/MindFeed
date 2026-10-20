import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_field_helpers.dart';

class ArticleContentField extends StatelessWidget {
  final TextEditingController controller;

  const ArticleContentField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddArticleCubit, AddArticleState>(
      buildWhen: (previous, current) =>
          previous.content != current.content ||
          previous.formErrors.contentError != current.formErrors.contentError,
      builder: (context, state) {
        final contentWordCount = state.contentWordCount;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArticleSectionHeader(
              title: 'Story Content (Markdown)',
              counter: '$contentWordCount / 300 words min',
              isCounterError: contentWordCount < 300,
              isCounterSuccess: contentWordCount >= 300,
            ),
            const SizedBox(height: 6),
            TextField(
              key: const Key('article_content_field'),
              controller: controller,
              onChanged: (val) =>
                  context.read<AddArticleCubit>().onContentChanged(val),
              minLines: 12,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.ink,
              ),
              decoration: articleInputDecoration(
                hintText:
                    'Write your story here in Markdown format (at least 300 words)...',
                errorText: state.formErrors.contentError,
              ),
            ),
          ],
        );
      },
    );
  }
}
