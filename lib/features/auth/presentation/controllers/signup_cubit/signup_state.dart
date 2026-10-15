part of 'signup_cubit.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}

final class SignupLoading extends SignupState {}

final class SignupRequiresConfirmation extends SignupState {
  final String email;
  SignupRequiresConfirmation({required this.email});
}

final class SignupSuccess extends SignupState {}

final class SignupFailure extends SignupState {
  final String errorMessage;
  final bool isUserAlreadyRegistered;
  SignupFailure({
    required this.errorMessage,
    this.isUserAlreadyRegistered = false,
  });
}
