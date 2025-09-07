# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Claude Code Documentation for Neovim Configuration

## Overview
A **simplified, modern Neovim configuration** built with Lua architecture. This configuration focuses on essential functionality with LSP for diagnostics, Copilot.lua for AI-powered completion, and Claude Code for AI assistance. The setup is clean, maintainable, and performance-optimized.

## Architecture and Configuration Flow

```
.config/nvim/
├── init.lua                    # Entry point: Lazy setup → settings → plugins → config
├── lazy-lock.json             # Plugin version lockfile
├── lua/
│   ├── settings.lua           # Core Neovim settings (leaders, display, backup dirs)
│   ├── config/
│   │   ├── init.lua          # Module loader: calls all config/*.lua files
│   │   ├── keymap.lua        # 24+ keybindings (telescope, LSP, buffers, AI)
│   │   ├── lsp-config.lua    # Manual LSP setup (9 servers, no auto-start)
│   │   ├── filetypes.lua     # YAML filetype detection (autocmds)
│   │   ├── mason-cleanup.lua # Custom Mason package cleanup functionality
│   │   ├── copilot-cmp.lua   # Copilot completion integration
│   │   ├── nvim-treesitter.lua # Syntax highlighting configuration
│   │   └── themes.lua        # Gruvbox theme setup
│   └── plugins/
│       └── init.lua          # Plugin definitions (15 essential, lazy-loaded)
└── tmp/                      # Neovim-managed directories
    ├── backup/, undo/, swap/ # File persistence locations
```

### Configuration Loading Order
1. `init.lua`: Auto-installs Lazy.nvim, enables loader
2. `settings.lua`: Basic Neovim options, leader keys, file management
3. `plugins/*.lua`: Plugin definitions and lazy-loading rules  
4. `config/*.lua`: Feature configurations after plugins load

### Key Architectural Decisions
- **Mason decoupling**: LSP servers installed via Mason but configured manually to prevent RPC errors
- **Filetype specialization**: YAML files get dedicated servers (azure_pipelines_ls, helm_ls) instead of yamlls  
- **Modular design**: Each feature in separate config file for maintainability

## Core Features

### Plugin Management
- **Lazy.nvim**: Modern plugin manager with lazy loading
- **Simplified setup**: No hostname-based conditional loading
- **Performance optimized**: Essential plugins only

### Essential Plugins (~15 total)
- **Core**: lazy.nvim, mini.nvim ecosystem
- **LSP**: neovim/nvim-lspconfig, mason.nvim, mason-lspconfig.nvim
- **Completion**: copilot.lua, copilot-cmp (replaces nvim-cmp)
- **Navigation**: telescope.nvim, nvim-treesitter
- **AI Assistant**: claudecode.nvim (official Claude Code plugin)
- **UI**: gruvbox.nvim, which-key.nvim, vim-visual-multi
- **Utils**: mini.comment, mini.files, mini.statusline, mini.tabline, mini.trailspace
- **Language**: vim-helm (for Helm templates)

### Language Server Support (9 servers)
- **Bash**: bashls
- **Lua**: lua_ls (with Neovim-specific configuration)
- **Rust**: rust_analyzer (with clippy integration)
- **Docker**: dockerls
- **Terraform**: terraformls
- **Azure Pipelines**: azure_pipelines_ls (specialized for .yml files)
- **Python**: pyright
- **Helm**: helm_ls (specialized for Helm templates and values)
- **Markdown**: markdownlint

**LSP Architecture**: Manual configuration with proper root directory detection. Mason is decoupled from LSP auto-start to prevent RPC URI errors. Each LSP server is configured manually in `lua/config/lsp-config.lua` with filetype-specific activation.

### AI-Powered Completion
- **Copilot.lua**: Primary completion engine
- **Tab-based**: Simple Tab to accept suggestions
- **Smart triggers**: Auto-trigger with debounce
- **YAML/Helm enabled**: Active for YAML and Helm template editing
- **File type aware**: Disabled for markdown, help files
- **Keybindings**: Meta keys for navigation, Ctrl to dismiss

