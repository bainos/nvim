# Agent Guidelines for Neovim Configuration

This document provides essential information for AI coding agents operating in this Neovim
configuration repository.

## Project Overview

A simplified, modern Neovim configuration built with Lua. Features LSP support, Avante AI
integration, Telescope navigation, Tree-sitter syntax, and the Gruvbox theme. Optimized for YAML
workflows (Kubernetes, Helm, Azure Pipelines) with specialized LSP servers.

## Build, Test, and Lint Commands

### Neovim Operations

```bash
# Launch Neovim (automatic plugin installation on first run)
nvim

# Install/update plugins
nvim --headless "+Lazy! sync" +qa

# Check health
nvim --headless "+checkhealth" +qa

# Update Tree-sitter parsers
nvim --headless "+TSUpdate" +qa
```

### Linting

```bash
# Lint Markdown files (100-character line limit)
markdownlint-cli2 "**/*.md"

# Lint specific Markdown file
markdownlint-cli2 AGENTS.md

# Format Markdown files with Prettier (100-character wrap)
prettier --write "**/*.md"
```

### Mason Package Management

```bash
# Inside Neovim:
:Mason                    # Open Mason UI to manage LSP servers
:MasonInstall <package>   # Install a specific package
:MasonUninstall <package> # Remove a package
:MasonCleanup --dry-run   # Preview orphaned packages
:MasonCleanup             # Remove orphaned packages (with confirmation)
:MasonCleanup --force     # Remove without confirmation
```

### Git Operations

```bash
# Standard workflow
git status
git add .
git commit -m "descriptive message"
git push

# Check commit history
git log --oneline -10
```

## Code Style Guidelines

### Lua Style

#### General Formatting

- **Indentation**: 4 spaces (never tabs)
- **Line length**: 120 characters maximum
- **Quote style**: Single quotes (`'string'`) preferred
- **End of line**: LF (Unix-style)
- **Final newline**: Always insert
- **Trailing whitespace**: Remove (use `:lua MiniTrailspace.trim()`)

#### Naming Conventions

- **Variables/Functions**: `snake_case`
- **Local functions**: `snake_case`
- **Constants**: `UPPER_SNAKE_CASE` or `snake_case`
- **Module pattern**: Always use `local M = {}` with `return M`

#### Module Structure

```lua
local M = {}

function M.setup()
    -- Configuration logic here
end

return M
```

#### Function Definitions

```lua
-- Preferred: align function parameters
function M.long_function_name(param1, param2,
                              param3, param4)
    -- Function body
end

-- Remove parentheses for single-arg function calls when unambiguous
require 'module'.setup()  -- NOT require('module').setup()
```

#### Tables

```lua
-- Keep space between table and brackets
local t = { 1, 2, 3 }

-- Multi-line tables: always trailing separator
local config = {
    key1 = 'value1',
    key2 = 'value2',
    key3 = {
        nested = true,
    },
}

-- No table field separators (commas/semicolons) when not needed
local simple = {
    first = 1
    second = 2
}
```

#### Comments

```lua
-- Single-line comments with space after --
-- Use descriptive comments for non-obvious logic

--[[
Multi-line comments for complex explanations
or documentation blocks
]]
```

#### Diagnostic Suppressions

```lua
-- Use when necessary for valid code that triggers warnings
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)
```

### Markdown Style

- **Line length**: 100 characters (enforced by markdownlint and Prettier)
- **Headers**: ATX-style (`# ## ###`)
- **Lists**: Dash style (`-` for unordered lists)
- **List indentation**: 2 spaces
- **Code blocks**: Always specify language (```lua, ```bash, etc.)
- **Blank lines**: Surround headers with blank lines
- **Emphasis**: Use standard Markdown (`**bold**`, `*italic*`)

## Architecture Patterns

### Plugin Loading

- Use `lazy.nvim` for plugin management
- Lazy load plugins when possible (`lazy = true`, `event = 'VeryLazy'`)
- Configure plugins inline or in separate config files

### Configuration Module Pattern

```lua
-- lua/config/init.lua loads all configuration modules
function M.setup()
    require 'config.themes'.setup()
    require 'config.nvim-treesitter'.setup()
    require 'config.lsp-installer'.setup()
    require 'config.keymap'.setup()
end
```

### Keymap Definitions

```lua
vim.keymap.set('n', '<Leader>key', ':command<cr>', {
    noremap = true,
    silent = true,
    desc = 'clear description',
})
```

