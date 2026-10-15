import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customShowSnackBar({
  required final String message,
  required final BuildContext context,
  final SnackBarAction? action,
  final Duration duration = const Duration(seconds: 4),
}) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(
  content: Text(message),
  action: action,
  duration: duration,
));
