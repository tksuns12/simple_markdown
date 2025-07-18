import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'nodes.dart';
import 'styles.dart';

class RenderMarkdownParagraph extends RenderBox {
  RenderMarkdownParagraph({
    required TextPainter textPainter,
    required EdgeInsets padding,
  }) : _textPainter = textPainter, 
       _padding = padding;

  TextPainter _textPainter;
  EdgeInsets _padding;

  TextPainter get textPainter => _textPainter;
  set textPainter(TextPainter value) {
    if (_textPainter == value) return;
    _textPainter = value;
    markNeedsLayout();
  }

  EdgeInsets get padding => _padding;
  set padding(EdgeInsets value) {
    if (_padding == value) return;
    _padding = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final maxWidth = constraints.maxWidth - _padding.horizontal;
    _textPainter.layout(minWidth: 0, maxWidth: maxWidth);
    
    size = Size(
      constraints.maxWidth,
      _textPainter.height + _padding.vertical,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _textPainter.paint(
      context.canvas,
      offset + Offset(_padding.left, _padding.top),
    );
  }
}

class RenderMarkdownHeader extends RenderBox {
  RenderMarkdownHeader({
    required TextPainter textPainter,
    required EdgeInsets padding,
  }) : _textPainter = textPainter, _padding = padding;

  TextPainter _textPainter;
  EdgeInsets _padding;

  TextPainter get textPainter => _textPainter;
  set textPainter(TextPainter value) {
    if (_textPainter == value) return;
    _textPainter = value;
    markNeedsLayout();
  }

  EdgeInsets get padding => _padding;
  set padding(EdgeInsets value) {
    if (_padding == value) return;
    _padding = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final maxWidth = constraints.maxWidth - _padding.horizontal;
    _textPainter.layout(minWidth: 0, maxWidth: maxWidth);
    
    size = Size(
      constraints.maxWidth,
      _textPainter.height + _padding.vertical,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _textPainter.paint(
      context.canvas,
      offset + Offset(_padding.left, _padding.top),
    );
  }
}

class RenderMarkdownList extends RenderBox {
  RenderMarkdownList({
    required List<RenderBox> children,
    required EdgeInsets padding,
    required bool ordered,
  }) : _children = children, _padding = padding, _ordered = ordered;

  List<RenderBox> _children;
  EdgeInsets _padding;
  bool _ordered;

  List<RenderBox> get children => _children;
  set children(List<RenderBox> value) {
    if (_children == value) return;
    _children = value;
    markNeedsLayout();
  }

  EdgeInsets get padding => _padding;
  set padding(EdgeInsets value) {
    if (_padding == value) return;
    _padding = value;
    markNeedsLayout();
  }

  bool get ordered => _ordered;
  set ordered(bool value) {
    if (_ordered == value) return;
    _ordered = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    double totalHeight = _padding.top;
    final maxWidth = constraints.maxWidth - _padding.horizontal;
    
    for (final child in _children) {
      child.layout(
        BoxConstraints(maxWidth: maxWidth),
        parentUsesSize: true,
      );
      totalHeight += child.size.height;
    }
    
    totalHeight += _padding.bottom;
    size = Size(constraints.maxWidth, totalHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double currentY = offset.dy + _padding.top;
    
    for (int i = 0; i < _children.length; i++) {
      final child = _children[i];
      final childOffset = Offset(offset.dx + _padding.left, currentY);
      
      if (_ordered) {
        final numberPainter = TextPainter(
          text: TextSpan(
            text: '${i + 1}. ',
            style: const TextStyle(fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        );
        numberPainter.layout();
        numberPainter.paint(context.canvas, childOffset);
      } else {
        final bulletPainter = TextPainter(
          text: const TextSpan(
            text: '• ',
            style: TextStyle(fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        );
        bulletPainter.layout();
        bulletPainter.paint(context.canvas, childOffset);
      }
      
      context.paintChild(
        child,
        childOffset + const Offset(20, 0),
      );
      
      currentY += child.size.height;
    }
  }
}

class MarkdownRenderer {
  final MarkdownStyle style;

  MarkdownRenderer({required this.style});

  List<RenderBox> render(DocumentNode document) {
    final renderObjects = <RenderBox>[];
    
    for (final node in document.children) {
      final renderObject = _renderNode(node);
      if (renderObject != null) {
        renderObjects.add(renderObject);
      }
    }
    
    return renderObjects;
  }

  RenderBox? _renderNode(MarkdownNode node) {
    if (node is HeaderNode) {
      return _renderHeader(node);
    } else if (node is ParagraphNode) {
      return _renderParagraph(node);
    } else if (node is ListNode) {
      return _renderList(node);
    }
    
    return null;
  }

  RenderMarkdownHeader _renderHeader(HeaderNode node) {
    final textSpan = _buildTextSpan(node.children, style.getHeaderStyle(node.level));
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    
    return RenderMarkdownHeader(
      textPainter: textPainter,
      padding: style.headerPadding,
    );
  }

  RenderMarkdownParagraph _renderParagraph(ParagraphNode node) {
    final textSpan = _buildTextSpan(node.children, style.paragraphStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    
    return RenderMarkdownParagraph(
      textPainter: textPainter,
      padding: style.paragraphPadding,
    );
  }

  RenderMarkdownList _renderList(ListNode node) {
    final children = <RenderBox>[];
    
    for (final item in node.items) {
      final textSpan = _buildTextSpan(item.children, style.listItemStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      
      final renderObject = RenderMarkdownParagraph(
        textPainter: textPainter,
        padding: EdgeInsets.zero,
      );
      
      children.add(renderObject);
    }
    
    return RenderMarkdownList(
      children: children,
      padding: style.listPadding,
      ordered: node.ordered,
    );
  }

  TextSpan _buildTextSpan(List<MarkdownNode> nodes, TextStyle baseStyle) {
    final children = <TextSpan>[];
    
    for (final node in nodes) {
      if (node is TextNode) {
        TextStyle nodeStyle = baseStyle;
        
        if (node.bold) {
          nodeStyle = nodeStyle.merge(style.boldStyle);
        }
        if (node.italic) {
          nodeStyle = nodeStyle.merge(style.italicStyle);
        }
        if (node.code) {
          nodeStyle = nodeStyle.merge(style.codeStyle);
        }
        
        children.add(TextSpan(
          text: node.text,
          style: nodeStyle,
        ));
      }
    }
    
    return TextSpan(children: children);
  }
}