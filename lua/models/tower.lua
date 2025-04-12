local Disk = require('models.disk')
local Tower = {}
Tower.__index = Tower

function Tower.new(capacity)
  return setmetatable({ capacity = capacity, disks = {} }, Tower)
end

function Tower:push(disk)
  return table.insert(self.disks, disk)
end

function Tower:pop()
  return table.remove(self.disks)
end

function Tower:peek()
  return self.disks[#self.disks]
end

function Tower:get_stack()
    local stack = {}
    local start_index = self.capacity - #self.disks
    for i = 1, self.capacity do
	if i < start_index then
	    table.insert(stack, Disk.new(0))
	else
	    table.insert(stack, self.disks[i - start_index])
	end
    end
    print("Produced stack", vim.inspect(stack))
    return stack
end

return Tower
