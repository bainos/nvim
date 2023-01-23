local M = {}

function M.setup()
  require 'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
    },
    ensure_installed = {
      "bash",
      "dockerfile",
      "python",
      "lua",
      "terraform",
      "vim",
      "yaml",
    },
  }
end

return M
