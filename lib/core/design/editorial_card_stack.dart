import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_card.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

class EditorialCardStack extends StatefulWidget {
  const EditorialCardStack({
    super.key,
    required this.items,
    required this.onOpenArticle,
    this.onDismiss,
    this.onShare,
    this.height = 570,
  });

  final List<EditorialNewsItem> items;
  final ValueChanged<EditorialNewsItem> onOpenArticle;
  final ValueChanged<EditorialNewsItem>? onDismiss;
  final ValueChanged<EditorialNewsItem>? onShare;
  final double height;

  @override
  State<EditorialCardStack> createState() => _EditorialCardStackState();
}

class _EditorialCardStackState extends State<EditorialCardStack>
    with SingleTickerProviderStateMixin {
  late List<EditorialNewsItem> _cards;
  Offset _dragOffset = Offset.zero;
  late AnimationController _animController;
  late Animation<Offset> _offsetAnimation;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _cards = List.from(widget.items);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant EditorialCardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _cards = List.from(widget.items);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isDismissing || _cards.isEmpty) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isDismissing || _cards.isEmpty) return;

    if (_dragOffset.dy < -70 || details.velocity.pixelsPerSecond.dy < -300) {
      final top = _cards.first;
      _resetPosition();
      widget.onOpenArticle(top);
      return;
    }

    if (_dragOffset.dx.abs() > 90 ||
        details.velocity.pixelsPerSecond.dx.abs() > 300) {
      final sign = _dragOffset.dx >= 0 ? 1 : -1;
      _isDismissing = true;
      _offsetAnimation = Tween<Offset>(
        begin: _dragOffset,
        end: Offset(sign * 500.0, _dragOffset.dy),
      ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

      _animController.forward(from: 0).then((_) {
        final dismissed = _cards.removeAt(0);
        _cards.add(dismissed);
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
    _offsetAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward(from: 0).then((_) {
      setState(() {
        _dragOffset = Offset.zero;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: Text(
            'No more stories in this topic',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (_cards.length > 2)
            Positioned(
              left: 16,
              right: 16,
              top: 0,
              bottom: 48,
              child: Opacity(
                opacity: 0.85,
                child: EditorialCard(
                  item: _cards[2],
                  showActions: false,
                  onOpen: () => widget.onOpenArticle(_cards[2]),
                ),
              ),
            ),
          if (_cards.length > 1)
            Positioned(
              left: 8,
              right: 8,
              top: 16,
              bottom: 24,
              child: Opacity(
                opacity: 0.95,
                child: EditorialCard(
                  item: _cards[1],
                  showActions: false,
                  onOpen: () => widget.onOpenArticle(_cards[1]),
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            top: 32,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  final offset = _isDismissing || _animController.isAnimating
                      ? _offsetAnimation.value
                      : _dragOffset;
                  final rotation = (offset.dx / 300) * 0.12;

                  return Transform.translate(
                    offset: offset,
                    child: Transform.rotate(
                      angle: rotation,
                      child: child,
                    ),
                  );
                },
                child: EditorialCard(
                  item: _cards.first,
                  onOpen: () => widget.onOpenArticle(_cards.first),
                  onLike: () {
                    setState(() {
                      _cards.first.isLiked = !_cards.first.isLiked;
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text(
                          _cards.first.isLiked
                              ? 'Liked "${_cards.first.title.split('\n').first}"'
                              : 'Unliked story',
                        ),
                      ),
                    );
                  },
                  onSave: () {
                    setState(() {
                      _cards.first.isSaved = !_cards.first.isSaved;
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text(
                          _cards.first.isSaved
                              ? 'Saved to reading list'
                              : 'Removed from reading list',
                        ),
                      ),
                    );
                  },
                  onShare: () => showEditorialShareSheet(
                    context,
                    title: _cards.first.title,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
