local Game = require('models.game')
local Board = require('views.board')

local M = {}
local state = {}

function M.setup()
    print('Running the hanoi.nvim setup function')
end

function M.open_towers_of_hanoi()
    if not state.game then
        state.game = Game.new(3)
    end
    Board.render(state.game)
end

return M
