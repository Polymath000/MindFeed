
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:meta/meta.dart';

  part 'article_state.dart';
  
  class ArticleCubit extends Cubit<ArticleState> {
    ArticleCubit() : super(ArticleInitial());
  }
  