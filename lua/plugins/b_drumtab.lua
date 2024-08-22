local M = {}
-- Define the drum parts
local drum_parts = {
    'CC',
    'HH',
    'SD',
    'BD',
}

-- ----------------
-- DRAW DRUMTABS
-- ----------------
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

-- ----------------
-- PARSE DRUMTABS
-- ----------------
local function add_to_group(part, current_group)
    if not current_group:match '^<.*>$' then
        return '<' .. current_group .. ' ' .. part .. '>'
    else
        -- Remove the last '>' and add the new part inside the delimiters
        return current_group:sub(1, -2) .. ' ' .. part .. '>'
    end
end

local function parse_drum_tab(dtab, time_sig)
    local beats, beat_unit = time_sig:match '(%d+)/(%d+)'
    beats = tonumber(beats)
    beat_unit = tonumber(beat_unit)

    local dt = {}
    for _, measure in ipairs(dtab) do
        local m = {}
        local current_unit = ''
        local current_length = 1
        local dash_length = beat_unit * #measure
        for i = 1, #measure do
            if measure[i] == '-' and i == 1 then
                measure[i] = 'RRr'
            end

            if measure[i] ~= '-' then
                if current_unit ~= '' then
                    local note_length = dash_length / current_length
                    table.insert(m, current_unit .. note_length)
                end

                current_length = 1
                current_unit = measure[i]
            else
                current_length = current_length + 1
            end
        end
        if current_unit ~= '' then
            local note_length = dash_length / current_length
            table.insert(m, current_unit .. note_length)
        end
        table.insert(dt, m)
    end

    return dt
end

local function collapse_rows(tab)
    local time_sig = tab[1]:match '^TS (%d+/%d+)'
    if time_sig then
        table.remove(tab, 1)
    else
        time_sig = '4/4'
    end

    local result = {}
    for _, line in ipairs(tab) do
        local part_name = line:sub(1, 2)
        local part_content = line:sub(4)
        local j = 1
        for i = 1, #part_content do
            local char = part_content:sub(i, i)

            if char == '|' then
                result[j] = char
                j = j + 1
            elseif char ~= '-' then
                if result[j] == nil or result[j] == '-' then
                    result[j] = part_name .. char
                    j = j + 1
                else
                    result[j] = add_to_group(part_name .. char, result[j])
                    j = j + 1
                end
            else
                if result[j] == nil then
                    result[j] = char
                end
                j = j + 1
            end
        end
    end

    local dtab = {}
    local measure = {}
    for _, e in ipairs(result) do
        if e == '|' then
            if #measure > 0 then
                table.insert(dtab, measure)
                measure = {}
            end
        else
            table.insert(measure, e)
        end
    end

    return parse_drum_tab(dtab, time_sig)
end

local function merge_tabs_within_group(group)
    local merged_tabs = {}

    for _, tab in ipairs(group) do
        tab = collapse_rows(tab)
        for _, v in ipairs(tab) do
            table.insert(merged_tabs, v)
        end
    end

    return merged_tabs
end

local function print_merged_tabs_and_groups(groups)
    for _, group in ipairs(groups) do
        local merged_tabs = merge_tabs_within_group(group)

        for i = 1, #merged_tabs do
            vim.api.nvim_buf_set_lines(0, -1, -1, false, { table.concat(merged_tabs[i], ' '), })
        end
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { '', }) -- Insert an empty line after each merged tab group

        -- Add separator if there are more groups
        if _ < #groups then
            vim.api.nvim_buf_set_lines(0, -1, -1, false, { '---', '', })
        end
    end
end

local function identify_tabs(buffer_lines)
    local groups = {}
    local current_group = {}
    local current_tab = {}
    local blank_line_count = 0

    for _, line in ipairs(buffer_lines) do
        if line:match '^%u%u ' then -- Line belongs to a drum tab part
            blank_line_count = 0
            table.insert(current_tab, line)
        elseif line:match '^%s*$' then -- Empty line encountered
            blank_line_count = blank_line_count + 1
            if blank_line_count == 1 then
                if #current_tab > 0 then
                    table.insert(current_group, current_tab)
                    current_tab = {}
                end
            elseif blank_line_count > 1 then
                if #current_group > 0 then
                    table.insert(groups, current_group)
                    current_group = {}
                end
            end
        end
    end

    -- Add the last tab and group if they exist
    if #current_tab > 0 then
        table.insert(current_group, current_tab)
    end
    if #current_group > 0 then
        table.insert(groups, current_group)
    end

    return groups
end

local function lilypondify()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    vim.cmd 'new'

    local groups = identify_tabs(lines)
    print_merged_tabs_and_groups(groups)
end


-- Function to draw the empty 4/4 drum tablature
function M.setup()
    vim.opt.wrap = true
    vim.opt.linebreak = true
    vim.opt.showbreak = '| '
    vim.opt.breakindent = true
    vim.opt.breakindentopt = 'shift:4,sbr'
    vim.opt.breakat = '|'

    vim.api.nvim_create_user_command('DrumTabDraw', draw_drum_tab, { nargs = 1, })

    vim.api.nvim_create_user_command('DrumTabLilypondify', lilypondify, {})
end

return M
