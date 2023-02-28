local textService = game:GetService("TextService")

local RichText = {}
RichText.Defaults = {
    TextSize = 20,
    TextScaled = true,
    Font = Enum.Font.Arial,
    TextStrokeColor3 = Color3.new(1,1,1),
    TextColor3 = Color3.new(1,1,1),
    TextStrokeTransparency = 1,
    TextTransparency = 0,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center,
}

RichText.__index = RichText


function RichText.new(ui_element)
    local self = {}
    self.Text = ""
    self.Root = ui_element
    return setmetatable(self, RichText)
end

function RichText:Animate(yield)
    local current_position = Vector2.new(0,0)

    local function applyMarkup(text_label)

    end

    local function changeSetting(option, value)
        if self.TextInformation[option] then
            if value == "/" then
                self.TextInformation = self.Defaults[option]
            else
                if string.match(option, "Color3") then
                    local r, g, b = string.match(value, "%d%.%d%.%d")
                    if not r or not g or not b then
                        return "Not valid."
                    end
                    r, g, b = math.clamp(r, 0, 1), math.clamp(g, 0, 1), math.clamp(b, 0, 1)
                    value = Color3.new(r, g, b)
                elseif value == "true" then
                    value = true
                elseif value == "false" then
                    value = false
                end
                self.TextInformation[option] = value
            end
            
        end
        
    end
    
    local function compileText(text)
        self.TextInformation = self.Defaults
        local removed
        for index, value in string.gmatch(text, "%a") do
            local option, value = string.match(text, "<(.+)=(.+)>", index)
            changeSetting(option, value)
            local character = Instance.new("TextLabel")

        end
    end


    

end


return RichText
