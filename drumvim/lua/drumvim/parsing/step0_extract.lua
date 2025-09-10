-- DrumVim Step 0.1: Document Block Extraction
-- Extract raw drumtab code blocks from document text

local M = {}

-- Extract all ```drumtab code blocks from document
-- @param document_text string: full document content
-- @return table: array of raw block content strings
function M.extract_blocks(document_text)
  local blocks = {}
  local lines = vim.split(document_text, '\n')
  local in_drumtab_block = false
  local current_block = {}
  
  for _, line in ipairs(lines) do
    if line:match("^```drumtab%s*$") then
      -- Start of drumtab block
      if in_drumtab_block then
        -- Nested block - skip with warning
        print("Warning: Found nested drumtab block - ignoring")
      else
        in_drumtab_block = true
        current_block = {}
      end
    elseif line:match("^```%s*$") and in_drumtab_block then
      -- End of drumtab block
      if #current_block > 0 then
        table.insert(blocks, table.concat(current_block, '\n'))
      else
        print("Warning: Empty drumtab block found - skipping")
      end
      in_drumtab_block = false
      current_block = {}
    elseif in_drumtab_block then
      -- Inside drumtab block - collect content
      table.insert(current_block, line)
    end
    -- Lines outside drumtab blocks are ignored
  end
  
  -- Check for unclosed block
  if in_drumtab_block then
    print("Warning: Unclosed drumtab block found - skipping")
  end
  
  return blocks
end

return M