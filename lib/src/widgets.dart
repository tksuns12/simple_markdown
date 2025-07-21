import 'package:flutter/widgets.dart';
import 'renderer.dart';
import 'styles.dart';
import 'parser.dart';

class MarkdownWidget extends StatelessWidget {
  final String data;
  final MarkdownStyle style;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final bool? softWrap;
  final BoxConstraints? constraints;

  const MarkdownWidget({
    super.key,
    required this.data,
    this.style = const MarkdownStyle(),
    this.textOverflow,
    this.maxLines,
    this.softWrap,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final document = MarkdownParser.parse(data);
    final effectiveStyle = style.copyWith(
      textOverflow: textOverflow ?? style.textOverflow,
      maxLines: maxLines ?? style.maxLines,
      softWrap: softWrap ?? style.softWrap,
    );
    
    final widgets = MarkdownRenderer.buildFromDocument(document, effectiveStyle);
    
    Widget child;
    if (widgets.length == 1) {
      // If there's only one widget (typically RichText), wrap it in Align
      // to prevent it from expanding to fill all available space
      child = Align(
        alignment: Alignment.topLeft,
        child: widgets.first,
      );
    } else {
      // Multiple widgets need Column layout
      child = Column(
        mainAxisSize: effectiveStyle.mainAxisSize,
        crossAxisAlignment: effectiveStyle.crossAxisAlignment,
        children: widgets,
      );
    }
    
    if (constraints != null) {
      child = ConstrainedBox(
        constraints: constraints!,
        child: child,
      );
    }
    
    return child;
  }
}

class MarkdownSliver extends StatelessWidget {
  final String data;
  final MarkdownStyle style;

  const MarkdownSliver({
    super.key,
    required this.data,
    this.style = const MarkdownStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: MarkdownWidget(data: data, style: style),
    );
  }
}