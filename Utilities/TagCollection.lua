local Tag = game:GetService("CollectionService")
local init = false

local module = {}
module.actions = {}

local function runTag(tag, func)
    if not func then return end
    for _, object in next, Tag:GetTagged(tag) do
        func(object)
    end
end

local function init()
    for _, tag in next, tag:GetTags() do
        runTag(tag, module.actions[tag])
    end)
    init = true
end

function module:Created(tag, func)
    if init then
        runTag(tag, func)
    else
        module.actions[tag] = func
    end
end

function module:Removed(tag, func)
    -- When is removed do this
end

init()

return module