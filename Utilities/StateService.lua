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


function module.new(object, states : {any})
    states = states or {}

    local config_lb = {}
    config_lb.Object = object
    config_lb.States = states
    config_lb.OnStateChange = Instance.new("BindableEvent")
    config_lb.OnObjectChange = Instance.new("BindableEvent")

    return setmetatable(config_lb, module)
end

function module:Remove()
    self = nil
end

function module:Clear()
    self.States = {}
end

function module:SetObject(object)
    self.Object = object
end

function module:AddState(state)
    if table.find(self.States, state) then
        return debug.traceback("State already exists.")
    else
        self.OnStateChange.Fire(self.Object, state, "A")
        table.insert(self.States, state)
    end
end


function module:RemoveState(state)
    local success, err = pcall(function()
        table.remove(self.States, table.find(self.States, state))
    end)

    if not success then
        return debug.traceback("Error when attempting to remove non-existing state.")
    elseif success then
        self.OnStateChange.Fire(self.Object, state, "R")
    end
end

function module:AppendStates(states: {any})
    for _, state in ipairs(states) do
        if table.find(self.States, state) then
            debug.traceback("State already exists. Skipping...")
        else
            self.OnStateChange.Fire(self.Object, state, "A")
            table.insert(self.States, state)
        end
    end
end

function module:RemoveStates(states: {any})
    for _, state in ipairs(states) do
        local success, err = pcall(function()
            table.remove(self.States, table.find(self.States, state))
        end)
    
        if not success then
            debug.traceback("Error when attempting to remove non-existing state.")
        elseif success then
            self.OnStateChange.Fire(self.Object, state, nil)
        end
    end
end
