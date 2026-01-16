local M = {}

-- Module state
local ghost_state = {
    ns_id = vim.api.nvim_create_namespace('bedrock_ghost'),
    suggestion = nil,
    bufnr = nil,
    line = nil,
    col = nil,
}

function M.show(suggestion_text)
    if not suggestion_text or suggestion_text == '' then
        return
    end

    -- Clear any existing ghost
    M.dismiss()

    -- Get current buffer and cursor
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = cursor[1] - 1 -- 0-indexed
    local col = cursor[2]

    -- Split suggestion into lines
    local lines = vim.split(suggestion_text, '\n', { plain = true })

    -- Display first line as inline ghost text
    if lines[1] and lines[1] ~= '' then
        vim.api.nvim_buf_set_extmark(bufnr, ghost_state.ns_id, line, col, {
            virt_text = { { lines[1], 'Comment' } },
            virt_text_pos = 'overlay',
        })
    end

    -- Display subsequent lines below (if multi-line)
    if #lines > 1 then
        local virt_lines = {}
        for i = 2, #lines do
            table.insert(virt_lines, { { lines[i], 'Comment' } })
        end
        vim.api.nvim_buf_set_extmark(bufnr, ghost_state.ns_id, line, 0, {
            virt_lines = virt_lines,
        })
    end

    -- Store state
    ghost_state.suggestion = suggestion_text
    ghost_state.bufnr = bufnr
    ghost_state.line = line
    ghost_state.col = col
end

function M.accept()
    if not ghost_state.suggestion then
        return
    end

    -- Get current buffer and cursor position
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1] - 1  -- Convert to 0-indexed
    local col = cursor[2]
    
    -- Split suggestion into lines
    local lines = vim.split(ghost_state.suggestion, '\n', { plain = true })
    
    -- Insert text using INSERT-mode-safe API
    vim.api.nvim_buf_set_text(bufnr, row, col, row, col, lines)
    
    -- Calculate new cursor position (0-indexed for row, 0-indexed for col)
    local new_row, new_col
    if #lines > 1 then
        -- Multi-line: move to last line of insertion (0-indexed)
        new_row = row + #lines - 1
        new_col = #lines[#lines]
    else
        -- Single line: stay on same row (0-indexed), move column right
        new_row = row
        new_col = col + #lines[1]
    end
    
    -- Convert row to 1-indexed for vim.api.nvim_win_set_cursor (col stays 0-indexed)
    vim.api.nvim_win_set_cursor(0, {new_row + 1, new_col})
    
    -- Clear ghost
    M.dismiss()
end

function M.dismiss()
    if ghost_state.bufnr then
        vim.api.nvim_buf_clear_namespace(ghost_state.bufnr, ghost_state.ns_id, 0, -1)
    end
    ghost_state.suggestion = nil
    ghost_state.bufnr = nil
    ghost_state.line = nil
    ghost_state.col = nil
end

function M.has_suggestion()
    return ghost_state.suggestion ~= nil
end

return M
