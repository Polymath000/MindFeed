import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mind_feed/config/routes/app_routes.dart';
import 'package:mind_feed/core/constants/app_icons.dart';
import 'package:mind_feed/features/home/presentation/widgets/widgets/home_write_article_fab.dart';

void main() {
  testWidgets('HomeWriteArticleFab renders tooltip and triggers navigation to addArticle',
      (tester) async {
    var routePushed = false;

    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.addArticle) {
            routePushed = true;
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Add Article Screen')),
            );
          }
          return null;
        },
        home: const Scaffold(
          floatingActionButton: HomeWriteArticleFab(),
        ),
      ),
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byTooltip('Write article'), findsOneWidget);
    expect(find.byIcon(AppIcons.edit), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(routePushed, isTrue);
  });
}
