class CheckCodeArgs {
  final String email;
  final bool isPasswordReset;

  const CheckCodeArgs({
    required this.email,
    this.isPasswordReset = false,
  });
}
