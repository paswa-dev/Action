
local prompt = {}
prompt.storage = {}
prompt.activated = {}
prompt.object = nil


local function get_distance(x1, x2)
    return (x1-x2).Magnitude
end


task.spawn(function()
    while task.wait() do
        if not object then return
        for i, v in next, prompt.storage then
            local index = table.find(prompt.activated, i)
            local d = get_distance(prompt.object.Position, i.Position)
            if ( d >= v.radius) and not index then
                table.insert(prompt.activated, i)
                v.enter()
            elseif ( d < v.radius) and index then
                table.remove(prompt.activated, index)
                v.leave()
            end
        end
    end
end)

function prompt.new(adornee, enter_callback, leave_callback, radius)
    prompt.storage[adornee] = {enter=enter_callback, leave=leave_callback, radius=radius}
end

function prompt.remove(adornee)
    prompt.storage[adornee] = nil
end

return prompt

