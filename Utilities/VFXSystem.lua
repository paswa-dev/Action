local vfx = {}
vfx.__index = vfx

function vfx.new(location, name)
    local file
    if not name then local file = location else file=location[name] end
    if not file then debug.trackback("File does not exists.") return end
    
    local config = {}
    config.emitters = {}

    for i, v in next, file:GetDescendents() do
        if v:IsA("ParticleEmitter") then
            table.insert(config.emitters, {emitter=v, amount=50, delay=nil})
        end
    end

    return setmetatable(config, vfx)
end

function vfx:OverrideConfig(new_config)
    for i, v in next, new_config do
        self.emitters[i].amount = (v.amount or self.emitters[i].amount)
        self.emitters[i].delay = (v.delay or self.emitters[i].delay)
    end
end

function vfx:Charge(global_delay)
    local looped = true
    task.spawn(function()
        while task.wait() do
            task.wait()
            self:Play()
            if not looped then break end
        end
    end)
    return function()
        looped = false
    end
end

function vfx:Play(amount)
    for i, v in next, emitters do
        if v.delay then task.wait(v.delay) end
        v.emitter:Emit(v.amount)
    end
end

return vfx