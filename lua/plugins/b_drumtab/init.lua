--[[
  Neovim Drumtab Plugin
  
  A plugin for creating and converting drum tablature in Neovim.
  This module provides functionality to:
  - Generate empty drum tabs with customizable measures and subdivisions
  - Parse drum tabs into structured Lua tables
  - Convert drum tabs to LilyPond notation
]]

local M = {}

-- Define the drum parts (CC = Crash Cymbal, HH = Hi-Hat, SD = Snare Drum, BD = Bass Drum)
local drum_parts = {
    'CC', -- Crash Cymbal
    'HH', -- Hi-Hat
    'SD', -- Snare Drum
    'BD', -- Bass Drum
}

-- ----------------
-- DRAW DRUMTABS
-- ----------------
-- Function to draw the drum tablature with dynamic measures and beats
-- @param args - Table containing command arguments
-- @param args.args - String of space-separated numbers: measures and subdivisions
local function draw_drum_tab(args)
    -- Parse the arguments: measures, beats per measure, note value, subdivisions
    local args_table = {}
    for arg in args.args:gmatch '%d+' do
        table.insert(args_table, tonumber(arg))
    end

    -- Unpack the arguments into variables with defaults
    local measures = args_table[1] or 4
    local subdivisions = args_table[2] or 16

    -- Validate arguments
    if measures <= 0 or subdivisions <= 0 then
        vim.api.nvim_err_writeln("Invalid arguments: measures and subdivisions must be positive numbers")
        return
    end

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

    -- Position cursor at the beginning of the first drum part
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, { cursor[1] - 4, cursor[2] + 4, })
end

-- ----------------
-- PARSE DRUMTABS
-- ----------------
-- Adds a drum part to a group (for simultaneous notes)
-- @param part - The drum part to add (e.g., "HHx")
-- @param current_group - The current group to add to
-- @return The updated group string
local function add_to_group(part, current_group)
    if not current_group or current_group == "" then
        return part
    elseif not current_group:match '^<.*>$' then
        return '<' .. current_group .. ' ' .. part .. '>'
    else
        -- Remove the last '>' and add the new part inside the delimiters
        return current_group:sub(1, -2) .. ' ' .. part .. '>'
    end
end

-- Parses a drum tab into a structured format
-- @param dtab - The drum tab to parse
-- @param time_sig - The time signature (e.g., "4/4")
-- @return Parsed drum tab structure
local function parse_drum_tab(dtab, time_sig)
    if not dtab or #dtab == 0 then
        vim.api.nvim_err_writeln("Empty drum tab provided for parsing")
        return {}
    end

    local beats, beat_unit = time_sig:match '(%d+)/(%d+)'
    if not beats or not beat_unit then
        vim.api.nvim_err_writeln("Invalid time signature format: " .. tostring(time_sig))
        -- Default to 4/4 as fallback
        beats, beat_unit = 4, 4
    end
    
    beats = tonumber(beats)
    beat_unit = tonumber(beat_unit)

    local dt = {}
    for _, measure in ipairs(dtab) do
        local m = {}
        local current_unit = ''
        local current_length = 1
        local dash_length = beat_unit * #measure
        
        -- Process each character in the measure
        for i = 1, #measure do
            if measure[i] == '-' and i == 1 then
                measure[i] = 'RRr' -- Rest at the beginning
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
        
        -- Handle the last note/rest
        if current_unit ~= '' then
            local note_length = dash_length / current_length
            table.insert(m, current_unit .. note_length)
        end
        
        table.insert(dt, m)
    end

    return dt
end

