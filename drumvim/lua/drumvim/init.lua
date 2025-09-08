-- DrumVim main module
-- Entry point and API for the drumtab editor plugin

local generator = require('drumvim.generator')

local M = {}

-- Default configuration
M.config = {
  defaults = {
    time_signature = "4/4",
    subdivision = "8th", 
    kit_pieces = {"HH", "SD", "BD"},
    measures = 4,
    bpm = 120
  }
}

-- Setup plugin with user configuration
-- @param user_config table: user configuration overrides
function M.setup(user_config)
  M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
end

-- Create new empty drumtab
-- @param params table: optional parameters {time_sig, subdivision, kit_pieces, measures}
-- @return table: array of drumtab lines
function M.new_drumtab(params)
  -- Merge with defaults
  local merged_params = vim.tbl_deep_extend("force", M.config.defaults, params or {})
  
  -- Generate drumtab
  local drumtab_lines = generator.generate_empty(merged_params)
  
  return drumtab_lines
end

-- Insert drumtab into current buffer
-- @param params table: optional parameters for drumtab generation
function M.insert_drumtab(params)
  local drumtab_lines = M.new_drumtab(params)
  
  -- Get current cursor position
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  
  -- Insert lines at cursor position + 1 (leave blank line)
  vim.api.nvim_buf_set_lines(0, cursor_line, cursor_line, false, drumtab_lines)
  
  -- Position cursor at first rest of first drum line
  -- First line is Time: markers, second line is first drum piece
  if #drumtab_lines >= 2 then
    local first_drum_line = drumtab_lines[2]
    local first_rest_col = first_drum_line:find('-')
    
    if first_rest_col then
      -- Move to first rest position (convert to 0-based column)
      vim.api.nvim_win_set_cursor(0, {cursor_line + 2, first_rest_col - 1})
    else
      -- Fallback: move to start of first drum line
      vim.api.nvim_win_set_cursor(0, {cursor_line + 2, 0})
    end
  else
    -- Fallback: move to start of inserted content
    vim.api.nvim_win_set_cursor(0, {cursor_line + 1, 0})
  end
end

-- Create new buffer with drumtab
-- @param params table: optional parameters for drumtab generation
function M.new_drumtab_buffer(params)
  local drumtab_lines = M.new_drumtab(params)
  
  -- Create new buffer
  local buf = vim.api.nvim_create_buf(true, false)
  
  -- Set buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, drumtab_lines)
  
  -- Set filetype for syntax highlighting (to be implemented)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'drumtab')
  
  -- Switch to new buffer
  vim.api.nvim_set_current_buf(buf)
  
  return buf
end

return M