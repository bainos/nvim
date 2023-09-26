local servers = {}

table.insert(servers, 'bashls')
table.insert(servers, 'lua_ls')
table.insert(servers, 'rust_analyzer')
table.insert(servers, 'dockerls')
table.insert(servers, 'terraformls')
table.insert(servers, 'azure_pipelines_ls')
table.insert(servers, 'ruff_lsp')

local conf = {
    bashls = 'bashls conf',
}

for _, server in pairs(servers) do
    if conf[server] then print(server) end
end
