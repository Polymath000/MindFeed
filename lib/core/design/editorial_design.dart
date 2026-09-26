import 'package:flutter/material.dart';

sealed class EditorialPalette {
  static const ink = Color(0xFF171614);
  static const charcoal = Color(0xFF262422);
  static const cream = Color(0xFFFFF1C6);
  static const butter = Color(0xFFFFE8A1);
  static const blush = Color(0xFFFFDDE0);
  static const powder = Color(0xFFDCEEFF);
  static const lilac = Color(0xFFE9DEFF);
  static const mint = Color(0xFFD7F5E8);
  static const peach = Color(0xFFFFE5D0);
  static const sand = Color(0xFFF5EEDC);
  static const mutedInk = Color(0xFF514D46);
  static const softCream = Color(0xFFFFF8E6);
}

sealed class EditorialSpace {
  static const page = 20.0;
  static const compact = 12.0;
  static const roomy = 24.0;
}

sealed class EditorialRadii {
  static const card = BorderRadius.all(Radius.circular(26));
  static const control = BorderRadius.all(Radius.circular(24));
}

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
        icon: Icon(
          icon,
          color: light ? EditorialPalette.ink : EditorialPalette.softCream,
        ),
        iconSize: 21,
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        style: IconButton.styleFrom(
          backgroundColor: light
              ? EditorialPalette.cream
              : EditorialPalette.ink,
          foregroundColor: light
              ? EditorialPalette.ink
              : EditorialPalette.softCream,
          shape: const RoundedRectangleBorder(
            borderRadius: EditorialRadii.control,
          ),
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
          _isFollowing ? Icons.check_rounded : Icons.add_rounded,
          size: 16,
          color: _isFollowing ? EditorialPalette.ink : EditorialPalette.softCream,
        ),
        label: Text(
          _isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _isFollowing ? EditorialPalette.ink : EditorialPalette.softCream,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: _isFollowing
              ? EditorialPalette.cream
              : EditorialPalette.ink,
          elevation: _isFollowing ? 1 : 0,
          minimumSize: const Size(82, 40),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: EditorialRadii.control,
          ),
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
  final shareUrl = url ?? 'https://mindfeed.app/stories/${Uri.encodeComponent(title.split('\n').first)}';

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1D1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Color(0xFF383530), width: 1.5),
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
                color: const Color(0xFF55524C),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(Icons.ios_share_rounded, color: EditorialPalette.cream, size: 20),
              SizedBox(width: 8),
              Text(
                'Share Story',
                style: TextStyle(
                  color: EditorialPalette.softCream,
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
                icon: Icons.link_rounded,
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
                icon: Icons.chat_bubble_outline_rounded,
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
                icon: Icons.alternate_email_rounded,
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
                icon: Icons.bookmark_add_outlined,
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
              color: const Color(0xFF2A2825),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF383530)),
            ),
            child: Icon(icon, color: EditorialPalette.cream, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: EditorialPalette.softCream,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
