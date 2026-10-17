import 'package:flutter/material.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/core/constants/borders.dart';

class ArticleSlowScrollBar extends StatefulWidget {
  const ArticleSlowScrollBar({
    super.key,
    required this.isScrolling,
    required this.currentPace,
    required this.onToggleSlowScroll,
    required this.onSelectPace,
    this.isRetracted = false,
    this.onToggleRetract,
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

  bool get _effectiveRetracted =>
      widget.onToggleRetract != null ? widget.isRetracted : _isRetracted;

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
      return _RetractedSlowScrollPill(
        isScrolling: widget.isScrolling,
        onTap: _toggleRetract,
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.ink,
        borderRadius: AppBorders.bar,
        boxShadow: [BoxShadow(color: AppColors.blackAlpha66, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SlowScrollToggleButton(
              isScrolling: widget.isScrolling,
              onTap: widget.onToggleSlowScroll,
            ),
            const SizedBox(width: 8),
            _PaceChipsRow(
              currentPace: widget.currentPace,
              onSelectPace: widget.onSelectPace,
            ),
            const SizedBox(width: 10),
            _RetractBarButton(onTap: _toggleRetract),
          ],
        ),
      ),
    );
  }
}

class _RetractedSlowScrollPill extends StatelessWidget {
  const _RetractedSlowScrollPill({
    required this.isScrolling,
    required this.onTap,
  });

  final bool isScrolling;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Extend slow scroll bar',
      child: Tooltip(
        message: 'Extend slow scroll bar',
        child: InkWell(
          key: const Key('slow_scroll_retract_button'),
          onTap: onTap,
          borderRadius: AppBorders.xs,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: const BoxDecoration(
              color: AppColors.ink,
              borderRadius: AppBorders.xs,
              boxShadow: [BoxShadow(color: AppColors.blackAlpha66, blurRadius: 10, offset: Offset(0, 4))],
            ),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(AppIcons.chevronLeftRounded, size: 18, color: AppColors.softCream),
        if (isScrolling) ...[
          const SizedBox(width: 4),
          const Icon(AppIcons.playArrowRounded, size: 14, color: AppColors.amberDark),
        ],
        const SizedBox(width: 6),
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: isScrolling ? AppColors.amberDark : AppColors.yellowHighlight,
            borderRadius: AppBorders.indicator,
          ),
        ),
      ],
    );
  }
}

class _SlowScrollToggleButton extends StatelessWidget {
  const _SlowScrollToggleButton({required this.isScrolling, required this.onTap});

  final bool isScrolling;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isScrolling ? 'Pause slow scroll' : 'Start slow scroll',
      child: InkWell(
        key: const Key('slow_scroll_toggle_button'),
        onTap: onTap,
        borderRadius: AppBorders.badge,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isScrolling ? AppColors.roseRed : AppColors.whiteAlpha25,
            borderRadius: AppBorders.badge,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isScrolling ? AppIcons.pauseRounded : AppIcons.playArrowRounded,
                color: AppColors.softCream,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                isScrolling ? 'Scrolling' : 'Slow Scroll',
                style: const TextStyle(color: AppColors.softCream, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaceChipsRow extends StatelessWidget {
  const _PaceChipsRow({required this.currentPace, required this.onSelectPace});

  final double currentPace;
  final ValueChanged<double> onSelectPace;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final pace in ArticleSlowScrollBar.availablePaces)
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: _PaceChip(
              pace: pace,
              isSelected: (pace - currentPace).abs() < 0.01,
              onTap: () => onSelectPace(pace),
            ),
          ),
      ],
    );
  }
}

class _PaceChip extends StatelessWidget {
  const _PaceChip({
    required this.pace,
    required this.isSelected,
    required this.onTap,
  });

  final double pace;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('scroll_pace_$pace'),
      onTap: onTap,
      borderRadius: AppBorders.badge,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.softCream : AppColors.transparent,
          borderRadius: AppBorders.badge,
          border: Border.all(
            color: isSelected ? AppColors.softCream : AppColors.whiteAlpha40,
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
    );
  }
}

class _RetractBarButton extends StatelessWidget {
  const _RetractBarButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Retract slow scroll bar',
      child: Tooltip(
        message: 'Retract slow scroll bar',
        child: InkWell(
          key: const Key('slow_scroll_retract_button'),
          onTap: onTap,
          borderRadius: AppBorders.badge,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(AppIcons.chevronRightRounded, size: 18, color: AppColors.softCream),
                const SizedBox(width: 4),
                Container(
                  width: 4,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.yellowHighlight,
                    borderRadius: AppBorders.indicator,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
