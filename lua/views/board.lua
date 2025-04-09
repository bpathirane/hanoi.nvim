local Game = require('models.game')

local M = {}
local state = {
  game = nil,
  floats = {},
}

local create_window_configurations = function()
  local bg_width = vim.o.columns
  local bg_height = vim.o.lines
  local tower_width = math.floor(bg_width / 3)

  local pnl_width = math.floor(bg_width * 0.7)
  local pnl_height = math.floor(bg_height * 0.5)
  local pnl_top = math.floor((bg_height - pnl_height) / 2)
  local pnl_left = math.floor((bg_width - pnl_width) / 2)

  local header_height = 1 + 2 -- 1 + border
  local footer_height = 1 -- 1, no border
  local body_height = bg_height - header_height - footer_height - 2 - 1 -- for our own border

  local configs = {
    background = {
      relative = 'editor',
      width = bg_width,
      height = bg_height,
      style = 'minimal',
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
      width = bg_width,
      height = 1,
      style = 'minimal',
      border = 'rounded',
      col = pnl_left,
      row = pnl_top,
      zindex = 3,
    },
    tower1 = {
      relative = 'editor',
      width = tower_width,
      height = body_height,
      style = 'minimal',
      border = 'rounded',
      col = pnl_left,
      row = pnl_top + 2,
    },
    tower2 = {
      relative = 'editor',
      width = tower_width,
      height = body_height,
      style = 'minimal',
      border = 'rounded',
      col = pnl_left + tower_width,
      row = pnl_top + 2,
    },
    tower3 = {
      relative = 'editor',
      width = tower_width,
      height = body_height,
      style = 'minimal',
      border = 'rounded',
      col = pnl_left + tower_width * 2,
      row = pnl_top + 2,
    },
    footer = {
      relative = 'editor',
      width = bg_width,
      anchor = 'SW',
      height = 1,
      style = 'minimal',
      -- TODO: Just a border on the top?
      -- border = "rounded",
      col = pnl_left,
      row = bg_height - 1,
      zindex = 3,
    },
  }
  return configs
end

local function create_floating_win()
  local buf = vim.api.nvim_create_buf(false, true)

  local window_configs = create_window_configurations()

  state.floats.background = create_floating_window(window_configs.background)
  state.floats.header = create_floating_window(window_configs.header)
  state.floats.footer = create_floating_window(window_configs.footer)
  state.floats.tower1 = create_floating_window(window_configs.tower1, true)
  state.floats.tower2 = create_floating_window(window_configs.tower2, true)
  state.floats.tower3 = create_floating_window(window_configs.tower3, true)

  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.api.nvim_win_set_config(win, {
    title = ' Towers of Hanoi ',
    title_pos = 'center',
  })
  -- Draw placeholder for towers
  local lines = {
    '',
    '       |       |       |       ',
    '      ---     ---     ---      ',
    '     -----   -----   -----     ',
    '    ------- ------- -------    ',
    '     T1       T2       T3      ',
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })

  -- Set Esc key to close the window
  vim.keymap.set('n', '<Esc>', function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, silent = true })

  return buf, win
end

function M.render(game)
  state.game = game
  return create_floating_win()
end

return M
