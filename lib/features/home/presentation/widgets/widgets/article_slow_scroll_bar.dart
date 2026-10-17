import 'package:flutter/material.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class ArticleSlowScrollBar extends StatefulWidget {
  const ArticleSlowScrollBar({
    super.key, required this.isScrolling, required this.currentPace,
    required this.onToggleSlowScroll, required this.onSelectPace,
    this.isRetracted = false, this.onToggleRetract,
  });

  final bool isScrolling;
  final double currentPace;
  final VoidCallback onToggleSlowScroll;
  final ValueChanged<double> onSelectPace;
  final bool isRetracted;
  final VoidCallback? onToggleRetract;
  static const List<double> availablePaces = [0.5, 1.0, 1.5, 2.0];

  @override
  State<ArticleSlowScrollBar> createState() => _ArticleSlowScrollBarState();
}

class _ArticleSlowScrollBarState extends State<ArticleSlowScrollBar> {
  late bool _isRetracted;

  @override
  void initState() {
    super.initState();
    _isRetracted = widget.isRetracted;
  }

  @override
  void didUpdateWidget(covariant ArticleSlowScrollBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onToggleRetract != null) _isRetracted = widget.isRetracted;
  }

  bool get _effectiveRetracted => widget.onToggleRetract != null ? widget.isRetracted : _isRetracted;

  void _toggleRetract() {
    if (widget.onToggleRetract != null) {
      widget.onToggleRetract!();
    } else {
      setState(() => _isRetracted = !_isRetracted);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_effectiveRetracted) {
      return Semantics(
        button: true,
        label: 'Extend slow scroll bar',
        child: Tooltip(
          message: 'Extend slow scroll bar',
          child: InkWell(
            key: const Key('slow_scroll_retract_button'),
            onTap: _toggleRetract,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.chevron_left_rounded, size: 18, color: AppColors.softCream),
                  if (widget.isScrolling) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.play_arrow_rounded, size: 14, color: AppColors.amberDark),
                  ],
                  const SizedBox(width: 6),
                  Container(
                    width: 4, height: 22,
                    decoration: BoxDecoration(
                      color: widget.isScrolling ? AppColors.amberDark : AppColors.yellowHighlight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              button: true,
              label: widget.isScrolling ? 'Pause slow scroll' : 'Start slow scroll',
              child: InkWell(
                key: const Key('slow_scroll_toggle_button'),
                onTap: widget.onToggleSlowScroll,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.isScrolling ? AppColors.roseRed : Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.isScrolling ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: AppColors.softCream, size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.isScrolling ? 'Scrolling' : 'Slow Scroll',
                        style: const TextStyle(color: AppColors.softCream, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: ArticleSlowScrollBar.availablePaces.map((pace) {
                final isSelected = (pace - widget.currentPace).abs() < 0.01;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: InkWell(
                    key: Key('scroll_pace_$pace'),
                    onTap: () => widget.onSelectPace(pace),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.softCream : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.softCream : Colors.white.withAlpha(40),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${pace.toStringAsFixed(1)}x',
                        style: TextStyle(
                          color: isSelected ? AppColors.ink : AppColors.softCream,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(width: 10),
            Semantics(
              button: true,
              label: 'Retract slow scroll bar',
              child: Tooltip(
                message: 'Retract slow scroll bar',
                child: InkWell(
                  key: const Key('slow_scroll_retract_button'),
                  onTap: _toggleRetract,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.softCream),
                        const SizedBox(width: 4),
                        Container(
                          width: 4, height: 22,
                          decoration: BoxDecoration(color: AppColors.yellowHighlight, borderRadius: BorderRadius.circular(4)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
