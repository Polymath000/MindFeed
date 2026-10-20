import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_background_card.dart';
import 'package:mind_feed/core/design/editorial_deck_synchronizer.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/design/editorial_top_card_layer.dart';

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
  final ValueNotifier<Offset> _dragOffset = ValueNotifier<Offset>(Offset.zero);
  late AnimationController _animController;
  late Animation<Offset> _offsetAnimation;
  late final Listenable _cardMotionListenable;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _cards = List.from(widget.items);
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
    _offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _cardMotionListenable = Listenable.merge([_animController, _dragOffset]);
  }

  @override
  void didUpdateWidget(covariant EditorialCardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _cards = EditorialDeckSynchronizer.sync(currentDeck: _cards, incomingItems: widget.items);
    }
  }

  @override
  void dispose() {
    _dragOffset.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isDismissing || _cards.isEmpty) return;
    final currentOffset = _dragOffset.value;
    final s = Scrollable.maybeOf(context);
    if (s != null && s.position.hasPixels && s.position.maxScrollExtent > 0 &&
        currentOffset.dx.abs() < 24 && details.delta.dy.abs() > details.delta.dx.abs()) {
      s.position.jumpTo((s.position.pixels - details.delta.dy)
          .clamp(s.position.minScrollExtent, s.position.maxScrollExtent));
      return;
    }
    _dragOffset.value = currentOffset + details.delta;
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isDismissing || _cards.isEmpty) return;
    final currentOffset = _dragOffset.value;
    final dy = currentOffset.dy, vy = details.velocity.pixelsPerSecond.dy;
    final dx = currentOffset.dx, vx = details.velocity.pixelsPerSecond.dx;
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
      _dismissCard(isRight: isRight);
      return;
    }
    _resetPosition();
  }

  void _dismissCard({required bool isRight}) {
    if (_isDismissing || _cards.isEmpty) return;
    final sign = isRight ? 1 : -1;
    final startOffset = _dragOffset.value;
    _isDismissing = true;
    _offsetAnimation = Tween<Offset>(
      begin: startOffset,
      end: Offset(sign * 500.0, startOffset.dy),
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward(from: 0).then((_) {
      if (!mounted || _cards.isEmpty) return;
      final dismissed = _cards.removeAt(0);
      if (sign > 0) {
        dismissed.isSaved = true;
        _cards.add(dismissed);
        if (widget.onSwipeRight != null) {
          widget.onSwipeRight!(dismissed);
        } else {
          widget.onToggleSave?.call(dismissed);
        }
      } else {
        _cards.add(dismissed);
        widget.onSwipeLeft?.call(dismissed);
      }
      widget.onDismiss?.call(dismissed);
      _dragOffset.value = Offset.zero;
      _isDismissing = false;
      _animController.reset();
      setState(() {});
    });
  }

  void _resetPosition() {
    _offsetAnimation = Tween<Offset>(begin: _dragOffset.value, end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward(from: 0).then((_) {
      if (mounted) _dragOffset.value = Offset.zero;
    });
  }

  void _notify(String msg) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(duration: const Duration(seconds: 2), content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: Text('No more stories in this topic', style: TextStyle(color: Colors.white70, fontSize: 16)),
        ),
      );
    }
    return RepaintBoundary(
      child: SizedBox(
        height: widget.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (_cards.length > 2)
              EditorialBackgroundCard(
                item: _cards[2], left: 16, right: 16, top: 0, bottom: 48, opacity: 0.85,
                onOpen: () => widget.onOpenArticle(_cards[2]),
              ),
            if (_cards.length > 1)
              EditorialBackgroundCard(
                item: _cards[1], left: 8, right: 8, top: 16, bottom: 24, opacity: 0.95,
                onOpen: () => widget.onOpenArticle(_cards[1]),
              ),
            EditorialTopCardLayer(
              item: _cards.first,
              onOpen: () => widget.onOpenArticle(_cards.first),
              onLike: () {
                final top = _cards.first;
                setState(() => top.isLiked = !top.isLiked);
                widget.onToggleLike?.call(top);
                _notify(top.isLiked ? 'Liked "${top.title.split('\n').first}"' : 'Unliked story');
              },
              onSave: () => _dismissCard(isRight: true),
              onShare: () => (widget.onShare != null)
                  ? widget.onShare!(_cards.first)
                  : showEditorialShareSheet(context, title: _cards.first.title),
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              motionListenable: _cardMotionListenable,
              dragOffsetListenable: _dragOffset,
              offsetAnimation: _offsetAnimation,
              isDismissing: _isDismissing,
              isAnimating: _animController.isAnimating,
            ),
          ],
        ),
      ),
    );
  }
}
