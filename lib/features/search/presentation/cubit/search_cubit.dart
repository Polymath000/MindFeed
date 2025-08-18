
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:meta/meta.dart';

  part 'search_state.dart';
  
  class SearchCubit extends Cubit<SearchState> {
    SearchCubit() : super(SearchInitial());
  }
  