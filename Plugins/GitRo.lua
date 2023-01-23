local CHS = game:GetService("ChangeHistoryService")
local selection = game:GetService("Selection")
local toolbar = plugin:CreateToolbar("GitRo")

local config_button = toolbar:CreateButton("Settings", "Settings")
local commit_button = toolbar:CreateButton("Commit", "Commit")

local history = {}
local settings = {
    github = "",
    username = game.Players.LocalPlayer.Name .. "/" ..game.Players.LocalPlayer.UserId
}

config_button.Click:Connect(function()
    -- Show UI and settings
end)

commit_button = 