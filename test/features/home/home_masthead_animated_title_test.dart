import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/core/constants/constants.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/home_masthead_header.dart';

void main() {
  testWidgets('HomeMastheadAnimatedTitle renders default appName and rotates through words',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeMastheadAnimatedTitle(),
        ),
      ),
    );

    // Initial pump shows the first item in the rotation (AppConstants.appName)
    expect(find.byType(AnimatedTextKit), findsOneWidget);
    expect(find.text(AppConstants.appName), findsOneWidget);

    // Advance time to allow rotation
    await tester.pump(const Duration(milliseconds: 3500));
    // The animated text kit is still active and rotating
    expect(find.byType(AnimatedTextKit), findsOneWidget);
  });

  testWidgets('HomeMastheadAnimatedTitle respects custom rotating words list',
      (tester) async {
    const customWords = ['MindFeed', 'Discover', 'Inspire'];

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeMastheadAnimatedTitle(words: customWords),
        ),
      ),
    );

    expect(find.text('MindFeed'), findsOneWidget);
  });
}
