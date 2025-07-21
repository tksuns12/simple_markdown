import 'nodes.dart';

class MarkdownParser {
  static DocumentNode parse(String input) {
    final lines = input.split('\n');
    final nodes = <MarkdownNode>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trim().isEmpty) {
        if (i > 0 && lines[i - 1].trim().isNotEmpty) {
          nodes.add(LineBreakNode());
        }
      } else if (line.startsWith('### ')) {
        nodes.add(HeaderNode(3, _parseInlineText(line.substring(4))));
      } else if (line.startsWith('## ')) {
        nodes.add(HeaderNode(2, _parseInlineText(line.substring(3))));
      } else if (line.startsWith('# ')) {
        nodes.add(HeaderNode(1, _parseInlineText(line.substring(2))));
      } else if (line.startsWith('- ')) {
        nodes.add(ListItemNode(_parseInlineText(line.substring(2))));
      } else {
        nodes.add(ParagraphNode(_parseInlineText(line)));
      }
    }

    return DocumentNode(nodes);
  }
  
  static List<MarkdownNode> _parseInlineText(String text) {
    final lines = text.split('\n');
    final result = <MarkdownNode>[];
    for (var i = 0; i < lines.length; i++) {
      result.addAll(_parseSingleLine(lines[i]));
      if (i < lines.length - 1) {
        result.add(LineBreakNode());
      }
    }
    return result;
  }

  static List<MarkdownNode> _parseSingleLine(String text) {
    final nodes = <MarkdownNode>[];
    final buffer = StringBuffer();
    int i = 0;
    
    while (i < text.length) {
      if (i < text.length - 1) {
        // Check for **bold**
        if (text[i] == '*' && text[i + 1] == '*') {
          if (buffer.isNotEmpty) {
            nodes.add(TextNode(buffer.toString()));
            buffer.clear();
          }
          i += 2;
          final boldStart = i;
          while (i < text.length - 1 && !(text[i] == '*' && text[i + 1] == '*')) {
            i++;
          }
          if (i < text.length - 1) {
            nodes.add(TextNode(text.substring(boldStart, i), isBold: true));
            i += 2;
          } else {
            buffer.write('**');
            i = boldStart;
          }
          continue;
        }
        
        // Check for *italic*
        if (text[i] == '*') {
          if (buffer.isNotEmpty) {
            nodes.add(TextNode(buffer.toString()));
            buffer.clear();
          }
          i++;
          final italicStart = i;
          while (i < text.length && text[i] != '*') {
            i++;
          }
          if (i < text.length) {
            nodes.add(TextNode(text.substring(italicStart, i), isItalic: true));
            i++;
          } else {
            buffer.write('*');
            i = italicStart;
          }
          continue;
        }
        
        // Check for `code`
        if (text[i] == '`') {
          if (buffer.isNotEmpty) {
            nodes.add(TextNode(buffer.toString()));
            buffer.clear();
          }
          i++;
          final codeStart = i;
          while (i < text.length && text[i] != '`') {
            i++;
          }
          if (i < text.length) {
            nodes.add(TextNode(text.substring(codeStart, i), isCode: true));
            i++;
          } else {
            buffer.write('`');
            i = codeStart;
          }
          continue;
        }
      }
      
      buffer.write(text[i]);
      i++;
    }
    
    if (buffer.isNotEmpty) {
      nodes.add(TextNode(buffer.toString()));
    }
    
    return nodes.isEmpty ? [TextNode('')] : nodes;
  }
}