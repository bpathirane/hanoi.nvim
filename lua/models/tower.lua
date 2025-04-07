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

return Tower
