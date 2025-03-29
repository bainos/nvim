local M = {}

function M.setup()
    require 'lazy'.setup {
        {
            'vscode-neovim/vscode-multi-cursor.nvim',
            event = 'VeryLazy',
            cond = not not vim.g.vscode,
            opts = {},
            config = function()
                require 'vscode-multi-cursor'.setup()
            end,
        },
    }

    vim.g.clipboard = vim.g.vscode_clipboard
    vim.notify = require 'vscode-neovim'.notify

    vim.opt.mouse = ''

    -- ---------------------------------------
    -- KEYBINDINGS
    -- ---------------------------------------
    vim.g.mapleader = ','
    vim.g.maplocalleader = '\\'

    -- code actions
    vim.keymap.set('n', '<Leader>a', function() vim.fn.VSCodeNotify 'editor.action.codeAction' end,
        { noremap = true, silent = true, desc = 'code actions', })

    -- formatter
    vim.keymap.set('n', '<Leader>fr', function() vim.fn.VSCodeNotify 'editor.action.formatDocument' end,
        { noremap = true, silent = true, desc = 'format buffer', })
    vim.keymap.set('n', '<Leader>tr', function() vim.fn.VSCodeNotify 'editor.action.trimTrailingWhitespace' end,
        { noremap = true, silent = true, desc = 'trim trailing spaces', })

    -- buffers
    vim.keymap.set('n', '<Leader>w', function() vim.fn.VSCodeNotify 'workbench.action.files.saveAll' end,
        { noremap = true, silent = true, desc = 'write all', })
    vim.keymap.set('n', '<Leader>q', function() vim.fn.VSCodeNotify 'workbench.action.quit' end,
        { noremap = true, silent = true, desc = 'quit all', })
    vim.keymap.set('n', '<Leader>#', function() vim.fn.VSCodeNotify 'workbench.action.openPreviousEditor' end,
        { noremap = true, silent = true, desc = 'last buffer', })

    -- toggle line numbers
    vim.keymap.set('n', '<Leader>l', function() vim.fn.VSCodeNotify 'workbench.action.toggleLineNumbers' end,
        { noremap = true, silent = true, desc = 'toggle line numbers', })

    -- diagnostic
    vim.keymap.set('n', '<Leader>d', function() vim.fn.VSCodeNotify 'editor.action.showHover' end,
        { noremap = true, silent = true, desc = 'diagnostic open float', })
    vim.keymap.set('n', '<Leader>n', function() vim.fn.VSCodeNotify 'editor.action.marker.next' end,
        { noremap = true, silent = true, desc = 'diagnostic next', })
    vim.keymap.set('n', '<Leader>p', function() vim.fn.VSCodeNotify 'editor.action.marker.prev' end,
        { noremap = true, silent = true, desc = 'diagnostic previous', })

    -- file/buffer manager
    vim.keymap.set('n', '<Leader>ff', function() vim.fn.VSCodeNotify 'workbench.action.quickOpen' end,
        { noremap = true, silent = true, desc = 'show files', })
    vim.keymap.set('n', '<Leader>fg', function() vim.fn.VSCodeNotify 'workbench.action.findInFiles' end,
        { noremap = true, silent = true, desc = 'grep files', })
    vim.keymap.set('n', '<Leader>fb', function() vim.fn.VSCodeNotify 'workbench.action.showAllEditors' end,
        { noremap = true, silent = true, desc = 'show buffers', })
    vim.keymap.set('n', '<Leader>fh', function() vim.fn.VSCodeNotify 'workbench.action.showCommands' end,
        { noremap = true, silent = true, desc = 'show help tags', })
    vim.keymap.set('n', '<Leader>fs', function() vim.fn.VSCodeNotify 'workbench.action.gotoSymbol' end,
        { noremap = true, silent = true, desc = 'show LSP symbols', })
    vim.keymap.set('n', '<Leader>fd', function() vim.fn.VSCodeNotify 'editor.action.revealDefinition' end,
        { noremap = true, silent = true, desc = 'show/go to definition', })
    vim.keymap.set('n', '<Leader>fm', function() vim.fn.VSCodeNotify 'workbench.view.explorer' end,
        { noremap = true, silent = true, desc = 'file browser', })
    vim.keymap.set('n', '<Leader>bn', function() vim.fn.VSCodeNotify 'workbench.action.nextEditor' end,
        { noremap = true, silent = true, desc = 'next buffer', })
    vim.keymap.set('n', '<Leader>bp', function() vim.fn.VSCodeNotify 'workbench.action.previousEditor' end,
        { noremap = true, silent = true, desc = 'previous buffer', })

    -- session
    vim.keymap.set('n', '<Leader>ss', function() vim.fn.VSCodeNotify 'workbench.action.files.save' end,
        { noremap = true, silent = true, desc = 'save session', })

    -- multicursor
    vim.keymap.set({ 'n', 'x', 'i', }, '<C-d>', function()
        require 'vscode-multi-cursor'.addSelectionToNextFindMatch()
    end)
    vim.keymap.set({ 'n', 'x', 'i', }, '<C-S-d>', function()
        require 'vscode-multi-cursor'.addSelectionToPreviousFindMatch()
    end)

    -- local vscode = require("vscode")
	-- vim.keymap.set({ "n", "x", "i" }, "<C-S-L>", function()
	-- 	vscode.with_insert(function()
	-- 		vscode.action("editor.action.selectHighlights")
	-- 	end)
	-- end)
    
    -- terminal
    vim.keymap.set('n', '<Leader>t', function() vim.fn.VSCodeNotify 'workbench.action.terminal.toggleTerminal' end,
        { noremap = true, silent = true, desc = 'toggle terminal', })
    
    -- copilot
    vim.keymap.set('n', '<Leader>i', function() vim.fn.VSCodeNotify 'github.copilot.inlineChat' end,
        { noremap = true, silent = true, desc = 'trigger Copilot inline chat', })

end

return M