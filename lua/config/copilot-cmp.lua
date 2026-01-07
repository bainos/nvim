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