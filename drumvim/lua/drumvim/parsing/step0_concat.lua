-- DrumVim Step 0.3: Multiline Drumtab Concatenation
-- Handle multiline drumtab concatenation with kit piece validation

local M = {}

-- Concatenate multiline drumtab segments
-- @param segments table: array of parsed segments
-- @param block_id number: block identifier for error messages
-- @return string: concatenated content or nil on error
function M.concatenate_multiline(segments, block_id)
  if not segments or #segments == 0 then
    return nil
  end
  
  -- Single segment - no concatenation needed
  if #segments == 1 then
    return M.format_single_segment(segments[1])
  end
  
  -- Multiple segments - validate and concatenate
  local kit_pieces = M.validate_kit_pieces(segments, block_id)
  if not kit_pieces then
    return nil -- Error already reported
  end
  
  return M.perform_concatenation(segments, kit_pieces)
end

-- Validate kit pieces consistency across segments
-- @param segments table: array of segments
-- @param block_id number: block identifier for error messages  
-- @return table: kit pieces array or nil on error
function M.validate_kit_pieces(segments, block_id)
  local first_kit_pieces = segments[1].kit_pieces
  
  if not first_kit_pieces or #first_kit_pieces == 0 then
    print("Warning: Skipping drumtab block " .. block_id .. " - No kit pieces found in first segment")
    return nil
  end
  
  -- Check all segments have same kit pieces in same order
  for i = 2, #segments do
    local current_kit_pieces = segments[i].kit_pieces
    
    if #current_kit_pieces ~= #first_kit_pieces then
      print("Warning: Skipping drumtab block " .. block_id .. " - Kit piece count mismatch")
      print("Expected: " .. #first_kit_pieces .. " pieces, Found in segment " .. i .. ": " .. #current_kit_pieces .. " pieces")
      return nil
    end
    
    for j, piece in ipairs(first_kit_pieces) do
      if current_kit_pieces[j] ~= piece then
        print("Warning: Skipping drumtab block " .. block_id .. " - Kit piece mismatch")
        print("Expected: " .. table.concat(first_kit_pieces, ", "))
        print("Found in segment " .. i .. ": " .. table.concat(current_kit_pieces, ", "))
        return nil
      end
    end
  end
  
  return first_kit_pieces
end

-- Perform actual concatenation of segments
-- @param segments table: validated segments
-- @param kit_pieces table: validated kit pieces array
-- @return string: concatenated drumtab content
function M.perform_concatenation(segments, kit_pieces)
  local result_lines = {}
  
  -- Concatenate time lines (remove "Time:" from continuation segments)
  local time_parts = {}
  for i, segment in ipairs(segments) do
    if segment.time_line then
      if i == 1 then
        -- Keep first Time: header
        table.insert(time_parts, segment.time_line)
      else
        -- Remove Time: header and leading | from continuation segments
        local time_content = segment.time_line:match("^Time:%s*|?(.*)$")
        if time_content then
          table.insert(time_parts, time_content)
        end
      end
    end
  end
  
  -- Join time parts
  if #time_parts > 0 then
    table.insert(result_lines, table.concat(time_parts))
  end
  
  -- Concatenate kit piece lines
  for kit_index, kit_piece in ipairs(kit_pieces) do
    local kit_parts = {}
    
    for segment_index, segment in ipairs(segments) do
      local kit_line = segment.kit_lines[kit_index]
      if kit_line then
        if segment_index == 1 then
          -- Keep first kit piece with label
          table.insert(kit_parts, kit_line)
        else
          -- Remove kit piece label and leading | from continuation segments
          local kit_pattern = kit_line:match("^" .. kit_piece .. "%s*|?(.*)$")
          if kit_pattern then
            table.insert(kit_parts, kit_pattern)
          end
        end
      end
    end
    
    -- Join kit parts
    if #kit_parts > 0 then
      table.insert(result_lines, table.concat(kit_parts))
    end
  end
  
  return table.concat(result_lines, '\n')
end

-- Format single segment (no concatenation needed)
-- @param segment table: single segment data
-- @return string: formatted content
function M.format_single_segment(segment)
  local lines = {}
  
  if segment.time_line then
    table.insert(lines, segment.time_line)
  end
  
  for _, kit_line in ipairs(segment.kit_lines) do
    table.insert(lines, kit_line)
  end
  
  return table.concat(lines, '\n')
end

return M