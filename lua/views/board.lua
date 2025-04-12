local Game = require('models.game')

local M = {}
local state = {
  game = nil,
  floats = {},
}

local create_window_configurations = function()
  local bg_width = vim.o.columns
  local bg_height = vim.o.lines

  local pnl_width = math.floor(bg_width * 0.7)
  local pnl_height = math.floor(bg_height * 0.5)
  local pnl_top = math.floor((bg_height - pnl_height) / 2)
  local pnl_left = math.floor((bg_width - pnl_width) / 2)

  local tower_padding = 2
  local tower_width = math.floor((pnl_width - tower_padding * 3) / 3) -- two columns padding on eitherside
  local tower_height = math.floor(pnl_height - 9)
  local tower_top = pnl_top + 5

  local configs = {
    panel = {
      relative = 'editor',
      width = pnl_width,
      height = pnl_height,
      style = 'minimal',
      border = 'rounded',
      col = pnl_left,
      row = pnl_top,
      zindex = 2,
    },
    header = {
      relative = 'editor',
      width = pnl_width - 4,
      height = 2,
      style = 'minimal',
      border = 'rounded',
      col = pnl_left + tower_padding,
      row = pnl_top + 1,
      zindex = 3,
    },
    footer = {
      relative = 'editor',
      width = pnl_width - 4,
      height = 1,
      style = 'minimal',
    	border= 'rounded',
      col = pnl_left + tower_padding,
      row = tower_top + tower_height + 2,
      zindex = 3,
    },
  }
    for i = 1, 3, 1 do
    	configs['tower' .. i] = {
      relative = 'editor',
      width = tower_width,
      height = tower_height,
      style = 'minimal',
      border = 'rounded',
      col = pnl_left + (tower_padding * i) + (tower_width * (i - 1)),
      row = tower_top,
    }
    end
  print('Window configurations', vim.inspect(configs))
  return configs
end

local function create_floating_window(opts, enter, lines)
  enter = enter or false
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)
  -- vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  if lines then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end
  return { buf = buf, win = win }
end

local function create_game_panel(game)
  local window_configs = create_window_configurations()

    for key, win in pairs(window_configs) do
	state.floats[key] = create_floating_window(win, true, { tostring(key) })
    end

  local win = state.floats.panel.win
  vim.api.nvim_win_set_config(win, {
    title = ' Towers of Hanoi ',
    title_pos = 'center',
  })

  -- Set Esc key to close the window
  vim.keymap.set('n', '<Esc>', function()
	print('Closing all windows...')
    for _, float in pairs(state.floats) do
      if vim.api.nvim_win_is_valid(float.win) then
        vim.api.nvim_win_close(float.win, true)
      end
    end
  end, { buffer = state.floats.panel.buf, silent = true })
end

function M.render(game)
  state.game = game
  return create_game_panel(game)
end

return M
