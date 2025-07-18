abstract class MarkdownNode {}

class TextNode extends MarkdownNode {
  final String text;
  final bool bold;
  final bool italic;
  final bool code;

  TextNode({
    required this.text,
    this.bold = false,
    this.italic = false,
    this.code = false,
  });
}

class ParagraphNode extends MarkdownNode {
  final List<MarkdownNode> children;

  ParagraphNode({required this.children});
}

class HeaderNode extends MarkdownNode {
  final int level;
  final List<MarkdownNode> children;

  HeaderNode({required this.level, required this.children});
}

class ListNode extends MarkdownNode {
  final List<ListItemNode> items;
  final bool ordered;

  ListNode({required this.items, this.ordered = false});
}

class ListItemNode extends MarkdownNode {
  final List<MarkdownNode> children;

  ListItemNode({required this.children});
}

class LineBreakNode extends MarkdownNode {}

class DocumentNode extends MarkdownNode {
  final List<MarkdownNode> children;

  DocumentNode({required this.children});
}