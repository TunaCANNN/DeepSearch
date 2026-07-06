--// DeepSearch v12 - Lite Version (Fixed Layout)
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearchLite"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 720, 0, 420)
main.Position = UDim2.new(0.5, -360, 0.5, -210)
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

-- Console (Fixed - no longer cut off)
local console = Instance.new("ScrollingFrame")
console.Size = UDim2.new(1, -130, 1, -45)
console.Position = UDim2.new(0, 125, 0, 34)
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

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 118, 1, -38)
sidebar.Position = UDim2.new(0, 5, 0, 32)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
sidebar.Parent = main

local currentLogs = {}
local currentWordbankType = "main"

local function log(text)
    local ts = os.date("%H:%M:%S")
    local line = "["..ts.."] "..text
    table.insert(currentLogs, line)
    if #currentLogs > 50 then table.remove(currentLogs, 1) end
    output.Text = table.concat(currentLogs, "\n")
    console.CanvasPosition = Vector2.new(0, console.AbsoluteCanvasSize.Y)
end

-- Wordbanks
local mainWordbank = {}
local priorityWordbank = {}

local function loadWordbanks()
    local success1, data1 = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/TunaCANNN/DeepSearch/refs/heads/main/wordbanks/main.json")
    end)
    if success1 and data1 then mainWordbank = HttpService:JSONDecode(data1) end

    local success2, data2 = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/TunaCANNN/DeepSearch/refs/heads/main/wordbanks/priority.json")
    end)
    if success2 and data2 then priorityWordbank = HttpService:JSONDecode(data2) end

    log("Wordbanks loaded.")
end

local function getKeywords()
    if currentWordbankType == "main" then
        local keywords = {}
        for _, list in pairs(mainWordbank) do
            for _, word in ipairs(list) do table.insert(keywords, word) end
        end
        return keywords
    else
        return priorityWordbank.HighPriority or {}
    end
end

local function runScan(mode)
    log("Starting " .. mode .. " scan (" .. currentWordbankType .. ")...")
    local keywords = getKeywords()
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

-- Button Creator
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 26)
    btn.Position = UDim2.new(0, 4, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 10, 42)
    btn.TextColor3 = Color3.fromRGB(200, 150, 255)
    btn.Text = text
    btn.Font = Enum.Font.Code
    btn.TextSize = 11
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- Buttons
local y = 6
createButton("Quick Scan", y, function() runScan("quick") end); y += 30
createButton("Deep Scan", y, function() runScan("deep") end); y += 30
createButton("Main Wordbank", y, function()
    currentWordbankType = "main"
    log("Switched to Main Wordbank")
end); y += 30
createButton("Priority Wordbank", y, function()
    currentWordbankType = "priority"
    log("Switched to Priority Wordbank")
end); y += 30
createButton("Copy Logs", y, function()
    if setclipboard then setclipboard(table.concat(currentLogs, "\n")) end
end); y += 30
createButton("Clear Logs", y, function()
    currentLogs = {}
    output.Text = ""
end)

-- Keybind
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- Startup
loadWordbanks()
log("DeepSearch Lite loaded.")
log("Press RightShift to toggle UI.")