### Claude Code Integration
- **Official plugin**: coder/claudecode.nvim
- **Auto-start**: Enabled by default
- **Comprehensive keybindings**: Full `<Leader>a*` family
- **Diff management**: Accept/deny code changes
- **Buffer integration**: Send files and selections

## Key Mappings

### Leader Keys
- **Leader**: `,` (comma)
- **Local Leader**: `\` (backslash)

### LSP & Development (4 bindings)
- `<Leader>ca`: Code actions
- `<Leader>d`: Show diagnostics in float
- `<Leader>n`: Next diagnostic
- `<Leader>p`: Previous diagnostic

### File Management - Telescope (9 bindings)
- `<Leader>ff`: Find files (includes hidden)
- `<Leader>fg`: Live grep (includes hidden)
- `<Leader>fb`: Show buffers
- `<Leader>fh`: Help tags
- `<Leader>fs`: LSP document symbols
- `<Leader>fd`: LSP definitions (go to definition)
- `<Leader>fk`: Find Kubernetes manifests (resources/)
- `<Leader>fv`: Find Helm values files (values*.yaml)
- `<Leader>fp`: Find Azure Pipeline files (*.yml)

### Buffer Management (5 bindings)
- `<Leader>w`: Write all buffers
- `<Leader>q`: Quit all
- `<Leader>#`: Switch to last buffer
- `<Leader>bn`: Next buffer
- `<Leader>bp`: Previous buffer

### Mason Package Management (1 binding)
- `<Leader>mc`: Mason cleanup (dry-run preview)

### Utilities (4 bindings)
- `<Leader>l`: Toggle line numbers
- `<C-b>`: Clear search highlights
- `<Leader>fr`: Format buffer (LSP formatting)
- `<Leader>tr`: Trim trailing spaces

### File Browser (1 binding)
- `<Leader>fm`: Mini.files browser

## YAML Workflow Optimization

### Specialized LSP Architecture
- **No yamlls**: Eliminated problematic universal YAML server
- **Dedicated servers**: Each YAML type gets its specialized LSP
- **Copilot completion**: AI-powered suggestions for all YAML types
- **Reliable detection**: Autocmd-based filetype assignment

### File Type Detection (Autocmd-based)
- **Azure Pipelines**: `*.yml` → `yaml.azure-pipelines` → `azure_pipelines_ls`
- **Kubernetes**: `*/resources/*.yaml` → `yaml.kubernetes` (no LSP, Treesitter + Copilot)
- **Helm Values**: `values*.yaml` → `yaml.helm-values` → `helm_ls`
- **Helm Templates**: `*/templates/*.yaml`, `*/templates/*.tpl` → `helm` → `helm_ls`

### Benefits
- **Error-free**: No RPC URI errors from yamlls
- **Fast performance**: Lightweight, specialized servers
- **Accurate completion**: Context-aware suggestions per YAML type
- **Maintainable**: Clean, simple configuration

### Claude Code - AI Assistant (8+ bindings)
- `<Leader>a`: AI/Claude Code group
- `<Leader>ac`: Toggle Claude
- `<Leader>af`: Focus Claude
- `<Leader>ar`: Resume Claude
- `<Leader>aC`: Continue Claude
- `<Leader>ab`: Add current buffer
- `<Leader>as`: Send selection to Claude (visual mode)
- `<Leader>aa`: Accept diff
- `<Leader>ad`: Deny diff

### Copilot Completion
- `<Tab>`: Accept copilot suggestion
- `<M-]>`: Next suggestion
- `<M-[>`: Previous suggestion
- `<C-]>`: Dismiss suggestion
- `<M-CR>`: Open copilot panel

## Code Formatting
- **LSP-based**: Uses `vim.lsp.buf.format()` for all formatting
- **Command**: `:Format` for convenience
- **Keybinding**: `<Leader>fr`
- **Languages**: All LSP-supported languages

## Session and Backup Management
- **Backup files**: `~/.config/nvim/tmp/backup/`
- **Undo files**: `~/.config/nvim/tmp/undo/`
- **Swap files**: `~/.config/nvim/tmp/swap/`
- **No automatic sessions**: Manual session management removed for simplicity

## Common Development Commands

### Plugin Management
- `:Lazy`: Open Lazy plugin manager UI
- `:Lazy sync`: Update all plugins
- `:Lazy clean`: Remove unused plugins
- `:Lazy restore`: Restore plugins from lazy-lock.json

