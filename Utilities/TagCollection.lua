local Tag = game:GetService("CollectionService")
local init = false

local module = {}
module.actions = {}


local function runTag(tag, func)
    if not func then return end
    local tagged = Tag:GetTagged(tag)
    if not tagged then table.remove(tagged); return end
    for _, object in next, Tag:GetTagged(tag) do
        func(object)
    end
end

local function init()
    for _, tag in next, tag:GetAllTags() do
        Tag:GetInstanceAddedSignal(tag, function() module.actions[tag].start end)
        Tag:GetInstanceRemovedSignal(tag, function() module.actions[tag].end end)
        if module.actions[tag] then runTag(tag, module.actions[tag].start) end
        
    end)
    init = true
end

function module:Created(tag, func)
    if init then
        runTag(tag, func)
    else
        if not module.actions[tag] then module.actions[tag] = {} end
        module.actions[tag].start = func
    end
end

function module:Removed(tag, func)
    if not module.actions[tag] then module.actions[tag] = {} end
    module.actions[tag].end = func
    -- When is removed do this
end

init()

return module