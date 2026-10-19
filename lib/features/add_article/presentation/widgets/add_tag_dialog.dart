import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class AddTagDialog extends StatefulWidget {
  final ValueChanged<String> onTagAdded;

  const AddTagDialog({super.key, required this.onTagAdded});

  @override
  State<AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onTagAdded(text);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.sandLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Add New Tag',
        style: TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: TextField(
        key: const Key('add_tag_text_field'),
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        maxLength: 30,
        cursorColor: AppColors.ink,
        style: const TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          hintText: 'e.g. flutter, design, tech',
          hintStyle: TextStyle(color: AppColors.mutedInk, fontSize: 13),
          prefixText: '# ',
          prefixStyle: TextStyle(
            color: AppColors.mutedInk,
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.creamBorder, width: 1.5),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.ink, width: 2),
          ),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          key: const Key('add_tag_cancel_button'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.mutedInk,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          key: const Key('add_tag_confirm_button'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.ink,
            foregroundColor: AppColors.softCream,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _submit,
          child: const Text(
            'Add',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
