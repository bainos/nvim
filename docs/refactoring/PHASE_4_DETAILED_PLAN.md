# Phase 4 Detailed Implementation Plan - Completion System Overhaul

## Overview
Replace nvim-cmp completion system with copilot.lua for AI-powered completion. Remove CopilotChat and replace with modern copilot.lua + copilot-cmp integration.

## Step 4.1: Remove nvim-cmp and related plugins

### Current nvim-cmp plugins to remove:
From `lua/plugins/init.lua` (lines 82-92):
```lua
{
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'saadparwaiz1/cmp_luasnip',
        'L3MON4D3/LuaSnip',
    },
},
```

### Files to remove/modify:
1. **Remove entirely**: `lua/config/nvim-cmp.lua`
2. **Update**: `lua/config/init.lua` - remove nvim-cmp setup call
3. **Update**: `lua/plugins/init.lua` - remove nvim-cmp plugin block

### Expected result:
- No nvim-cmp related plugins loaded
- No completion conflicts with copilot
- Clean plugin list

## Step 4.2: Install and configure copilot.lua

### Add copilot.lua plugin:
Add to `lua/plugins/init.lua`:
```lua
{
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
        require('copilot').setup({
            panel = {
                enabled = true,
                auto_refresh = false,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<CR>",
                    refresh = "gr",
                    open = "<M-CR>"
                },
                layout = {
                    position = "bottom",
                    ratio = 0.4
                },
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = "<M-l>",
                    accept_word = false,
                    accept_line = false,
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
            filetypes = {
                yaml = false,
                markdown = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
            copilot_node_command = 'node',
            server_opts_overrides = {},
        })
    end,
},
```

### Expected result:
- Copilot.lua installed and configured
- Basic AI completion available
- Proper keybindings for copilot suggestions

## Step 4.3: Configure copilot-cmp for completion integration

### Add copilot-cmp plugin:
Add to `lua/plugins/init.lua`:
```lua
{
    'zbirenbaum/copilot-cmp',
    dependencies = { 'zbirenbaum/copilot.lua' },
    config = function()
        require('copilot_cmp').setup()
    end,
},
```

### Create new completion configuration:
Create `lua/config/copilot-cmp.lua`:
```lua
local M = {}

function M.setup()
    -- Simple tab-based completion with copilot
    vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    vim.g.copilot_no_tab_map = true
    
    -- Additional copilot keybindings
    vim.api.nvim_set_keymap("i", "<M-]>", 'copilot#Next()', { silent = true, expr = true })
    vim.api.nvim_set_keymap("i", "<M-[>", 'copilot#Previous()', { silent = true, expr = true })
    vim.api.nvim_set_keymap("i", "<C-]>", 'copilot#Dismiss()', { silent = true, expr = true })
end

return M
```

### Update config loading:
In `lua/config/init.lua`, replace nvim-cmp setup with:
```lua
require 'config.copilot-cmp'.setup()
```

### Expected result:
- Tab accepts copilot suggestions
- Meta keys navigate suggestions
- Clean completion experience

## Step 4.4: Remove CopilotChat configuration

### Remove CopilotChat imports:
From `lua/plugins/init.lua`, remove:
```lua
-- { import = 'plugins.copilotchat', },
{
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
        { 'github/copilot.vim' },
        { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = {},
},
```

### Remove CopilotChat file:
- Delete `lua/plugins/copilotchat.lua` (already done in Phase 2)

### Update keybindings:
In `lua/config/keymap.lua`, remove any CopilotChat keybindings if present.

### Expected result:
- No CopilotChat conflicts
- Claude Code remains as primary AI assistant
- Clean plugin configuration

## Step 4.5: Test completion functionality

### Testing checklist:
1. **Basic completion**:
   - Open a Python/Lua/Rust file
   - Start typing code
   - Verify copilot suggestions appear
   - Test Tab to accept suggestions

2. **Keybinding tests**:
   - `<Tab>`: Accept suggestion
   - `<M-]>`: Next suggestion
   - `<M-[>`: Previous suggestion
   - `<C-]>`: Dismiss suggestion

3. **Integration tests**:
   - Verify no conflicts with LSP
   - Test Claude Code still works
   - Verify file types work correctly

4. **Performance tests**:
   - Check startup time
   - Verify no completion lag
   - Test in various file types

### Expected result:
- Smooth completion experience
- No conflicts with existing features
- Fast and responsive

## Implementation Order:
1. Remove nvim-cmp from config/init.lua
2. Remove nvim-cmp plugin block from plugins/init.lua
3. Delete nvim-cmp.lua file
4. Add copilot.lua plugin configuration
5. Add copilot-cmp plugin configuration
6. Create copilot-cmp.lua configuration file
7. Update config/init.lua to load new completion
8. Test basic functionality
9. Remove any remaining CopilotChat references

## Files to modify:
1. `lua/config/init.lua` - Update module loading
2. `lua/plugins/init.lua` - Replace plugins
3. `lua/config/nvim-cmp.lua` - DELETE
4. `lua/config/copilot-cmp.lua` - CREATE
5. `lua/config/keymap.lua` - Update if needed

## Risk Assessment:
- **Medium risk**: Completion system is core functionality
- **Low risk**: Copilot.lua is well-established
- **Medium risk**: Keybinding conflicts possible

## Success Criteria:
- Copilot suggestions appear in insert mode
- Tab accepts suggestions smoothly
- No LSP conflicts
- No Claude Code conflicts
- Startup time maintained or improved
- All target languages supported

## Rollback Plan:
- Keep nvim-cmp configuration in comments initially
- Test thoroughly before final cleanup
- Git commit before each major change

## Expected Benefits:
- AI-powered intelligent completion
- Simpler configuration (fewer plugins)
- Modern completion experience
- Better integration with development workflow
- Reduced complexity vs nvim-cmp setup