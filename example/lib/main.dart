import 'package:flutter/material.dart';
import 'package:simple_markdown/simple_markdown.dart';

void main() {
  runApp(const MarkdownDemoApp());
}

class MarkdownDemoApp extends StatefulWidget {
  const MarkdownDemoApp({super.key});

  @override
  State<MarkdownDemoApp> createState() => _MarkdownDemoAppState();
}

class _MarkdownDemoAppState extends State<MarkdownDemoApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Markdown Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: MarkdownDemoHome(onThemeToggle: _toggleTheme),
    );
  }
}

class MarkdownDemoHome extends StatefulWidget {
  final VoidCallback onThemeToggle;
  
  const MarkdownDemoHome({super.key, required this.onThemeToggle});

  @override
  State<MarkdownDemoHome> createState() => _MarkdownDemoHomeState();
}

class _MarkdownDemoHomeState extends State<MarkdownDemoHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Simple Markdown Demo'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: widget.onThemeToggle,
            tooltip: 'Toggle theme',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.edit), text: 'Live Editor'),
            Tab(icon: Icon(Icons.article), text: 'Samples'),
            Tab(icon: Icon(Icons.palette), text: 'Styles'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LiveEditorTab(),
          SamplesTab(),
          StyleDemoTab(),
        ],
      ),
    );
  }
}

class LiveEditorTab extends StatefulWidget {
  const LiveEditorTab({super.key});

  @override
  State<LiveEditorTab> createState() => _LiveEditorTabState();
}

class _LiveEditorTabState extends State<LiveEditorTab> {
  final TextEditingController _controller = TextEditingController();
  
  final String _initialText = '''# Welcome to Simple Markdown!

This is a **live editor** where you can type markdown and see it rendered in real-time.

## Features

- **Bold text** using `**text**`
- *Italic text* using `*text*`
- `Inline code` using backticks
- Headers from H1 to H6

### Lists

Unordered list:
- Item 1
- Item 2
- Item 3

Ordered list:
1. First item
2. Second item
3. Third item

Try editing this text to see the live preview!''';

