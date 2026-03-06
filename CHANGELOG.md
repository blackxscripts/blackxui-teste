# CHANGELOG

All notable changes to BLACKX will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-01-09

### Changed

#### Project Structure Refactoring
- **Eliminated File Redundancy**: Removed duplicate files from root directory (old init.lua, Theme.lua, Assets.lua, usage_example.lua)
- **Removed Old Directories**: Deleted redundant Core/, Components/, Services/ folders from root level
- **Single Source of Truth**: All code now flows exclusively through `/src/init.lua`
- **Cleaned Documentation**: Removed internal meta-documentation (COMECE_AQUI.md, PROJECT_SUMMARY.md, QA_CHECKLIST.md, etc.)
- **Professional GitHub Structure**: Simplified to: src/, docs/, examples/, and essential GitHub files only

#### Documentation Improvements
- **README.md Refactored**: Reduced from 262 lines to 113 lines (professional GitHub standard)
- **Consolidated Information**: Removed redundant sections, maintained all essential details
- **Clear API Summary**: Quick reference with signature-style method listing
- **Better Navigation**: Links to detailed docs/ files instead of inline documentation bloat

#### Quality Improvements
- **Version Management**: Centralized version control in src/init.lua
- **Architecture Clarity**: Documented 3-layer system (Core→Components→Services)
- **Maintenance Ready**: Project now meets senior-level production standards

### Fixed
- Removed confusion from duplicate file locations
- Eliminated broken require() paths from old root modules
- Simplified developer onboarding through clean structure

### Removed
- Duplicate root files (init.lua, Theme.lua, Assets.lua, usage_example.lua)
- Redundant directories (Core/, Components/, Services/ at root)
- Unnecessary internal documentation (7+ meta-files)
- HTML visual index (non-essential for GitHub)

## [1.0.0] - 2024-01-15

### Added

#### Core Features
- **Window System**: Main UI window with customizable title and logo
- **Three-Column Layout**: 
  - Left column: Tab navigation and component list
  - Center column: Console and command input bar
  - Right column: DEX Explorer and Properties (persistent, independent of tabs)
- **Tab System**: Create multiple tabs with independent component containers
- **Component Library**:
  - `Button` - Simple clickable button
  - `Toggle` - Boolean checkbox switch
  - `Slider` - Numeric range slider with min/max
  - `TextBox` - Text input with submit callback
  - `Section` - Labeled container for organizing components

#### Command System
- Integrated Infinite Yield command execution
- Whitelist-enforced command validation (speed, jump, fly, noclip, hop server)
- Special formatting for "speed X" command: displays Portuguese message
- Silent rejection of unauthorized commands
- Semicolon (`;`) prefix support for commands

#### Logging & Console
- Event-driven logging system with BindableEvent
- Color-coded log output:
  - `info` - White text
  - `success` - Green text
  - `warning` - Yellow text
  - `system` - Gray text
- Scrollable console with auto-scroll to latest messages
- Message history with 200 log limit
- Manual and automatic logging via `AddLog()`

#### DEX Integration
- Automatic Explorer and Properties loader
- 50/50 vertical split layout in right panel
- Persistent visibility (independent of tab switching)
- Safe module discovery with fallback search locations

#### Event Monitoring
- Backpack tracking (item pickups)
- LeaderStat change monitoring
- RemoteEvent listening with safe argument filtering
- Automatic logging of game state changes

#### Services
- `LogManager` - Centralized logging with history and event dispatch
- `InfiniteAdapter` - Whitelisted bridge to Infinite Yield's execCmd
- `ServerEventAdapter` - Wrapper for RemoteEvent/RemoteFunction communications

### Documentation
- **README.md** - Project overview, installation, quick start guide
- **API.md** - Complete function reference with examples
- **Architecture.md** - System design and module relationships
- **Integration.md** - DEX and Infinite Yield setup instructions
- **CHANGELOG.md** - This file

### Project Structure
- `src/` directory with organized subdirectories:
  - `Core/` - System modules (Window, Layout, Console, etc.)
  - `Components/` - UI element classes
  - `Services/` - Business logic and integrations
- `docs/` - Comprehensive documentation
- `examples/` - Usage demonstrations
- Root-level: README, LICENSE, .gitignore

### Theme System
- Centralized color palette in `Theme.lua`
- 10 customizable color variables
- Easy color adjustment for entire UI

### Assets System
- Icon asset ID storage
- Default logo asset
- GetIcon() helper function

## [Unreleased]

### Planned Features
- [ ] Additional component types (ColorPicker, Dropdown, etc.)
- [ ] More theme presets (dark, light, neon, etc.)
- [ ] Keyboard shortcut system
- [ ] Drag-and-drop window positioning
- [ ] Window resizing
- [ ] Tab reordering
- [ ] Component event history viewer
- [ ] Advanced command parsing with arguments
- [ ] Command history and autocomplete
- [ ] Multi-language support
- [ ] Animation system for UI transitions
- [ ] Export/import configuration
- [ ] Plugin system for extending BLACKX

### Known Limitations
- Currently Roblox-specific (Lua 5.1)
- Requires Infinite Yield with execCmd function
- DEX modules must be available at runtime
- Single-window support (no multiple windows)
- No built-in anti-detection features

## Security & Safety

### Version 1.0.0 Security Notes
- All command execution wrapped in `pcall()` for error safety
- Command whitelist prevents arbitrary code execution
- No eval() or dynamic code generation for user input
- InfiniteAdapter validates all commands before execution
- Console logs are read-only (cannot modify game state)
- No external network calls (except Infinite Yield's optional updates)

---

## Installation Instructions by Version

### 1.0.0 Release
```lua
local BLACKX = require(script.Parent.src.init)
local window = BLACKX:CreateWindow({Title = "My Script"})
```

## Contributors

- Initial release team

## License

MIT License - See [LICENSE](LICENSE) for full details

---

For detailed usage instructions, see [README.md](README.md)

For API documentation, see [docs/API.md](docs/API.md)

For integration help, see [docs/Integration.md](docs/Integration.md)
