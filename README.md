# Simple Markdown

A Flutter package for parsing and rendering markdown using low-level rendering APIs.

## Features

- Parse markdown text into an Abstract Syntax Tree (AST)
- Render markdown using Flutter's low-level rendering system
- Support for common markdown elements:
  - Headers (H1-H6)
  - Paragraphs
  - Bold and italic text
  - Inline code
  - Ordered and unordered lists
- Customizable styling system
- Widget-based API for easy integration

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  simple_markdown: ^0.0.1
```

## Usage

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:simple_markdown/simple_markdown.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MarkdownWidget(
          data: '''
# Welcome to Simple Markdown

This is a **bold** text and this is *italic*.

Here's a list:
- Item 1
- Item 2
- Item 3

And an ordered list:
1. First item
2. Second item
3. Third item

You can also use `inline code`.
          ''',
        ),
      ),
    );
  }
}
```

### Custom Styling

```dart
MarkdownWidget(
  data: '# Custom Header\n\nThis is a custom paragraph.',
  style: MarkdownStyle(
    h1Style: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    ),
    paragraphStyle: TextStyle(
      fontSize: 16,
      color: Colors.grey[800],
    ),
    boldStyle: TextStyle(
      fontWeight: FontWeight.w900,
      color: Colors.red,
    ),
  ),
)
```

### Parser API

You can also use the parser directly:

```dart
final parser = MarkdownParser();
final document = parser.parse('# Hello\n\nWorld');

// Access the AST
for (final node in document.children) {
  if (node is HeaderNode) {
    print('Header level: ${node.level}');
  } else if (node is ParagraphNode) {
    print('Paragraph with ${node.children.length} children');
  }
}
```

## Supported Markdown Syntax

| Element | Syntax | Example |
|---------|--------|---------|
| Headers | `# ## ### #### ##### ######` | `# Header 1` |
| Bold | `**text**` | `**bold text**` |
| Italic | `*text*` | `*italic text*` |
| Code | `` `text` `` | `` `inline code` `` |
| Unordered List | `- * +` | `- List item` |
| Ordered List | `1. 2. 3.` | `1. First item` |

## Architecture

The package consists of several key components:

- **Parser**: Converts markdown text into an AST
- **Nodes**: Represent different markdown elements (headers, paragraphs, etc.)
- **Renderer**: Low-level rendering using Flutter's RenderObject system
- **Widgets**: High-level widget wrappers for easy integration
- **Styles**: Customizable styling system

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
