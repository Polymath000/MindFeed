import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_empty_view.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_view_content.dart';

import '../controllers/article_reader/article_reader_cubit.dart';

export 'package:mind_feed/core/design/editorial_models.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({super.key, this.item, this.cubit});
  static const String routeName = 'article';
  final EditorialNewsItem? item;
  final ArticleReaderCubit? cubit;

  ArticleReaderCubit _createCubit() =>
      getIt<ArticleReaderCubit>()..initArticle(item);

  @override
  Widget build(BuildContext context) {
    if (item == null && cubit == null) return const ArticleReaderEmptyView();
    if (cubit != null) {
      if (cubit!.state.item == null && item != null) cubit!.initArticle(item);
      return BlocProvider<ArticleReaderCubit>.value(
        value: cubit!,
        child: ArticleViewContent(initialItem: item),
      );
    }
    return BlocProvider<ArticleReaderCubit>(
      create: (_) => _createCubit(),
      child: ArticleViewContent(initialItem: item),
    );
  }
}
