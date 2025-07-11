# Phase 5 Detailed Implementation Plan - Plugin Configuration Cleanup

## Overview
Clean up the plugin configuration by removing conditional loading, streamlining mini.nvim usage, maintaining essential functionality, and ensuring clean plugin setup.

## Step 5.1: Simplify lua/plugins/init.lua - remove conditional loading

### Current issues to address:
1. **Commented code blocks**: Remove all commented/unused plugin configurations
2. **Complex plugin setup**: Simplify setup_mini_plugins function
3. **Redundant configurations**: Clean up duplicate or unused settings
4. **Lazy loading optimization**: Review and optimize lazy loading settings

### Commented blocks to remove:
- Lines ~155-168: Commented claude-code plugin (old version)
- Lines ~169-176: Commented outline plugin
- Lines ~181-209: Commented noice/notify configurations
- Lines ~215-227: Commented treesitter matchup (redundant)
- Lines ~228-231: Commented notify setup

### Functions to simplify:
- `setup_mini_plugins()` function: Remove unused mini.surround setup call

### Expected result:
- Clean plugin list without commented code
- Streamlined configuration
- Reduced file size by ~50 lines

## Step 5.2: Keep only essential mini.nvim plugins

### Current mini.nvim plugins:
From analysis of plugins/init.lua:
```lua
{ 'echasnovski/mini.nvim', version = '*', lazy = false, },
{ 'echasnovski/mini.comment', version = '*', lazy = false, },
{ 'echasnovski/mini.files', version = '*', lazy = false, },
{ 'echasnovski/mini.statusline', version = '*', event = 'VeryLazy', },
{ 'echasnovski/mini.tabline', version = '*', lazy = false, },
{ 'echasnovski/mini.trailspace', version = '*', lazy = false, },
```

### Essential mini.nvim plugins to keep:
1. **mini.comment** - Essential for commenting
2. **mini.files** - File browser (used in keybindings)
3. **mini.statusline** - Status line
4. **mini.tabline** - Tab line
5. **mini.trailspace** - Trailing space management (used in keybindings)

### Plugins to potentially remove:
- **mini.nvim** base package - if not needed directly
- Check if all individual mini plugins are actually used

### Setup function cleanup:
In `setup_mini_plugins()` function:
- Remove `require 'mini.surround'.setup()` (not in plugin list)
- Keep only active plugin setups
- Ensure all setup calls match plugin list

### Expected result:
- Only essential mini.nvim plugins loaded
- Consistent plugin list and setup calls
- No unused mini.nvim dependencies

## Step 5.3: Maintain Claude Code configuration

### Current Claude Code config analysis:
- Plugin: `coder/claudecode.nvim`
- Dependencies: `folke/snacks.nvim`
- Configuration: `config = true`
- Extensive keybinding setup

### Verification needed:
1. **Plugin loading**: Ensure clean loading without conflicts
2. **Keybinding review**: Verify all Claude Code keybindings are functional
3. **Dependencies**: Ensure snacks.nvim is properly configured
4. **Auto-setup**: Check `vim.g.claudecode_auto_setup` configuration

### Current keybindings to verify:
- `<leader>ac`: Toggle Claude
- `<leader>af`: Focus Claude
- `<leader>ar`: Resume Claude
- `<leader>aC`: Continue Claude
- `<leader>ab`: Add current buffer
- `<leader>as`: Send to Claude
- `<leader>aa`: Accept diff
- `<leader>ad`: Deny diff

### Expected result:
- Claude Code fully functional
- All keybindings working
- Clean integration with rest of config

## Step 5.4: Clean up Telescope and Treesitter configs

### Telescope configuration cleanup:
Current config in plugins/init.lua:
```lua
{
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
    },
},
```

### Improvements needed:
1. Add proper configuration block
2. Optimize lazy loading
3. Clean up dependencies
4. Add essential telescope settings

### Treesitter configuration analysis:
- Currently configured in nvim-treesitter.lua (cleaned in previous phases)
- Plugin definition in plugins/init.lua has inline config
- May have duplicate configurations

### Treesitter cleanup tasks:
1. **Inline config review**: Check if config in plugins/init.lua is consistent with nvim-treesitter.lua
2. **Dependency cleanup**: Ensure andymass/vim-matchup dependency is properly configured
3. **Language list**: Verify ensure_installed languages are correct
4. **Remove duplicates**: Ensure no conflicting configurations

### Expected result:
- Clean Telescope configuration with proper settings
- Consistent Treesitter configuration
- No duplicate or conflicting configs
- Optimized plugin loading

## Implementation Order:
1. Remove all commented code blocks from plugins/init.lua
2. Clean up setup_mini_plugins function
3. Verify mini.nvim plugin list consistency
4. Review and verify Claude Code configuration
5. Add proper Telescope configuration
6. Verify Treesitter configuration consistency
7. Test all functionality

## Files to modify:
1. `lua/plugins/init.lua` - Major cleanup
2. Potentially verify `lua/config/nvim-treesitter.lua` consistency

## Risk Assessment:
- **Low risk**: Most changes are cleanup/removal
- **Medium risk**: Mini.nvim plugin changes could affect functionality
- **Low risk**: Telescope/Treesitter are mostly verification

## Success Criteria:
- No commented code blocks remain
- All mini.nvim plugins work correctly
- Claude Code fully functional
- Telescope works for file finding
- Treesitter syntax highlighting works
- Configuration loads without errors
- Reduced file complexity

## Expected Benefits:
- Cleaner, more maintainable configuration
- Faster loading (less unused code)
- Easier to understand plugin structure
- No confusion from commented alternatives
- Consistent configuration style

## Testing Checklist:
1. **Plugin loading**: No errors on startup
2. **Mini.nvim**: Test commenting, file browser, statusline, tabline, trailspace
3. **Claude Code**: Test all keybindings and functionality
4. **Telescope**: Test file finding, grep, buffers
5. **Treesitter**: Test syntax highlighting in various languages
6. **Overall**: Verify no regressions from previous phases