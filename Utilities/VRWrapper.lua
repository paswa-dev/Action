local VR = game:GetService("VRService")

local VRWrap = {}
VRWrap.ACTIVE_CONTROLLERS = {}
VRWrap.__index = VRWrap

-- VRService

function VRWrap.VRController(player, model)
    if not VR.VREnabled then
        debug.traceback("Player does not support a VRController")
        return
    end

    local self = {} 
    self.model = model
    self.controller_host = player
    self.CFrame_changed = 

    table.insert(VRWrap.ACTIVE_CONTROLLERS, self)
    return setmetatable(self, VRWrap)
end

return VRWrap