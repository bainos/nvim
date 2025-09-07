# DrumVim - Neovim Plugin Development Project

## Project Overview
A custom Neovim plugin developed with Lua, designed to extend Neovim functionality with modern development practices.

## Development Environment
- **Neovim Version**: v0.11.3 (API level 13)
- **Lua Runtime**: LuaJIT 2.1.1753364724
- **API Functions**: 179 available functions
- **Development Location**: `/home/bainos/.config/nvim/drumvim/`

## Plugin Architecture
Standard Neovim plugin structure:
```
drumvim/
├── CLAUDE.md              # Project documentation and development notes
├── plugin/                # Plugin entry points and commands
├── lua/
│   └── drumvim/          # Core plugin modules
│       ├── init.lua      # Main plugin initialization
│       ├── config.lua    # Configuration management
│       └── utils.lua     # Utility functions
├── doc/                  # Help documentation
└── README.md            # User-facing documentation
```

## Development Guidelines
- **Lua Standards**: Follow Neovim Lua best practices
- **API Usage**: Leverage `vim.api` for core functionality
- **Modular Design**: Separate concerns into focused modules
- **Error Handling**: Robust error checking and user feedback
- **Performance**: Lazy loading and efficient resource usage
- **Documentation**: Comprehensive help docs and code comments

## Core Features
DrumVim is a **drumtab editor plugin** for creating and editing drum tablature notation.

### Initial Features
- [ ] Drumtab file type detection and syntax highlighting
- [ ] Basic drumtab template generation (time signatures, kit setup)
- [ ] Simple pattern editing and manipulation
- [ ] Time signature and subdivision configuration

### Architecture Principles
1. **Keep It Simple**: Avoid complexity - split logic when it grows complex
2. **Modular Organization**: Separate files/folders for independent growth and bug isolation
3. **API-Style Communication**: Isolated areas with clean interfaces

### Drumtab Format
Based on glossary.md examples:
- Text-based ASCII notation for drum patterns
- Support for even rhythms (2, 4 subdivisions), ternary (3 subdivisions), and odd time signatures
- Standard kit pieces (HH, SD, BD, etc.) with hit symbols (x, o, -, g, f, r)

## Development Notes
- Plugin developed in session starting 2025-09-06
- Target: Modern Neovim plugin with Lua architecture
- Focus: Clean, maintainable, and performant code

## API Reference Access
- In-editor: `:help api`, `:help lua-guide`, `:help vim.api`
- Programmatic: `vim.inspect(vim.api)`, `vim.fn.getcompletion('nvim_', 'function')`
- Functions: 179 total API functions available (all `nvim_*` prefixed)

---
*Project initialized: 2025-09-06*