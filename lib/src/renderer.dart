import 'package:flutter/widgets.dart';
import 'nodes.dart';
import 'styles.dart';

class MarkdownRenderer {
  static List<Widget> buildFromDocument(
    DocumentNode document,
    MarkdownStyle style,
  ) {
    return [
      RichText(
        text: TextSpan(
          style: style.baseStyle,
          children: _buildTextSpans(document.children, style),
        ),
        overflow: style.textOverflow,
        maxLines: style.maxLines,
        softWrap: style.softWrap,
      ),
    ];
  }

  static List<TextSpan> _buildTextSpans(List<MarkdownNode> nodes, MarkdownStyle style) {
    final spans = <TextSpan>[];
    
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      if (node is TextNode) {
        TextStyle textStyle = style.baseStyle;
        
        if (node.isBold) {
          textStyle = textStyle.merge(style.bold);
        }
        if (node.isItalic) {
          textStyle = textStyle.merge(style.italic);
        }
        if (node.isCode) {
          textStyle = textStyle.merge(style.code);
        }
        
        spans.add(TextSpan(
          text: node.text,
          style: textStyle,
        ));
      } else if (node is HeaderNode) {
        final headerStyle = style.getHeaderStyle(node.level);
        spans.addAll([
          TextSpan(text: '\n', style: style.baseStyle), // Line break before header
          ..._buildTextSpans(node.children, style.copyWith(baseStyle: headerStyle)),
          TextSpan(text: '\n', style: style.baseStyle), // Line break after header
        ]);
      } else if (node is ListItemNode) {
        spans.addAll([
          TextSpan(text: '\n• ', style: style.listItem), // Bullet point
          ..._buildTextSpans(node.children, style),
        ]);
      } else if (node is ParagraphNode) {
        spans.addAll(_buildTextSpans(node.children, style));
        if (i < nodes.length - 1) {
          spans.add(const TextSpan(text: '\n'));
        }
      } else if (node is LineBreakNode) {
        spans.add(const TextSpan(text: '\n'));
      } else {
        // Handle other node types by processing their children
        spans.addAll(_buildTextSpans(node.children, style));
      }
    }
    
    return spans;
  }
}