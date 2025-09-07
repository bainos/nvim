-- DrumVim hit symbols and notation
-- Defines all valid drumtab symbols and their meanings

local M = {}

-- Hit symbols for drumtab notation
M.HIT_SYMBOLS = {
  x = "Normal hit",
  o = "Normal hit (alternative)",
  X = "Accent/loud hit", 
  O = "Accent/loud hit (alternative)",
  ["-"] = "Rest/silence",
  g = "Ghost note/quiet hit",
  f = "Flam",
  r = "Rimshot",
  d = "Double stroke"  -- New: allows reaching 64th note feel with 32nd subdivision
}

-- Special notation symbols
M.SPECIAL_SYMBOLS = {
  ["|"] = "Measure/bar line",
  ["||"] = "Double bar (section end)"
}

-- Standard kit pieces
M.KIT_PIECES = {
  HH = "Hi-Hat",
  SD = "Snare Drum",
  BD = "Bass/Kick Drum", 
  CC = "Crash Cymbal",
  RC = "Ride Cymbal",
  TH = "Tom High",
  TM = "Tom Medium", 
  TL = "Tom Low",
  FT = "Floor Tom"
}

-- Check if character is a valid hit symbol
-- @param char string: single character to check
-- @return boolean: true if valid hit symbol
function M.is_valid_hit(char)
  return M.HIT_SYMBOLS[char] ~= nil
end

-- Check if string is a valid kit piece
-- @param piece string: kit piece abbreviation
-- @return boolean: true if valid kit piece
function M.is_valid_kit_piece(piece)
  return M.KIT_PIECES[piece] ~= nil
end

-- Get default kit pieces for new drumtabs
-- @return table: array of default kit piece names
function M.get_default_kit()
  return {"HH", "SD", "BD"}
end

-- Get all valid hit symbols as array
-- @return table: array of hit symbol characters
function M.get_hit_symbols()
  return vim.tbl_keys(M.HIT_SYMBOLS)
end

-- Get all valid kit pieces as array
-- @return table: array of kit piece names
function M.get_kit_pieces()
  return vim.tbl_keys(M.KIT_PIECES)
end

return M