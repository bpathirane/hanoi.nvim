local Disk = {}
Disk.__index = Disk

function Disk.new(size, color)
    return setmetatable({ size = size, color = color }, Disk)
end

return Disk
