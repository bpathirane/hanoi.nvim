local Disk = {}
Disk.__index = Disk

function Disk:new(size, color)
    return setmetatable({ size = size, color = color }, self)
end

return Disk
