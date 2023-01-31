local M = {}

local pkg_aliases = {
    ['sumneko_lua'] = 'lua-language-server',
}

local function is_executable(cmd)
    local cmd_executable = io.popen(
        string.format('which %s', cmd),
        'r'
    ):read 'l'
    return true and cmd_executable or false
end

M.is_termux = function()
    return is_executable 'termux-info'
end

---@type table<string, boolean>
M.pkg_install = setmetatable({}, {
    __index = function(_, key)
        local pkg = pkg_aliases[key] or key
        if not is_executable(pkg) then
            local pkg_install = io.popen(
                string.format('pkg install %s', key),
                'r'
            ):read '*l'
            print(pkg_install)
            return true
        end
        return false
    end,
})

return M
