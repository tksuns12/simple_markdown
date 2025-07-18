import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_markdown/simple_markdown.dart';

void main() {
  group('MarkdownWidget Overflow Tests', () {
    testWidgets('applies TextOverflow.ellipsis correctly', (tester) async {
      const longText = 'This is a very long text that should be truncated with ellipsis when constrained';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: longText,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 1,
              constraints: const BoxConstraints(maxWidth: 100),
            ),
          ),
        ),
      );
      
      expect(find.byType(MarkdownWidget), findsOneWidget);
      expect(find.byType(RichText), findsOneWidget);
      
      final richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.overflow, TextOverflow.ellipsis);
      expect(richText.maxLines, 1);
    });

    testWidgets('applies TextOverflow.clip correctly', (tester) async {
      const longText = 'This is a very long text that should be clipped when constrained';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: longText,
              textOverflow: TextOverflow.clip,
              constraints: const BoxConstraints(maxWidth: 100),
            ),
          ),
        ),
      );
      
      final richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.overflow, TextOverflow.clip);
    });

    testWidgets('applies TextOverflow.fade correctly', (tester) async {
      const longText = 'This is a very long text that should fade when constrained';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: longText,
              textOverflow: TextOverflow.fade,
              constraints: const BoxConstraints(maxWidth: 100),
            ),
          ),
        ),
      );
      
      final richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.overflow, TextOverflow.fade);
    });

    testWidgets('applies maxLines constraint', (tester) async {
      const multilineText = '''# Header
      
This is a paragraph with multiple lines.
This is the second line.
This is the third line.
This is the fourth line.''';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: multilineText,
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
      
      final richTextWidgets = tester.widgetList<RichText>(find.byType(RichText));
      for (final richText in richTextWidgets) {
        expect(richText.maxLines, 2);
        expect(richText.overflow, TextOverflow.ellipsis);
      }
    });

    testWidgets('applies softWrap setting', (tester) async {
      const longText = 'This is a very long text that should wrap when softWrap is true';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: longText,
              softWrap: false,
              constraints: const BoxConstraints(maxWidth: 100),
            ),
          ),
        ),
      );
      
      final richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.softWrap, false);
    });

    testWidgets('widget-level overflow overrides style-level overflow', (tester) async {
      const text = 'Test text for overflow override';
      const style = MarkdownStyle(
        textOverflow: TextOverflow.clip,
        maxLines: 5,
        softWrap: false,
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: text,
              style: style,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: true,
            ),
          ),
        ),
      );
      
      final richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.overflow, TextOverflow.ellipsis); // Widget override
      expect(richText.maxLines, 2); // Widget override
      expect(richText.softWrap, true); // Widget override
    });

    testWidgets('BoxConstraints are applied correctly', (tester) async {
      const text = 'Test text';
      const constraints = BoxConstraints(maxWidth: 200, maxHeight: 100);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: text,
              constraints: constraints,
            ),
          ),
        ),
      );
      
      final constrainedBoxes = tester.widgetList<ConstrainedBox>(find.byType(ConstrainedBox));
      // Find the ConstrainedBox that was added by MarkdownWidget
      final markdownConstrainedBox = constrainedBoxes.firstWhere((box) => 
        box.constraints.maxWidth == 200 && box.constraints.maxHeight == 100);
      expect(markdownConstrainedBox.constraints.maxWidth, 200);
      expect(markdownConstrainedBox.constraints.maxHeight, 100);
    });

    testWidgets('handles infinite height constraints gracefully', (tester) async {
      const text = 'Test text';
      const constraints = BoxConstraints(maxWidth: 200, maxHeight: double.infinity);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MarkdownWidget(
                data: text,
                constraints: constraints,
              ),
            ),
          ),
        ),
      );
      
      expect(find.byType(MarkdownWidget), findsOneWidget);
      expect(tester.takeException(), isNull); // No layout exceptions
    });

    testWidgets('Column mainAxisSize and crossAxisAlignment work correctly', (tester) async {
      const text = '''# Header
      
Paragraph text here.''';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: text,
              style: const MarkdownStyle(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ),
          ),
        ),
      );
      
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisSize, MainAxisSize.max);
      expect(column.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('shrinkWrap affects Column children wrapping', (tester) async {
      const text = '''# Header
      
Paragraph text here.''';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: text,
              shrinkWrap: false,
            ),
          ),
        ),
      );
      
      final column = tester.widget<Column>(find.byType(Column));
      // When shrinkWrap is false, children should be wrapped in Expanded
      expect(column.children.every((child) => child is Expanded), true);
    });

    testWidgets('overflow settings apply to headers, paragraphs, and lists', (tester) async {
      const markdownText = '''# Very long header that should be truncated
      
This is a very long paragraph that should also be truncated when constrained.

- Very long list item that should be truncated
- Another long list item that should be truncated''';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkdownWidget(
              data: markdownText,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 1,
              constraints: const BoxConstraints(maxWidth: 150),
            ),
          ),
        ),
      );
      
      final richTextWidgets = tester.widgetList<RichText>(find.byType(RichText));
      expect(richTextWidgets.length, greaterThan(1));
      
      // Check that at least one RichText widget has the overflow settings
      // (Some may have defaults from the base style)
      bool hasEllipsisOverflow = false;
      bool hasMaxLinesSet = false;
      
      for (final richText in richTextWidgets) {
        if (richText.overflow == TextOverflow.ellipsis) {
          hasEllipsisOverflow = true;
        }
        if (richText.maxLines == 1) {
          hasMaxLinesSet = true;
        }
      }
      
      expect(hasEllipsisOverflow, true, reason: 'At least one RichText should have ellipsis overflow');
      expect(hasMaxLinesSet, true, reason: 'At least one RichText should have maxLines set to 1');
    });
  });

  group('MarkdownStyle Overflow Tests', () {
    test('MarkdownStyle creates with overflow defaults', () {
      const style = MarkdownStyle();
      
      expect(style.textOverflow, TextOverflow.clip);
      expect(style.maxLines, isNull);
      expect(style.softWrap, true);
      expect(style.mainAxisSize, MainAxisSize.min);
      expect(style.crossAxisAlignment, CrossAxisAlignment.start);
    });

    test('MarkdownStyle copyWith preserves overflow settings', () {
      const originalStyle = MarkdownStyle(
        textOverflow: TextOverflow.ellipsis,
        maxLines: 3,
        softWrap: false,
      );
      
      final copiedStyle = originalStyle.copyWith(
        textOverflow: TextOverflow.fade,
      );
      
      expect(copiedStyle.textOverflow, TextOverflow.fade);
      expect(copiedStyle.maxLines, 3); // Preserved
      expect(copiedStyle.softWrap, false); // Preserved
    });

    test('MarkdownStyle copyWith can override all overflow properties', () {
      const originalStyle = MarkdownStyle();
      
      final newStyle = originalStyle.copyWith(
        textOverflow: TextOverflow.ellipsis,
        maxLines: 5,
        softWrap: false,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
      );
      
      expect(newStyle.textOverflow, TextOverflow.ellipsis);
      expect(newStyle.maxLines, 5);
      expect(newStyle.softWrap, false);
      expect(newStyle.mainAxisSize, MainAxisSize.max);
      expect(newStyle.crossAxisAlignment, CrossAxisAlignment.end);
    });
  });
}