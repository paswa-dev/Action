
local prompt = {}
prompt.storage = {}
prompt.activated = {}
prompt.object = nil
prompt.Enums = {
    enter = 1,
    leave = 0
}


local function get_distance(x1, x2)
    return (x1-x2).Magnitude
end


task.spawn(function()
    while task.wait() do
        if not object then return end
        for i, v in next, prompt.storage then
            pcall(function()
                local index = table.find(prompt.activated, i)
                local d = get_distance(prompt.object.Position, i.Position)
                if ( d >= v.radius) and not index then
                    table.insert(prompt.activated, i)
                    v.func(1)
                elseif ( d < v.radius) and index then
                    table.remove(prompt.activated, index)
                    v.func(0)
                end
            end)
        end
    end
end)

function prompt.new(adornee, radius, callback)
    prompt.storage[adornee] = {func=callback, radius=radius}
end

function prompt.remove(adornee)
    prompt.storage[adornee] = nil
end

return prompt

