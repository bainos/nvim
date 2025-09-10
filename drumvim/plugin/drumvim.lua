-- DrumVim plugin commands
-- Neovim command interface for DrumVim functionality

-- Prevent multiple loading
if vim.g.loaded_drumvim then
  return
end
vim.g.loaded_drumvim = true

local drumvim = require('drumvim')

-- Initialize plugin with default config
drumvim.setup()

-- Command: DrumTab <subcommand> [args...]
-- Subcommands:
--   new [time_sig] [subdivision] [kit_pieces] [measures] - Create drumtab template
--   extract                                              - Extract drumtab blocks from document  
--   ly                                                   - Generate LilyPond from drumtab blocks
-- Examples:
--   :DrumTab new                          (shows template picker)
--   :DrumTab new 4/4 16th HH,SD,BD 4     (direct parameters)
--   :DrumTab extract                      (parse current buffer)
--   :DrumTab ly                           (full pipeline to LilyPond)
vim.api.nvim_create_user_command('DrumTab', function(opts)
  local args = opts.fargs
  local subcmd = args[1]
  
  if subcmd == "new" then
    -- If no additional parameters, show template picker
    if #args == 1 then
      local ui = require('drumvim.ui')
      ui.show_template_picker(function(template_params)
        if template_params then
          drumvim.insert_drumtab(template_params)
        end
      end)
      return
    end
    
    -- Parse manual parameters
    local params = {}
    if args[2] then params.time_sig = args[2] end
    if args[3] then params.subdivision = args[3] end
    if args[4] then 
      -- Parse kit pieces (comma-separated)
      params.kit_pieces = vim.split(args[4], ",", {trimempty = true})
    end
    if args[5] then params.measures = tonumber(args[5]) end
    
    -- Insert drumtab at cursor position
    drumvim.insert_drumtab(params)
    
  elseif subcmd == "extract" then
    -- Extract drumtab blocks from current buffer using Step 0
    local parsing = require('drumvim.parsing')
    
    -- Get current buffer content
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local document_text = table.concat(lines, '\n')
    
    -- Run Step 0 parsing
    local result = parsing.step0.parse_document(document_text)
    
    if result and result.blocks and #result.blocks > 0 then
      print("DrumVim: Extracted " .. #result.blocks .. " drumtab block(s)")
      
      -- Write to temp file for inspection
      local temp_file = vim.fn.tempname() .. "_drumtab_blocks.json"
      local output_module = require('drumvim.parsing.step0_output')
      if output_module.write_to_file(result, temp_file) then
        print("DrumVim: Output written to " .. temp_file)
      end
    else
      print("DrumVim: No drumtab blocks found in current buffer")
    end
    
  elseif subcmd == "ly" then
    -- Generate LilyPond from drumtab blocks (Step 0 for now, more steps later)
    local parsing = require('drumvim.parsing')
    
    -- Get current buffer content  
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local document_text = table.concat(lines, '\n')
    
    -- Run Step 0 parsing
    local result = parsing.step0.parse_document(document_text)
    
    if result and result.blocks and #result.blocks > 0 then
      print("DrumVim: Processing " .. #result.blocks .. " drumtab block(s) for LilyPond generation...")
      
      -- Write to temp file
      local temp_file = vim.fn.tempname() .. "_drumtab_blocks.json" 
      local output_module = require('drumvim.parsing.step0_output')
      if output_module.write_to_file(result, temp_file) then
        print("DrumVim: Step 0 complete - " .. temp_file)
        print("DrumVim: TODO - Steps 1-8 not implemented yet")
      end
    else
      print("DrumVim: No drumtab blocks found in current buffer")
    end
    
  else
    local valid_commands = {"new", "extract", "ly"}
    print("DrumVim: Unknown subcommand '" .. (subcmd or "") .. "'")
    print("DrumVim: Valid subcommands: " .. table.concat(valid_commands, ", "))
  end
end, {
  nargs = "*",
  complete = function(arglead, cmdline, cursorpos)
    local args = vim.split(cmdline, "%s+", {trimempty = true})
    
    if #args == 2 then
      -- First argument: subcommands
      return {"new", "extract", "ly"}
    elseif #args == 3 then
      -- Second argument: time signatures
      local time_sig = require('drumvim.time_signature')
      return time_sig.get_common_signatures()
    elseif #args == 4 then
      -- Third argument: subdivisions
      local subdivision = require('drumvim.subdivision')
      return subdivision.get_valid_names()
    end
    
    return {}
  end
})

