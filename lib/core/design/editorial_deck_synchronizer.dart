import 'package:mind_feed/core/design/editorial_models.dart';

class EditorialDeckSynchronizer {
  const EditorialDeckSynchronizer._();

  static List<EditorialNewsItem> sync({
    required List<EditorialNewsItem> currentDeck,
    required List<EditorialNewsItem> incomingItems,
  }) {
    if (incomingItems.isEmpty) return const [];
    final itemMap = {for (final item in incomingItems) item.id: item};
    final hasOverlap = currentDeck.any((c) => itemMap.containsKey(c.id));
    if (!hasOverlap || currentDeck.isEmpty) {
      return List.from(incomingItems);
    }
    final updated = <EditorialNewsItem>[];
    for (final card in currentDeck) {
      final current = itemMap[card.id];
      if (current != null) updated.add(current);
    }
    final existingIds = {for (final card in updated) card.id};
    for (final item in incomingItems) {
      if (!existingIds.contains(item.id)) updated.add(item);
    }
    return updated;
  }
}
