local grid = {}
grid.__index = grid

function grid.new()
    local self = {}
    self.box_size = UDim2.fromScale(0.1,0.1)
    self.spacing = UDim2.fromScale(0,0)
    return setmetatable(self, grid)
end

function grid:applyTo(frame)


end

return grid