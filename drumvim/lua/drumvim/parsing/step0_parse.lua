-- DrumVim Step 0.2: Block Content Parsing
-- Parse drumtab block content into segments

local M = {}

-- Parse block content into segments separated by empty lines
-- @param raw_block string: raw block content
-- @return table: array of segment tables
function M.parse_block_content(raw_block)
  local lines = vim.split(raw_block, '\n')
  local segments = {}
  local current_segment = {}
  
  for _, line in ipairs(lines) do
    local trimmed = line:match("^%s*(.-)%s*$") -- trim whitespace
    
    if trimmed == "" then
      -- Empty line - end current segment
      if #current_segment > 0 then
        table.insert(segments, M.parse_segment(current_segment))
        current_segment = {}
      end
    else
      -- Non-empty line - add to current segment
      table.insert(current_segment, line)
    end
  end
  
  -- Add final segment if exists
  if #current_segment > 0 then
    table.insert(segments, M.parse_segment(current_segment))
  end
  
  return segments
end

-- Parse individual segment into structured data
-- @param segment_lines table: array of lines in segment
-- @return table: structured segment data
function M.parse_segment(segment_lines)
  local segment = {
    time_line = nil,
    kit_lines = {},
    kit_pieces = {}
  }
  
  for _, line in ipairs(segment_lines) do
    local trimmed = line:match("^%s*(.-)%s*$")
    
    if trimmed:match("^Time:") then
      -- Time marker line
      segment.time_line = trimmed
    else
      -- Kit piece line - extract piece name and pattern
      local kit_piece, pattern = trimmed:match("^(%w+)%s*(.*)$")
      if kit_piece and pattern then
        table.insert(segment.kit_lines, trimmed)
        table.insert(segment.kit_pieces, kit_piece)
      else
        -- Invalid line format - skip with warning
        print("Warning: Invalid line format, skipping: " .. trimmed)
      end
    end
  end
  
  return segment
end

return M