local raw_os_name = io.popen('uname -s','r'):read('*l')
print(raw_os_name)
local raw_arch_name = io.popen('uname -m','r'):read('*l')
print(raw_arch_name)

--local builtin = require('telescope.builtin')
--builtin.planets()