  @override
  void initState() {
    super.initState();
    _controller.text = _initialText;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Markdown Input',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (value) {
                          setState(() {});
                        },
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: 'Type your markdown here...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 1,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Preview',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: MarkdownWidget(
                          data: _controller.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SamplesTab extends StatefulWidget {
  const SamplesTab({super.key});

  @override
  State<SamplesTab> createState() => _SamplesTabState();
}

class _SamplesTabState extends State<SamplesTab> {
  int _selectedSample = 0;

  final List<Map<String, String>> _samples = [
    {
      'title': 'Headers',
      'content': '''# Header 1
## Header 2  
### Header 3
#### Header 4
##### Header 5
###### Header 6

Regular paragraph text for comparison.'''
    },
    {
      'title': 'Text Formatting',
      'content': '''This is **bold text** and this is *italic text*.

You can also combine them: ***bold and italic***.

Here's some `inline code` in a sentence.

**Bold** and *italic* can be used together in the same paragraph.'''
    },
    {
      'title': 'Lists',
      'content': '''## Unordered Lists

- First item
- Second item
- Third item

Alternative syntax:
* Item A
* Item B
* Item C

## Ordered Lists

1. First numbered item
2. Second numbered item
3. Third numbered item

Another example:
1. Plan the project
2. Execute the plan
3. Review the results'''
    },
    {
      'title': 'Mixed Content',
      'content': '''# Project Documentation

## Overview
This project demonstrates **markdown rendering** with *various features*.

## Features
- Support for `inline code`
- **Bold** and *italic* text
- Multiple header levels
- Both ordered and unordered lists

## Installation
1. Add the package to your `pubspec.yaml`
2. Run `flutter pub get`
3. Import and use the `MarkdownWidget`

## Usage
Simply pass your markdown text to the widget:

```
MarkdownWidget(data: "# Hello World")
```

That's it! The widget will handle the rest.'''
    },
    {
      'title': 'README Example',
      'content': '''# Simple Markdown Package

A Flutter package for parsing and rendering markdown.

## Features

- ✅ Headers (H1-H6)
- ✅ **Bold** and *italic* text
- ✅ `Inline code`
- ✅ Lists (ordered and unordered)
- ✅ Custom styling support

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  simple_markdown: ^0.0.1
```

### Usage

```dart
import 'package:simple_markdown/simple_markdown.dart';

MarkdownWidget(
  data: "# Hello **World**!",
)
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.'''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Categories',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _samples.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_samples[index]['title']!),
                            selected: _selectedSample == index,
                            onTap: () {
                              setState(() {
                                _selectedSample = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _samples[_selectedSample]['title']!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: MarkdownWidget(
                          data: _samples[_selectedSample]['content']!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StyleDemoTab extends StatefulWidget {
  const StyleDemoTab({super.key});

  @override
  State<StyleDemoTab> createState() => _StyleDemoTabState();
}

class _StyleDemoTabState extends State<StyleDemoTab> {
  int _selectedStyle = 0;

  final String _demoContent = '''# Style Demo

This content shows how **different styles** affect the *markdown rendering*.

## Features
- Custom header sizes
- Different text colors
- Varied spacing
- Unique font weights

### Code Example
Here's some `inline code` with custom styling.

### Lists
1. First styled item
2. Second styled item
3. Third styled item

- Unordered item A
- Unordered item B
- Unordered item C''';

  final List<Map<String, dynamic>> _styles = [
    {
      'name': 'Default',
      'style': const MarkdownStyle(),
    },
    {
      'name': 'Theme-aware',
      'style': null, // Will be computed based on theme
    },
    {
      'name': 'Large Headers',
      'style': const MarkdownStyle(
        h1Style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        h2Style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        h3Style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    },
    {
      'name': 'Colorful',
      'style': const MarkdownStyle(
        h1Style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
        h2Style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
        h3Style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
        boldStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        italicStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.purple),
      ),
    },
    {
      'name': 'Compact',
      'style': const MarkdownStyle(
        h1Style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        h2Style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        h3Style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        paragraphStyle: TextStyle(fontSize: 12, height: 1.2),
        paragraphPadding: EdgeInsets.only(bottom: 8.0),
        headerPadding: EdgeInsets.only(bottom: 8.0, top: 4.0),
      ),
    },
    {
      'name': 'Spacious',
      'style': const MarkdownStyle(
        h1Style: TextStyle(fontSize: 36, fontWeight: FontWeight.w300),
        h2Style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
        h3Style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        paragraphStyle: TextStyle(fontSize: 16, height: 1.8),
        paragraphPadding: EdgeInsets.only(bottom: 24.0),
        headerPadding: EdgeInsets.only(bottom: 20.0, top: 16.0),
      ),
    },
  ];

  MarkdownStyle _getStyle(BuildContext context, int index) {
    final style = _styles[index]['style'];
    if (style == null) {
      // Theme-aware style
      final theme = Theme.of(context);
      final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
      
      return MarkdownStyle(
        h1Style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        h2Style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        h3Style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        paragraphStyle: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
        boldStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        italicStyle: TextStyle(
          fontStyle: FontStyle.italic,
          color: textColor,
        ),
        codeStyle: TextStyle(
          fontFamily: 'monospace',
          backgroundColor: theme.brightness == Brightness.light
              ? const Color(0xFFF5F5F5)
              : const Color(0xFF2D2D2D),
          color: textColor,
        ),
        listItemStyle: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
      );
    }
    return style;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Style Presets',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _styles.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_styles[index]['name']!),
                            selected: _selectedStyle == index,
                            onTap: () {
                              setState(() {
                                _selectedStyle = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preview: ${_styles[_selectedStyle]['name']}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: MarkdownWidget(
                          data: _demoContent,
                          style: _getStyle(context, _selectedStyle),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
