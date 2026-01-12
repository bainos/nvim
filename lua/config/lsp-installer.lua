local M = {}

function M.setup()
    -- Install LSP servers for OpenCode to use
    -- No loading, no configuration, just installation
    require('mason').setup()
    
    local servers = {
        'bash-language-server',
        'lua-language-server', 
        'pyright',
        'ruff',
        'markdownlint-cli2',    -- Markdown linting
        'prettier',             -- Markdown formatting (100-char wrap)
    }
    
    -- Auto-install servers on startup
    vim.defer_fn(function()
        local mason_registry = require('mason-registry')
        for _, server in ipairs(servers) do
            if not mason_registry.is_installed(server) then
                vim.cmd('MasonInstall ' .. server)
            end
        end
    end, 1000)
end

return M