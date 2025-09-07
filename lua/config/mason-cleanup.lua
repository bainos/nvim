local M = {}

-- Get the ensure_installed list from our LSP configuration
local function get_ensure_installed_packages()
    -- These should match the lsp_servers list in lsp-config.lua
    local lsp_servers = {
        'bashls',
        'lua_ls',
        'rust_analyzer',
        'dockerls',
        'terraformls',
        'azure_pipelines_ls',
        'pyright',
        'markdownlint',
        'helm_ls',
    }
    
    -- Map LSP server names to Mason package names (if different)
    local server_to_package = {
        bashls = 'bash-language-server',
        lua_ls = 'lua-language-server',
        rust_analyzer = 'rust-analyzer',
        dockerls = 'dockerfile-language-server',
        terraformls = 'terraform-ls',
        azure_pipelines_ls = 'azure-pipelines-language-server',
        pyright = 'pyright',
        markdownlint = 'markdownlint',
        helm_ls = 'helm-ls',
    }
    
    local packages = {}
    for _, server in ipairs(lsp_servers) do
        local package_name = server_to_package[server] or server
        table.insert(packages, package_name)
    end
    
    return packages
end

-- Get list of currently installed Mason packages
local function get_installed_packages()
    local mason_registry = require('mason-registry')
    local installed = {}
    
    for _, pkg in ipairs(mason_registry.get_installed_packages()) do
        table.insert(installed, pkg.name)
    end
    
    return installed
end

-- Find packages that are installed but not in ensure_installed
local function find_orphaned_packages(ensure_installed, installed)
    local orphaned = {}
    local ensure_set = {}
    
    -- Create a set for faster lookup
    for _, pkg in ipairs(ensure_installed) do
        ensure_set[pkg] = true
    end
    
    -- Find packages not in ensure_installed
    for _, pkg in ipairs(installed) do
        if not ensure_set[pkg] then
            table.insert(orphaned, pkg)
        end
    end
    
    return orphaned
end

-- Show preview of what would be cleaned up
local function show_cleanup_preview(orphaned)
    if #orphaned == 0 then
        vim.api.nvim_echo({
            { '[Mason Cleanup]: ', 'Title' },
            { 'No orphaned packages found. All installed packages are in ensure_installed list.', 'Normal' }
        }, true, {})
        return
    end
    
    vim.api.nvim_echo({
        { '[Mason Cleanup]: ', 'Title' },
        { 'Found ' .. #orphaned .. ' orphaned package(s):', 'WarningMsg' }
    }, true, {})
    
    for _, pkg in ipairs(orphaned) do
        vim.api.nvim_echo({
            { '  - ', 'Normal' },
            { pkg, 'ErrorMsg' }
        }, true, {})
    end
    
    vim.api.nvim_echo({
        { '\nRun ', 'Normal' },
        { ':MasonCleanup', 'Special' },
        { ' to remove these packages (with confirmation)', 'Normal' }
    }, true, {})
end

-- Remove packages with optional confirmation
local function remove_packages(orphaned, force)
    if #orphaned == 0 then
        vim.api.nvim_echo({
            { '[Mason Cleanup]: ', 'Title' },
            { 'No orphaned packages to remove.', 'Normal' }
        }, true, {})
        return
    end
    
    -- Show what will be removed
    vim.api.nvim_echo({
        { '[Mason Cleanup]: ', 'Title' },
        { 'Will remove ' .. #orphaned .. ' package(s):', 'WarningMsg' }
    }, true, {})
    
    for _, pkg in ipairs(orphaned) do
        vim.api.nvim_echo({
            { '  - ', 'Normal' },
            { pkg, 'ErrorMsg' }
        }, true, {})
    end
    
    -- Confirmation unless force flag is used
    if not force then
        local response = vim.fn.input('\nProceed with removal? [y/N]: ')
        if response:lower() ~= 'y' and response:lower() ~= 'yes' then
            vim.api.nvim_echo({
                { '\n[Mason Cleanup]: ', 'Title' },
                { 'Cleanup cancelled.', 'Normal' }
            }, true, {})
            return
        end
    end
    
    -- Perform actual removal
    local mason_registry = require('mason-registry')
    local removed = {}
    local failed = {}
    
    for _, pkg_name in ipairs(orphaned) do
        local success = pcall(function()
            local pkg = mason_registry.get_package(pkg_name)
            if pkg:is_installed() then
                pkg:uninstall()
            end
        end)
        
        if success then
            table.insert(removed, pkg_name)
        else
            table.insert(failed, pkg_name)
        end
    end
    
    -- Report results
    if #removed > 0 then
        vim.api.nvim_echo({
            { '\n[Mason Cleanup]: ', 'Title' },
            { 'Successfully removed ' .. #removed .. ' package(s):', 'DiagnosticOk' }
        }, true, {})
        
        for _, pkg in ipairs(removed) do
            vim.api.nvim_echo({
                { '  ✓ ', 'DiagnosticOk' },
                { pkg, 'Normal' }
            }, true, {})
        end
    end
    
    if #failed > 0 then
        vim.api.nvim_echo({
            { '\n[Mason Cleanup]: ', 'Title' },
            { 'Failed to remove ' .. #failed .. ' package(s):', 'DiagnosticError' }
        }, true, {})
        
        for _, pkg in ipairs(failed) do
            vim.api.nvim_echo({
                { '  ✗ ', 'DiagnosticError' },
                { pkg, 'Normal' }
            }, true, {})
        end
    end
end

-- Main cleanup function
function M.cleanup(opts)
    opts = opts or {}
    local dry_run = opts.dry_run or false
    local force = opts.force or false
    
    vim.api.nvim_echo({
        { '[Mason Cleanup]: ', 'Title' },
        { 'Scanning for orphaned packages...', 'Normal' }
    }, true, {})
    
    local ensure_installed = get_ensure_installed_packages()
    local installed = get_installed_packages()
    local orphaned = find_orphaned_packages(ensure_installed, installed)
    
    if dry_run then
        show_cleanup_preview(orphaned)
    else
        remove_packages(orphaned, force)
    end
end

-- Setup function to register commands
function M.setup()
    -- Create the MasonCleanup user command
    vim.api.nvim_create_user_command('MasonCleanup', function(opts)
        local args = vim.split(opts.args, ' ')
        local dry_run = vim.tbl_contains(args, '--dry-run')
        local force = vim.tbl_contains(args, '--force')
        
        M.cleanup({ dry_run = dry_run, force = force })
    end, {
        nargs = '*',
        desc = 'Clean up Mason packages not in ensure_installed list',
        complete = function()
            return { '--dry-run', '--force' }
        end
    })
    
    vim.api.nvim_echo({
        { '[Mason Cleanup]: ', 'Title' },
        { 'Commands registered. Use :MasonCleanup --dry-run to preview.', 'Normal' }
    }, true, {})
end

return M