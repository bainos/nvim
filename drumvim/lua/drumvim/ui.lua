-- DrumVim UI interactions
-- Telescope integration for template selection and parameter input

local templates = require('drumvim.templates')

local M = {}

-- Show template picker using telescope
-- @param callback function: called with selected template params
function M.show_template_picker(callback)
  local has_telescope, telescope = pcall(require, 'telescope')
  
  if not has_telescope then
    -- Fallback to vim.ui.select if telescope not available
    M.show_template_picker_fallback(callback)
    return
  end
  
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  
  pickers.new({}, {
    prompt_title = 'DrumVim Templates',
    finder = finders.new_table({
      results = templates.get_template_names(),
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          local template_index = selection.index
          local template = templates.get_template(template_index)
          
          if template.name == "Custom" then
            -- Handle custom template with parameter input
            M.show_custom_parameter_input(callback)
          else
            -- Use template parameters
            callback(template.params)
          end
        end
      end)
      return true
    end,
  }):find()
end

-- Fallback template picker using vim.ui.select
-- @param callback function: called with selected template params
function M.show_template_picker_fallback(callback)
  local template_names = templates.get_template_names()
  
  vim.ui.select(template_names, {
    prompt = 'Select DrumVim Template:',
  }, function(choice, idx)
    if choice and idx then
      local template = templates.get_template(idx)
      
      if template.name == "Custom" then
        M.show_custom_parameter_input(callback)
      else
        callback(template.params)
      end
    end
  end)
end

-- Show custom parameter input dialog
-- @param callback function: called with custom parameters
function M.show_custom_parameter_input(callback)
  local drumvim = require('drumvim')
  local defaults = drumvim.config.defaults
  
  -- For now, use defaults and let user modify via command
  -- TODO: Could add multi-step input for time_sig, subdivision, etc.
  print("DrumVim: Custom template selected. Using defaults: " .. 
        defaults.time_signature .. " " .. defaults.subdivision .. " " .. 
        defaults.measures .. " measures")
  print("Tip: Use :DrumTab new 7/8 16th HH,SD,BD,CC 2 for custom parameters")
  
  callback(defaults)
end

return M