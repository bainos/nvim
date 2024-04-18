local M = {}

function is_neovim_started_without_file()
    local args = vim.fn.argv()
    if #args == 0 then
        return true
    end
    return false
end

function file_exists(file_path)
    local file = io.open(file_path, 'r')
    if file then
        file:close()
        return true
    end
    return false
end

function M.save()
    vim.ui.input({ prompt = 'Create session in ' .. vim.fn.getcwd() .. '? ', },
        function(input)
            if input == nil then return end
            vim.cmd ':mksession! .session.vim'
            print('session saved: ' .. vim.fn.getcwd() .. '/.session.vim')
        end
    )
end

function M.setup()
    if is_neovim_started_without_file()
        and file_exists(vim.fn.getcwd() .. '/.session.vim')
    then
        vim.cmd ':source .session.vim'
    end
end

return M