### LSP and Language Servers
- `:Mason`: Open Mason UI to install/manage LSP servers
- `:MasonCleanup --dry-run`: Preview orphaned packages to remove
- `:MasonCleanup`: Remove orphaned packages (with confirmation)
- `:MasonCleanup --force`: Force remove without confirmation
- `:LspInfo`: Show active LSP clients and their status
- `:LspRestart`: Restart LSP clients
- `:LspLog`: View LSP client logs

### Code Formatting and Quality
- `:Format`: Format current buffer using LSP formatter
- `:checkhealth`: Run Neovim health checks
- `:TSUpdate`: Update Tree-sitter parsers

### AI Assistant Tools
- `:Copilot auth`: Authenticate GitHub Copilot
- `:Copilot status`: Check Copilot connection status
- `:ClaudeCode`: Toggle Claude Code interface
- `:ClaudeCodeFocus`: Focus Claude Code panel
- `:ClaudeCode --resume`: Resume previous Claude session
- `:ClaudeCode --continue`: Continue current conversation

### Configuration Maintenance
- Leader key: `,` (comma) - all custom mappings use this prefix
- `<Leader>mc`: Mason cleanup dry-run (preview orphaned packages)
- Directory structure follows lua/settings.lua → lua/config/ → lua/plugins/ pattern

## Getting Started

### Initial Setup
1. **Start Neovim**: Configuration auto-installs Lazy.nvim on first run
2. **Install plugins**: `:Lazy sync` (automatic on first launch)
3. **Install LSP servers**: `:Mason` then install required servers
4. **Authenticate Copilot**: `:Copilot auth` for AI completion
5. **Verify Claude Code**: Should auto-start, use `:ClaudeCode` to toggle

## Troubleshooting

### LSP Issues
- **Check servers**: `:LspInfo`
- **Check logs**: `:LspLog` 
- **Restart LSP**: `:LspRestart`
- **RPC URI Errors**: Resolved via proper root directory detection and separation of Mason auto-start from manual LSP configuration

### Copilot Issues
- **Authentication**: `:Copilot auth`
- **Status check**: `:Copilot status`
- **Node.js required**: Ensure Node.js is installed

### Plugin Issues
- **Update plugins**: `:Lazy sync`
- **Check health**: `:checkhealth`
- **Clean install**: `:Lazy clean` then `:Lazy sync`

### Mason Package Management
- **Clean orphaned packages**: `:MasonCleanup --dry-run` to preview, `:MasonCleanup` to remove
- **Reinstall removed package**: Use `:Mason` to browse and install
- **Force cleanup**: `:MasonCleanup --force` (skip confirmation)
- **Keybinding**: `<Leader>mc` for dry-run preview

## Performance Features
- **Lazy loading**: Most plugins load on-demand
- **Optimized startup**: Disabled default Neovim plugins
- **Clean configuration**: No complex conditional logic
- **Essential only**: Removed 40%+ of original plugins

## Customization Notes
- **Modular design**: Easy to modify individual components
- **No hostname dependencies**: Works consistently everywhere
- **Standard patterns**: Uses conventional Neovim/Lua practices
- **Well documented**: Clear, descriptive keybinding descriptions

## Migration from Previous Setup
If upgrading from the old complex configuration:
1. **Backup first**: The old setup had hostname-based features
2. **Copilot setup**: Replace nvim-cmp workflow with Copilot authentication
3. **Removed features**: Custom formatters, session auto-restore, hostname configs
4. **New workflow**: Tab-based completion, simplified LSP, unified configuration

## Recent Major Fixes

### RPC URI Error Resolution (2025-01-11)
- **Issue**: Persistent "Scheme is missing" RPC errors when opening YAML files
- **Root Cause**: Mason-lspconfig auto-start conflicting with manual LSP configuration + missing root directory detection
- **Solution**: Separated Mason from LSP auto-management and implemented proper root directory detection
- **Documentation**: Complete debugging process documented in `docs/debug/COMPLETE_SOLUTION.md`

---

**This configuration prioritizes simplicity, performance, and modern development workflows while maintaining all essential functionality.**