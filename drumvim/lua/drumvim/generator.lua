-- DrumVim drumtab generator
-- Creates empty drumtab templates based on parameters

local subdivision = require('drumvim.subdivision')
local time_signature = require('drumvim.time_signature')
local symbols = require('drumvim.symbols')

local M = {}

-- Generate empty drumtab
-- @param params table: {time_sig, subdivision, kit_pieces, measures}
-- @return table: array of drumtab lines
function M.generate_empty(params)
  -- Parse and validate parameters
  local time_sig = time_signature.parse(params.time_sig or "4/4")
  local subdiv_count = subdivision.parse(params.subdivision or "16th")
  local kit_pieces = params.kit_pieces or symbols.get_default_kit()
  local measures = params.measures or 2
  
  -- Validate kit pieces
  for _, piece in ipairs(kit_pieces) do
    if not symbols.is_valid_kit_piece(piece) then
      error("Invalid kit piece: " .. piece .. ". Use: " .. table.concat(symbols.get_kit_pieces(), ", "))
    end
  end
  
  -- Calculate positions per measure
  local positions_per_measure = time_sig.beats * subdiv_count
  
  -- Generate time markers line
  local time_line = M.generate_time_markers(time_sig, subdiv_count, measures)
  
  -- Generate empty pattern lines for each kit piece
  local pattern_lines = {}
  for _, piece in ipairs(kit_pieces) do
    local line = M.generate_empty_pattern_line(piece, positions_per_measure, measures)
    table.insert(pattern_lines, line)
  end
  
  -- Combine all lines
  local drumtab_lines = {time_line}
  for _, line in ipairs(pattern_lines) do
    table.insert(drumtab_lines, line)
  end
  
  return drumtab_lines
end

-- Generate time markers line
-- @param time_sig table: parsed time signature
-- @param subdiv_count number: subdivisions per beat
-- @param measures number: number of measures
-- @return string: time markers line
function M.generate_time_markers(time_sig, subdiv_count, measures)
  local markers = {"Time:  "}
  
  for measure = 1, measures do
    table.insert(markers, "|")
    
    -- Generate beat markers aligned with subdivision positions
    for beat = 1, time_sig.beats do
      -- Add beat number at the start of each beat
      table.insert(markers, beat)
      
      -- Add padding spaces to align with subdivision positions
      -- Each beat has (subdiv_count - 1) additional positions
      for _ = 2, subdiv_count do
        table.insert(markers, " ")
      end
    end
  end
  
  table.insert(markers, "|")
  return table.concat(markers)
end

-- Generate empty pattern line for a kit piece
-- @param piece string: kit piece name (HH, SD, BD, etc.)
-- @param positions_per_measure number: total positions in one measure
-- @param measures number: number of measures
-- @return string: empty pattern line with rests
function M.generate_empty_pattern_line(piece, positions_per_measure, measures)
  local line_parts = {piece .. string.rep(" ", 7 - #piece)}  -- Pad to align with "Time:  "
  
  for measure = 1, measures do
    table.insert(line_parts, "|")
    table.insert(line_parts, string.rep("-", positions_per_measure))
  end
  
  table.insert(line_parts, "|")
  return table.concat(line_parts)
end

return M