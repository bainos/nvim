# TAB-Based Completion System for Neovim

## Overview
Implementation guide for a simple TAB-based completion system using Neovim's native APIs:
- Virtual text for completion previews
- TAB key to accept completions
- Simple trigger mechanisms
- No complex completion frameworks

## Core Components

### 1. Virtual Text API (nvim_buf_set_extmark)

Neovim's extmark system allows displaying virtual text without modifying the buffer:

```lua
-- Display completion preview as virtual text
local function show_completion_preview(completion_text)
    local bufnr = vim.api.nvim_get_current_buf()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    
    -- Create namespace for our completion
    local ns_id = vim.api.nvim_create_namespace('tab_completion')
    
    -- Clear any existing preview
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
    
    -- Add virtual text at cursor position
    vim.api.nvim_buf_set_extmark(bufnr, ns_id, row - 1, col, {
        virt_text = {{completion_text, 'Comment'}}, -- Gray text style
        virt_text_pos = 'overlay', -- Overlay at cursor position
    })
    
    return ns_id
end
```

### 2. Context Extraction

Extract text around cursor for completion context:

```lua
-- Get current line and cursor position for context
local function get_completion_context()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    
    -- Extract word before cursor
    local before_cursor = line:sub(1, col)
    local word_start = before_cursor:find('[%w_]*$') or col + 1
    local current_word = before_cursor:sub(word_start)
    
    return {
        line = line,
        row = row,
        col = col,
        word = current_word,
        word_start = word_start - 1, -- 0-indexed for nvim API
    }
end
```

### 3. Simple Completion Engine

Basic completion logic with word matching:

```lua
-- Simple word-based completion engine
local function generate_completion(context)
    local current_word = context.word
    
    -- Skip if no word to complete
    if #current_word == 0 then
        return nil
    end
    
    -- Get all words from current buffer
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local words = {}
    
    -- Extract unique words
    for _, line in ipairs(lines) do
        for word in line:gmatch('[%w_]+') do
            if word ~= current_word and word:lower():find('^' .. current_word:lower()) then
                words[word] = true
            end
        end
    end
    
    -- Return first match
    for word, _ in pairs(words) do
        return word:sub(#current_word + 1) -- Return only the completion part
    end
    
    return nil
end
```

### 4. TAB Key Handler

TAB key mapping to accept and insert completion:

```lua
local completion_state = {
    active = false,
    text = nil,
    ns_id = nil,
    context = nil,
}

-- Accept current completion
local function accept_completion()
    if not completion_state.active or not completion_state.text then
        return false -- No completion active
    end
    
    -- Insert completion text at cursor
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, {completion_state.text})
    
    -- Move cursor after inserted text
    vim.api.nvim_win_set_cursor(0, {row, col + #completion_state.text})
    
    -- Clear completion state
    clear_completion()
    
    return true -- Completion accepted
end

-- Clear completion preview
function clear_completion()
    if completion_state.ns_id then
        vim.api.nvim_buf_clear_namespace(0, completion_state.ns_id, 0, -1)
    end
    completion_state = {
        active = false,
        text = nil,
        ns_id = nil,
        context = nil,
    }
end
```

### 5. Complete Implementation

Full working implementation:

