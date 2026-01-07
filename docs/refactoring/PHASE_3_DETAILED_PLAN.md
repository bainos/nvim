# Phase 3 Detailed Implementation Plan - LSP Simplification

## Overview
Simplify LSP configuration by removing complex handlers, custom configurations, and focusing on basic diagnostics and navigation only. Remove ruff server (will be replaced by copilot.lua for completion).

## Step 3.1: Refactor lua/config/lsp-config.lua to use only farm-net servers

### Current state analysis:
- Already using static farm-net server list (completed in Phase 2)
- Contains complex server-specific configurations
- Has custom handlers for pyright
- Contains extensive YAML schema configurations

### Changes needed:
- Remove 'ruff' from lsp_servers list (completion will be handled by copilot)
- Keep essential servers: bashls, lua_ls, rust_analyzer, dockerls, terraformls, azure_pipelines_ls, pyright, yamlls, marksman
- Verify server list is correct for basic diagnostics

### Expected result:
- Clean server list focused on diagnostics
- No completion-focused servers (ruff removed)

## Step 3.2: Remove custom LSP handlers and complex configurations

### Custom handlers to remove:
1. **pyright handlers** (lines 84-89):
   ```lua
   pyright = {
       handlers = {
           ['textDocument/publishDiagnostics'] = function(...)
           end,
       },
   },
   ```
   - This disables pyright diagnostics completely
   - Remove this to allow basic diagnostics

2. **ruff init_options** (lines 90-97):
   - Remove entire ruff configuration block
   - ruff server already removed from server list

### Complex configurations to simplify:
1. **yamlls settings** (lines 122-139):
   - Keep basic schema configuration
   - Remove complex Kubernetes schema URLs
   - Simplify to essential YAML support

2. **azure_pipelines_ls settings** (lines 140-150):
   - Keep basic configuration
   - Remove complex schema definitions

3. **rust_analyzer settings** (lines 151-173):
   - Simplify to essential settings
   - Remove complex cargo and macro configurations

### Expected result:
- Cleaner server configurations
- Basic diagnostics enabled for all servers
- Removed completion-focused complexity

## Step 3.3: Keep only basic diagnostic and navigation features

### Diagnostic configuration to review:
- Current config is already basic (lines 58-67)
- Keep warning-level signs
- Keep underline and virtual_text settings
- No changes needed here

### LSP capabilities to maintain:
- Basic diagnostics (errors, warnings)
- Go to definition
- Hover information
- Code actions (basic)
- Formatting (basic)

### Features to ensure are removed:
- Complex completion integration (handled by copilot)
- Advanced refactoring tools
- Complex hover providers

### Expected result:
- Clean diagnostic experience
- Essential navigation features
- No LSP-based completion interference

## Step 3.4: Remove custom formatters, use LSP formatting only

### Current state:
- Custom formatters already removed in Phase 2
- Keybinding updated to use vim.lsp.buf.format
- This step is already complete

### Verification needed:
- Ensure no references to custom formatting remain
- Verify LSP formatting works for supported languages
- Test formatting keybinding (<Leader>fr)

### Expected result:
- Clean LSP-only formatting
- No custom formatter dependencies

## Implementation Order:
1. Remove ruff from server list
2. Remove pyright custom handlers
3. Remove ruff configuration block
4. Simplify yamlls configuration
5. Simplify azure_pipelines_ls configuration
6. Simplify rust_analyzer configuration
7. Test LSP functionality
8. Verify no custom formatter references remain

## Files to modify:
1. `lua/config/lsp-config.lua` - Main simplification target
2. No other files need modification for this phase

## Risk Assessment:
- **Low risk**: Most changes are removal of complexity
- **Medium risk**: Removing pyright handlers might show more diagnostics
- **Low risk**: Server list changes are straightforward

## Testing Steps:
1. Restart Neovim
2. Open files of different types (Lua, Python, Rust, YAML, Bash)
3. Verify LSP diagnostics appear
4. Test go-to-definition (<Leader>fd)
5. Test formatting (<Leader>fr)
6. Verify no LSP errors in :LspInfo

## Success Criteria:
- LSP servers start without errors
- Basic diagnostics work for all languages
- Go-to-definition works
- Formatting works via LSP
- No custom handlers or complex configurations remain
- ruff server removed (preparation for copilot.lua)

## Expected Line Reduction:
- Remove ~40 lines from lsp-config.lua
- Significant complexity reduction
- Cleaner, more maintainable configuration

## Rollback Plan:
- Git commit before each major change
- Keep original complex configurations in comments initially
- Test thoroughly before final cleanup