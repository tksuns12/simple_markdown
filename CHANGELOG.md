# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