```lua
-- tab_completion.lua
local M = {}

-- State management
local completion_state = {
    active = false,
    text = nil,
    ns_id = nil,
    context = nil,
}

-- Create namespace for virtual text
local ns_id = vim.api.nvim_create_namespace('tab_completion')

-- Get completion context from cursor position
local function get_completion_context()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    
    local before_cursor = line:sub(1, col)
    local word_start = before_cursor:find('[%w_]*$') or col + 1
    local current_word = before_cursor:sub(word_start)
    
    return {
        line = line,
        row = row,
        col = col,
        word = current_word,
        word_start = word_start - 1,
    }
end

-- Generate completion based on buffer words
local function generate_completion(context)
    local current_word = context.word
    
    if #current_word < 2 then -- Minimum 2 chars to trigger
        return nil
    end
    
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local words = {}
    
    for _, line in ipairs(lines) do
        for word in line:gmatch('[%w_]+') do
            if word ~= current_word and 
               #word > #current_word and
               word:lower():find('^' .. current_word:lower()) then
                words[word] = true
            end
        end
    end
    
    -- Return first alphabetical match
    local sorted_words = {}
    for word, _ in pairs(words) do
        table.insert(sorted_words, word)
    end
    table.sort(sorted_words)
    
    if #sorted_words > 0 then
        return sorted_words[1]:sub(#current_word + 1)
    end
    
    return nil
end

-- Show completion preview using virtual text
local function show_completion_preview(completion_text, context)
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Clear existing preview
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
    
    -- Add virtual text at cursor
    vim.api.nvim_buf_set_extmark(bufnr, ns_id, context.row - 1, context.col, {
        virt_text = {{completion_text, 'Comment'}},
        virt_text_pos = 'overlay',
    })
    
    return ns_id
end

-- Clear completion state and preview
local function clear_completion()
    if completion_state.ns_id then
        vim.api.nvim_buf_clear_namespace(0, completion_state.ns_id, 0, -1)
    end
    completion_state = {
        active = false,
        text = nil,
        ns_id = nil,
        context = nil,
    }
end

-- Trigger completion preview
function M.trigger_completion()
    local context = get_completion_context()
    local completion = generate_completion(context)
    
    if completion then
        completion_state.active = true
        completion_state.text = completion
        completion_state.context = context
        completion_state.ns_id = show_completion_preview(completion, context)
    else
        clear_completion()
    end
end

-- Accept current completion
function M.accept_completion()
    if not completion_state.active or not completion_state.text then
        -- No completion active, insert normal tab
        vim.api.nvim_feedkeys('\t', 'n', true)
        return
    end
    
    -- Insert completion text
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, {completion_state.text})
    
    -- Move cursor after completion
    vim.api.nvim_win_set_cursor(0, {row, col + #completion_state.text})
    
    -- Clear state
    clear_completion()
end

-- Setup function with keymaps
function M.setup()
    -- TAB to accept completion
    vim.keymap.set('i', '<Tab>', M.accept_completion, {
        desc = 'Accept completion or insert tab',
        noremap = true,
        silent = true,
    })
    
    -- Manual trigger (optional)
    vim.keymap.set('i', '<C-Space>', M.trigger_completion, {
        desc = 'Trigger completion',
        noremap = true,
        silent = true,
    })
    
    -- Auto-clear on cursor move
    vim.api.nvim_create_autocmd({'CursorMovedI'}, {
        callback = function()
            if completion_state.active then
                local context = get_completion_context()
                -- Clear if cursor moved away from completion
                if context.row ~= completion_state.context.row or
                   context.col < completion_state.context.col then
                    clear_completion()
                end
            end
        end,
    })
    
    -- Auto-trigger on text change (optional)
    vim.api.nvim_create_autocmd({'TextChangedI'}, {
        callback = function()
            -- Debounce auto-trigger
            vim.defer_fn(M.trigger_completion, 100)
        end,
    })
end

return M
```

## Usage Examples

### 1. Manual Setup

Add to your Neovim config:

```lua
-- In init.lua or appropriate config file
local tab_completion = require('tab_completion')
tab_completion.setup()
```

### 2. Key Behaviors

- **TAB**: Accept visible completion or insert normal tab
- **Ctrl+Space**: Manually trigger completion
- **Cursor movement**: Auto-clear completion preview
- **Text changes**: Auto-trigger completion after 100ms delay

### 3. Visual Feedback

Completions appear as grayed-out text (using 'Comment' highlight group) overlaying the cursor position.

## Advanced Features

### 1. LSP Integration

Extend with LSP completions:

```lua
-- LSP-based completion generation
local function generate_lsp_completion(context)
    local params = vim.lsp.util.make_position_params()
    params.context = {
        triggerKind = 1, -- Invoked
    }
    
    local results = vim.lsp.buf_request_sync(0, 'textDocument/completion', params, 1000)
    
    if results then
        for _, result in pairs(results) do
            if result.result and result.result.items and #result.result.items > 0 then
                local item = result.result.items[1]
                return item.insertText or item.label
            end
        end
    end
    
    return nil
end
```

### 2. Multiple Completions

Support cycling through multiple completions:

```lua
-- Enhanced state for multiple completions
local completion_state = {
    active = false,
    completions = {},
    current_index = 1,
    ns_id = nil,
    context = nil,
}

-- Cycle to next completion
function M.next_completion()
    if not completion_state.active or #completion_state.completions == 0 then
        return
    end
    
    completion_state.current_index = completion_state.current_index + 1
    if completion_state.current_index > #completion_state.completions then
        completion_state.current_index = 1
    end
    
    local current_completion = completion_state.completions[completion_state.current_index]
    show_completion_preview(current_completion, completion_state.context)
end
```

### 3. File-Type Specific

Different completion sources per file type:

```lua
-- File-type specific completions
local function get_completion_source()
    local filetype = vim.bo.filetype
    
    if filetype == 'lua' then
        return generate_lua_completion
    elseif filetype == 'python' then
        return generate_python_completion
    else
        return generate_buffer_completion
    end
end
```

## Integration with Current Config

To add this to your current Neovim setup:

1. **Create the module**: Save the complete implementation as `lua/tab_completion.lua`

2. **Add to config loader**: In `lua/config/init.lua`:
```lua
require('tab_completion').setup()
```

3. **Optional keybinding**: Add to `lua/config/keymap.lua`:
```lua
-- TAB completion toggle
vim.keymap.set('n', '<Leader>tc', function()
    vim.g.tab_completion_enabled = not vim.g.tab_completion_enabled
    print('Tab completion:', vim.g.tab_completion_enabled and 'enabled' or 'disabled')
end, { desc = 'Toggle tab completion' })
```

This implementation provides a clean, simple alternative to complex completion frameworks while maintaining the TAB-based workflow you're looking for.