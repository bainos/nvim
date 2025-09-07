-- DrumVim time signature handling
-- Parse and validate time signatures (4/4, 6/8, 7/8, etc.)

local M = {}

-- Parse time signature string into components
-- @param input string: time signature like "4/4", "6/8", "7/8"
-- @return table: {beats = number, beat_unit = number}
function M.parse(input)
  if type(input) ~= "string" then
    error("Time signature must be a string like '4/4'. Got: " .. tostring(input))
  end
  
  local beats, beat_unit = input:match("^(%d+)/(%d+)$")
  
  if not beats or not beat_unit then
    error("Invalid time signature format. Use 'beats/beat_unit' like '4/4', '6/8'. Got: " .. input)
  end
  
  beats = tonumber(beats)
  beat_unit = tonumber(beat_unit)
  
  -- Validate beat unit (must be power of 2: 1, 2, 4, 8, 16, 32)
  if not M.is_valid_beat_unit(beat_unit) then
    error("Invalid beat unit. Use 1, 2, 4, 8, 16, or 32. Got: " .. beat_unit)
  end
  
  -- Validate reasonable beats count
  if beats < 1 or beats > 32 then
    error("Invalid beats count. Use 1-32 beats. Got: " .. beats)
  end
  
  return {
    beats = beats,
    beat_unit = beat_unit,
    original = input
  }
end

-- Check if beat unit is valid (power of 2)
-- @param unit number: beat unit to check
-- @return boolean: true if valid
function M.is_valid_beat_unit(unit)
  local valid_units = {[1] = true, [2] = true, [4] = true, [8] = true, [16] = true, [32] = true}
  return valid_units[unit] == true
end

-- Get common time signatures  
-- @return table: array of common time signature strings
function M.get_common_signatures()
  return {
    "4/4",   -- Common time
    "2/4",   -- March time
    "3/4",   -- Waltz time
    "6/8",   -- Compound duple
    "9/8",   -- Compound triple
    "12/8",  -- Compound quadruple
    "5/8",   -- Odd time
    "7/8",   -- Odd time
    "11/8"   -- Complex odd time
  }
end

-- Check if time signature is valid
-- @param input string: time signature to check
-- @return boolean: true if valid
function M.is_valid(input)
  local success, result = pcall(M.parse, input)
  return success
end

-- Get default time signature
-- @return string: default time signature
function M.get_default()
  return "4/4"
end

return M