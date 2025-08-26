
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:meta/meta.dart';

  part 'articles_save_state.dart';
  
  class ArticlesSaveCubit extends Cubit<ArticlesSaveState> {
    ArticlesSaveCubit() : super(ArticlesSaveInitial());
  }
  