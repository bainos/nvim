-- DrumVim subdivision handling
-- Converts user-friendly subdivision names to internal numeric values

local M = {}

-- Parse subdivision input and return subdivisions per beat
-- @param input string: "8th", "16th", or "32nd"
-- @return number: subdivisions per beat (2, 4, or 8)
function M.parse(input)
  local valid_subdivisions = {
    ["8th"] = 2,   -- 2 subdivisions per beat
    ["16th"] = 4,  -- 4 subdivisions per beat  
    ["32nd"] = 8   -- 8 subdivisions per beat
  }
  
  local result = valid_subdivisions[input]
  if not result then
    local valid_options = table.concat(vim.tbl_keys(valid_subdivisions), "', '")
    error("Invalid subdivision. Use: '" .. valid_options .. "'. Got: " .. tostring(input))
  end
  
  return result
end

-- Get list of valid subdivision names
-- @return table: array of valid subdivision strings
function M.get_valid_names()
  return {"8th", "16th", "32nd"}
end

-- Check if subdivision name is valid
-- @param input string: subdivision to check
-- @return boolean: true if valid
function M.is_valid(input)
  local valid = {["8th"] = true, ["16th"] = true, ["32nd"] = true}
  return valid[input] == true
end

return M