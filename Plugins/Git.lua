local CHS = game:GetService("ChangeHistoryService")
local http = game:GetService("HttpService")
local selection = game:GetService("Selection")
local toolbar = plugin:CreateToolbar("GitRo")

local config_button = toolbar:CreateButton("Settings", "Settings")
local commit_button = toolbar:CreateButton("Commit", "Commit")
local connect_button = toolbar:CreateButton("Connect", "Connect")

local github_api = "https://api.github.com"
local username = game.Players.LocalPlayer.Name .. "/" ..game.Players.LocalPlayer.UserId,

--https://docs.github.com/en/rest/repos/contents?apiVersion=2022-11-28#create-or-update-file-contents

local history = {}

local settings = {
    github_token = "",
    github_name = "",
    github_email = "",
    github_account_name = "",
    repo_name = ""
}

local function get(endpoint, payload)
    if not settings.github_name or not settings.github_token then return end
    local headers = {
        Authorization = "TOKEN" .. settings.github_token,
        Accept = "application/vnd.github.v3+json",
        ["X-GitHub-Api-Version"]: "2022-11-28"
    }

    local response = http:PostAsync(github_api .. endpoint, http:JSONEncode(payload), Enum.HttpContentType.ApplicationJson, false, headers)
    return response
end

config_button.Click:Connect(function()
    -- Show UI and settings
end)

commit_button.Click:Connect(function()
    --Commit to the github address
end)
