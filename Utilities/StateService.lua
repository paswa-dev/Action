local module = {}
if (not _G.global_states) then
    _G.global_states = {}
end
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
    _G.global_states[object] = states
end

function module.Remove(object)
    _G.global_states[object] = nil
end

function module.Clear(object)
    _G.global_states[object] = {}
end

function module.SetObject(object, new_object)
    local c = _G.global_states[object]
    _G.global_states[object] = nil
    _G.global_states[new_object] = c

end

function module.AddState(object, state)
    if table.find(_G.global_states[object], state) then
        return debug.traceback("State already exists.")
    else
        self.OnStateChange.Fire(object, state, "A")
        table.insert(_G.global_states[object], state)
    end
end


function module.RemoveState(object, state)
    local success, err = pcall(function()
        table.remove(_G.global_states[object], table.find(_G.global_states[object], state))
    end)

    if not success then
        return debug.traceback("Error when attempting to remove non-existing state.")
    elseif success then
        self.OnStateChange.Fire(object, state, "R")
    end
end

function module.AppendStates(object, states: {any})
    for _, state in ipairs(states) do
        if table.find(_G.global_states[object], state) then
            debug.traceback("State already exists. Skipping...")
        else
            self.OnStateChange.Fire(object, state, "A")
            table.insert(_G.global_states[object], state)
        end
    end
end

function module.RemoveStates(object, states: {any})
    for _, state in ipairs(states) do
        local success, err = pcall(function()
            table.remove(_G.global_states[object], table.find(_G.global_states[object], state))
        end)
    
        if not success then
            debug.traceback("Error when attempting to remove non-existing state.")
        elseif success then
            self.OnStateChange.Fire(object, state, "R")
        end
    end
end
