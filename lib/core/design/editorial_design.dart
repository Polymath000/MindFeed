import 'package:mind_feed/core/constants/borders.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

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

void showEditorialShareSheet(
  BuildContext context, {
  required String title,
  String? url,
}) {
  final shareUrl =
      url ??
      'https://mindfeed.app/stories/${Uri.encodeComponent(title.split('\n').first)}';

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.inkDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: AppColors.borderDark, width: 1.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.mutedInk,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(AppIcons.iosShareRounded, color: AppColors.cream, size: 20),
              SizedBox(width: 8),
              Text(
                'Share Story',
                style: TextStyle(
                  color: AppColors.softCream,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title.replaceAll('\n', ' '),
            style: const TextStyle(
              color: Color(0xFFAAA49B),
              fontSize: 13.5,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShareAction(
                ctx,
                icon: AppIcons.linkRounded,
                label: 'Copy Link',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text('Link copied: $shareUrl'),
                    ),
                  );
                },
              ),
              _buildShareAction(
                ctx,
                icon: AppIcons.chatBubbleOutlineRounded,
                label: 'Message',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening messaging apps...')),
                  );
                },
              ),
              _buildShareAction(
                ctx,
                icon: AppIcons.alternateEmailRounded,
                label: 'Post to X',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Composing story share...')),
                  );
                },
              ),
              _buildShareAction(
                ctx,
                icon: AppIcons.bookmarkAddOutlined,
                label: 'Bookmark',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Story saved to collection')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildShareAction(
  BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.darkTile,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Icon(icon, color: AppColors.cream, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.softCream,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
