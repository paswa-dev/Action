local ServerData = {}

local onServerClose = Instance.new("BindableEvent")

function _G.ServerLoad(data: {any})
    ServerData = data
end

function _G.ServerSave(name, data)
    if not data then
        debug.traceback("No data provided")
        return nil
    elseif not name then
        debug.traceback("No name/scope was provided")
        return nil
    end
    ServerData[name] = data
end

function _G.ServerGet(name)
    name = ServerData[name] or ServerData
    if not name then
        debug.traceback("No data by that name exists.")
        return nil
    end
    return name
end

game:BindToClosed(function()
    onServerClose.Fire()
end)


