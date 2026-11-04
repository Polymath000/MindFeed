import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/constants/app_colors.dart';
import 'package:mind_feed/core/constants/app_text_styles.dart';
import 'package:mind_feed/features/article/presentation/widgets/article_reader_top_bar.dart';

void main() {
  Widget harness(Widget child) => MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );

  testWidgets(
    'ArticleReaderTopBar renders badge with badgeColor background and white text',
    (tester) async {
      const testColor = Color(0xFF065F46); // Science Deep Emerald

      await tester.pumpWidget(
        harness(
          const ArticleReaderTopBar(
            badge: 'SCIENCE',
            badgeColor: testColor,
          ),
        ),
      );

      final badgeText = find.text('SCIENCE');
      expect(badgeText, findsOneWidget);

      final textWidget = tester.widget<Text>(badgeText);
      expect(textWidget.style?.color, AppColors.white);
      expect(
        textWidget.style?.fontWeight,
        AppTextStyles.readerTopBadge.fontWeight,
      );

      final badgeContainer = tester.widget<Container>(
        find.ancestor(of: badgeText, matching: find.byType(Container)).first,
      );
      final decoration = badgeContainer.decoration as BoxDecoration;
      expect(decoration.color, testColor);
    },
  );
}
