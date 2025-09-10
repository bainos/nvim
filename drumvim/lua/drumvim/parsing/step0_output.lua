-- DrumVim Step 0.4: Output Generation
-- Generate final drumtab_blocks.json structure

local M = {}

-- Generate final output structure
-- @param processed_blocks table: array of processed block data
-- @return table: final drumtab_blocks structure
function M.generate_output(processed_blocks)
  local output = {
    blocks = {},
    metadata = {
      total_blocks = #processed_blocks,
      generated_at = os.date("%Y-%m-%d %H:%M:%S"),
      step = "0"
    }
  }
  
  for _, block in ipairs(processed_blocks) do
    table.insert(output.blocks, {
      id = block.id,
      content = block.content
    })
  end
  
  return output
end

-- Write output to JSON file
-- @param output_data table: drumtab_blocks structure
-- @param file_path string: output file path
-- @return boolean: success status
function M.write_to_file(output_data, file_path)
  local json_content = vim.fn.json_encode(output_data)
  
  local file = io.open(file_path, 'w')
  if not file then
    print("Error: Could not open file for writing: " .. file_path)
    return false
  end
  
  file:write(json_content)
  file:close()
  
  return true
end

return M