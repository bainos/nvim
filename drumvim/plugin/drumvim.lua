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

-- Command: DrumTab new [time_sig] [subdivision] [kit_pieces] [measures]
-- Examples:
--   :DrumTab new                          (shows template picker)
--   :DrumTab new 4/4
--   :DrumTab new 4/4 16th
--   :DrumTab new 4/4 16th HH,SD,BD 4
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
  else
    print("DrumVim: Unknown subcommand '" .. (subcmd or "") .. "'. Use: :DrumTab new [params...]")
  end
end, {
  nargs = "*",
  complete = function(arglead, cmdline, cursorpos)
    local args = vim.split(cmdline, "%s+", {trimempty = true})
    
    if #args == 2 then
      -- First argument: subcommands
      return {"new"}
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

