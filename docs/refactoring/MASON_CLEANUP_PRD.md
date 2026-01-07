# Mason Auto-Cleanup - Product Requirements Document

## Overview
This document outlines the plan to implement automatic cleanup of Mason packages that are not listed in the `ensure_installed` configuration. The goal is to maintain a clean, minimal Mason installation with only the explicitly required tools.

## Current State Analysis
- **Mason packages directory**: `~/.local/share/nvim/mason/packages/`
- **Current packages installed**: 13 packages (azure-pipelines-language-server, bash-language-server, dockerfile-language-server, helm-ls, lua-language-server, marksman, prettier, prettierd, pyright, ruff, rust-analyzer, shfmt, terraform-ls)
- **Defined in ensure_installed**: 9 LSP servers (bashls, lua_ls, rust_analyzer, dockerls, terraformls, azure_pipelines_ls, pyright, marksman, helm_ls)
- **Orphaned packages**: prettier, prettierd, ruff, shfmt (not in ensure_installed list)

## Problem Statement
Mason's `ensure_installed` option only ensures packages are installed but does not remove packages that are no longer listed. This leads to:
1. **Package bloat** - unused tools accumulating over time
2. **Inconsistent environments** - different setups on different machines
3. **Maintenance overhead** - manual cleanup required

## Goals
1. **Automatic cleanup** - Remove packages not in `ensure_installed` list
2. **Safe operation** - Avoid removing critical system dependencies
3. **User control** - Option to enable/disable auto-cleanup
4. **Logging** - Clear visibility of what gets removed

## Implementation Strategy

### Approach 1: Mason Post-Setup Hook
**Method**: Add cleanup logic after mason-lspconfig setup
**Pros**: Simple, integrated with existing flow
**Cons**: Runs on every Neovim startup

### Approach 2: Custom Mason Command
**Method**: Create `:MasonCleanup` command for manual execution
**Pros**: User-controlled, safe, on-demand
**Cons**: Requires manual execution

### Approach 3: Startup Check with Throttling
**Method**: Auto-cleanup with daily/weekly throttling
**Pros**: Automatic but not excessive
**Cons**: More complex implementation

## Recommended Approach: Approach 2 (Custom Command)

### Implementation Plan

#### Phase 1: Package Discovery
- **Step 1.1**: Read current `ensure_installed` list from configuration
- **Step 1.2**: Scan Mason packages directory for installed packages
- **Step 1.3**: Compare lists to identify orphaned packages
- **Step 1.4**: Filter out system-critical packages (if any)

#### Phase 2: Safe Removal Logic
- **Step 2.1**: Create backup/dry-run mode to show what would be removed
- **Step 2.2**: Implement actual removal using Mason's uninstall API
- **Step 2.3**: Add confirmation prompts for safety
- **Step 2.4**: Handle removal errors gracefully

#### Phase 3: Command Integration
- **Step 3.1**: Create `:MasonCleanup` user command
- **Step 3.2**: Add `--dry-run` flag for preview mode
- **Step 3.3**: Add `--force` flag to skip confirmations
- **Step 3.4**: Integrate with which-key for discoverability

#### Phase 4: Enhanced Features
- **Step 4.1**: Add keybinding (`<Leader>mc` for Mason Cleanup)
- **Step 4.2**: Show cleanup summary with package sizes
- **Step 4.3**: Optional: Add to startup with user preference
- **Step 4.4**: Document usage in CLAUDE.md

## Technical Implementation

### Core Function Structure
```lua
local function mason_cleanup(opts)
    opts = opts or {}
    local dry_run = opts.dry_run or false
    local force = opts.force or false
    
    -- Get ensure_installed list
    local ensure_installed = get_ensure_installed_packages()
    
    -- Get currently installed packages
    local installed_packages = mason.get_installed_packages()
    
    -- Find orphaned packages
    local orphaned = find_orphaned_packages(ensure_installed, installed_packages)
    
    -- Handle removal
    if dry_run then
        show_cleanup_preview(orphaned)
    else
        remove_packages(orphaned, force)
    end
end
```

