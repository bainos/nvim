local M = {}
-- Define the drum parts
local drum_parts = {
    'CC',
    'HH',
    'SD',
    'BD',
}

-- Function to draw the drum tablature with dynamic measures and beats
local function draw_drum_tab(args)
    -- Parse the arguments: measures, beats per measure, note value, subdivisions
    local args_table = {}
    for arg in args.args:gmatch '%d+' do
        table.insert(args_table, tonumber(arg))
    end

    -- Unpack the arguments into variables
    local measures = args_table[1] or 4
    local subdivisions = args_table[2] or 16

    -- Calculate the number of dashes based on subdivisions
    local measure_str = string.rep('-', subdivisions) .. '|'

    -- Construct the tab strings
    local tab_lines = { '', }
    for _, part in ipairs(drum_parts) do
        local line = part .. ' |'
        for _ = 1, measures do
            line = line .. measure_str
        end
        table.insert(tab_lines, line)
    end

    -- Get the current buffer
    local buf = vim.api.nvim_get_current_buf()

    -- Go to the last written line and get the current cursor position
    vim.cmd 'normal! G$'
    local line = vim.api.nvim_win_get_cursor(0)[1]

    -- Insert the drum tab into the buffer
    vim.api.nvim_buf_set_lines(buf, line - 1, line - 1, false, tab_lines)

    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, { cursor[1] - 4, cursor[2] + 4, })
end

local function parse_measure_count()
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local total_pipes = 0
    local tab_lines = 0

    for _, line in ipairs(buf_lines) do
        -- Count the number of '|' characters in the line
        local pipe_count = select(2, line:gsub('|', '|'))
        total_pipes = total_pipes + pipe_count

        -- Count the line if it has at least 2 pipes
        if pipe_count >= 2 then
            tab_lines = tab_lines + 1
        end
    end

    -- Calculate total measures
    if tab_lines > 0 then
        local pipes = total_pipes - tab_lines
        local total_measures = pipes / #drum_parts
        return total_measures .. ' | ' .. pipes
            .. ' / ' .. tab_lines
    else
        return 0
    end
end


-- EXPERIMENTAL
local function add_to_group(part, current_group)
    if not current_group:match '^<.*>$' then
        return '<' .. current_group .. ' ' .. part .. '>'
    else
        -- Remove the last '>' and add the new part inside the delimiters
        return current_group:sub(1, -2) .. ' ' .. part .. '>'
    end
end

local function parse_drum_table(drum_table)
    local result = {}
    local current_unit = ''
    local current_length = 1

    for i = 1, #drum_table do
        if drum_table[i] == '-' then
            if i == 1 then
                current_unit = 'RRr'
            else
                current_length = current_length + 1
            end
        else
            if current_unit ~= '' then
                table.insert(result, current_unit .. current_length)
            end
            current_unit = drum_table[i]
            current_length = 1
        end
    end

    if current_unit ~= '' then
        table.insert(result, current_unit .. current_length)
    end

    return result
end

local function merge_drum_tabs(tab1, tab2)
    local result = {}

    for i = 1, #tab1 do
        local part1 = tab1[i]
        local part2 = tab2[i]

        local merged_line = part1:sub(1, 4) .. part1:sub(5) .. part2:sub(5)
        -- merged_line = merged_line:gsub('|', '')
        local drum_part = merged_line:sub(1, 2) -- Extract the drum part (e.g., 'CC')
        local pattern = merged_line:sub(4)      -- Extract the rest of the line (the pattern)
        for j = 1, #pattern do
            local char = pattern:sub(j, j)

            if char == '|' then
                result[j] = char
            elseif char ~= '-' then
                if result[j] == nil or result[j] == '-' then
                    result[j] = drum_part .. char
                else
                    -- result[j] = result[j] .. ',' .. drum_part .. char
                    result[j] = add_to_group(drum_part .. char, result[j])
                end
            else
                if result[j] == nil then
                    result[j] = char
                end
            end
        end
    end

    local drum_table = {}
    local line_tmp = {}
    for i = 1, #result do
        if result[i] == '|' then
            table.insert(drum_table,
                table.concat(
                    parse_drum_table(line_tmp), ' '))
            line_tmp = {}
        else
            table.insert(line_tmp, result[i])
        end
    end
    -- return merged_tab
    return drum_table
end

local function get_buffer_lines(start_line, end_line)
    return vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
end

local function set_buffer_lines(start_line, new_lines)
    vim.api.nvim_buf_set_lines(0, start_line, start_line, false, new_lines)
end

local function show_measure_count()
    local measures = parse_measure_count()
    local lines = get_buffer_lines(0, -1)
    local tab1 = { unpack(lines, 1, 4), }
    local tab2 = { unpack(lines, 6, 9), }

    local merged_tab = merge_drum_tabs(tab1, tab2)

    vim.cmd 'new'

    -- Write the number of measures into the buffer
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'Number of measures: ' .. measures, })
    -- vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'result: ' .. table.concat(merged_tab, ' '), })
    -- vim.api.nvim_buf_set_lines(0, 0, -1, false, merged_tab)
    set_buffer_lines(#lines, merged_tab)
end

-- EXPERIMENTAL END


-- Function to draw the empty 4/4 drum tablature
function M.setup()
    vim.opt.wrap = true
    vim.opt.linebreak = true
    vim.opt.showbreak = '| '
    vim.opt.breakindent = true
    vim.opt.breakindentopt = 'shift:4,sbr'
    vim.opt.breakat = '|'

    -- Create a command to run the function with arguments
    vim.api.nvim_create_user_command('DrawDrumTab', draw_drum_tab, { nargs = 1, })

    -- Create the command to show the measure count
    vim.api.nvim_create_user_command('ShowMeasureCount', show_measure_count, {})
end

return M
