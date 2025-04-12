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
  local tower_width = math.floor((pnl_width - tower_padding * 4) / 3) -- two columns padding on eitherside
  local tower_height = math.floor(pnl_height - 6)
  local tower_top = pnl_top + 4

  local configs = {
    background = {
      relative = 'editor',
      width = bg_width,
      height = bg_height,
      style = 'minimal',
      border = 'rounded',
      col = 0,
      row = 0,
      zindex = 1,
    },
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
      width = pnl_width,
      height = 2,
      style = 'minimal',
      border = 'rounded',
      col = pnl_left,
      row = pnl_top,
      zindex = 3,
    },
    footer = {
      relative = 'editor',
      width = bg_width,
      anchor = 'SW',
      height = 1,
      style = 'minimal',
      col = pnl_left,
      row = bg_height - 1,
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

  state.floats.background = create_floating_window(window_configs.background, { 'background' })
  state.floats.panel = create_floating_window(window_configs.panel, { 'panel' })
  state.floats.header = create_floating_window(window_configs.header, { 'header' })
  state.floats.footer = create_floating_window(window_configs.footer, { 'footer' })
  state.floats.tower1 = create_floating_window(window_configs.tower1, false, { 'tower1' })
  state.floats.tower2 = create_floating_window(window_configs.tower2, false, { 'tower2' })
  state.floats.tower3 = create_floating_window(window_configs.tower3, false, { 'tower3' })
  state.floats.footer = create_floating_window(window_configs.footer, false, { 'footer' })

  local win = state.floats.background.win
  vim.api.nvim_win_set_config(win, {
    title = ' Towers of Hanoi ',
    title_pos = 'center',
  })

  -- Set Esc key to close the window
  vim.keymap.set('n', '<Esc>', function()
    for _, float in pairs(state.floats) do
      if vim.api.nvim_win_is_valid(float.win) then
        vim.api.nvim_win_close(float.win, true)
      end
    end
  end, { buffer = state.floats.background.buf, silent = true })
end

function M.render(game)
  state.game = game
  return create_game_panel(game)
end

return M
