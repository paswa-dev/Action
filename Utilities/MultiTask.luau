local MultiTask = {}
local MT = {__index = MultiTask}

local function checkCallingFunctionForParralel()
    local calling_script = getfenv(2)
    if not calling_script then return nil end
    if calling_script.Parent:IsA("Actor") then return true end
    return false
end

function MultiTask.Process(parrallel_function, serial_function)
    task.desynchronize()
    parrallel_function()
    task.synchronize()
    serial_function()
end

function MultiTask.Thread(thread_function)
    local Config = {}
    setmetatable(Config, MT)
    Config = {
        suspended = false,
        thread = coroutine.create(function()
            local passed
            while true do
                local results = thread_function(suspended, table.unpack(passed))
                passed = table.pack(coroutine.yield(results))
            end
        end)
    }
    return Config
end

function MultiTask:Call(...)
    if suspended then return end
    return coroutine.resume(self.thread, ...)
end

function MultiTask:State()
    return coroutine.status(self.thread)
end

function MultiTask:Suspend(value : boolean)
    self.suspended = value or true
end



return MultiTask