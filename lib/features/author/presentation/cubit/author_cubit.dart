
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:meta/meta.dart';

  part 'author_state.dart';
  
  class AuthorCubit extends Cubit<AuthorState> {
    AuthorCubit() : super(AuthorInitial());
  }
  