local CHS = game:GetService("ChangeHistoryService")
local http = game:GetService("HTTPService")
local selection = game:GetService("Selection")
local toolbar = plugin:CreateToolbar("GitRo")

local config_button = toolbar:CreateButton("Settings", "Settings")
local commit_button = toolbar:CreateButton("Commit", "Commit")
local connect_button = toolbar:CreateButton("Connect", "Connect")

local github_api = "https://api.github.com"
local complete_address = ""

local history = {}
local settings = {
    github_token = ,
    username = game.Players.LocalPlayer.Name .. "/" ..game.Players.LocalPlayer.UserId,
    github_name = ""
}



config_button.Click:Connect(function()
    -- Show UI and settings
end)

commit_button.Click:Connect(function()
    --Commit to the github address
end)

connect_button.Click:Connect(function()
    if not settings.github_name or not settings.github_token then return end
    local payload = {["name"]=settings.github_name}
end)
