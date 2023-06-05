local M = {}

function M.setup()
    -- setup must be called before loading the colorscheme
    -- Default options:
    require 'gruvbox'.setup {
        undercurl = true,
        underline = true,
        bold = true,
        --italic = true,
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = '',  -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
    }
    vim.opt.background = 'dark' -- or "light" for light mode
    if require 'termux'.is_termux() then
        vim.cmd [[colorscheme gruvbox]]
    else
        vim.cmd [[colorscheme gruvbox]]
    end
end

return M
