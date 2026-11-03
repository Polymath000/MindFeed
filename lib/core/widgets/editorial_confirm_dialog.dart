import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';

class EditorialConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Future<void> Function() onConfirm;

  static const TextStyle _titleStyle = TextStyle(
    color: AppColors.ink,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle _contentStyle = TextStyle(
    color: AppColors.mutedInk,
    fontSize: 14,
  );

  const EditorialConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: _titleStyle),
      content: Text(message, style: _contentStyle),
      actions: [
        _buildCancelButton(context),
        _buildConfirmButton(context),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        cancelLabel,
        style: const TextStyle(color: AppColors.greyText),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () async {
        Navigator.pop(context);
        await onConfirm();
      },
      child: Text(confirmLabel),
    );
  }
}

Future<void> showEditorialConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = 'Cancel',
  required Future<void> Function() onConfirm,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogCtx) => EditorialConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
    ),
  );
}
