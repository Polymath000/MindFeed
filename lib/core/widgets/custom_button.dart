import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/widgets/custom_loading_indecator.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.height = 54,
    this.isLoading = false,
  });

  final String buttonText;
  final void Function()? onTap;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cream,
          foregroundColor: AppColors.ink,
          disabledBackgroundColor: AppColors.cream.withValues(alpha: 0.85),
          disabledForegroundColor: AppColors.ink,
          elevation: isLoading ? 0 : 2,
          shadowColor: Colors.black45,
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorders.control,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CustomLoadingIndicator(
                  size: 22,
                  color: AppColors.ink,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: AppColors.ink,
                ),
              ),
      ),
    );
  }
}
