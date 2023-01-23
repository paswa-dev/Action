local CHS = game:GetService("ChangeHistoryService")
local http = game:GetService("HttpService")
local selection = game:GetService("Selection")
local toolbar = plugin:CreateToolbar("Github Utility")

local config_button = toolbar:CreateButton("Settings", "Settings")
local commit_button = toolbar:CreateButton("Commit", "Commit")
local init_button = toolbar:CreateButton("Init", "Init")

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

local function replace(message, char_old, char_new)
    local final = ""
    for i=1, string.len(message) do
        local char = string.sub(final, i, i)
        if char == char_old then
            final = final .. char_new
        else
            final = final .. char
        end
    end
end

local function get(endpoint, payload)
    if not settings.github_name or not settings.github_token then return end
    local headers = {
        ["Authorization"] = "TOKEN" .. settings.github_token,
        ["Accept"] = "application/vnd.github.v3+json",
        ["X-GitHub-Api-Version"]: "2022-11-28"
    }

    local response = http:PostAsync(github_api .. endpoint, http:JSONEncode(payload), Enum.HttpContentType.ApplicationJson, false, headers)
    return response
end

config_button.Click:Connect(function()
    for name, value in pairs(settings) do 
        -- Show prompt with an input, or create a entire UI with indivual prompts.
    end
    -- Show UI and settings
end)

commit_button.Click:Connect(function()
    if not settings.repo_name then return end -- Basically make it so that a prompt shows.
end)


init_button.Click:Connect(function()
    local folders = {}
    for _, file in next, game:GetDescendents() do
        if file:IsA('Folder') and file.Parent:IsA("Folder") then
            local location = file:GetFullName()
            replace(location, ".", "/")
        end
    end
end)

