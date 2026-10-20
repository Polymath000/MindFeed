import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

InputDecoration articleInputDecoration({
  required String hintText,
  String? errorText,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: AppColors.greyText, fontSize: 14),
    errorText: errorText,
    errorMaxLines: 2,
    errorStyle: const TextStyle(
      color: AppColors.redHighlight,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    ),
    filled: true,
    fillColor: AppColors.whiteLight,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.creamBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.creamBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.redHighlight, width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.redHighlight, width: 1.5),
    ),
  );
}

class ArticleSectionHeader extends StatelessWidget {
  final String title;
  final String counter;
  final bool isCounterError;
  final bool isCounterSuccess;

  const ArticleSectionHeader({
    super.key,
    required this.title,
    required this.counter,
    this.isCounterError = false,
    this.isCounterSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    Color counterColor = AppColors.mutedInk;
    if (isCounterError) {
      counterColor = AppColors.redHighlight;
    } else if (isCounterSuccess) {
      counterColor = AppColors.successGreen;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        Text(
          counter,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: counterColor,
          ),
        ),
      ],
    );
  }
}
