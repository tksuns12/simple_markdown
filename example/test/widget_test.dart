import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Markdown demo app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MarkdownDemoApp());

    // Verify that our app loads correctly
    expect(find.text('Simple Markdown Demo'), findsOneWidget);
    expect(find.text('Live Editor'), findsOneWidget);
    expect(find.text('Samples'), findsOneWidget);
    expect(find.text('Styles'), findsOneWidget);
    
    // Verify that the basic structure is rendered
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(TabBarView), findsOneWidget);
    
    // Verify that there are RichText widgets for markdown content
    expect(find.byType(RichText), findsAtLeastNWidgets(1));
  });
}
