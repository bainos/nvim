-- DrumVim Step 0: Document Parsing and Drumtab Block Extraction
-- Extract drumtab blocks from markdown documents and handle multiline concatenation

local extract = require('drumvim.parsing.step0_extract')
local parse = require('drumvim.parsing.step0_parse')
local concat = require('drumvim.parsing.step0_concat')
local output = require('drumvim.parsing.step0_output')

local M = {}

-- Main API: Parse document and extract drumtab blocks
-- @param document_text string: full document content
-- @return table: drumtab_blocks structure or nil on error
function M.parse_document(document_text)
  if not document_text or document_text == "" then
    return { blocks = {} }
  end
  
  -- Substep 0.1: Extract raw blocks
  local raw_blocks = extract.extract_blocks(document_text)
  if not raw_blocks or #raw_blocks == 0 then
    return { blocks = {} }
  end
  
  -- Process each block
  local processed_blocks = {}
  for i, raw_block in ipairs(raw_blocks) do
    local result = M.process_single_block(raw_block, i)
    if result then
      table.insert(processed_blocks, result)
    end
  end
  
  -- Substep 0.4: Generate final output
  return output.generate_output(processed_blocks)
end

-- Process single block through substeps 0.2 and 0.3
-- @param raw_block string: raw block content
-- @param block_id number: block identifier
-- @return table: processed block or nil if error
function M.process_single_block(raw_block, block_id)
  -- Substep 0.2: Parse block content into segments
  local segments = parse.parse_block_content(raw_block)
  if not segments or #segments == 0 then
    print("Warning: Skipping empty drumtab block " .. block_id)
    return nil
  end
  
  -- Substep 0.3: Concatenate multiline drumtab
  local concatenated_content = concat.concatenate_multiline(segments, block_id)
  if not concatenated_content then
    return nil -- Error already reported in concatenate_multiline
  end
  
  return {
    id = block_id,
    content = concatenated_content
  }
end

return M