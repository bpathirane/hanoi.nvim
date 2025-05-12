local Tower = require('models.tower')
local Disk = require('models.disk')

local Game = {}
Game.__index = Game

function Game:new(numDisks)
    local obj = setmetatable({ disks = numDisks }, self)

    obj.towers = {}
    -- Create three towers
    for t = 1, 3, 1 do
        table.insert(obj.towers, Tower.new('Tower ' .. t, numDisks))
    end

    -- Load the disks to the first tower
    for i = numDisks, 1, -1 do
        obj.towers[1]:push(Disk.new(i))
    end

    return obj
end

function Game.solve()
    print('Solve the game')
end

return Game
