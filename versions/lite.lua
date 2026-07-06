--// DeepSearch v12 - Lite Version
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = game.Players.LocalPlayer

-- Simple UI
local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearchLite"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 700, 0, 420)
main.Position = UDim2.new(0.5, -350, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(14, 14, 19)
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "DeepSearch v12 - Lite"
title.TextColor3 = Color3.fromRGB(200, 200, 220)
title.TextScaled = true
title.Font = Enum.Font.Code
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = titleBar

local console = Instance.new("ScrollingFrame")
console.Size = UDim2.new(1, -20, 1, -45)
console.Position = UDim2.new(0, 10, 0, 35)
console.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
console.ScrollBarThickness = 5
console.Parent = main

local output = Instance.new("TextLabel")
output.Size = UDim2.new(1, -8, 1, 0)
output.BackgroundTransparency = 1
output.TextColor3 = Color3.fromRGB(180, 100, 255)
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextYAlignment = Enum.TextYAlignment.Top
output.Font = Enum.Font.Code
output.TextSize = 13
output.TextWrapped = true
output.Parent = console

local currentLogs = {}

local function log(text)
    local ts = os.date("%H:%M:%S")
    local line = "["..ts.."] "..text
    table.insert(currentLogs, line)
    if #currentLogs > 50 then table.remove(currentLogs, 1) end
    output.Text = table.concat(currentLogs, "\n")
    console.CanvasPosition = Vector2.new(0, console.AbsoluteCanvasSize.Y)
end

-- WordBank
local function loadWordBank()
    local success, data = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/TunaCANNN/DeepSearch/refs/heads/main/wordbanks/main.json")
    end)
    if success and data then
        local decoded = HttpService:JSONDecode(data)
        local keywords = {}
        for _, list in pairs(decoded) do
            for _, word in ipairs(list) do
                table.insert(keywords, word)
            end
        end
        return keywords
    end
    return {}
end

local function runScan(mode)
    log("Starting " .. mode .. " scan (Lite)...")
    local keywords = loadWordBank()
    local found = 0

    for _, v in ipairs(game:GetDescendants()) do
        for _, kw in ipairs(keywords) do
            if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                log("→ " .. v:GetFullName())
                found += 1
                break
            end
        end
    end

    log("Scan complete. Found " .. found .. " matches.")
end

-- Keybind
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

log("DeepSearch Lite Version loaded.")
log("Press RightShift to toggle UI.")
