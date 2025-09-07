-- DrumVim template system
-- Predefined drumtab templates for common styles

local M = {}

-- Template definitions
M.templates = {
  {
    name = "Rock Beat",
    description = "Classic rock pattern - 4/4, 8th notes",
    params = {
      time_signature = "4/4",
      subdivision = "8th",
      kit_pieces = {"HH", "SD", "BD"},
      measures = 4
    }
  },
  {
    name = "Jazz Swing",
    description = "Swing feel - 6/8, 8th notes",
    params = {
      time_signature = "6/8", 
      subdivision = "8th",
      kit_pieces = {"HH", "SD", "BD"},
      measures = 4
    }
  },
  {
    name = "Funk Groove",
    description = "Tight funk pattern - 4/4, 16th notes",
    params = {
      time_signature = "4/4",
      subdivision = "16th", 
      kit_pieces = {"HH", "SD", "BD"},
      measures = 4
    }
  },
  {
    name = "Latin Montuno",
    description = "Latin groove - 4/4, 8th notes",
    params = {
      time_signature = "4/4",
      subdivision = "8th",
      kit_pieces = {"HH", "SD", "BD", "CC"},
      measures = 4
    }
  },
  {
    name = "Odd Time 7/8",
    description = "Odd time signature - 7/8, 8th notes",
    params = {
      time_signature = "7/8",
      subdivision = "8th",
      kit_pieces = {"HH", "SD", "BD"},
      measures = 2
    }
  },
  {
    name = "Custom",
    description = "Create custom drumtab with your parameters",
    params = nil -- Will trigger custom parameter input
  }
}

-- Get all template names for picker
-- @return table: array of template display strings
function M.get_template_names()
  local names = {}
  for _, template in ipairs(M.templates) do
    table.insert(names, template.name .. " - " .. template.description)
  end
  return names
end

-- Get template by index
-- @param index number: template index (1-based)
-- @return table: template data or nil
function M.get_template(index)
  return M.templates[index]
end

-- Get template count
-- @return number: total number of templates
function M.get_count()
  return #M.templates
end

return M