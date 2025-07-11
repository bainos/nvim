# Phase 2 Detailed Implementation Plan

## Step 2.1: Remove hostname-based logic from all files

### Files to modify:
1. `lua/config/lsp-config.lua`
   - Remove `hostname` variable and string.find checks
   - Keep only farm-net LSP servers list
   - Remove conditional server additions
   - Clean up lsp_servers array to be static

2. `lua/plugins/init.lua`
   - Remove hostname detection calls
   - Remove helm plugin conditional loading (lines 147-149)
   - Remove Flutter/Dart conditional loading (lines 155-162)
   - Keep vim-helm unconditionally (was in farm-net)
   - Remove neovide conditionals

3. `lua/plugins/b_formatter.lua`
   - Remove hostname detection
   - Keep only farm-net formatters (shfmt, prettier)
   - Remove conditional formatter additions
   - Make formatters list static

### Expected changes:
- Reduce lsp-config.lua by ~30 lines
- Reduce plugins/init.lua by ~20 lines
- Reduce b_formatter.lua by ~15 lines

## Step 2.2: Simplify lua/settings.lua

### Functions to remove:
- `M.hostname()` - no longer needed
- `M.os_type()` - only used by hostname logic
- Keep `M.home()` as it's used for backup paths

### Settings to clean up:
- Remove line 38 conditional dictionary setting
- Remove line 40 mouse nil setting (redundant with line 26)
- Clean up comments and unused sections

### Expected changes:
- Remove ~15 lines of utility functions
- Cleaner, more focused settings module

## Step 2.3: Clean up lua/config/init.lua

### Current state analysis:
- Very simple module, just loads other configs
- No hostname logic here
- May need to remove nvim-treesitter.lua loading if we integrate it

### Changes needed:
- Remove `require 'config.nvim-treesitter'.setup()` (will integrate into main config)
- Keep all other module loads as-is
- File should become even simpler

## Step 2.4: Remove all b_* custom plugins

### Files to remove completely:
1. `lua/plugins/b_custom_filetypes.lua`
2. `lua/plugins/b_formatter.lua` 
3. `lua/plugins/b_session.lua`
4. `lua/plugins/b_yank_mouse_restore.lua`

### Dependencies to update:
1. In `lua/plugins/init.lua`:
   - Remove line 229: `require 'plugins.b_custom_filetypes'.setup()`
   - Remove line 230: `require 'plugins.b_formatter'.setup()`
   - Remove line 231: `require 'plugins.b_session'.setup()`
   - Remove line 232: `require 'plugins.b_yank_mouse_restore'.setup()`

2. In `lua/config/keymap.lua`:
   - Remove lines 18-23: formatter keybindings
   - Remove lines 63-64: session keybindings
   - Update line 22: remove MiniTrailspace.trim call

### Impact assessment:
- Loss of custom file type detection
- Loss of custom formatting logic
- Loss of session management
- Loss of yank/mouse utilities
- Simplification of plugin loading

### Replacement strategy:
- LSP will handle file type detection
- LSP formatting will replace custom formatters
- Manual session management or remove feature
- Standard vim yank/mouse behavior

## Implementation Order:
1. Start with removing b_* files (safest, no dependencies)
2. Update plugins/init.lua to remove b_* calls
3. Update keymap.lua to remove b_* bindings
4. Remove hostname logic from remaining files
5. Clean up settings.lua
6. Update config/init.lua

## Risk Mitigation:
- Keep git commits granular for easy rollback
- Test configuration loading after each step
- Backup current config before starting
- Validate no syntax errors after each file modification

## Validation Steps:
1. `:lua require('plugins').setup()` should work without errors
2. `:lua require('config').setup()` should work without errors
3. No lua errors on nvim startup
4. All remaining keybindings should work (except removed ones)

## Expected File Count Reduction:
- Remove: 4 files (b_* plugins)
- Modify: 6 files
- Net: -4 files, significant LOC reduction