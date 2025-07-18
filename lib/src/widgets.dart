import 'package:flutter/material.dart';
import 'nodes.dart';
import 'parser.dart';
import 'renderer.dart';
import 'styles.dart';

class MarkdownWidget extends StatelessWidget {
  final String data;
  final MarkdownStyle? style;
  
  // Overflow handling properties
  final TextOverflow? textOverflow;
  final int? maxLines;
  final bool? softWrap;
  final bool shrinkWrap;
  final BoxConstraints? constraints;

  const MarkdownWidget({
    super.key,
    required this.data,
    this.style,
    this.textOverflow,
    this.maxLines,
    this.softWrap,
    this.shrinkWrap = true,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final parser = MarkdownParser();
    final document = parser.parse(data);
    final baseStyle = style ?? const MarkdownStyle();
    
    // Create effective style with widget-level overrides
    final effectiveStyle = baseStyle.copyWith(
      textOverflow: textOverflow ?? baseStyle.textOverflow,
      maxLines: maxLines ?? baseStyle.maxLines,
      softWrap: softWrap ?? baseStyle.softWrap,
    );
    
    Widget column = Column(
      mainAxisSize: effectiveStyle.mainAxisSize,
      crossAxisAlignment: effectiveStyle.crossAxisAlignment,
      children: shrinkWrap 
        ? _buildWidgets(document, effectiveStyle)
        : _buildWidgets(document, effectiveStyle).map((widget) => Expanded(child: widget)).toList(),
    );
    
    // Apply constraints if provided
    if (constraints != null) {
      column = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: constraints!.maxWidth,
          maxHeight: constraints!.maxHeight.isFinite ? constraints!.maxHeight : double.infinity,
        ),
        child: column,
      );
    }
    
    return column;
  }

  List<Widget> _buildWidgets(DocumentNode document, MarkdownStyle style) {
    final widgets = <Widget>[];
    
    for (final node in document.children) {
      final widget = _buildWidget(node, style);
      if (widget != null) {
        widgets.add(widget);
      }
    }
    
    return widgets;
  }

  Widget? _buildWidget(MarkdownNode node, MarkdownStyle style) {
    if (node is HeaderNode) {
      return _buildHeader(node, style);
    } else if (node is ParagraphNode) {
      return _buildParagraph(node, style);
    } else if (node is ListNode) {
      return _buildList(node, style);
    }
    
    return null;
  }

  Widget _buildHeader(HeaderNode node, MarkdownStyle style) {
    return Padding(
      padding: style.headerPadding,
      child: RichText(
        text: _buildTextSpan(node.children, style.getHeaderStyle(node.level), style),
        overflow: style.textOverflow,
        maxLines: style.maxLines,
        softWrap: style.softWrap,
      ),
    );
  }

  Widget _buildParagraph(ParagraphNode node, MarkdownStyle style) {
    return Padding(
      padding: style.paragraphPadding,
      child: RichText(
        text: _buildTextSpan(node.children, style.paragraphStyle, style),
        overflow: style.textOverflow,
        maxLines: style.maxLines,
        softWrap: style.softWrap,
      ),
    );
  }

  Widget _buildList(ListNode node, MarkdownStyle style) {
    return Padding(
      padding: style.listPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: node.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  child: Text(
                    node.ordered ? '${index + 1}.' : '•',
                    style: style.listItemStyle,
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: _buildTextSpan(item.children, style.listItemStyle, style),
                    overflow: style.textOverflow,
                    maxLines: style.maxLines,
                    softWrap: style.softWrap,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  TextSpan _buildTextSpan(List<MarkdownNode> nodes, TextStyle baseStyle, MarkdownStyle style) {
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

class MarkdownParagraphWidget extends LeafRenderObjectWidget {
  final TextPainter textPainter;
  final EdgeInsets padding;

  const MarkdownParagraphWidget({
    super.key,
    required this.textPainter,
    required this.padding,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMarkdownParagraph(
      textPainter: textPainter,
      padding: padding,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMarkdownParagraph renderObject) {
    renderObject
      ..textPainter = textPainter
      ..padding = padding;
  }
}

class MarkdownHeaderWidget extends LeafRenderObjectWidget {
  final TextPainter textPainter;
  final EdgeInsets padding;

  const MarkdownHeaderWidget({
    super.key,
    required this.textPainter,
    required this.padding,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMarkdownHeader(
      textPainter: textPainter,
      padding: padding,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMarkdownHeader renderObject) {
    renderObject
      ..textPainter = textPainter
      ..padding = padding;
  }
}

class MarkdownListWidget extends MultiChildRenderObjectWidget {
  final EdgeInsets padding;
  final bool ordered;

  const MarkdownListWidget({
    super.key,
    required this.padding,
    required this.ordered,
    required super.children,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMarkdownList(
      children: [],
      padding: padding,
      ordered: ordered,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMarkdownList renderObject) {
    renderObject
      ..padding = padding
      ..ordered = ordered;
  }
}