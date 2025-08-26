
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:meta/meta.dart';

  part 'downloaded_articles_view_state.dart';
  
  class DownloadedArticlesViewCubit extends Cubit<DownloadedArticlesViewState> {
    DownloadedArticlesViewCubit() : super(DownloadedArticlesViewInitial());
  }
  