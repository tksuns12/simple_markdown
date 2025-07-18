import 'nodes.dart';

class MarkdownParser {
  DocumentNode parse(String markdown) {
    final lines = markdown.split('\n');
    final nodes = <MarkdownNode>[];
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      if (line.trim().isEmpty) {
        continue;
      }
      
      final node = _parseLine(line, lines, i);
      if (node != null) {
        nodes.add(node);
        
        // Skip ahead if we parsed a list that consumed multiple lines
        if (node is ListNode && node.items.length > 1) {
          i += node.items.length - 1;
        }
      }
    }
    
    return DocumentNode(children: nodes);
  }

  MarkdownNode? _parseLine(String line, List<String> lines, int startIndex) {
    final trimmed = line.trim();
    
    if (trimmed.startsWith('#')) {
      return _parseHeader(trimmed);
    }
    
    if (trimmed.startsWith('- ') || trimmed.startsWith('* ') || trimmed.startsWith('+ ')) {
      return _parseUnorderedList(lines, startIndex);
    }
    
    if (RegExp(r'^\d+\.\s').hasMatch(trimmed)) {
      return _parseOrderedList(lines, startIndex);
    }
    
    return _parseParagraph(trimmed);
  }

  HeaderNode _parseHeader(String line) {
    int level = 0;
    for (int i = 0; i < line.length && line[i] == '#'; i++) {
      level++;
    }
    
    final text = line.substring(level).trim();
    final children = _parseInlineText(text);
    
    return HeaderNode(level: level, children: children);
  }

  ListNode _parseUnorderedList(List<String> lines, int startIndex) {
    final items = <ListItemNode>[];
    
    for (int i = startIndex; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      
      if (line.startsWith('- ') || line.startsWith('* ') || line.startsWith('+ ')) {
        final text = line.substring(2).trim();
        final children = _parseInlineText(text);
        items.add(ListItemNode(children: children));
      } else {
        break;
      }
    }
    
    return ListNode(items: items, ordered: false);
  }

  ListNode _parseOrderedList(List<String> lines, int startIndex) {
    final items = <ListItemNode>[];
    
    for (int i = startIndex; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      
      final match = RegExp(r'^\d+\.\s').firstMatch(line);
      if (match != null) {
        final text = line.substring(match.end).trim();
        final children = _parseInlineText(text);
        items.add(ListItemNode(children: children));
      } else {
        break;
      }
    }
    
    return ListNode(items: items, ordered: true);
  }

  ParagraphNode _parseParagraph(String line) {
    final children = _parseInlineText(line);
    return ParagraphNode(children: children);
  }

  List<MarkdownNode> _parseInlineText(String text) {
    final nodes = <MarkdownNode>[];
    final buffer = StringBuffer();
    bool bold = false;
    bool italic = false;
    bool code = false;
    
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      
      if (char == '*' && i + 1 < text.length && text[i + 1] == '*') {
        if (buffer.isNotEmpty) {
          nodes.add(TextNode(
            text: buffer.toString(),
            bold: bold,
            italic: italic,
            code: code,
          ));
          buffer.clear();
        }
        bold = !bold;
        i++; // Skip the next *
      } else if (char == '*') {
        if (buffer.isNotEmpty) {
          nodes.add(TextNode(
            text: buffer.toString(),
            bold: bold,
            italic: italic,
            code: code,
          ));
          buffer.clear();
        }
        italic = !italic;
      } else if (char == '`') {
        if (buffer.isNotEmpty) {
          nodes.add(TextNode(
            text: buffer.toString(),
            bold: bold,
            italic: italic,
            code: code,
          ));
          buffer.clear();
        }
        code = !code;
      } else {
        buffer.write(char);
      }
    }
    
    if (buffer.isNotEmpty) {
      nodes.add(TextNode(
        text: buffer.toString(),
        bold: bold,
        italic: italic,
        code: code,
      ));
    }
    
    return nodes;
  }
}