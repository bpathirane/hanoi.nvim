local M = {}

function M.setup()
    print "Running the hanoi.nvim setup function"
end

local function create_floating_win()
    local buf = vim.api.nvim_create_buf(false, true)

    local width = math.floor(vim.o.columns * 0.7)
    local height = math.floor(vim.o.lines * 0.5)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local opts = {
	style = "minimal",
	relative = "editor",
	width = width,
	height = height,
	row = row,
	col = col,
	border = "rounded",
    }
   local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_win_set_config(win, {
      title = " Towers of Hanoi ",
      title_pos = "center",
    })
    -- Draw placeholder for towers
  local lines = {
    "",
    "       |       |       |       ",
    "      ---     ---     ---      ",
    "     -----   -----   -----     ",
    "    ------- ------- -------    ",
    "     T1       T2       T3      ",
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

   -- Set Esc key to close the window
  vim.keymap.set("n", "<Esc>", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, silent = true }) return buf, win
end

function M.open_towers_of_hanoi()
    return create_floating_win()
end

return M
