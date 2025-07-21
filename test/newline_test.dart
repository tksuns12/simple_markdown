import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_markdown/simple_markdown.dart';

void main() {
  group('Newline Handling Tests', () {
    late MarkdownParser parser;
    late MarkdownStyle style;

    setUp(() {
      parser = MarkdownParser();
      style = MarkdownStyle();
    });

    group('Parser Newline Tests', () {
      test('should preserve single newline between text lines', () {
        const input = 'First line\nSecond line';
        final document = MarkdownParser.parse(input);
        
        // Should create separate nodes or preserve newline information
        expect(document.children.length, greaterThan(1));
        
        // When rendered, should have line break between lines
        final widgets = MarkdownRenderer.buildFromDocument(document, style);
        final richText = widgets.first as RichText;
        final textSpan = richText.text as TextSpan;
        final fullText = _extractFullText(textSpan);
        
        expect(fullText, contains('\n'));
        expect(fullText, matches(r'First line\s*\n\s*Second line'));
      });

      test('should handle multiple consecutive newlines', () {
        const input = 'First line\n\nSecond line';
        final document = MarkdownParser.parse(input);
        final widgets = MarkdownRenderer.buildFromDocument(document, style);
        final richText = widgets.first as RichText;
        final textSpan = richText.text as TextSpan;
        final fullText = _extractFullText(textSpan);
        
        // Should preserve paragraph separation
        expect(fullText, contains('\n'));
        expect(fullText, isNot(equals('First lineSecond line')));
      });

      test('should handle newlines with inline formatting', () {
        const input = '**Bold text**\n*Italic text*';
        final document = MarkdownParser.parse(input);
        final widgets = MarkdownRenderer.buildFromDocument(document, style);
        final richText = widgets.first as RichText;
        final textSpan = richText.text as TextSpan;
        final fullText = _extractFullText(textSpan);
        
        expect(fullText, contains('\n'));
        expect(fullText, isNot(equals('Bold textItalic text')));
      });

      test('should handle newlines mixed with headers', () {
        const input = 'Regular text\n# Header\nMore text';
        final document = MarkdownParser.parse(input);
        final widgets = MarkdownRenderer.buildFromDocument(document, style);
        final richText = widgets.first as RichText;
        final textSpan = richText.text as TextSpan;
        final fullText = _extractFullText(textSpan);
        
        // Should have proper spacing around header
        expect(fullText, contains('Regular text'));
        expect(fullText, contains('Header'));
        expect(fullText, contains('More text'));
        expect(fullText, isNot(equals('Regular textHeaderMore text')));
      });

      test('should handle newlines with list items', () {
        const input = 'Text before\n- List item\nText after';
        final document = MarkdownParser.parse(input);
        final widgets = MarkdownRenderer.buildFromDocument(document, style);
        final richText = widgets.first as RichText;
        final textSpan = richText.text as TextSpan;
        final fullText = _extractFullText(textSpan);
        
        expect(fullText, contains('Text before'));
        expect(fullText, contains('List item'));
        expect(fullText, contains('Text after'));
        expect(fullText, isNot(equals('Text beforeList itemText after')));
      });

      test('should handle trailing newlines', () {
        const input = 'Text with trailing newline\n';
        final document = MarkdownParser.parse(input);
        final widgets = MarkdownRenderer.buildFromDocument(document, style);
        final richText = widgets.first as RichText;
        final textSpan = richText.text as TextSpan;
        final fullText = _extractFullText(textSpan);
        
        expect(fullText, contains('Text with trailing newline'));
        // Should not crash or produce unexpected output
      });

      test('should handle leading newlines', () {
        const input = '\nText with leading newline';
        final document = MarkdownParser.parse(input);
        final widgets = MarkdownRenderer.buildFromDocument(document, style);
        final richText = widgets.first as RichText;
        final textSpan = richText.text as TextSpan;
        final fullText = _extractFullText(textSpan);
        
        expect(fullText, contains('Text with leading newline'));
      });

      test('should handle only newlines', () {
        const input = '\n\n\n';
        final document = MarkdownParser.parse(input);
        
        // Should not crash and should handle gracefully
        expect(document.children, isNotNull);
        
        final widgets = MarkdownRenderer.buildFromDocument(document, style);
        expect(widgets, isNotEmpty);
      });

      test('should handle complex mixed content with newlines', () {
        const input = '''First paragraph
with multiple lines

# Header

Second paragraph
with **bold** and *italic*

- List item 1
- List item 2

Final paragraph''';
        
        final document = MarkdownParser.parse(input);
        final widgets = MarkdownRenderer.buildFromDocument(document, style);
        final richText = widgets.first as RichText;
        final textSpan = richText.text as TextSpan;
        final fullText = _extractFullText(textSpan);
        
        // Should contain all content with proper spacing
        expect(fullText, contains('First paragraph'));
        expect(fullText, contains('Header'));
        expect(fullText, contains('Second paragraph'));
        expect(fullText, contains('List item 1'));
        expect(fullText, contains('Final paragraph'));
        
        // Should not be concatenated without breaks
        expect(fullText, isNot(equals('First paragraphwith multiple linesHeaderSecond paragraphwith bold and italicList item 1List item 2Final paragraph')));
      });
    });

    group('Edge Cases', () {
      test('should handle Windows line endings (\\r\\n)', () {
        const input = 'First line\r\nSecond line';
        final document = MarkdownParser.parse(input);
        final widgets = MarkdownRenderer.buildFromDocument(document, style);
        final richText = widgets.first as RichText;
        final textSpan = richText.text as TextSpan;
        final fullText = _extractFullText(textSpan);
        
        expect(fullText, isNot(equals('First lineSecond line')));
      });

      test('should handle mixed line endings', () {
        const input = 'First line\nSecond line\r\nThird line';
        final document = MarkdownParser.parse(input);
        final widgets = MarkdownRenderer.buildFromDocument(document, style);
        
        // Should not crash and should handle gracefully
        expect(widgets, isNotEmpty);
      });
    });
  });
}

// Helper function to extract full text from TextSpan tree
String _extractFullText(TextSpan span) {
  final buffer = StringBuffer();
  
  void extractText(InlineSpan span) {
    if (span is TextSpan) {
      if (span.text != null) {
        buffer.write(span.text);
      }
      if (span.children != null) {
        for (final child in span.children!) {
          extractText(child);
        }
      }
    }
  }
  
  extractText(span);
  return buffer.toString();
}