### Command Registration
```lua
vim.api.nvim_create_user_command('MasonCleanup', function(opts)
    local args = vim.split(opts.args, ' ')
    local dry_run = vim.tbl_contains(args, '--dry-run')
    local force = vim.tbl_contains(args, '--force')
    
    mason_cleanup({ dry_run = dry_run, force = force })
end, {
    nargs = '*',
    desc = 'Clean up Mason packages not in ensure_installed',
    complete = function()
        return { '--dry-run', '--force' }
    end
})
```

## Files to Modify/Create
1. `lua/config/mason-cleanup.lua` - New module for cleanup functionality
2. `lua/config/lsp-config.lua` - Integration point for command registration
3. `lua/config/keymap.lua` - Add keybinding for cleanup command
4. `CLAUDE.md` - Document new cleanup functionality

## Safety Considerations
- **Confirmation prompts** for actual removals
- **Dry-run mode** as default behavior
- **Error handling** for failed removals
- **Backup recommendations** before first use
- **LSP server mapping** - ensure package names match server names correctly

## Success Criteria
- [x] `:MasonCleanup --dry-run` shows orphaned packages without removing
- [x] `:MasonCleanup` removes orphaned packages with confirmation
- [x] `:MasonCleanup --force` removes without confirmation
- [x] Keybinding `<Leader>mc` accessible and documented
- [x] No critical packages accidentally removed
- [x] Clear feedback on what was removed and why

## Risk Assessment
- **Low Risk**: Only removes packages not in ensure_installed
- **Medium Risk**: User might accidentally remove needed packages
- **Low Risk**: Packages can be easily reinstalled via Mason

## Dependencies
- **Mason.nvim**: Core package management
- **mason-lspconfig.nvim**: LSP server integration
- **Neovim 0.8+**: For user command completion

## Testing Strategy
- Test with various ensure_installed configurations
- Verify dry-run mode accuracy
- Test removal and reinstallation cycle
- Validate no critical packages removed

## Future Enhancements
- **Auto-cleanup option**: Enable/disable in configuration
- **Package size reporting**: Show disk space reclaimed
- **Selective cleanup**: Choose specific packages to remove
- **Cleanup scheduling**: Weekly/monthly automatic cleanup

---

## Implementation Summary

### ✅ Phase 1: Package Discovery (COMPLETED)
- **Created `mason-cleanup.lua`** with package detection logic
- **LSP server to Mason package mapping** implemented
- **Orphaned package identification** working correctly
- **Current orphaned packages**: prettier, prettierd, ruff, shfmt

### ✅ Phase 2: Safe Removal Logic (COMPLETED)
- **Dry-run mode** shows preview without removing packages
- **Confirmation prompts** for actual removals
- **Error handling** for failed removals with detailed feedback
- **Success/failure reporting** with clear status indicators

### ✅ Phase 3: Command Integration (COMPLETED)
- **`:MasonCleanup` command** registered with completion
- **`--dry-run` flag** for safe preview mode
- **`--force` flag** to skip confirmation prompts
- **Integrated with lsp-config.lua** for automatic setup

### ✅ Phase 4: Enhanced Features (COMPLETED)
- **`<Leader>mc` keybinding** for quick dry-run access
- **CLAUDE.md documentation** updated with commands and usage
- **Troubleshooting section** added for Mason package management
- **User-friendly interface** with colored output and clear messaging

## Files Created/Modified
1. ✅ `lua/config/mason-cleanup.lua` - Main cleanup functionality
2. ✅ `lua/config/lsp-config.lua` - Integration point for setup
3. ✅ `lua/config/keymap.lua` - Added `<Leader>mc` keybinding
4. ✅ `CLAUDE.md` - Updated documentation with commands and troubleshooting

---

**Document Status**: ✅ COMPLETED
**Last Updated**: 2025-01-11
**Implementation**: All 4 phases completed successfully