import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/drafts_cubit/drafts_cubit.dart';
import 'package:mind_feed/features/add_article/presentation/controllers/drafts_cubit/drafts_state.dart';
import 'package:mind_feed/features/add_article/presentation/routes/add_article_routes.dart';
import 'package:mind_feed/features/add_article/presentation/widget/draft_item_card.dart';
import 'package:mind_feed/features/add_article/presentation/widget/drafts_status_views.dart';

class DraftsView extends StatelessWidget {
  const DraftsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sandLight,
      appBar: AppBar(
        backgroundColor: AppColors.sandLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBackRounded, color: AppColors.ink),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'My Drafts',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'New Article',
            icon: const Icon(AppIcons.add, color: AppColors.ink),
            onPressed: () => _openAddArticle(context),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<DraftsCubit, DraftsState>(
          listener: _handleStateNotification,
          builder: (context, state) {
            if (state is DraftsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.ink),
              );
            }
            if (state is DraftsError) {
              return DraftsErrorView(
                message: state.message,
                onRetry: () => context.read<DraftsCubit>().loadDrafts(),
              );
            }
            if (state is DraftsEmpty) {
              return DraftsEmptyView(
                onWriteNew: () => _openAddArticle(context),
              );
            }
            if (state is DraftsLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                itemCount: state.drafts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    DraftItemCard(draft: state.drafts[index]),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _openAddArticle(BuildContext context) {
    Navigator.pushNamed(context, AddArticleRoutes.addArticle).then((_) {
      if (context.mounted) {
        context.read<DraftsCubit>().loadDrafts();
      }
    });
  }

  void _handleStateNotification(BuildContext context, DraftsState state) {
    if (state is DraftsError) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.redHighlight,
        ),
      );
    }
  }
}
