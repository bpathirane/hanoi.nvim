local Disk = {}
Disk.__index = Disk

function Disk.new(size, color)
    print("Creating a new disk of size " .. size .. " and color " .. (color or "(default)"))

  return setmetatable({ size = size, color = color }, Disk)
end

return Disk
