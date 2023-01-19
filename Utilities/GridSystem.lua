local grid = {}
grid.__index = grid

function grid.new()
    local self = {}
    self.box_size = UDim2.fromScale(0.1,0.1)
    self.spacing = UDim2.fromScale(0,0)
    self.box_frame = Instance.new("Frame")
    return setmetatable(self, grid)
end

function grid:applyTo(frame)
    local grid_main = Instance.new("UIGridLayout")
    grid_main.CellPadding = self.spacing
    grid_main.CellSize = self.box_size
    grid_main.Parent = frame

    local grid_matrix = {}
    local pastY = 0
    local x, y = 1, 0

    for i=1, grid_main.AbsoluteCellCount do
        local box = self.box_frame:Clone()
        box.Parent = frame
        ---------------------------------------
        if pastY ~= box.Position.Scale.Y then 
            y += 1
            x = 1
        end
        ---------------------------------------
        if not grid_matrix[x] then
            grid_matrix[x] = {}
        end
        ---------------------------------------
        grid_matrix[x][y] = box
        ---------------------------------------
        x += 1
        pastY = box.Position.Scale.Y
    end
    return grid_matrix
end


end

return grid