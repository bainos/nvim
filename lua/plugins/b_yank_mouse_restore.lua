local M = {}

local last_positions = {}
local old_mode = false  -- Track if we were in Visual mode
local mouse = false     -- Track whether Visual mode was entered via mouse

local function debug_warning(msg)
  vim.api.nvim_echo({ { msg, "WarningMsg" } }, true, {})
end

local function handle_mouse_event(event_name)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<' .. event_name .. '>', true, true, true), 'n', true)
  if event_name:match("Drag") then
    mouse = true
  end
  debug_warning("Mouse event detected: " .. event_name)
end

local function define_mouse_command(event_name)
  vim.api.nvim_create_user_command(
    "BHandle" .. event_name,
    function()
      handle_mouse_event(event_name)
    end,
    {}
  )
end

local function update_cursor_position()
  if vim.api.nvim_get_mode().mode == "v" or vim.api.nvim_get_mode().mode == "V" or vim.api.nvim_get_mode().mode == "\22" then
    return  -- Do not track position in Visual mode
  end

  local current_pos = vim.api.nvim_win_get_cursor(0)
  table.insert(last_positions, current_pos)

  if #last_positions > 2 then
    table.remove(last_positions, 1)
  end
end

local function handle_last_positions()
  debug_warning("Last positions: " .. vim.inspect(last_positions))
  debug_warning("Mouse interaction: " .. vim.inspect(mouse))
  if old_mode and vim.api.nvim_get_mode().mode == "n" and mouse then
    if #last_positions > 0 then
      vim.api.nvim_win_set_cursor(0, last_positions[1])  -- Set cursor to the first position
    end
    old_mode = false  -- Reset mode flag
    mouse = false     -- Reset mouse flag
  end
end

-- Track the mode before yank and detect mouse-based Visual mode entry
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function(args)
    local mode = vim.api.nvim_get_mode().mode

    -- Detect entry into Visual mode
    if mode == "v" or mode == "V" or mode == "\22" then
      old_mode = true
    else
      old_mode = false
    end
  end
})

function M.setup()
  debug_warning("Hello, Neovim!")

  local mouse_events = {
    "LeftMouse",
    "RightMouse",
    "MiddleMouse",
    "LeftRelease",
    "RightRelease",
    "MiddleRelease",
    "LeftDrag",
    "RightDrag",
    "MiddleDrag",
    "MouseMove",
  }

  for _, event_name in pairs(mouse_events) do
    define_mouse_command(event_name)
  end

  vim.api.nvim_set_keymap('n', "<LeftMouse>", ":BHandleLeftMouse<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', "<RightMouse>", ":BHandleRightMouse<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', "<MiddleMouse>", ":BHandleMiddleMouse<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', "<LeftRelease>", ":BHandleLeftRelease<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', "<RightRelease>", ":BHandleRightRelease<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', "<MiddleRelease>", ":BHandleMiddleRelease<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', "<LeftDrag>", ":BHandleLeftDrag<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', "<RightDrag>", ":BHandleRightDrag<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', "<MiddleDrag>", ":BHandleMiddleDrag<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', "<MouseMove>", ":BHandleMouseMove<CR>", { noremap = true, silent = true })

  -- Autocmd to track cursor position, skip in VISUAL mode
  vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function() update_cursor_position() end
  })

  -- Autocmd to handle last positions after yank if the previous mode was VISUAL
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() handle_last_positions() end
  })
end

M.handle_mouse_event = handle_mouse_event
M.update_cursor_position = update_cursor_position

return M

