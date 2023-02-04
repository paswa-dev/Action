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

local function __init__()
	for _, tag in next, Tag:GetAllTags() do
		Tag:GetInstanceAddedSignal(tag):Connect(function(obj) module.actions[tag].START(obj) end)
		Tag:GetInstanceRemovedSignal(tag):Connect(function(obj) module.actions[tag].END(obj) end)
		if module.actions[tag] then runTag(tag, module.actions[tag].START) end
	end
	init = true
end

function module:Created(tag, func)
	if init then
		runTag(tag, func)
	else
		if not module.actions[tag] then module.actions[tag] = {} end
		module.actions[tag].START = func
	end
end

function module:Removed(tag, func)
	if not module.actions[tag] then module.actions[tag] = {} end
	module.actions[tag].END = func
-- When is removed do this
end

__init__()

return module
