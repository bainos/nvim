local l = require 'lspconfig'
print(l.sumneko_lua)

for k, v in pairs(l.sumneko_lua.document_config.default_config.settings.Lua) do
    print(string.format('%s: %s', k, v))
end

--local raw_os_name = io.popen('uname -s','r'):read('*l')
--print(raw_os_name)
--local raw_arch_name = io.popen('uname -m','r'):read('*l')
--print(raw_arch_name)

--local builtin = require('telescope.builtin')
--builtin.planets()

--local platform = require 'mason-core.platform'
--if platform.is.linux_arm then
--print('linux_arm')
--end

--local test = {'a','b'}
--print(test)

--local termux = require("termux")
--if termux.pkg_install.python then
--print("python installed via pkg")
--end
--if termux.pkg_install.stylua then
--print("stylua installed via pkg")
--end
