local M = {}

local ghost = require('bedrock_ghost.ghost')
local completion = require('bedrock_ghost.completion')

M.config = {
    model = 'us.anthropic.claude-haiku-4-5-20251001-v1:0',
    region = 'us-east-1',
    max_tokens = 512,
    keymaps = {
        request = '<Leader>ai',
        accept = '<Tab>',
        dismiss = '<Esc>',
    },
}

function M.setup(opts)
    -- Merge user config
    if opts then
        M.config = vim.tbl_deep_extend('force', M.config, opts)
    end

    -- Update completion config
    completion.config.model = M.config.model
    completion.config.region = M.config.region
    completion.config.max_tokens = M.config.max_tokens

    -- Set up keybindings
    vim.keymap.set('n', M.config.keymaps.request, M.request_completion, {
        noremap = true,
        silent = true,
        desc = 'Request Bedrock completion',
    })

    vim.keymap.set('i', M.config.keymaps.accept, function()
        if ghost.has_suggestion() then
            vim.schedule(function()
                ghost.accept()
            end)
            return ''  -- Consume the Tab key, don't insert anything
        else
            return M.config.keymaps.accept -- Fallback to normal Tab
        end
    end, {
        noremap = true,
        silent = true,
        expr = true,
        desc = 'Accept ghost text suggestion',
    })

    vim.keymap.set('n', '<Esc>', function()
        ghost.dismiss()
    end, {
        noremap = true,
        silent = true,
        desc = 'Dismiss ghost text (NORMAL mode)',
    })

    -- INSERT mode trigger (Ctrl+Space)
    vim.keymap.set('i', '<C-Space>', function()
        M.request_completion()  -- Stay in INSERT mode
    end, {
        noremap = true,
        silent = true,
        desc = 'Request Bedrock completion (INSERT mode)',
    })

    -- Dismiss in INSERT mode (Ctrl+])
    vim.keymap.set('i', '<C-]>', function()
        if ghost.has_suggestion() then
            ghost.dismiss()
        end
    end, {
        noremap = true,
        silent = true,
        desc = 'Dismiss ghost text (INSERT mode)',
    })

    -- Dismiss with Esc in INSERT mode (stay in INSERT, double-Esc to exit)
    vim.keymap.set('i', '<Esc>', function()
        if ghost.has_suggestion() then
            vim.schedule(function()
                ghost.dismiss()
            end)
            return ''  -- Consume Esc, stay in INSERT mode
        else
            return '<Esc>'  -- Normal behavior: exit INSERT mode
        end
    end, {
        noremap = true,
        silent = true,
        expr = true,
        desc = 'Dismiss ghost text (stay in INSERT) or exit INSERT mode',
    })

    -- Auto-dismiss ghost on certain events
    local ghost_group = vim.api.nvim_create_augroup('bedrock_ghost_cleanup', { clear = true })

    -- Dismiss when leaving buffer
    vim.api.nvim_create_autocmd('BufLeave', {
        group = ghost_group,
        callback = function()
            ghost.dismiss()
        end,
    })

    -- Dismiss when user continues typing (ignores suggestion)
    vim.api.nvim_create_autocmd('TextChangedI', {
        group = ghost_group,
        callback = function()
            if ghost.has_suggestion() then
                ghost.dismiss()
            end
        end,
    })

    -- Dismiss when leaving INSERT mode (safety net for Ctrl+C, Ctrl+[, etc.)
    vim.api.nvim_create_autocmd('InsertLeave', {
        group = ghost_group,
        callback = function()
            if ghost.has_suggestion() then
                ghost.dismiss()
            end
        end,
    })
end

function M.request_completion()
    -- Get context
    local context = completion.get_context()

    -- Call Bedrock API (blocking)
    local suggestion = completion.request_bedrock(context)

    -- Display ghost text
    if suggestion then
        ghost.show(suggestion)
    end
end

return M
