import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/borders.dart';

class EditorialIconButton extends StatelessWidget {
  const EditorialIconButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.light = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool light;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: Tooltip(
      message: label,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: light ? AppColors.ink : AppColors.softCream),
        iconSize: 21,
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        style: IconButton.styleFrom(
          backgroundColor: light ? AppColors.cream : AppColors.ink,
          foregroundColor: light ? AppColors.ink : AppColors.softCream,
          shape: const RoundedRectangleBorder(borderRadius: AppBorders.control),
        ),
      ),
    ),
  );
}

class EditorialFollowButton extends StatefulWidget {
  const EditorialFollowButton({
    super.key,
    this.authorName = 'Author',
    this.initialFollowing = false,
    this.onChanged,
  });

  final String authorName;
  final bool initialFollowing;
  final ValueChanged<bool>? onChanged;

  @override
  State<EditorialFollowButton> createState() => _EditorialFollowButtonState();
}

class _EditorialFollowButtonState extends State<EditorialFollowButton> {
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.initialFollowing;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: FilledButton.icon(
        onPressed: () {
          setState(() {
            _isFollowing = !_isFollowing;
          });
          widget.onChanged?.call(_isFollowing);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(
                _isFollowing
                    ? 'You are now following ${widget.authorName}'
                    : 'Unfollowed ${widget.authorName}',
              ),
            ),
          );
        },
        icon: Icon(
          _isFollowing ? AppIcons.checkRounded : AppIcons.add,
          size: 16,
          color: _isFollowing ? AppColors.ink : AppColors.softCream,
        ),
        label: Text(
          _isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _isFollowing ? AppColors.ink : AppColors.softCream,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: _isFollowing ? AppColors.cream : AppColors.ink,
          elevation: _isFollowing ? 1 : 0,
          minimumSize: const Size(82, 40),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: const RoundedRectangleBorder(borderRadius: AppBorders.control),
        ),
      ),
    ),
  );
}