-- Collapses multiple rows of a drum tab into a single representation
-- @param tab - The drum tab rows to collapse
-- @return Collapsed drum tab structure
local function collapse_rows(tab)
    if not tab or #tab == 0 then
        vim.api.nvim_err_writeln("Empty tab provided for collapsing")
        return {}
    end

    -- Extract time signature if present
    local time_sig = tab[1]:match '^TS (%d+/%d+)'
    if time_sig then
        table.remove(tab, 1)
    else
        time_sig = '4/4' -- Default time signature
    end

    local result = {}
    for _, line in ipairs(tab) do
        if #line < 4 then
            vim.api.nvim_err_writeln("Invalid drum tab line format: " .. line)
            goto continue
        end
        
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
        
        ::continue::
    end

    -- Convert to measures
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

    -- Add the last measure if it exists
    if #measure > 0 then
        table.insert(dtab, measure)
    end

    return parse_drum_tab(dtab, time_sig)
end

-- Merges multiple tabs within a group
-- @param group - The group of tabs to merge
-- @return Merged tab structure
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

-- Prints merged tabs and groups to the buffer
-- @param groups - The groups of tabs to print
local function print_merged_tabs_and_groups(groups)
    for i, group in ipairs(groups) do
        local merged_tabs = merge_tabs_within_group(group)

        for j = 1, #merged_tabs do
            vim.api.nvim_buf_set_lines(0, -1, -1, false, { table.concat(merged_tabs[j], ' '), })
        end
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { '', }) -- Insert an empty line after each merged tab group

        -- Add separator if there are more groups
        if i < #groups then
            vim.api.nvim_buf_set_lines(0, -1, -1, false, { '---', '', })
        end
    end
end

-- Identifies drum tabs within the buffer
-- @param buffer_lines - The lines of the buffer to analyze
-- @return Groups of identified tabs
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

-- Converts drum tabs to LilyPond notation
-- @return None (creates a new buffer with the LilyPond notation)
local function lilypondify()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    
    if #lines == 0 then
        vim.api.nvim_err_writeln("No content to convert to LilyPond")
        return
    end

    vim.cmd 'new'

    local groups = identify_tabs(lines)
    if #groups == 0 then
        vim.api.nvim_err_writeln("No valid drum tabs found")
        return
    end
    
    print_merged_tabs_and_groups(groups)
end

-- Sets up the plugin with necessary options and commands
function M.setup()
    -- Create an autocmd group for the plugin
    local augroup = vim.api.nvim_create_augroup('DrumTabPlugin', { clear = true })
    
    -- Set up filetype-specific settings and commands
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'drumtab',
        group = augroup,
        callback = function()
            -- Set up editor options for better drum tab display
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
            vim.opt_local.showbreak = '| '
            vim.opt_local.breakindent = true
            vim.opt_local.breakindentopt = 'shift:4,sbr'
            vim.opt_local.breakat = '|'
            
            -- Register buffer-local user commands
            vim.api.nvim_buf_create_user_command(0, 'DrumTabDraw', draw_drum_tab, { 
                nargs = 1,
                desc = "Draw an empty drum tab. Usage: DrumTabDraw [measures] [subdivisions]"
            })
            
            vim.api.nvim_buf_create_user_command(0, 'DrumTabLilypondify', lilypondify, {
                desc = "Convert drum tabs to LilyPond notation"
            })
            
            -- Additional setup for drum tab files
            vim.bo.commentstring = '# %s'
        end,
    })
    
    -- Register global commands for convenience
    vim.api.nvim_create_user_command('DrumTabDraw', function(args)
        if vim.bo.filetype ~= 'drumtab' then
            vim.api.nvim_err_writeln("This command is only available in drumtab files")
            return
        end
        draw_drum_tab(args)
    end, { 
        nargs = 1,
        desc = "Draw an empty drum tab. Usage: DrumTabDraw [measures] [subdivisions]"
    })
    
    vim.api.nvim_create_user_command('DrumTabLilypondify', function()
        if vim.bo.filetype ~= 'drumtab' then
            vim.api.nvim_err_writeln("This command is only available in drumtab files")
            return
        end
        lilypondify()
    end, {
        desc = "Convert drum tabs to LilyPond notation"
    })
    
    -- Return success message
    return "Drumtab plugin initialized successfully!"
end

return M
