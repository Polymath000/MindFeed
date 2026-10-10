import 'package:flutter/material.dart';
import 'package:mind_feed/core/design/editorial_design.dart';
import 'package:mind_feed/core/design/editorial_models.dart';
import 'package:mind_feed/core/constants/app_colors.dart';

class EditorialSavedStack extends StatefulWidget {
  const EditorialSavedStack({
    super.key,
    required this.items,
    required this.onOpenArticle,
    this.onDeleteArticle,
  });

  final List<EditorialNewsItem> items;
  final ValueChanged<EditorialNewsItem> onOpenArticle;
  final ValueChanged<EditorialNewsItem>? onDeleteArticle;

  @override
  State<EditorialSavedStack> createState() => _EditorialSavedStackState();
}

class _EditorialSavedStackState extends State<EditorialSavedStack> {
  late List<EditorialNewsItem> _savedItems;

  @override
  void initState() {
    super.initState();
    _savedItems = List.from(widget.items);
  }

  @override
  void didUpdateWidget(covariant EditorialSavedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _savedItems = List.from(widget.items);
    }
  }

  void _deleteItem(int index, EditorialNewsItem item) {
    setState(() {
      _savedItems.removeAt(index);
    });
    widget.onDeleteArticle?.call(item);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: Text('Removed "${item.title.split('\n').first}"'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: EditorialPalette.butter,
          onPressed: () {
            setState(() {
              _savedItems.insert(index, item);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_savedItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.center,
        child: const Text(
          'No saved articles yet',
          style: TextStyle(
            color: AppColors.greyIcon,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < _savedItems.length; i++)
          _buildDismissibleCard(i, _savedItems[i]),
      ],
    );
  }

  Widget _buildDismissibleCard(int index, EditorialNewsItem item) {
    final isFirst = index == 0;
    final overlapOffset = isFirst ? 0.0 : -32.0 * index;

    return Transform.translate(
      offset: Offset(0, overlapOffset),
      child: Dismissible(
        key: ValueKey(item.id),
        direction: DismissDirection.horizontal,
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: EditorialRadii.card,
          ),
          child: const Row(
            children: [
              Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: EditorialRadii.card,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
            ],
          ),
        ),
        onDismissed: (_) => _deleteItem(index, item),
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! < -200) {
              widget.onOpenArticle(item);
            }
          },
          child: InkWell(
            onTap: () => widget.onOpenArticle(item),
            borderRadius: EditorialRadii.card,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 26),
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: EditorialRadii.card,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 24,
                      height: 1.18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                      color: EditorialPalette.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.excerpt,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: EditorialPalette.ink,
                    ),
                  ),
                  if (isFirst) const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