## Error Handling

### LSP Configuration

- Never auto-start LSP servers via Mason (causes RPC URI conflicts)
- Use Mason only for installation, not configuration
- Implement proper root directory detection for LSP servers
- Defer Mason auto-install with `vim.defer_fn()` to avoid startup conflicts

### Common Pitfalls

- Avoid mixing tabs and spaces (always use spaces)
- Don't use hostname-based conditional loading (removed for simplicity)
- Don't create complex nested configurations
- Test changes in a clean Neovim instance (`:checkhealth`)

## AWS Credentials for Avante.nvim

Avante.nvim uses AWS Bedrock for AI features. Credentials are managed automatically via
`lua/config/aws-credentials.lua`:

### How It Works

- **Auto-fetches** credentials from AWS CLI on first startup
- **Caches** credentials in `~/.config/nvim/aws-auth.json` (600 permissions)
- **Auto-refreshes** 5 minutes before expiration
- **Zero impact** on shell environment (no exported AWS variables)

### Environment Variables

- `AWS_PROFILE`: AWS profile to use (default: `default`)
- `AWS_REGION` or `AWS_DEFAULT_REGION`: AWS region (default: `us-east-1`)

### Manual Refresh (Optional)

To force refresh credentials, add to `lua/config/keymap.lua`:

```lua
vim.api.nvim_create_user_command('AwsRefresh', function()
    if require('config.aws-credentials').refresh() then
        vim.notify('AWS credentials refreshed', vim.log.levels.INFO)
    end
end, { desc = 'Refresh AWS credentials' })
```

### Troubleshooting

- Check cache exists: `ls -la ~/.config/nvim/aws-auth.json`
- Test AWS CLI: `aws configure export-credentials --profile default --format process`
- Manual refresh: Call `require('config.aws-credentials').refresh()` in Neovim

## File Organization

```
.config/nvim/
├── init.lua                      # Entry point
├── lua/
│   ├── settings.lua             # Core Neovim settings
│   ├── config/
│   │   ├── init.lua            # Config loader
│   │   ├── aws-credentials.lua # AWS credentials caching
│   │   ├── keymap.lua          # Keybindings
│   │   ├── lsp-installer.lua   # LSP installation (Mason)
│   │   ├── nvim-treesitter.lua # Tree-sitter config
│   │   └── themes.lua          # Theme setup
│   └── plugins/
│       └── init.lua            # Plugin definitions
├── docs/                        # Documentation
├── tmp/                         # Backup/undo/swap files
├── aws-auth.json               # Cached AWS credentials (gitignored)
└── lazy-lock.json              # Plugin version lock
```

## Key Features to Preserve

1. **Modular architecture**: Each config aspect in separate files
2. **Lazy loading**: Performance-optimized plugin loading
3. **YAML workflow**: Specialized LSP and keybindings for YAML types
4. **AI integration**: Avante.nvim with AWS Bedrock Claude
5. **Minimalist approach**: Only essential plugins (~10-15 total)

## Making Changes

1. **Read existing code**: Always check current implementation before modifying
2. **Test incrementally**: Restart Neovim to verify changes
3. **Follow patterns**: Match existing code style and architecture
4. **Document changes**: Update CLAUDE.md if architecture changes significantly
5. **No breaking changes**: Maintain compatibility with existing keybindings and workflows

## Common Commands Reference

| Command           | Description                     |
| ----------------- | ------------------------------- |
| `:Lazy`           | Plugin manager UI               |
| `:Mason`          | LSP server manager              |
| `:LspInfo`        | Check LSP server status         |
| `:LspRestart`     | Restart LSP servers             |
| `:TSUpdate`       | Update Tree-sitter parsers      |
| `:Format`         | Format current buffer (LSP)     |
| `:checkhealth`    | Neovim health check             |
| `<Leader>mc`      | Mason cleanup (dry-run preview) |
| `<Leader>tr`      | Trim trailing spaces            |
| `<Leader>fm`      | Open file browser (mini.files)  |
| `<Leader>ff`      | Find files (Telescope)          |
| `<Leader>fg`      | Live grep (Telescope)           |
| `<Leader>cc`      | Ask Avante AI                   |
| `<Leader>ce`      | Edit with Avante AI             |

---

**Priority**: Maintain simplicity, performance, and the modular Lua architecture.
