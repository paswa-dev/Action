

local replicated = game:GetService("ReplicatedStorage")
local module = {}
module.__index = module

--[[
local function table_contains(t, v)
    for i, value in ipairs(t) do
        if value == v then
            return i
        end
    end
    return nil
end
]]--

function module.new(class, sub_folder)
    sub_folder = sub_folder or replicated
    local control_pickup = Instance.new("RemoteEvent", sub_folder)
    ---
    local config_tb = {}
    config_tb.Subscribed = {}
    config_tb.OnPlayerRemove = Instance.new("BindableEvent")
    config_tb.OnPlayerAdd = Instance.new("BindableEvent")
    config_tb.Binded = {}

    control_pickup.OnServerEvent:Connect(function(player, key_pickup)
        if table_contains(config_tb.Subscribed, player) then
            if config_tb.Binded[key.KeyCode] then
                config_tb.Binded[key.KeyCode](player)
            elseif config_tb.Binded[key.UserInputType] then
                config_tb.Binded[key.UserInputType](player)
            end
        end
    end)

    return setmetatable(config_tb, module)
end

function module:subscribe(player)
    if table.find(self.Subscribed, player) then
        return debug.traceback("Player already subscribed.")
    end
    table.insert(self.Subscribed, player)
    self.OnPlayerAdd.Fire(player)
end

function module:unsubscribe(player)
    local success, err = pcall(function()
        table.remove(self.Subscribed, table.find(self.Subscribed, player))
    end)

    if not success then
        return debug.traceback("Error occured when attempting to unsubscribe user.")
    elseif success then
        self.OnPlayerRemove.Fire(player)
    end
end

return module