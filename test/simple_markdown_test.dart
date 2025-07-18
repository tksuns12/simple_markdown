import 'package:flutter_test/flutter_test.dart';
import 'package:simple_markdown/simple_markdown.dart';

void main() {
  test('package exports work correctly', () {
    final parser = MarkdownParser();
    final document = parser.parse('# Test\n\nHello world');
    
    expect(document, isA<DocumentNode>());
    expect(document.children, hasLength(2));
    expect(document.children[0], isA<HeaderNode>());
    expect(document.children[1], isA<ParagraphNode>());
  });

  test('MarkdownStyle can be instantiated', () {
    const style = MarkdownStyle();
    expect(style, isA<MarkdownStyle>());
    expect(style.h1Style.fontSize, 32);
  });
}
