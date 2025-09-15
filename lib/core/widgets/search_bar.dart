import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/core/constants/borders.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search_rounded),
                suffixIcon: Icon(FontAwesomeIcons.xmark, size: 22),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppBorders.xxxs,
                  borderSide: BorderSide(color: AppColors.lightBlue),
                ),
                border: OutlineInputBorder(
                  borderRadius: AppBorders.xxxs,
                  borderSide: BorderSide(color: AppColors.white),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.all(14),
            icon: Icon(
              FontAwesomeIcons.magnifyingGlass,
              color: AppColors.white,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              shape: RoundedRectangleBorder(borderRadius: AppBorders.xxxs),
            ),
          ),
        ],
      ),
    );
  }
}
