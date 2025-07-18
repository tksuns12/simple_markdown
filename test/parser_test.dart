import 'package:flutter_test/flutter_test.dart';
import 'package:simple_markdown/simple_markdown.dart';

void main() {
  group('MarkdownParser', () {
    late MarkdownParser parser;

    setUp(() {
      parser = MarkdownParser();
    });

    test('parses empty string', () {
      final result = parser.parse('');
      expect(result, isA<DocumentNode>());
      expect(result.children, isEmpty);
    });

    test('parses simple paragraph', () {
      final result = parser.parse('Hello world');
      expect(result.children, hasLength(1));
      expect(result.children[0], isA<ParagraphNode>());
      
      final paragraph = result.children[0] as ParagraphNode;
      expect(paragraph.children, hasLength(1));
      expect(paragraph.children[0], isA<TextNode>());
      
      final text = paragraph.children[0] as TextNode;
      expect(text.text, 'Hello world');
      expect(text.bold, false);
      expect(text.italic, false);
      expect(text.code, false);
    });

    test('parses headers', () {
      final result = parser.parse('# Header 1\n## Header 2\n### Header 3');
      expect(result.children, hasLength(3));
      
      final h1 = result.children[0] as HeaderNode;
      expect(h1.level, 1);
      expect((h1.children[0] as TextNode).text, 'Header 1');
      
      final h2 = result.children[1] as HeaderNode;
      expect(h2.level, 2);
      expect((h2.children[0] as TextNode).text, 'Header 2');
      
      final h3 = result.children[2] as HeaderNode;
      expect(h3.level, 3);
      expect((h3.children[0] as TextNode).text, 'Header 3');
    });

    test('parses bold text', () {
      final result = parser.parse('**bold text**');
      final paragraph = result.children[0] as ParagraphNode;
      final text = paragraph.children[0] as TextNode;
      
      expect(text.text, 'bold text');
      expect(text.bold, true);
      expect(text.italic, false);
    });

    test('parses italic text', () {
      final result = parser.parse('*italic text*');
      final paragraph = result.children[0] as ParagraphNode;
      final text = paragraph.children[0] as TextNode;
      
      expect(text.text, 'italic text');
      expect(text.bold, false);
      expect(text.italic, true);
    });

    test('parses code text', () {
      final result = parser.parse('`code text`');
      final paragraph = result.children[0] as ParagraphNode;
      final text = paragraph.children[0] as TextNode;
      
      expect(text.text, 'code text');
      expect(text.code, true);
    });

    test('parses mixed formatting', () {
      final result = parser.parse('**bold** and *italic* and `code`');
      final paragraph = result.children[0] as ParagraphNode;
      
      expect(paragraph.children, hasLength(5));
      
      final bold = paragraph.children[0] as TextNode;
      expect(bold.text, 'bold');
      expect(bold.bold, true);
      
      final and1 = paragraph.children[1] as TextNode;
      expect(and1.text, ' and ');
      
      final italic = paragraph.children[2] as TextNode;
      expect(italic.text, 'italic');
      expect(italic.italic, true);
      
      final and2 = paragraph.children[3] as TextNode;
      expect(and2.text, ' and ');
      
      final code = paragraph.children[4] as TextNode;
      expect(code.text, 'code');
      expect(code.code, true);
    });

    test('parses unordered list', () {
      final result = parser.parse('- Item 1\n- Item 2\n- Item 3');
      expect(result.children, hasLength(1));
      
      final listNode = result.children[0] as ListNode;
      expect(listNode.ordered, false);
      expect(listNode.items, hasLength(3));
      
      for (int i = 0; i < 3; i++) {
        expect((listNode.items[i].children[0] as TextNode).text, 'Item ${i + 1}');
      }
    });

    test('parses ordered list', () {
      final result = parser.parse('1. First item\n2. Second item\n3. Third item');
      expect(result.children, hasLength(1));
      
      final listNode = result.children[0] as ListNode;
      expect(listNode.ordered, true);
      expect(listNode.items, hasLength(3));
      
      final items = ['First item', 'Second item', 'Third item'];
      for (int i = 0; i < 3; i++) {
        expect((listNode.items[i].children[0] as TextNode).text, items[i]);
      }
    });

    test('ignores empty lines', () {
      final result = parser.parse('Line 1\n\n\nLine 2');
      expect(result.children, hasLength(2));
      
      final line1 = result.children[0] as ParagraphNode;
      expect((line1.children[0] as TextNode).text, 'Line 1');
      
      final line2 = result.children[1] as ParagraphNode;
      expect((line2.children[0] as TextNode).text, 'Line 2');
    });
  });
}