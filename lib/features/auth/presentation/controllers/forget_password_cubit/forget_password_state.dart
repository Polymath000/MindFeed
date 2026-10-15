part of 'forget_password_cubit.dart';

sealed class ForgetPasswordState {
  const ForgetPasswordState();
}

final class ForgetPasswordInitial extends ForgetPasswordState {
  const ForgetPasswordInitial();
}

final class ForgetPasswordLoading extends ForgetPasswordState {
  const ForgetPasswordLoading();
}

final class ForgetPasswordSuccess extends ForgetPasswordState {
  final String email;
  const ForgetPasswordSuccess({required this.email});
}

final class ForgetPasswordFailure extends ForgetPasswordState {
  final String errorMessage;
  const ForgetPasswordFailure({required this.errorMessage});
}
