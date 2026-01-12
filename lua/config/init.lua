local M = {}

function M.setup()
    require 'config.themes'.setup()
    require 'config.nvim-treesitter'.setup()
    require 'config.lsp-installer'.setup()
    require 'config.keymap'.setup()
end

return M
