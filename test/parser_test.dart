import 'package:flutter_test/flutter_test.dart';
import 'package:simple_markdown/src/parser.dart';
import 'package:simple_markdown/src/nodes.dart';

void main() {
  group('MarkdownParser Enhanced Tests', () {
    test('should parse bold text correctly', () {
      final result = MarkdownParser.parse('This is **bold** text');
      final nodes = result.children;
      
      expect(nodes.length, 3);
      expect((nodes[0] as TextNode).text, 'This is ');
      expect((nodes[0] as TextNode).isBold, false);
      
      expect((nodes[1] as TextNode).text, 'bold');
      expect((nodes[1] as TextNode).isBold, true);
      
      expect((nodes[2] as TextNode).text, ' text');
      expect((nodes[2] as TextNode).isBold, false);
    });
    
    test('should parse italic text correctly', () {
      final result = MarkdownParser.parse('This is *italic* text');
      final nodes = result.children;
      
      expect(nodes.length, 3);
      expect((nodes[0] as TextNode).text, 'This is ');
      expect((nodes[0] as TextNode).isItalic, false);
      
      expect((nodes[1] as TextNode).text, 'italic');
      expect((nodes[1] as TextNode).isItalic, true);
      
      expect((nodes[2] as TextNode).text, ' text');
      expect((nodes[2] as TextNode).isItalic, false);
    });
    
    test('should parse code text correctly', () {
      final result = MarkdownParser.parse('This is `code` text');
      final nodes = result.children;
      
      expect(nodes.length, 3);
      expect((nodes[0] as TextNode).text, 'This is ');
      expect((nodes[0] as TextNode).isCode, false);
      
      expect((nodes[1] as TextNode).text, 'code');
      expect((nodes[1] as TextNode).isCode, true);
      
      expect((nodes[2] as TextNode).text, ' text');
      expect((nodes[2] as TextNode).isCode, false);
    });
    
    test('should parse headers with inline formatting', () {
      final result = MarkdownParser.parse('# Header with **bold** text');
      final nodes = result.children;
      
      expect(nodes.length, 1);
      expect(nodes[0], isA<HeaderNode>());
      
      final header = nodes[0] as HeaderNode;
      expect(header.level, 1);
      expect(header.children.length, 3);
      
      expect((header.children[0] as TextNode).text, 'Header with ');
      expect((header.children[1] as TextNode).text, 'bold');
      expect((header.children[1] as TextNode).isBold, true);
      expect((header.children[2] as TextNode).text, ' text');
    });
    
    test('should parse list items with inline formatting', () {
      final result = MarkdownParser.parse('- Item with *italic* text');
      final nodes = result.children;
      
      expect(nodes.length, 1);
      expect(nodes[0], isA<ListItemNode>());
      
      final listItem = nodes[0] as ListItemNode;
      expect(listItem.children.length, 3);
      
      expect((listItem.children[0] as TextNode).text, 'Item with ');
      expect((listItem.children[1] as TextNode).text, 'italic');
      expect((listItem.children[1] as TextNode).isItalic, true);
      expect((listItem.children[2] as TextNode).text, ' text');
    });
    
    test('should handle mixed formatting', () {
      final result = MarkdownParser.parse('Text with **bold**, *italic*, and `code`');
      final nodes = result.children;
      
      expect(nodes.length, 6);
      expect((nodes[0] as TextNode).text, 'Text with ');
      expect((nodes[1] as TextNode).text, 'bold');
      expect((nodes[1] as TextNode).isBold, true);
      expect((nodes[2] as TextNode).text, ', ');
      expect((nodes[3] as TextNode).text, 'italic');
      expect((nodes[3] as TextNode).isItalic, true);
      expect((nodes[4] as TextNode).text, ', and ');
      expect((nodes[5] as TextNode).text, 'code');
      expect((nodes[5] as TextNode).isCode, true);
    });
    
    test('should skip empty lines', () {
      final result = MarkdownParser.parse('Line 1\n\nLine 2');
      final nodes = result.children;
      
      expect(nodes.length, 2);
      expect((nodes[0] as TextNode).text, 'Line 1');
      expect((nodes[1] as TextNode).text, 'Line 2');
    });
  });
}