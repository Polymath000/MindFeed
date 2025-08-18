
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:meta/meta.dart';

  part 'aricles_by_categories_state.dart';
  
  class AriclesByCategoriesCubit extends Cubit<AriclesByCategoriesState> {
    AriclesByCategoriesCubit() : super(AriclesByCategoriesInitial());
  }
  