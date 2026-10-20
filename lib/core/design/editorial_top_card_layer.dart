import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_card.dart';
import 'package:mind_feed/core/design/editorial_card_feedback_badge.dart';
import 'package:mind_feed/core/design/editorial_models.dart';

class EditorialTopCardLayer extends StatelessWidget {
  const EditorialTopCardLayer({
    super.key,
    required this.item,
    required this.onOpen,
    required this.onLike,
    required this.onSave,
    required this.onShare,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.motionListenable,
    required this.dragOffsetListenable,
    required this.offsetAnimation,
    required this.isDismissing,
    required this.isAnimating,
  });

  final EditorialNewsItem item;
  final VoidCallback onOpen;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;
  final Listenable motionListenable;
  final ValueNotifier<Offset> dragOffsetListenable;
  final Animation<Offset> offsetAnimation;
  final bool isDismissing;
  final bool isAnimating;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 32,
      bottom: 0,
      child: GestureDetector(
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: AnimatedBuilder(
          animation: motionListenable,
          builder: (context, child) {
            final offset = isDismissing || isAnimating
                ? offsetAnimation.value
                : dragOffsetListenable.value;
            return Transform.translate(
              offset: offset,
              child: Transform.rotate(
                angle: (offset.dx / 300) * 0.12,
                child: child,
              ),
            );
          },
          child: RepaintBoundary(
            child: Stack(
              children: [
                EditorialCard(
                  item: item,
                  onOpen: onOpen,
                  onLike: onLike,
                  onSave: onSave,
                  onShare: onShare,
                ),
                EditorialCardFeedbackBadge(
                  dragOffsetListenable: dragOffsetListenable,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
