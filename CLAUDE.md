# Claude Code Documentation for Neovim Configuration

## Overview
A **simplified, modern Neovim configuration** built with Lua architecture. This configuration focuses on essential functionality with LSP for diagnostics, Copilot.lua for AI-powered completion, and Claude Code for AI assistance. The setup is clean, maintainable, and performance-optimized.

## Architecture
```
.config/nvim/
├── init.lua                    # Main entry point
├── lazy-lock.json             # Plugin version lock file
├── lua/
│   ├── settings.lua           # Core Neovim settings
│   ├── config/
│   │   ├── init.lua          # Configuration module loader
│   │   ├── keymap.lua        # Key mappings (24 essential bindings)
│   │   ├── lsp-config.lua    # LSP server configurations (9 servers)
│   │   ├── copilot-cmp.lua   # Copilot completion setup
│   │   ├── nvim-treesitter.lua # Tree-sitter configuration
│   │   └── themes.lua        # Gruvbox theme configuration
│   └── plugins/
│       └── init.lua          # Plugin definitions (~15 essential plugins)
├── docs/
│   └── refactoring/          # Historical refactoring documentation
└── tmp/
    ├── backup/               # Backup files directory
    ├── undo/                 # Undo files directory
    └── swap/                 # Swap files directory
```

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
- **Azure Pipelines**: azure_pipelines_ls
- **Python**: pyright
- **YAML**: yamlls
- **Markdown**: marksman

### AI-Powered Completion
- **Copilot.lua**: Primary completion engine
- **Tab-based**: Simple Tab to accept suggestions
- **Smart triggers**: Auto-trigger with debounce
- **File type aware**: Disabled for yaml, markdown, help files
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

### File Management - Telescope (6 bindings)
- `<Leader>ff`: Find files (includes hidden)
- `<Leader>fg`: Live grep (includes hidden)
- `<Leader>fb`: Show buffers
- `<Leader>fh`: Help tags
- `<Leader>fs`: LSP document symbols
- `<Leader>fd`: LSP definitions (go to definition)

### Buffer Management (5 bindings)
- `<Leader>w`: Write all buffers
- `<Leader>q`: Quit all
- `<Leader>#`: Switch to last buffer
- `<Leader>bn`: Next buffer
- `<Leader>bp`: Previous buffer

### Utilities (4 bindings)
- `<Leader>l`: Toggle line numbers
- `<C-b>`: Clear search highlights
- `<Leader>fr`: Format buffer (LSP formatting)
- `<Leader>tr`: Trim trailing spaces

### File Browser (1 binding)
- `<Leader>fm`: Mini.files browser

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

## Getting Started

### First Launch
1. **Restart Neovim completely**
2. **Install plugins**: `:Lazy sync`
3. **Check LSP servers**: `:Mason`
4. **Authenticate Copilot**: `:Copilot auth`
5. **Verify Claude Code**: Should auto-start

### Essential Commands
- `:Lazy`: Plugin manager
- `:Mason`: LSP server manager
- `:LspInfo`: LSP server status
- `:Copilot status`: Copilot status
- `:Format`: Format current buffer
- `:ClaudeCode`: Toggle Claude Code

## Troubleshooting

### LSP Issues
- **Check servers**: `:LspInfo`
- **Check logs**: `:LspLog`
- **Restart LSP**: `:LspRestart`

### Copilot Issues
- **Authentication**: `:Copilot auth`
- **Status check**: `:Copilot status`
- **Node.js required**: Ensure Node.js is installed

### Plugin Issues
- **Update plugins**: `:Lazy sync`
- **Check health**: `:checkhealth`
- **Clean install**: `:Lazy clean` then `:Lazy sync`

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

---

**This configuration prioritizes simplicity, performance, and modern development workflows while maintaining all essential functionality.**