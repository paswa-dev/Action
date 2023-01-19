local VR = game:GetService("VRService")

local VRWrap = {}
VRWrap.__index = VRWrap

-- VRService

function VRWrap.VRController(model)
    if not VR.VREnabled then
        debug.traceback("Player does not support a VRController")
        return
    end

    local self = {} 
    self.model = model
    self.controller_host = player
    self.CFrameChanged = VR.UserCFrameChanged

    return setmetatable(self, VRWrap)
end

function VRWrap:Destroy()
    self.model:Destroy()
    self = nil
end

function VRWrap:BindJoint()
    
end

return VRWrap