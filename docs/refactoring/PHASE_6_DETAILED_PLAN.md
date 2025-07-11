# Phase 6 Detailed Implementation Plan - Keybinding Preservation

## Overview
Audit and clean up keybindings in keymap.lua, ensuring essential bindings are preserved while removing obsolete ones. Focus on maintaining core navigation, management, and essential functionality while removing custom formatter bindings.

## Step 6.1: Audit lua/config/keymap.lua for essential bindings

### Current keybinding categories to audit:
1. **Leader key definition** - Keep as-is (`,` and `\`)
2. **Code actions** - Essential LSP functionality
3. **Formatter bindings** - Need review/cleanup
4. **Search bindings** - Essential navigation
5. **Buffer management** - Essential workflow
6. **Line numbers toggle** - Useful utility
7. **Diagnostics** - Essential LSP functionality
8. **File/buffer management (Telescope)** - Core functionality
9. **LSP navigation** - Essential development
10. **Buffer navigation** - Essential workflow
11. **Neovide-specific** - Environment-specific

### Keybindings to audit for essentials:
- `<Leader>ca`: Code actions (KEEP - essential LSP)
- `<Leader>fr`: Format buffer (NEEDS UPDATE - already uses LSP)
- `<Leader>tr`: Trim trailing spaces (KEEP - uses mini.trailspace)
- `<C-b>`: Clear search highlights (KEEP - essential)
- `<Leader>w`: Write all (KEEP - essential)
- `<Leader>q`: Quit all (KEEP - essential)
- `<Leader>#`: Last buffer (KEEP - useful)
- `<Leader>l`: Toggle line numbers (KEEP - useful)
- `<Leader>d`: Diagnostic float (KEEP - essential LSP)
- `<Leader>n`: Next diagnostic (KEEP - essential LSP)
- `<Leader>p`: Previous diagnostic (KEEP - essential LSP)
- Telescope bindings (KEEP ALL - core functionality)
- Buffer navigation (KEEP - essential)

### Expected result:
- Complete inventory of current keybindings
- Classification of essential vs obsolete
- Plan for cleanup

## Step 6.2: Remove custom formatter keybindings

### Current formatter-related bindings:
From analysis of keymap.lua:
```lua
-- formatter
vim.keymap.set('n', '<Leader>fr', vim.lsp.buf.format, { noremap = true, silent = true, desc = 'format buffer', })
```

### Status check:
- Custom formatter references already removed in Phase 2
- Current binding uses `vim.lsp.buf.format` (correct)
- No cleanup needed for this binding

### User command cleanup:
- Check if `:Format` command still references old formatter
- Currently not defined (was removed with custom formatters)
- May need to add simple `:Format` command for convenience

### Expected result:
- Verify no obsolete custom formatter references
- Ensure LSP formatting works correctly
- Add convenience command if needed

## Step 6.3: Preserve core navigation and management keybindings

### Essential keybinding categories to preserve:

#### 1. LSP and Development
- `<Leader>ca`: Code actions
- `<Leader>d`: Diagnostic float
- `<Leader>n`: Next diagnostic
- `<Leader>p`: Previous diagnostic
- `<Leader>fd`: LSP definitions
- `<Leader>fs`: LSP symbols

#### 2. File and Buffer Management
- `<Leader>ff`: Find files (Telescope)
- `<Leader>fg`: Live grep (Telescope)
- `<Leader>fb`: Show buffers (Telescope)
- `<Leader>fh`: Help tags (Telescope)
- `<Leader>fm`: Mini.files browser
- `<Leader>bn`: Next buffer
- `<Leader>bp`: Previous buffer
- `<Leader>#`: Last buffer

#### 3. Core Workflow
- `<Leader>w`: Write all
- `<Leader>q`: Quit all
- `<Leader>l`: Toggle line numbers
- `<C-b>`: Clear search highlights
- `<Leader>fr`: Format buffer (LSP)
- `<Leader>tr`: Trim trailing spaces

#### 4. Claude Code Integration
- All `<Leader>a*` bindings (defined in plugins/init.lua)

### Keybindings to verify work correctly:
- Test each essential binding
- Ensure descriptions are accurate
- Verify no conflicts

### Expected result:
- All essential keybindings preserved and functional
- Clean, consistent keybinding scheme
- No obsolete bindings

## Step 6.4: Update Claude Code keybindings if needed

### Current Claude Code keybindings analysis:
Defined in `lua/plugins/init.lua` within the Claude Code plugin config:
- `<leader>a`: AI/Claude Code group
- `<leader>ac`: Toggle Claude
- `<leader>af`: Focus Claude
- `<leader>ar`: Resume Claude
- `<leader>aC`: Continue Claude
- `<leader>ab`: Add current buffer
- `<leader>as`: Send to Claude (visual mode)
- `<leader>aa`: Accept diff
- `<leader>ad`: Deny diff

### Verification needed:
1. **Consistency**: Ensure all bindings use consistent leader pattern
2. **Conflicts**: Check for conflicts with other bindings
3. **Completeness**: Verify all essential Claude Code functions covered
4. **Documentation**: Ensure descriptions are clear

### Potential improvements:
- Group organization could be clearer
- Consider if any bindings are missing
- Verify visual mode bindings work correctly

### Expected result:
- Claude Code keybindings optimized and verified
- No conflicts with other bindings
- Complete coverage of Claude Code functionality

## Implementation Order:
1. Read and analyze current keymap.lua thoroughly
2. Create inventory of all current keybindings
3. Classify bindings as essential/obsolete/needs-update
4. Remove any obsolete custom formatter references
5. Verify all essential bindings work correctly
6. Check Claude Code keybinding consistency
7. Clean up any obsolete bindings
8. Test all preserved bindings

## Files to modify:
1. `lua/config/keymap.lua` - Main cleanup target
2. Possibly verify `lua/plugins/init.lua` Claude Code bindings

## Risk Assessment:
- **Low risk**: Most changes are verification/cleanup
- **Medium risk**: Accidentally removing essential bindings
- **Low risk**: Keybinding conflicts

## Success Criteria:
- All essential keybindings preserved and functional
- No obsolete custom formatter references
- Claude Code bindings work correctly
- No keybinding conflicts
- Clean, well-documented keybinding scheme
- All bindings have proper descriptions

## Testing Checklist:
1. **LSP bindings**: Test code actions, diagnostics, definitions, symbols
2. **Telescope bindings**: Test file finding, grep, buffers, help
3. **Buffer management**: Test buffer navigation, write, quit
4. **Utility bindings**: Test line numbers, search clear, format, trim
5. **Claude Code**: Test all AI assistant functions
6. **No conflicts**: Verify no binding conflicts exist

## Expected Benefits:
- Clean, maintainable keybinding configuration
- No obsolete or conflicting bindings
- Consistent keybinding scheme
- All essential functionality preserved
- Better documentation of keybinding purpose

## Backup Plan:
- Document all current bindings before changes
- Make incremental changes with git commits
- Test each change individually