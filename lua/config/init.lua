local M = {}

function M.setup()
    require 'config.themes'.setup()
    require 'config.nvim-treesitter'.setup()
    require 'config.nvim-cmp'.setup()
    require 'config.lsp-config'.setup()
    require 'config.keymap'.setup()
end

return M
