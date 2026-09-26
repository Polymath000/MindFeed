import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';

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
          backgroundColor: EditorialPalette.cream,
          foregroundColor: EditorialPalette.ink,
          elevation: 2,
          shadowColor: Colors.black45,
          shape: const RoundedRectangleBorder(
            borderRadius: EditorialRadii.control,
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
            color: EditorialPalette.ink,
          ),
        ),
      ),
    );
  }
}
