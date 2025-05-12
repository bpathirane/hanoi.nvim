local Game = require('models.game')
local Board = require('views.board')

local Controller = {}
-- Set the method lookup back to itself
Controller.__index = Controller

function Controller:new()
    -- when calling this as Controller:new, self is set to Controller itself
   return setmetatable({ state = {}}, self)
end

function Controller:setup()
    print('Running the hanoi.nvim setup function')
end

function Controller:open_towers_of_hanoi()
    if not self.state.game then
        self.state.game = Game:new(3)
    end
    if not self.state.board then
        self.state.board = Board:new(self.state.game, self)
    end
    print('Rendering game:', vim.inspect(self.state))
    self.state.board:render()
end

return Controller
