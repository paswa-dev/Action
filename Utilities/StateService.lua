local module = {}
module.global_states = {}
module.__index = module

module.OnStateChange = Instance.new("BindableEvent")
module.OnObjectChange = Instance.new("BindableEvent")

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
    module.global_states[object] = states
end

function module.Remove(object)
    module.global_states[object] = nil
end

function module.Clear(object)
    module.global_states[object] = {}
end

function module.SetObject(object, new_object)
    local c = module.global_states[object]
    module.global_states[object] = nil
    module.global_states[new_object] = c

end

function module.AddState(object, state)
    if table.find(module.global_states[object], state) then
        return debug.traceback("State already exists.")
    else
        self.OnStateChange.Fire(object, state, "A")
        table.insert(module.global_states[object], state)
    end
end


function module.RemoveState(object, state)
    local success, err = pcall(function()
        table.remove(module.global_states[object], table.find(module.global_states[object], state))
    end)

    if not success then
        return debug.traceback("Error when attempting to remove non-existing state.")
    elseif success then
        self.OnStateChange.Fire(object, state, "R")
    end
end

function module.AppendStates(object, states: {any})
    for _, state in ipairs(states) do
        if table.find(module.global_states[object], state) then
            debug.traceback("State already exists. Skipping...")
        else
            self.OnStateChange.Fire(object, state, "A")
            table.insert(module.global_states[object], state)
        end
    end
end

function module.RemoveStates(object, states: {any})
    for _, state in ipairs(states) do
        local success, err = pcall(function()
            table.remove(module.global_states[object], table.find(module.global_states[object], state))
        end)
    
        if not success then
            debug.traceback("Error when attempting to remove non-existing state.")
        elseif success then
            self.OnStateChange.Fire(object, state, "R")
        end
    end
end
