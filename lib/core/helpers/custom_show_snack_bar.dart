import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customShowSnackBar({
  required final String message,
  required final BuildContext context
}) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(message)));
