part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginRequiresCategories extends LoginState {
  final UserEntity userEntity;
  LoginRequiresCategories({required this.userEntity});
}

final class LoginFailure extends LoginState {
  final String errorMessage;
  final String? email;
  LoginFailure({required this.errorMessage, this.email});
}
