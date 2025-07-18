# Simple Markdown Demo App

A comprehensive demo application showcasing the features of the `simple_markdown` Flutter package.

## Features

This demo app includes three main sections:

### 1. Live Editor
- Real-time markdown editing with live preview
- Type markdown on the left, see the rendered result on the right
- Pre-populated with example content to get started

### 2. Samples
- Curated examples showing different markdown features
- Categories include:
  - Headers (H1-H6)
  - Text formatting (bold, italic, inline code)
  - Lists (ordered and unordered)
  - Mixed content examples
  - README-style documentation

### 3. Style Demo
- Interactive demonstration of custom styling
- Multiple preset styles to choose from:
  - Default
  - Large Headers
  - Colorful
  - Compact
  - Spacious
- Shows how the same markdown content looks with different styles

## Getting Started

1. Ensure you have Flutter installed
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to launch the app
4. Explore the three tabs to see different features

## Package Usage

This app demonstrates how to use the `simple_markdown` package:

```dart
import 'package:simple_markdown/simple_markdown.dart';

// Basic usage
MarkdownWidget(
  data: '# Hello **World**!',
)

// With custom styling
MarkdownWidget(
  data: '# Custom Header\n\nParagraph text.',
  style: MarkdownStyle(
    h1Style: TextStyle(fontSize: 40, color: Colors.blue),
    paragraphStyle: TextStyle(fontSize: 16),
  ),
)
```

## Supported Markdown Features

- Headers (H1-H6)
- Bold and italic text
- Inline code
- Ordered and unordered lists
- Mixed content
- Custom styling support
