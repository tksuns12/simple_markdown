import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_markdown/simple_markdown.dart';

void main() {
  group('MarkdownWidget', () {
    testWidgets('renders simple markdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: '# Header\n\nThis is a paragraph with **bold** text.',
            ),
          ),
        ),
      );

      // Check that RichText widgets are rendered
      expect(find.byType(RichText), findsAtLeastNWidgets(2));
      
      // Check that Column is rendered (main container)
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('renders with custom style', (WidgetTester tester) async {
      final customStyle = MarkdownStyle(
        h1Style: TextStyle(fontSize: 40, color: Colors.red),
        paragraphStyle: TextStyle(fontSize: 16, color: Colors.blue),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: '# Red Header\n\nBlue paragraph.',
              style: customStyle,
            ),
          ),
        ),
      );

      // Check that RichText widgets are rendered with custom styles
      expect(find.byType(RichText), findsAtLeastNWidgets(2));
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('renders lists', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: '- Item 1\n- Item 2\n- Item 3',
            ),
          ),
        ),
      );

      // Check that list structure is rendered
      expect(find.byType(Column), findsAtLeastNWidgets(2)); // Main column + list column
      expect(find.byType(Row), findsNWidgets(3)); // Three list items
      expect(find.byType(RichText), findsNWidgets(6)); // Six RichText: 3 for bullets + 3 for text
    });

    testWidgets('renders ordered lists', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: '1. First\n2. Second\n3. Third',
            ),
          ),
        ),
      );

      // Check that ordered list structure is rendered
      expect(find.byType(Column), findsAtLeastNWidgets(2)); // Main column + list column
      expect(find.byType(Row), findsNWidgets(3)); // Three list items
      expect(find.byType(RichText), findsNWidgets(6)); // Six RichText: 3 for numbers + 3 for text
    });

    testWidgets('renders empty markdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(data: ''),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
    });
  });

  group('MarkdownStyle', () {
    test('creates default style', () {
      const style = MarkdownStyle();
      expect(style.h1Style.fontSize, 32);
      expect(style.h2Style.fontSize, 24);
      expect(style.paragraphStyle.fontSize, 14);
    });

    test('copyWith works correctly', () {
      const original = MarkdownStyle();
      final modified = original.copyWith(
        h1Style: TextStyle(fontSize: 40),
        paragraphStyle: TextStyle(fontSize: 16),
      );

      expect(modified.h1Style.fontSize, 40);
      expect(modified.paragraphStyle.fontSize, 16);
      expect(modified.h2Style.fontSize, 24); // unchanged
    });

    test('getHeaderStyle returns correct style', () {
      const style = MarkdownStyle();
      expect(style.getHeaderStyle(1), style.h1Style);
      expect(style.getHeaderStyle(2), style.h2Style);
      expect(style.getHeaderStyle(3), style.h3Style);
      expect(style.getHeaderStyle(4), style.h4Style);
      expect(style.getHeaderStyle(5), style.h5Style);
      expect(style.getHeaderStyle(6), style.h6Style);
      expect(style.getHeaderStyle(7), style.h6Style); // fallback
    });
  });
}