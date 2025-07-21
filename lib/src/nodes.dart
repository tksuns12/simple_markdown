abstract class MarkdownNode {
  List<MarkdownNode> children;
  MarkdownNode([this.children = const []]);
}

class DocumentNode extends MarkdownNode {
  DocumentNode([super.children]);
}

class TextNode extends MarkdownNode {
  final String text;
  final bool isBold;
  final bool isItalic;
  final bool isCode;

  TextNode(this.text, {
    this.isBold = false,
    this.isItalic = false,
    this.isCode = false,
  }) : super();
}

class HeaderNode extends MarkdownNode {
  final int level;
  HeaderNode(this.level, [super.children]);
}

class ListNode extends MarkdownNode {
  final bool ordered;
  ListNode(this.ordered, [super.children]);
}

class ListItemNode extends MarkdownNode {
  ListItemNode([super.children]);
}