-- DrumVim Parsing Module
-- Entry point for all parsing functionality

local M = {}

-- Step 0: Document parsing and drumtab block extraction
M.step0 = require('drumvim.parsing.step0')

return M