# Claude Code Documentation for Neovim Configuration

## Overview
This is a comprehensive Neovim configuration built with modern Lua architecture, organized into modular components. The configuration features plugin management via Lazy.nvim, LSP support, auto-completion, and various productivity enhancements.

## Structure
```
.config/nvim/
├── init.lua                    # Main entry point
├── lazy-lock.json             # Plugin version lock file
├── prettierrc                 # Prettier configuration
├── lua/
│   ├── settings.lua           # Core Neovim settings
│   ├── config/
│   │   ├── init.lua          # Configuration module loader
│   │   ├── keymap.lua        # Key mappings
│   │   ├── lsp-config.lua    # LSP server configurations
│   │   ├── nvim-cmp.lua      # Auto-completion setup
│   │   ├── nvim-treesitter.lua # Tree-sitter configuration
│   │   └── themes.lua        # Theme configuration
│   └── plugins/
│       ├── init.lua          # Plugin definitions and setup
│       ├── b_custom_filetypes.lua # Custom file type definitions
│       ├── b_formatter.lua   # Code formatting utilities
│       ├── b_session.lua     # Session management
│       ├── b_yank_mouse_restore.lua # Mouse and yank utilities
│       └── copilotchat.lua   # CopilotChat configuration
├── tests/
│   └── lsp_format.lua        # LSP formatting tests
└── tmp/
    ├── backup/               # Backup files directory
    ├── undo/                 # Undo files directory
    └── swap/                 # Swap files directory
```

## Key Features

### Plugin Management
- **Lazy.nvim**: Modern plugin manager with lazy loading
- **Mini.nvim**: Collection of minimal, independent plugins
- **Mason.nvim**: LSP server, formatter, and tool installer

### Core Plugins
- **Telescope**: Fuzzy finder and file picker
- **Treesitter**: Syntax highlighting and parsing
- **LSP**: Language Server Protocol support
- **nvim-cmp**: Auto-completion engine
- **Gruvbox**: Color scheme
- **Claude Code**: AI-powered coding assistant

### Language Support
Based on hostname, different LSP servers are configured:
- **farm-net**: Full development environment (Bash, Lua, Rust, Python, Docker, Terraform, YAML, Markdown)
- **neovide**: Similar to farm-net but without ruff
- **archtab**: Minimal setup (Bash, Lua, Rust)
- **012**: Web development (Lua, HTML, CSS, Vue)

## Key Mappings

### Leader Key
- Leader: `,`
- Local Leader: `\`

### Core Mappings
- `<Leader>w`: Write all buffers
- `<Leader>q`: Quit all
- `<Leader>#`: Switch to last buffer
- `<Leader>l`: Toggle line numbers
- `<C-b>`: Clear search highlights

### File Management (Telescope)
- `<Leader>ff`: Find files
- `<Leader>fg`: Live grep
- `<Leader>fb`: Show buffers
- `<Leader>fh`: Help tags
- `<Leader>fs`: LSP symbols
- `<Leader>fd`: LSP definitions
- `<Leader>fm`: Mini.files browser

### LSP & Diagnostics
- `<Leader>ca`: Code actions
- `<Leader>d`: Show diagnostics
- `<Leader>n`: Next diagnostic
- `<Leader>p`: Previous diagnostic

### Formatting
- `<Leader>fr`: Format buffer
- `<Leader>tr`: Trim trailing spaces
- `:Format`: Format current buffer

### Claude Code Integration
- `<Leader>ac`: Toggle Claude
- `<Leader>af`: Focus Claude
- `<Leader>ar`: Resume Claude
- `<Leader>aC`: Continue Claude
- `<Leader>ab`: Add current buffer
- `<Leader>as`: Send selection to Claude
- `<Leader>aa`: Accept diff
- `<Leader>ad`: Deny diff

### Sessions
- `<Leader>ss`: Save session

### Buffer Navigation
- `<Leader>bn`: Next buffer
- `<Leader>bp`: Previous buffer

## Custom Formatters

The configuration includes custom formatters for various file types:
- **Shell scripts**: `shfmt` with specific formatting options
- **JavaScript/YAML/Markdown**: `prettier` with custom configuration
- **Other languages**: Uses LSP formatting

## Environment-Specific Features

### Neovide Support
When running in Neovide, additional features are enabled:
- System clipboard integration
- Special key mappings for copy/paste
- Mouse support

### Hostname-based Configuration
Different configurations are loaded based on hostname:
- Different LSP servers
- Different formatters
- Specific plugin additions (e.g., Helm support for farm-net)

## Session Management
- Automatic session restoration when starting Neovim without files
- Manual session saving with `<Leader>ss`
- Sessions are saved as `.session.vim` in the current directory

## Backup and Undo
- Backup files: `~/.config/nvim/tmp/backup/`
- Undo files: `~/.config/nvim/tmp/undo/`
- Swap files: `~/.config/nvim/tmp/swap/`

## Development Notes

### LSP Configuration
The LSP setup (`lua/config/lsp-config.lua`) is highly customized:
- Different servers for different environments
- Custom diagnostic configuration
- Specific settings for each language server
- Kubernetes YAML schema support

### Auto-completion
- Trigger: `<C-n>` (manual)
- Navigation: `<Tab>` and `<S-Tab>`
- Sources: LSP, snippets, buffer, path
- No automatic completion (set to manual)

### Code Formatting
- Format on command (not on save)
- Custom formatters for specific file types
- Trim trailing spaces and empty lines

## Troubleshooting

### Common Commands
- `:Mason`: Open Mason installer
- `:Lazy`: Open Lazy plugin manager
- `:LspInfo`: Show LSP information
- `:Format`: Format current buffer
- `:ClaudeCode`: Toggle Claude Code

### File Types
Custom file types are defined in `lua/plugins/b_custom_filetypes.lua` for:
- Kubernetes YAML files
- Helm templates
- Various configuration files

### Performance
- Lazy loading for most plugins
- Disabled default Neovim plugins for better performance
- Syntax highlighting limited to 300 columns

## Claude Code Integration

This configuration includes the official Claude Code plugin with extensive key mappings:
- Full chat interface integration
- Diff management
- Buffer and visual selection support
- Resume and continue functionality
- Auto-start enabled via `vim.g.claudecode_auto_setup`

The configuration is designed to work seamlessly with Claude Code for AI-assisted development workflows.