local Disk = require('models.disk')
local Tower = {}
Tower.__index = Tower

function Tower.new(label, capacity)
  return setmetatable({ label = label, capacity = capacity, disks = {} }, Tower)
end

function Tower:push(disk)
    if getmetatable(disk) == Disk then
	table.insert(self.disks, 1, disk)
    elseif type(disk) == "number" then
	if disk > 0 then
	table.insert(self.disks, 1, Disk.new(disk))
	else
	    error("Disk has to be of a positive size")
	end
	else
	    error("Expects an instance of disk or a number. Got type " .. disk)
    end
end

function Tower:pop()
  return table.remove(self.disks)
end

function Tower:peek()
  return self.disks[#self.disks]
end

function Tower:get_stack()
    local stack = {}
    for i = 1, #self.disks, 1 do
	    table.insert(stack, i, self.disks[i])
    end
    -- print(self.label .. " size: ", #self.disks)
    return stack
end

return Tower
