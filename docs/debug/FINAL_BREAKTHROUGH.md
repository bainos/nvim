# Final Breakthrough - RPC Error Analysis

## Progress Made

### ✅ Lazy.nvim Checker Eliminated
- **Before**: Long stack trace including `lazy.nvim/lua/lazy/manage/git.lua`
- **After**: Short stack trace, only LSP client error
- **Conclusion**: Disabling lazy.nvim checker **partially fixed** the issue

### Current Error Pattern
- **Frequency**: Appears exactly twice per YAML file open
- **Error**: Pure LSP client initialization failure
- **Path**: "null" in URI scheme
- **Stack trace**: Much shorter, no lazy.nvim references

## Key Insight: Two LSP Servers Trying to Start

The error appearing **twice** suggests **two LSP servers** are attempting to start for the same YAML file, and both are receiving malformed root directories.

## Hypothesis: Automatic LSP Server Detection

Despite our configuration, something is auto-starting LSP servers with null root directories. Possible culprits:

1. **Mason auto-installation** triggering LSP servers
2. **Neovim's built-in LSP detection** for YAML files
3. **Multiple filetype triggers** causing duplicate starts

## Final Test: Complete LSP Disable

Let's test if ANY LSP server auto-starts by temporarily disabling ALL LSP functionality:

```lua
-- In lsp-config.lua - TEMPORARY TEST
function M.setup()
    -- COMPLETELY DISABLE ALL LSP
    vim.lsp.start_client = function() return nil end
    require('lspconfig').util.available_servers = function() return {} end
end
```

## If LSP Disable Fixes It

- **Confirms**: Issue is in LSP auto-start mechanism
- **Next step**: Identify which server is auto-starting
- **Strategy**: Re-enable servers one by one

## If LSP Disable Doesn't Fix It

- **Confirms**: Issue is outside LSP entirely
- **Possible sources**: Tree-sitter, other plugins, Neovim core
- **Strategy**: Minimal plugin configuration test

## The Mystery

Why does this **only happen with YAML files**? 

**Theory**: YAML files trigger multiple detection systems:
- Our custom filetype detection
- Built-in YAML detection
- Possibly tree-sitter YAML
- Mason registry checks

One of these is passing `null` as a file path to LSP initialization.

---

**Status**: Partially resolved (lazy.nvim checker eliminated)
**Next**: Complete LSP disable test to isolate the remaining source