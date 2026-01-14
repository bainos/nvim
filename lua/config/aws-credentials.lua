local M = {}

local CACHE_FILE = vim.fn.expand('~/.config/nvim/aws-auth.json')
local CACHE_TTL = 300 -- Refresh 5 min before expiration

function M.setup()
    local creds = M._load_from_cache()

    if not creds or M._is_expired(creds) then
        creds = M._fetch_from_aws()
        if creds then
            M._save_to_cache(creds)
        end
    end

    M._credentials = creds
end

function M._load_from_cache()
    local file = io.open(CACHE_FILE, 'r')
    if not file then
        return nil
    end
    local json = file:read('*a')
    file:close()
    local ok, data = pcall(vim.fn.json_decode, json)
    return ok and data or nil
end

function M._save_to_cache(creds)
    local file = io.open(CACHE_FILE, 'w')
    if not file then
        return
    end
    file:write(vim.fn.json_encode(creds))
    file:close()
    vim.fn.system('chmod 600 ' .. vim.fn.shellescape(CACHE_FILE))
end

function M._fetch_from_aws()
    local profile = os.getenv('AWS_PROFILE') or 'default'
    local cmd = string.format(
        'aws configure export-credentials --profile %s --format process 2>/dev/null',
        profile
    )
    local handle = io.popen(cmd)
    local output = handle:read('*a')
    handle:close()

    if output == '' then
        return nil
    end

    local ok, data = pcall(vim.fn.json_decode, output)
    if not ok then
        return nil
    end

    -- Parse expiration to epoch for validation
    local year, month, day, hour, min, sec = data.Expiration:match('(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)')
    if year then
        data._expiration_epoch = os.time({
            year = tonumber(year),
            month = tonumber(month),
            day = tonumber(day),
            hour = tonumber(hour),
            min = tonumber(min),
            sec = tonumber(sec),
        })
    end

    return data
end

function M._is_expired(creds)
    if not creds or not creds._expiration_epoch then
        return true
    end
    return os.time() >= (creds._expiration_epoch - CACHE_TTL)
end

function M.get_bedrock_keys()
    if not M._credentials then
        return nil
    end
    local c = M._credentials
    local region = os.getenv('AWS_REGION') or os.getenv('AWS_DEFAULT_REGION') or 'us-east-1'
    return string.format('%s,%s,%s,%s', c.AccessKeyId, c.SecretAccessKey, region, c.SessionToken)
end

function M.refresh()
    local creds = M._fetch_from_aws()
    if creds then
        M._credentials = creds
        M._save_to_cache(creds)
        return true
    end
    return false
end

return M
