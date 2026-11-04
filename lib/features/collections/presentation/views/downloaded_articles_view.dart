import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_feed/core/utls/setup_service_locator.dart';
import 'package:mind_feed/features/collections/presentation/controllers/downloads/downloads_cubit.dart';
import 'package:mind_feed/features/collections/presentation/widgets/downloaded_articles_view_body.dart';

class DownloadedArticlesView extends StatelessWidget {
  const DownloadedArticlesView({
    super.key,
    this.refreshSeed = 0,
    this.cubit,
  });

  static const String routeName = 'downloadedArticlesView';
  final int refreshSeed;
  final DownloadsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider<DownloadsCubit>.value(
        value: cubit!,
        child: DownloadedArticlesViewBody(refreshSeed: refreshSeed),
      );
    }

    return BlocProvider<DownloadsCubit>(
      create: (_) => getIt<DownloadsCubit>()..loadDownloads(),
      child: DownloadedArticlesViewBody(refreshSeed: refreshSeed),
    );
  }
}
