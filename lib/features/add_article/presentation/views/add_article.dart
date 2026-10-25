import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/add_article_cubit/add_article_state.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/add_article_app_bar.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_category_selector.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_content_field.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_cover_image_field.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_edit_warning_banner.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_editor_action_bar.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_tag_selector.dart';
import 'package:mind_feed/features/add_article/presentation/widgets/article_title_field.dart';

class AddArticleView extends StatefulWidget {
  final EditorialNewsItem? initialItem;
  final AddArticleCubit? cubit;

  const AddArticleView({super.key, this.initialItem, this.cubit});

  @override
  State<AddArticleView> createState() => _AddArticleViewState();
}

class _AddArticleViewState extends State<AddArticleView> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _coverUrlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialItem?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.initialItem?.content ?? '',
    );
    _coverUrlController = TextEditingController(
      text: widget.initialItem?.heroImageUrl ??
          widget.initialItem?.coverImageUrl ??
          '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _coverUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = BlocConsumer<AddArticleCubit, AddArticleState>(
      listener: (context, state) {
        final message = state.errorMessage ?? state.successMessage;
        if (message != null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: state.errorMessage != null
                  ? AppColors.redHighlight
                  : AppColors.ink,
            ),
          );
        }
      },
      builder: (context, state) {
        final isEditing =
            state.editingItemId != null && state.editingItemId!.isNotEmpty;
        final titleText = isEditing
            ? (state.isEditingPublished ? 'Edit Published Story' : 'Edit Draft')
            : 'Write Story';

        return Scaffold(
          backgroundColor: AppColors.sandLight,
          appBar: AddArticleAppBar(title: titleText),
          body: SafeArea(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.ink),
                  )
                : Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
                        children: [
                          if (state.hasLockoutError &&
                              widget.initialItem != null &&
                              !widget.initialItem!.isEditableWithinWindow)
                            ArticleEditWarningBanner(
                              message: state.errorMessage!,
                            ),
                          ArticleTitleField(controller: _titleController),
                          const SizedBox(height: 20),
                          ArticleCoverImageField(
                            controller: _coverUrlController,
                          ),
                          const SizedBox(height: 20),
                          const ArticleCategorySelector(),
                          const SizedBox(height: 20),
                          const ArticleTagSelector(),
                          const SizedBox(height: 20),
                          ArticleContentField(controller: _contentController),
                          const SizedBox(height: 32),
                          const ArticleEditorActionBar(),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );

    if (widget.cubit != null) {
      return BlocProvider<AddArticleCubit>.value(
        value: widget.cubit!,
        child: content,
      );
    }
    return content;
  }
}
