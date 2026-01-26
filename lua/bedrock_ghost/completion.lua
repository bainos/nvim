local M = {}

M.config = {
    model = 'us.anthropic.claude-haiku-4-5-20251001-v1:0',
    region = 'us-east-1',
    max_tokens = 512,
    temperature = 0.3,  -- Lower temperature for more focused completions
}

-- Clean response from markdown and unwanted formatting
local function clean_response(text)
    if not text then
        return nil
    end

    -- Remove markdown code blocks
    text = text:gsub('^```[%w]*\n', '')  -- Opening ```lang
    text = text:gsub('\n```$', '')       -- Closing ```
    text = text:gsub('^```[%w]*', '')    -- Opening without newline
    text = text:gsub('```$', '')         -- Closing without newline

    -- Remove XML-style tags
    text = text:gsub('^<[^>]+>', '')
    text = text:gsub('<[^>]+>$', '')

    -- Remove common labels
    text = text:gsub('^PREFIX:%s*', '')
    text = text:gsub('^OUTPUT:%s*', '')
    text = text:gsub('^COMPLETION:%s*', '')

    -- Trim whitespace
    text = text:gsub('^%s+', '')
    text = text:gsub('%s+$', '')

    return text
end

-- Build prompt with PREFIX/SUFFIX format and few-shot examples
local function build_prompt(context)
    local filetype = vim.bo.filetype or 'text'

    local prompt = string.format([[You are a code completion engine. Your ONLY job is to output the missing code continuation.

=== CRITICAL RULES (VIOLATION = FAILURE) ===
1. Output ONLY the completion text - nothing else
2. NEVER repeat any code from PREFIX section
3. NEVER add markdown (no ```, no language tags, no formatting)
4. NEVER add explanations or comments about what you're doing
5. If PREFIX ends with incomplete token, complete it first
6. Stop after completing the current logical unit (function, statement, etc)

=== INPUT FORMAT ===
FILETYPE: %s

PREFIX (code already written - DO NOT REPEAT THIS):
%s

SUFFIX (code after cursor - for context only):
%s

=== COMPLETION ALGORITHM (pseudocode) ===
IF prefix.lastToken is incomplete THEN
    output: completion of lastToken + rest of statement
ELSE
    output: next logical code unit
END IF

=== EXAMPLES ===

Example 1 (Python - incomplete function name):
PREFIX: "def fib"
CORRECT OUTPUT: "onacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)"
WRONG: "def fibonacci..." ← NEVER repeat PREFIX

Example 2 (Lua - incomplete function declaration):
PREFIX: "function calculate_"
CORRECT OUTPUT: "sum(a, b)
    return a + b
end"
WRONG: "function calculate_sum..." ← NEVER repeat PREFIX

Example 3 (Variable with partial name):
PREFIX: "local my_va"
CORRECT OUTPUT: "riable = 123"
WRONG: "local my_variable..." ← NEVER repeat PREFIX

=== YOUR TASK ===
Complete the code. Output ONLY the completion text (no prefixes, no markdown, no explanations):]],
        filetype,
        context.prefix,
        context.suffix ~= '' and context.suffix or '(end of file)'
    )

    return prompt
end

function M.get_context()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_line = cursor[1]  -- 1-indexed
    local cursor_col = cursor[2]   -- 0-indexed

    -- Split buffer into prefix (before cursor) and suffix (after cursor)
    local prefix_lines = {}
    local suffix_lines = {}

    for i, line in ipairs(lines) do
        if i < cursor_line then
            table.insert(prefix_lines, line)
        elseif i == cursor_line then
            -- Split cursor line at cursor position
            local before = line:sub(1, cursor_col)
            local after = line:sub(cursor_col + 1)
            table.insert(prefix_lines, before)
            if after ~= '' then
                table.insert(suffix_lines, after)
            end
        else
            table.insert(suffix_lines, line)
        end
    end

    local prefix = table.concat(prefix_lines, '\n')
    local suffix = table.concat(suffix_lines, '\n')

    return {
        prefix = prefix,
        suffix = suffix,
        cursor_line = cursor_line,
        cursor_col = cursor_col,
    }
end

function M.request_bedrock(context)
    -- Get AWS credentials
    local creds_module = require('config.aws-credentials')
    local bedrock_keys = creds_module.get_bedrock_keys()

    if not bedrock_keys then
        vim.notify('Bedrock credentials not available', vim.log.levels.ERROR)
        return nil
    end

    -- Parse credentials: format is "access_key,secret_key,region,session_token"
    local parts = vim.split(bedrock_keys, ',', { plain = true })
    if #parts < 3 then
        vim.notify('Invalid Bedrock credentials format', vim.log.levels.ERROR)
        return nil
    end

    local access_key = parts[1]
    local secret_key = parts[2]
    local region = parts[3]
    local session_token = parts[4] or ''

    -- Build prompt with PREFIX/SUFFIX format
    local prompt = build_prompt(context)

    -- Build request payload
    local payload = vim.fn.json_encode({
        anthropic_version = 'bedrock-2023-05-31',
        max_tokens = M.config.max_tokens,
        temperature = M.config.temperature,
        messages = {
            {
                role = 'user',
                content = prompt,
            },
        },
    })

    -- Escape payload for shell
    payload = payload:gsub("'", "'\\''")

    -- Build curl command with AWS SigV4
    local endpoint = string.format(
        'https://bedrock-runtime.%s.amazonaws.com/model/%s/invoke',
        region,
        M.config.model
    )

    local curl_cmd = string.format(
        [[curl -s -X POST --aws-sigv4 "aws:amz:%s:bedrock" --user "%s:%s" -H "Content-Type: application/json" %s -d '%s' "%s"]],
        region,
        access_key,
        secret_key,
        session_token ~= '' and string.format('-H "X-Amz-Security-Token: %s"', session_token) or '',
        payload,
        endpoint
    )

    -- Execute curl command
    local output = vim.fn.system(curl_cmd)
    local exit_code = vim.v.shell_error

    if exit_code ~= 0 then
        vim.notify('Bedrock API error: ' .. output, vim.log.levels.ERROR)
        return nil
    end

    -- Parse response
    local ok, response = pcall(vim.fn.json_decode, output)
    if not ok then
        vim.notify('Failed to parse Bedrock response', vim.log.levels.ERROR)
        return nil
    end

    -- Extract completion text
    if response.content and response.content[1] and response.content[1].text then
        local completion = response.content[1].text
        return clean_response(completion)
    end

    vim.notify('No completion in Bedrock response', vim.log.levels.WARN)
    return nil
end

return M
