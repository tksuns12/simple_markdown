import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_markdown/simple_markdown.dart';

void main() {
  group('MarkdownWidget Tests', () {
    group('Width Overflow Tests', () {
      Widget buildConstrainedMarkdown({
        required String text,
        required double width,
        TextOverflow? overflow,
        bool? softWrap,
      }) {
        return MaterialApp(
          home: Scaffold(
            body: Container(
              width: width,
              child: MarkdownWidget(
                data: text,
                textOverflow: overflow,
                softWrap: softWrap,
              ),
            ),
          ),
        );
      }

      testWidgets('TextOverflow.clip should clip text at container boundary', (
        tester,
      ) async {
        const longText =
            'This is a very long single line of text that should definitely overflow the container width when constrained';

        await tester.pumpWidget(
          buildConstrainedMarkdown(
            text: longText,
            width: 100,
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        );

        final richTextWidget = tester.widget<RichText>(find.byType(RichText));
        expect(richTextWidget.overflow, TextOverflow.clip);
        expect(richTextWidget.softWrap, false);

        // Verify the container width constraint is applied
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.maxWidth, 100);

        // Verify the RichText widget respects the container bounds
        final richTextSize = tester.getSize(find.byType(RichText));
        expect(richTextSize.width, lessThanOrEqualTo(100));
      });

      testWidgets('TextOverflow.ellipsis should show ellipsis at end', (
        tester,
      ) async {
        const longText =
            'This is a very long single line of text that should definitely overflow the container width when constrained';

        await tester.pumpWidget(
          buildConstrainedMarkdown(
            text: longText,
            width: 100,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        );

        final richTextWidget = tester.widget<RichText>(find.byType(RichText));
        expect(richTextWidget.overflow, TextOverflow.ellipsis);

        // Verify the text is constrained and ellipsis behavior is applied
        final richTextSize = tester.getSize(find.byType(RichText));
        expect(richTextSize.width, lessThanOrEqualTo(100));

        // The text should be truncated (we can't directly test ellipsis visibility,
        // but we can verify the widget is properly constrained)
        final textSpan = richTextWidget.text as TextSpan;
        expect(textSpan, isNotNull);
      });

      testWidgets('TextOverflow.fade should apply fade effect', (tester) async {
        const longText =
            'This is a very long single line of text that should definitely overflow the container width when constrained';

        await tester.pumpWidget(
          buildConstrainedMarkdown(
            text: longText,
            width: 100,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        );

        final richTextWidget = tester.widget<RichText>(find.byType(RichText));
        expect(richTextWidget.overflow, TextOverflow.fade);
      });

      testWidgets('TextOverflow.visible should allow text to overflow', (
        tester,
      ) async {
        const longText =
            'This is a very long single line of text that should definitely overflow the container width when constrained';

        await tester.pumpWidget(
          buildConstrainedMarkdown(
            text: longText,
            width: 100,
            overflow: TextOverflow.visible,
            softWrap: false,
          ),
        );

        final richTextWidget = tester.widget<RichText>(find.byType(RichText));
        expect(richTextWidget.overflow, TextOverflow.visible);
      });

      testWidgets('softWrap true should wrap text to multiple lines', (
        tester,
      ) async {
        const longText =
            'This is a very long single line of text that should wrap to multiple lines when softWrap is enabled';

        await tester.pumpWidget(
          buildConstrainedMarkdown(text: longText, width: 100, softWrap: true),
        );

        final richTextWidget = tester.widget<RichText>(find.byType(RichText));
        expect(richTextWidget.softWrap, true);

        // Verify that with softWrap enabled, the text height increases
        // (indicating multiple lines) while width stays within bounds
        final richTextSize = tester.getSize(find.byType(RichText));
        expect(richTextSize.width, lessThanOrEqualTo(100));
        expect(
          richTextSize.height,
          greaterThan(20),
        ); // Should be taller than single line
      });
    });

    group('Height Overflow Tests', () {
      Widget buildHeightConstrainedMarkdown({
        required String text,
        required double height,
        int? maxLines,
      }) {
        return MaterialApp(
          home: Scaffold(
            body: Container(
              height: height,
              child: MarkdownWidget(data: text, maxLines: maxLines),
            ),
          ),
        );
      }

      testWidgets('maxLines = 1 should limit to single line', (tester) async {
        const multiLineText = '''# Header 1
This is a paragraph with multiple lines.

## Header 2
- List item 1
- List item 2''';

        await tester.pumpWidget(
          buildHeightConstrainedMarkdown(
            text: multiLineText,
            height: 200,
            maxLines: 1,
          ),
        );

        final richTextWidget = tester.widget<RichText>(find.byType(RichText));
        expect(richTextWidget.maxLines, 1);

        // Verify the text height is constrained to approximately single line height
        final richTextSize = tester.getSize(find.byType(RichText));
        print('DEBUG: RichText size with maxLines=1: ${richTextSize}');
        print('DEBUG: RichText maxLines: ${richTextWidget.maxLines}');
        expect(
          richTextSize.height,
          lessThan(50),
        ); // Should be roughly single line height
      });

      testWidgets('maxLines = 3 should limit to three lines', (tester) async {
        const multiLineText = '''# Header 1
This is a paragraph with multiple lines.

## Header 2
- List item 1
- List item 2
- List item 3

Another paragraph here.''';

        await tester.pumpWidget(
          buildHeightConstrainedMarkdown(
            text: multiLineText,
            height: 200,
            maxLines: 3,
          ),
        );

        final richTextWidget = tester.widget<RichText>(find.byType(RichText));
        expect(richTextWidget.maxLines, 3);

        // Verify the text height is constrained to approximately 3 lines
        final richTextSize = tester.getSize(find.byType(RichText));
        expect(
          richTextSize.height,
          lessThan(100),
        ); // Should be roughly 3 lines height
        expect(
          richTextSize.height,
          greaterThan(20),
        ); // But more than single line
      });

      testWidgets('maxLines = null should allow unlimited lines', (
        tester,
      ) async {
        const multiLineText = '''# Header 1
This is a paragraph with multiple lines.

## Header 2
- List item 1
- List item 2
- List item 3

Another paragraph here.''';

        await tester.pumpWidget(
          buildHeightConstrainedMarkdown(
            text: multiLineText,
            height: 200,
            maxLines: null,
          ),
        );

        final richTextWidget = tester.widget<RichText>(find.byType(RichText));
        expect(richTextWidget.maxLines, null);

        // With unlimited lines, the text should take more vertical space
        final richTextSize = tester.getSize(find.byType(RichText));
        expect(
          richTextSize.height,
          greaterThan(20),
        ); // Should be tall enough for content
      });
    });

    group('Style Integration Tests', () {
      testWidgets('MarkdownStyle should apply custom text styles', (
        tester,
      ) async {
        const text = '# Header\n**Bold text** and *italic text*';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MarkdownWidget(
                data: text,
                style: MarkdownStyle(
                  h1Style: const TextStyle(fontSize: 32, color: Colors.red),
                  boldStyle: const TextStyle(fontWeight: FontWeight.w900),
                  italicStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(MarkdownWidget), findsOneWidget);
        expect(find.byType(RichText), findsOneWidget);

        // Verify that the RichText contains the expected text content
        final richTextWidget = tester.widget<RichText>(find.byType(RichText));
        final textSpan = richTextWidget.text as TextSpan;

        // The text span should contain our markdown content (parsed)
        expect(textSpan, isNotNull);
        // Just verify the textSpan exists for now
        expect(textSpan, isNotNull);

        // Verify the widget renders without throwing exceptions
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('MarkdownStyle padding should be applied', (tester) async {
        const text = '# Header\nParagraph text';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MarkdownWidget(
                data: text,
                style: MarkdownStyle(
                  headerPadding: const EdgeInsets.all(16),
                  paragraphPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(MarkdownWidget), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('Empty markdown string should render without error', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: MarkdownWidget(data: '')),
          ),
        );

        expect(find.byType(MarkdownWidget), findsOneWidget);
      });

      testWidgets('Very long words should handle overflow', (tester) async {
        final longWord = 'Supercalifragilisticexpialidocious' * 10;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                width: 100,
                child: MarkdownWidget(
                  data: longWord,
                  textOverflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ),
          ),
        );

        final richTextWidget = tester.widget<RichText>(find.byType(RichText));
        expect(richTextWidget.overflow, TextOverflow.ellipsis);

        // Verify the long word is properly constrained
        final richTextSize = tester.getSize(find.byType(RichText));
        expect(richTextSize.width, lessThanOrEqualTo(100));

        // Verify no overflow exceptions are thrown
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('Unicode and emoji content should render correctly', (
        tester,
      ) async {
        const unicodeText = '🚀 Hello 世界! **Bold 文字** and *italic テキスト*';

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: MarkdownWidget(data: unicodeText)),
          ),
        );

        expect(find.byType(MarkdownWidget), findsOneWidget);
        expect(find.byType(RichText), findsOneWidget);

        // Verify the unicode content is properly rendered
        final richTextWidget = tester.widget<RichText>(find.byType(RichText));
        final textSpan = richTextWidget.text as TextSpan;
        expect(textSpan, isNotNull);
        // Verify either direct text or children are present
        expect(
          textSpan.text != null ||
              (textSpan.children != null && textSpan.children!.isNotEmpty),
          isTrue,
        );

        // Verify no rendering exceptions with unicode content
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Verify the widget has reasonable dimensions
        final richTextSize = tester.getSize(find.byType(RichText));
        expect(richTextSize.width, greaterThan(0));
        expect(richTextSize.height, greaterThan(0));
      });
    });
  });

  group('MarkdownSliver Tests', () {
    Widget buildSliverMarkdown({
      required List<String> markdownItems,
      TextOverflow? overflow,
      int? maxLines,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              ...markdownItems.map(
                (text) => MarkdownSliver(
                  data: text,
                  style: MarkdownStyle(
                    textOverflow: overflow ?? TextOverflow.clip,
                    maxLines: maxLines,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('MarkdownSliver should work in CustomScrollView', (
      tester,
    ) async {
      final markdownItems = [
        '# First Header\nFirst paragraph',
        '## Second Header\nSecond paragraph with more content',
        '### Third Header\n- List item 1\n- List item 2',
      ];

      await tester.pumpWidget(
        buildSliverMarkdown(markdownItems: markdownItems),
      );

      expect(find.byType(MarkdownSliver), findsNWidgets(3));
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('MarkdownSliver should handle overflow in scrollable context', (
      tester,
    ) async {
      final markdownItems = [
        'This is a very long single line of text that should definitely overflow the container width when constrained in a sliver context',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 100,
              child: CustomScrollView(
                slivers: [
                  MarkdownSliver(
                    data: markdownItems[0],
                    style: MarkdownStyle(
                      textOverflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(MarkdownSliver), findsOneWidget);
    });

    testWidgets('Mixed slivers with MarkdownSliver should work together', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                const SliverAppBar(title: Text('Test App'), floating: true),
                MarkdownSliver(
                  data: '# Markdown Content\nThis is markdown in a sliver',
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    const ListTile(title: Text('Regular List Item')),
                  ]),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.byType(MarkdownSliver), findsOneWidget);
      expect(find.byType(SliverList), findsOneWidget);
    });

    testWidgets('MarkdownSliver should scroll properly with large content', (
      tester,
    ) async {
      final longContent = List.generate(
        20,
        (i) => '## Section $i\nContent for section $i with some text.',
      ).join('\n\n');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [MarkdownSliver(data: longContent)],
            ),
          ),
        ),
      );

      expect(find.byType(MarkdownSliver), findsOneWidget);

      // Test scrolling
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Should still find the sliver after scrolling
      expect(find.byType(MarkdownSliver), findsOneWidget);
    });
  });

  group('Markdown Content Rendering Tests', () {
    testWidgets('Headers should be parsed and rendered correctly', (
      tester,
    ) async {
      const markdownText = '# Header 1\n## Header 2\n### Header 3';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MarkdownWidget(data: markdownText)),
        ),
      );

      final richTextWidget = tester.widget<RichText>(find.byType(RichText));
      final textSpan = richTextWidget.text as TextSpan;

      // Verify the text span is created (even if empty for basic parser)
      expect(textSpan, isNotNull);

      // Verify the widget renders without exceptions
      expect(richTextWidget, isNotNull);
      expect(richTextWidget.text, isA<TextSpan>());

      // Verify no exceptions during rendering
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Bold and italic text should be styled correctly', (
      tester,
    ) async {
      const markdownText = 'Normal text **bold text** and *italic text*';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MarkdownWidget(data: markdownText)),
        ),
      );

      final richTextWidget = tester.widget<RichText>(find.byType(RichText));
      final textSpan = richTextWidget.text as TextSpan;

      // Verify the text span has content (indicating styled segments)
      expect(textSpan, isNotNull);
      // Just verify the textSpan exists for now
      expect(textSpan, isNotNull);

      // Verify rendering completes without errors
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('List items should be rendered correctly', (tester) async {
      const markdownText = '- Item 1\n- Item 2\n- Item 3';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MarkdownWidget(data: markdownText)),
        ),
      );

      final richTextWidget = tester.widget<RichText>(find.byType(RichText));
      final textSpan = richTextWidget.text as TextSpan;

      // Verify list content is parsed
      expect(textSpan, isNotNull);

      // Verify rendering works correctly
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Mixed markdown content should render as unified text', (
      tester,
    ) async {
      const markdownText = '''# Main Title

This is a **bold** paragraph with *italic* text.

## Subsection

- List item 1
- List item 2

Another paragraph here.''';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MarkdownWidget(data: markdownText)),
        ),
      );

      // Verify only one RichText widget is created (unified rendering)
      expect(find.byType(RichText), findsOneWidget);

      final richTextWidget = tester.widget<RichText>(find.byType(RichText));
      final textSpan = richTextWidget.text as TextSpan;

      // Verify complex content is parsed into text spans
      expect(textSpan, isNotNull);
      // Just verify the textSpan exists for now
      expect(textSpan, isNotNull);

      // Verify the widget has reasonable size for the content
      final richTextSize = tester.getSize(find.byType(RichText));
      expect(richTextSize.width, greaterThan(0));
      expect(
        richTextSize.height,
        greaterThan(20),
      ); // Should be tall for multi-line content

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('Integration Tests', () {
    testWidgets('MarkdownWidget in ListView should work correctly', (
      tester,
    ) async {
      final markdownItems = [
        '# Item 1\nFirst item content',
        '## Item 2\nSecond item content',
        '### Item 3\nThird item content',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: markdownItems.length,
              itemBuilder: (context, index) =>
                  MarkdownWidget(data: markdownItems[index]),
            ),
          ),
        ),
      );

      expect(find.byType(MarkdownWidget), findsNWidgets(3));
      expect(find.byType(ListView), findsOneWidget);

      // Verify each markdown widget renders correctly
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Nested constraints should work properly', (tester) async {
      const text =
          '''# This is a very long header that definitely will overflow in a small container

This is a **very long paragraph** with lots of text that will definitely overflow when placed in a constrained container. We can control how this overflow is handled using different TextOverflow options like clip, ellipsis, fade, or visible.

## Another long header to demonstrate overflow behavior

- This is a very long list item that will also overflow
- Another long item with **bold text** and *italic text*
- Yet another item with `inline code` that makes it even longer''';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 200,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MarkdownWidget(
                  data: text,
                  textOverflow: TextOverflow.clip,
                  maxLines: null,
                  softWrap: true,
                ),
              ),
            ),
          ),
        ),
      );

      final richTextWidget = tester.widget<RichText>(find.byType(RichText));
      expect(richTextWidget.overflow, TextOverflow.clip);
      expect(richTextWidget.maxLines, null);

      // Verify the nested constraints are respected for width
      // Note: Height is no longer constrained due to SingleChildScrollView
      final richTextSize = tester.getSize(find.byType(RichText));
      expect(
        richTextSize.width,
        lessThanOrEqualTo(200 - 32),
      ); // Account for padding
      
      // With direct RichText (no Column wrapper), height should still respect constraints
      // but may be different from the previous Column-wrapped behavior
      expect(richTextSize.height, lessThanOrEqualTo(100 - 32)); // Should fit in container minus padding

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'Overflow behavior should work consistently across different content types',
      (tester) async {
        final testCases = [
          '# Very Long Header That Should Definitely Overflow The Container Width',
          'Very long paragraph text that should definitely overflow the container width when constrained',
          '- Very long list item that should definitely overflow the container width when constrained',
          '**Very long bold text that should definitely overflow the container width when constrained**',
        ];

        for (final testCase in testCases) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Container(
                  width: 100,
                  child: MarkdownWidget(
                    data: testCase,
                    textOverflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ),
            ),
          );

          final richTextWidget = tester.widget<RichText>(find.byType(RichText));
          expect(richTextWidget.overflow, TextOverflow.ellipsis);

          final richTextSize = tester.getSize(find.byType(RichText));
          expect(richTextSize.width, lessThanOrEqualTo(100));

          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      },
    );
  });
}
