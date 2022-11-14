local module = {}

local e = 2.71828182846 -- Natural Log (Should i add?)
local g = 9.81 -- gravity
local pi = math.pi -- Pi

-- Formula for reference
-- https://wikimedia.org/api/rest_v1/media/math/render/svg/6a1f2a92d197cce47f77a919abe207d61bc57c92



function module.wave(position, wave_length, steepness, direction_2d, _time, time_constant)
    time_constant = time_constant or 1
    local k = ( 2 * pi ) / wave_length -- Wave Number (Non linear)
    local k_steep = steepness/k -- Steepness
    local d = direction_2d.Unit -- X/Z -> X,Y
    local c = math.sqrt(g/k) -- Phase Speed
    local f = k * d:Dot(Vector2.new(position.X, position.Y)) - c * (_time/time_constant)
    --        wave_number * (angle between direction and point) - phase_speed * time

    local f_cos = math.cos(f)

    local x = d.X * (k_steep * f_cos)
    local y = k_steep * math.sin(f)
    local z = d.Y * (k_steep * f_cos)
    return Vector3.new(x,y,z)
end


return module