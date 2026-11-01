import 'package:flutter/material.dart';
import 'package:mind_feed/features/article/presentation/controllers/article_reader/article_reader_cubit.dart';
import 'package:mind_feed/features/article/presentation/views/article_view.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_empty_view.dart';

class ArticlePreviewView extends StatelessWidget {
  final EditorialNewsItem? item;
  final ArticleReaderCubit? cubit;

  const ArticlePreviewView({super.key, this.item, this.cubit});

  @override
  Widget build(BuildContext context) {
    if (item == null && cubit == null) {
      return const ArticleReaderEmptyView();
    }

    return ArticleView(
      item: item,
      cubit: cubit,
      isPreview: true,
    );
  }
}
