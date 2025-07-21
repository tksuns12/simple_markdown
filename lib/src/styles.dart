import 'package:flutter/widgets.dart';
import 'nodes.dart';

@immutable
class MarkdownStyle {
  final TextStyle baseStyle;
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle bold;
  final TextStyle italic;
  final TextStyle code;
  final TextStyle listItem;
  final TextStyle paragraph;
  final EdgeInsets? paragraphPadding;
  final EdgeInsets? headerPadding;
  final TextOverflow textOverflow;
  final int? maxLines;
  final bool softWrap;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  const MarkdownStyle({
    this.baseStyle = const TextStyle(),
    TextStyle? h1Style,
    TextStyle? h2Style,
    TextStyle? h3Style,
    TextStyle? paragraphStyle,
    TextStyle? boldStyle,
    TextStyle? italicStyle,
    TextStyle? codeStyle,
    TextStyle? listItemStyle,
    this.paragraphPadding,
    this.headerPadding,
    this.textOverflow = TextOverflow.clip,
    this.maxLines,
    this.softWrap = true,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : h1 = h1Style ?? const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
       h2 = h2Style ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
       h3 = h3Style ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
       bold = boldStyle ?? const TextStyle(fontWeight: FontWeight.bold),
       italic = italicStyle ?? const TextStyle(fontStyle: FontStyle.italic),
       code = codeStyle ?? const TextStyle(fontFamily: 'monospace'),
       listItem = listItemStyle ?? const TextStyle(),
       paragraph = paragraphStyle ?? const TextStyle();

  TextStyle getTextStyle(MarkdownNode node) {
    if (node is HeaderNode) {
      return getHeaderStyle(node.level);
    }
    return baseStyle;
  }

  TextStyle getHeaderStyle(int level) {
    switch (level) {
      case 1: return h1;
      case 2: return h2;
      case 3: return h3;
      default: return baseStyle;
    }
  }

  MarkdownStyle copyWith({
    TextStyle? baseStyle,
    TextStyle? h1Style,
    TextStyle? h2Style,
    TextStyle? h3Style,
    TextStyle? boldStyle,
    TextStyle? italicStyle,
    TextStyle? codeStyle,
    TextStyle? listItemStyle,
    TextStyle? paragraphStyle,
    EdgeInsets? paragraphPadding,
    EdgeInsets? headerPadding,
    TextOverflow? textOverflow,
    int? maxLines,
    bool? softWrap,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
  }) {
    return MarkdownStyle(
      baseStyle: baseStyle ?? this.baseStyle,
      h1Style: h1Style ?? h1,
       h2Style: h2Style ?? h2,
       h3Style: h3Style ?? h3,
       boldStyle: boldStyle ?? bold,
       italicStyle: italicStyle ?? italic,
       codeStyle: codeStyle ?? code,
       listItemStyle: listItemStyle ?? listItem,
       paragraphStyle: paragraphStyle ?? paragraph,
       paragraphPadding: paragraphPadding ?? this.paragraphPadding,
       headerPadding: headerPadding ?? this.headerPadding,
       textOverflow: textOverflow ?? this.textOverflow,
       maxLines: maxLines ?? this.maxLines,
       softWrap: softWrap ?? this.softWrap,
       mainAxisSize: mainAxisSize ?? this.mainAxisSize,
       crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
    );
  }
}