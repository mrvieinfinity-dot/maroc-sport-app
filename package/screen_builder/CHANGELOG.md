# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-01-16

### Changed
- **CMS Evolution**: Screen Builder now operates as a full CMS model
- Everything defined in JSON: pages, navigation, reusable components
- Host no longer codes internal logic, only declares jsonPath, homePage, global options
- New ScreenBuilderConfig with navigationFile and homePage
- New ScreenBuilderPage widget that auto-loads home page and applies navigation
- JSON pages use component/children tree structure
- JSON navigation defines bottom navigation bar
- Added appbar, spacer, screen components

### Added
- ScreenBuilderPage widget
- JSON-based navigation system
- Tree-structured page definitions
- Auto-loading of pages from JSON files

## [1.0.0] - 2026-01-15

### Added
- Initial release of screen_builder package
- Component registry system
- Action engine
- Event bus
- Token resolver
- Navigation adapter
- API services