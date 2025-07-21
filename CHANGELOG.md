# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2024-12-20

### Added
- **Paragraph and Line Break Handling**
  - Introduced `ParagraphNode` to group consecutive lines of text.
  - Added `LineBreakNode` to preserve explicit line breaks from the source markdown.

### Changed
- **Parser Refactoring**
  - The parser now constructs a more structured AST with paragraphs and line breaks.
  - Improved logic to correctly handle single and multiple newlines.
- **Renderer Updates**
  - The renderer now correctly interprets `ParagraphNode` and `LineBreakNode`.
  - Paragraphs are rendered with appropriate spacing.

### Fixed
- Newline characters are now preserved in the final rendered output.
- Mixed content with inline formatting and newlines is handled correctly.

## [0.1.0] - 2024-12-19

### Added
- **Enhanced inline formatting support**
  - Bold text parsing with `**bold**` syntax
  - Italic text parsing with `*italic*` syntax
  - Inline code parsing with `` `code` `` syntax
  - Proper nesting and edge case handling for all formatting types
  - Mixed formatting support (e.g., `**bold and *italic* text**`)
- **Comprehensive parser improvements**
  - Robust inline text parsing with `_parseInlineText()` method
  - Empty line handling for cleaner output
  - Enhanced header parsing with inline formatting support
  - Improved list item parsing with inline formatting
  - Better error handling for unclosed formatting tags
- **Advanced renderer enhancements**
  - Complete node type support (TextNode, HeaderNode, ListItemNode)
  - Proper TextStyle merging for inline formatting
  - Line break handling around headers and list items
  - Bullet point rendering for list items
  - Recursive processing for nested node structures
- **Architecture optimizations**
  - Conditional rendering: single RichText widgets rendered directly
  - Overflow handling with Align widget to prevent expansion issues
  - Better integration with existing MarkdownStyle system
- **Comprehensive test suite**
  - 7 new parser tests covering all inline formatting scenarios
  - Mixed formatting test cases
  - Header and list item formatting tests
  - Edge case and error handling tests

### Changed
- **Parser logic** completely rewritten for better markdown compliance
- **Renderer architecture** enhanced to handle all node types properly
- **Widget rendering** optimized to avoid unnecessary Column wrappers
- **Style application** improved with proper TextStyle merging

### Fixed
- **RenderFlex overflow issues** resolved through architectural improvements
- **Missing inline formatting** now fully supported
- **Incomplete node rendering** fixed for headers and list items
- **Layout constraints** properly handled without external dependencies
- **Text styling** now correctly applies bold, italic, and code formatting

### Technical Details
- Enhanced parser supports complex inline formatting with proper precedence
- Renderer uses TextStyle.merge() for combining multiple formatting styles
- Conditional widget rendering eliminates unnecessary layout wrappers
- Comprehensive test coverage ensures reliability and backward compatibility
- All existing functionality preserved while adding significant new capabilities

## [0.0.2] - 2024-01-18

### Added
- **Comprehensive overflow handling system**
  - `TextOverflow` support (clip, ellipsis, fade, visible)
  - `maxLines` constraint for limiting text lines
  - `softWrap` control for text wrapping behavior
  - `BoxConstraints` support for widget-level size constraints
  - `MainAxisSize` and `CrossAxisAlignment` controls for Column layout
  - `shrinkWrap` property to control child widget wrapping
  - Widget-level overflow properties that override style-level settings
- **Interactive overflow demo** in example app
  - Live controls for all overflow parameters
  - Real-time preview of overflow behavior
  - Container size adjustments
  - Settings summary display
- **Comprehensive test coverage** for overflow functionality
  - Widget-level overflow tests
  - Style-level overflow tests
  - Constraint handling tests
  - Layout customization tests

### Changed
- **MarkdownStyle class** now includes overflow properties
- **MarkdownWidget class** now accepts overflow parameters
- **Example app** updated with new overflow demonstration tab
- **README.md** updated with overflow examples and v0.0.2 documentation

### Fixed
- **Analyzer warnings** removed unused overflow fields from low-level renderers
- **Infinite height constraints** properly handled in scrollable contexts
- **SoftWrap functionality** now works correctly with width constraints
- **Layout errors** resolved in overflow demo interface

### Technical Details
- Overflow handling implemented at the widget level using `RichText` properties
- `ConstrainedBox` used for applying size constraints with proper infinite height handling
- Low-level renderers kept simple and focused on core functionality
- Backward compatibility maintained - all existing code continues to work

## [0.0.1] - 2024-01-XX

### Added
- Initial release of Simple Markdown package
- **Core markdown parsing** functionality
  - Headers (H1-H6)
  - Paragraphs with inline formatting
  - Bold and italic text
  - Inline code
  - Ordered and unordered lists
- **Abstract Syntax Tree (AST)** representation
- **Low-level rendering** using Flutter's RenderObject system
- **High-level widget API** for easy integration
- **Customizable styling system**
- **Comprehensive test suite** with parser and widget tests
- **Example app** demonstrating all features
  - Live markdown editor
  - Sample markdown content
  - Style customization demos
  - Theme toggle (light/dark mode)
