import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.semanticLabel = 'Search news',
    this.hintText = 'Search',
    this.trailingSearchIcon = false,
    this.controller,
    this.onChanged,
  });
  final String semanticLabel;
  final String hintText;
  final bool trailingSearchIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Semantics(
      textField: true,
      label: semanticLabel,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: EditorialPalette.softCream, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.greyText, fontSize: 14),
          prefixIcon: trailingSearchIcon
              ? null
              : const Icon(
                  Icons.search_rounded,
                  color: EditorialPalette.softCream,
                ),
          suffixIcon: trailingSearchIcon
              ? const Icon(
                  Icons.search_rounded,
                  color: AppColors.greyText,
                )
              : null,
          filled: true,
          fillColor: AppColors.darkTile,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 18,
          ),
          border: const OutlineInputBorder(
            borderRadius: EditorialRadii.control,
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: EditorialRadii.control,
            borderSide: BorderSide(color: EditorialPalette.cream, width: 2),
          ),
        ),
      ),
    ),
  );
}
