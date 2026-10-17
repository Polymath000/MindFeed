import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/design/editorial_card.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

class EditorialCardStack extends StatefulWidget {
  const EditorialCardStack({
    super.key,
    required this.items,
    required this.onOpenArticle,
    this.onDismiss,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onToggleSave,
    this.onToggleLike,
    this.onShare,
    this.height = 570,
  });

  final List<EditorialNewsItem> items;
  final ValueChanged<EditorialNewsItem> onOpenArticle;
  final ValueChanged<EditorialNewsItem>? onDismiss, onSwipeRight, onSwipeLeft, onToggleSave, onToggleLike, onShare;
  final double height;

  @override
  State<EditorialCardStack> createState() => _EditorialCardStackState();
}

class _EditorialCardStackState extends State<EditorialCardStack> with SingleTickerProviderStateMixin {
  late List<EditorialNewsItem> _cards;
  Offset _dragOffset = Offset.zero;
  late AnimationController _animController;
  late Animation<Offset> _offsetAnimation;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _cards = List.from(widget.items);
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
    _offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant EditorialCardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) _cards = List.from(widget.items);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isDismissing || _cards.isEmpty) return;
    final s = Scrollable.maybeOf(context);
    if (s != null && s.position.hasPixels && s.position.maxScrollExtent > 0 &&
        _dragOffset.dx.abs() < 24 && details.delta.dy.abs() > details.delta.dx.abs()) {
      s.position.jumpTo((s.position.pixels - details.delta.dy).clamp(s.position.minScrollExtent, s.position.maxScrollExtent));
      return;
    }
    setState(() => _dragOffset += details.delta);
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isDismissing || _cards.isEmpty) return;
    final dy = _dragOffset.dy, vy = details.velocity.pixelsPerSecond.dy;
    final dx = _dragOffset.dx, vx = details.velocity.pixelsPerSecond.dx;
    final s = Scrollable.maybeOf(context);
    final isScroll = s != null && s.position.hasPixels && s.position.maxScrollExtent > 0;
    if (!isScroll && (dy < -70 || (vy < -320 && dy < -20))) {
      final top = _cards.first;
      _resetPosition();
      widget.onOpenArticle(top);
      return;
    }
    final isRight = dx > 90 || vx > 300, isLeft = dx < -90 || vx < -300;
    if (isRight || isLeft) {
      final sign = isRight ? 1 : -1;
      _isDismissing = true;
      _offsetAnimation = Tween<Offset>(begin: _dragOffset, end: Offset(sign * 500.0, dy)).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
      _animController.forward(from: 0).then((_) {
        if (!mounted || _cards.isEmpty) return;
        final dismissed = _cards.removeAt(0);
        if (sign > 0) {
          dismissed.isSaved = true;
          _cards.add(dismissed);
          widget.onSwipeRight?.call(dismissed);
        } else {
          _cards.add(dismissed);
          widget.onSwipeLeft?.call(dismissed);
        }
        widget.onDismiss?.call(dismissed);
        _dragOffset = Offset.zero;
        _isDismissing = false;
        _animController.reset();
        setState(() {});
      });
      return;
    }
    _resetPosition();
  }

  void _resetPosition() {
    _offsetAnimation = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward(from: 0).then((_) {
      if (mounted) setState(() => _dragOffset = Offset.zero);
    });
  }

  void _notify(String msg) {
    ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(SnackBar(duration: const Duration(seconds: 2), content: Text(msg)));
  }

  Widget _buildFeedbackBadge() {
    if (_dragOffset.dx.abs() <= 24) return const SizedBox.shrink();
    final isSave = _dragOffset.dx > 24;
    return Positioned(
      top: 14, left: 0, right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSave ? AppColors.yellowHighlight : AppColors.ink,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isSave ? AppIcons.bookmarkFilled : Icons.arrow_forward_rounded, size: 16, color: isSave ? AppColors.ink : AppColors.softCream),
              const SizedBox(width: 6),
              Text(isSave ? 'SAVE' : 'NEXT',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: isSave ? AppColors.ink : AppColors.softCream)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int i, double l, double r, double t, double b, double op) => Positioned(
    left: l, right: r, top: t, bottom: b,
    child: Opacity(opacity: op, child: EditorialCard(item: _cards[i], showActions: false, onOpen: () => widget.onOpenArticle(_cards[i]))),
  );

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('No more stories in this topic', style: TextStyle(color: Colors.white70, fontSize: 16))),
      );
    }
    return SizedBox(
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (_cards.length > 2) _buildCard(2, 16, 16, 0, 48, 0.85),
          if (_cards.length > 1) _buildCard(1, 8, 8, 16, 24, 0.95),
          Positioned(
            left: 0, right: 0, top: 32, bottom: 0,
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  final offset = _isDismissing || _animController.isAnimating ? _offsetAnimation.value : _dragOffset;
                  return Transform.translate(
                    offset: offset,
                    child: Transform.rotate(angle: (offset.dx / 300) * 0.12, child: child),
                  );
                },
                child: Stack(
                  children: [
                    EditorialCard(
                      item: _cards.first,
                      onOpen: () => widget.onOpenArticle(_cards.first),
                      onLike: () {
                        final top = _cards.first;
                        setState(() => top.isLiked = !top.isLiked);
                        widget.onToggleLike?.call(top);
                        _notify(top.isLiked ? 'Liked "${top.title.split('\n').first}"' : 'Unliked story');
                      },
                      onSave: () {
                        final top = _cards.first;
                        setState(() => top.isSaved = !top.isSaved);
                        widget.onToggleSave?.call(top);
                        _notify(top.isSaved ? 'Saved to reading list' : 'Removed from reading list');
                      },
                      onShare: () => (widget.onShare != null)
                          ? widget.onShare!(_cards.first)
                          : showEditorialShareSheet(context, title: _cards.first.title),
                    ),
                    _buildFeedbackBadge(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
