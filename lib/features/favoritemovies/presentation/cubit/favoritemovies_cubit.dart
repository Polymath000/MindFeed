
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:meta/meta.dart';

  part 'favoritemovies_state.dart';
  
  class FavoritemoviesCubit extends Cubit<FavoritemoviesState> {
    FavoritemoviesCubit() : super(FavoritemoviesInitial());
  }
  