import 'package:flutter/material.dart';

class MarkdownStyle {
  final TextStyle h1Style;
  final TextStyle h2Style;
  final TextStyle h3Style;
  final TextStyle h4Style;
  final TextStyle h5Style;
  final TextStyle h6Style;
  final TextStyle paragraphStyle;
  final TextStyle boldStyle;
  final TextStyle italicStyle;
  final TextStyle codeStyle;
  final TextStyle listItemStyle;
  final EdgeInsets paragraphPadding;
  final EdgeInsets headerPadding;
  final EdgeInsets listPadding;

  const MarkdownStyle({
    this.h1Style = const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    this.h2Style = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    this.h3Style = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    this.h4Style = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    this.h5Style = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    this.h6Style = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    this.paragraphStyle = const TextStyle(
      fontSize: 14,
      height: 1.4,
    ),
    this.boldStyle = const TextStyle(
      fontWeight: FontWeight.bold,
    ),
    this.italicStyle = const TextStyle(
      fontStyle: FontStyle.italic,
    ),
    this.codeStyle = const TextStyle(
      fontFamily: 'monospace',
      backgroundColor: Color(0xFFF5F5F5),
    ),
    this.listItemStyle = const TextStyle(
      fontSize: 14,
      height: 1.4,
    ),
    this.paragraphPadding = const EdgeInsets.only(bottom: 16.0),
    this.headerPadding = const EdgeInsets.only(bottom: 16.0, top: 8.0),
    this.listPadding = const EdgeInsets.only(left: 16.0, bottom: 8.0),
  });

  TextStyle getHeaderStyle(int level) {
    switch (level) {
      case 1:
        return h1Style;
      case 2:
        return h2Style;
      case 3:
        return h3Style;
      case 4:
        return h4Style;
      case 5:
        return h5Style;
      case 6:
        return h6Style;
      default:
        return h6Style;
    }
  }

  MarkdownStyle copyWith({
    TextStyle? h1Style,
    TextStyle? h2Style,
    TextStyle? h3Style,
    TextStyle? h4Style,
    TextStyle? h5Style,
    TextStyle? h6Style,
    TextStyle? paragraphStyle,
    TextStyle? boldStyle,
    TextStyle? italicStyle,
    TextStyle? codeStyle,
    TextStyle? listItemStyle,
    EdgeInsets? paragraphPadding,
    EdgeInsets? headerPadding,
    EdgeInsets? listPadding,
  }) {
    return MarkdownStyle(
      h1Style: h1Style ?? this.h1Style,
      h2Style: h2Style ?? this.h2Style,
      h3Style: h3Style ?? this.h3Style,
      h4Style: h4Style ?? this.h4Style,
      h5Style: h5Style ?? this.h5Style,
      h6Style: h6Style ?? this.h6Style,
      paragraphStyle: paragraphStyle ?? this.paragraphStyle,
      boldStyle: boldStyle ?? this.boldStyle,
      italicStyle: italicStyle ?? this.italicStyle,
      codeStyle: codeStyle ?? this.codeStyle,
      listItemStyle: listItemStyle ?? this.listItemStyle,
      paragraphPadding: paragraphPadding ?? this.paragraphPadding,
      headerPadding: headerPadding ?? this.headerPadding,
      listPadding: listPadding ?? this.listPadding,
    );
  }
}