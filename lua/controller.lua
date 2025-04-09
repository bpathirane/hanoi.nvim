local Game = require('models.game')
local Board = require('views.board')

local M = {}

function M.setup()
  print('Running the hanoi.nvim setup function')
end

function M.open_towers_of_hanoi()
  local game = Game.new(3)
  Board.render(game)
end

return M
