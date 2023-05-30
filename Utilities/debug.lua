local db = game:GetService("Debris")
local rs = game:GetService("RunService")
local log_service = game:GetService("LogService")
local http = game:GetService("HttpService")
local FastSignal = require(script.Parent.FastSignal)
local camera = game.Workspace.CurrentCamera
local player, PlayerGui, errorBin

local debugC, Pin = { Pins = {} }, {}
local PinMT = {__index = Pin}

--[[
	Fix coroutine calculations?,
	Make sure config can be updated and recieved via the coroutine. If not add config as parameters and pass,
	Remove Comments,
	Fix module structure and functions,
	Renaming,
	Multiprocessing or Multithreading? - Non-shared memory or shared memory. Race conditions common.
]]

local message_colors = {
	[Enum.MessageType.MessageInfo] = Color3.new(0.533333, 1, 0),
	[Enum.MessageType.MessageOutput] = Color3.new(1, 1, 1),
	[Enum.MessageType.MessageWarning] = Color3.new(1, 0.666667, 0.12549),
	[Enum.MessageType.MessageError] = Color3.new(1, 0.262745, 0.113725)
}

local function MiniSignal(a)
	local Options = {}
	Options.OnChange = FastSignal.new()
	function Options.Set(value)
		Options.OnChange:Fire(value)
	end
	return Options
end

local function UI(component)
	local OK, obj = pcall(Instance.new, component)
	if OK then
		return function(data)
			for key, value in pairs(data) do
				obj[key] = value
			end
			return obj
		end
	end

end

local function createErrorDisplayer(error_text, color)
	local message = UI "TextLabel" {
		Name = "Message",
		Text = error_text or "Nil Error",
		FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json"),
		TextColor3 = color,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(0.335, 0.02),
		AutomaticSize = Enum.AutomaticSize.XY
	}

	--

	local uITextSizeConstraint = UI "UITextSizeConstraint" {
		Name = "UITextSizeConstraint",
		MaxTextSize = 13,
		Parent = message
	}

	message.Parent = errorBin
	return message
end

function debugC.Init()
	log_service.MessageOut:Connect(debugC.AddEntry)

	player = game:GetService("Players").LocalPlayer
	PlayerGui = player:WaitForChild("PlayerGui")

	local errorScreening = UI "ScreenGui" {
		Name = "ErrorScreening",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false
	}

	local uIListLayout = UI "UIListLayout" {
		Name = "UIListLayout",
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Parent = errorScreening
	}

	errorScreening.Parent = PlayerGui
	errorBin = errorScreening
end

function debugC.AddEntry(text, message_type_or_color, duration)
	local color = message_colors[message_type_or_color] or message_type_or_color
	local errorObject = createErrorDisplayer(text, color)
	db:AddItem(errorObject, duration or 4)
end

function debugC.Traceback(text, color, duration)
	local EnviormentCaller = getfenv(2).script:GetFullName()
	local NewText = string.format("[%s : %d] %s", EnviormentCaller, tick(), text)
	debugC.AddEntry(NewText, color, duration)
end

function debugC.CreatePin(name)
	local config = {}
	local ID = http:GenerateGUID(false)
	config.Name = name
	config.TaskID = ID
	config.PinData = {}
	config.Connections = {}
	config.Enabled = false
	config.Parent = UI "ScreenGui" {
		Name = "Debug" .. ID,
		Parent = PlayerGui
	}
	config.Root = UI "Frame" {
		Name = ID,
		Parent = config.Parent,
		AnchorPoint = Vector2.new(0.5,0.5),
		Size = UDim2.fromScale(0.1, 0.1),
		BackgroundTransparency = 1
	}
	config.WorldPosition = Vector3.new(5,5,5)
	config.Adornee = nil
	config.OpenThread = coroutine.create(function()
		while true do
			if config.Adornee then config.WorldPosition = config.Adornee.CFrame.Position end
			local vector, onScreen = camera:WorldToScreenPoint(config.WorldPosition)
			if not onScreen then
				config.Root.Visible = false
			elseif onScreen then
				if not config.Root.Visible then config.Root.Visible = true end
				config.Root.Position = UDim2.fromOffset(vector.X, vector.Y)
			end
			coroutine.yield()
		end
	end)


	local _ = UI "UIListLayout" {
		Parent = config.Root,
		Name = "ListLayout",
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom
	}

	setmetatable(config, PinMT)
	debugC.Pins[name] = config
	return config
end

function debugC.DestroyPin(name)
	assert(debugC.Pins[name], `Failed to find {name} in Debug.Pins.`)
	debugC.Pins[name]:Destroy()
end

function Pin:Add(name : string, value : any)
	local Signal = MiniSignal(value)
	local Label = UI "TextLabel" {
		Name = name,
		Text = name .. "=" .. tostring(value),
		FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json"),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 15,
		Parent = self.Root
	}
	UI "UITextSizeConstraint" {
		MaxTextSize = 13,
		Parent = Label
	}
	self.Connections[name] = Signal.OnChange:Connect(function(value)
		Label.Text = name .. "=" .. tostring(value)
	end)
	self.PinData[name] = Signal
	return Label
end

function Pin:UpdateValue(name : string, value : any)
	local pin = self.PinData[name]
	if (not pin) or (not self.Enabled) then return end
	pin.Set(value)
end

function Pin:Remove(name : string)
	assert(self.PinData[name], `Failed to find {name} in PinData`)
	self.Connections[name]:Disconnect()
	self.PinData[name].OnChange:Destroy()
	self.PinData[name], self.Connections[name] = nil, nil
	self.Root[name]:Destroy()
end

function Pin:RemoveAll()
	for pin, _ in pairs(self.PinData) do
		self:Remove(pin)
	end
end

function Pin:Enable()
	if self.Enabled then return end
	if #self.Root:GetChildren() == 0 then return end
	rs:BindToRenderStep(self.TaskID, 100, function()
		coroutine.resume(self.OpenThread)
	end)
	self.Enabled = true
end

function Pin:Disable()
	if not self.Enabled then return end
	rs:UnbindFromRenderStep(self.TaskID)
	self.Root.Visible = false
	self.Enabled = false
end

function Pin:Destroy()
	local name do
		name = self.Name
		self:Disable()
		self:RemoveAll()
		coroutine.close(self.OpenThread)
		self.Parent:Destroy()
		for i, v_ in pairs(self) do
			self[i] = nil
		end
		self = nil
	end

	debugC.Pins[name] = nil
end

return debugC
