import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.height = 54,
  });

  final String buttonText;
  final void Function()? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cream,
          foregroundColor: AppColors.ink,
          elevation: 2,
          shadowColor: Colors.black45,
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorders.control,
          ),
        ),
        child: Text(
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
