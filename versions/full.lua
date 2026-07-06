--// DeepSearch v12 - Full Version (Complete)
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = game.Players.LocalPlayer

-- Variables
local currentLogs = {}
local importantFindings = {}
local currentWordbankType = "main"
local perfMode = "normal"
local autoSave = true

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearch"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 880, 0, 560)
main.Position = UDim2.new(0.5, -440, 0.5, -280)
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
title.Text = "DeepSearch v12"
title.TextColor3 = Color3.fromRGB(200, 200, 220)
title.TextScaled = true
title.Font = Enum.Font.Code
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = titleBar

-- Console
local console = Instance.new("ScrollingFrame")
console.Size = UDim2.new(1, -160, 1, -45)
console.Position = UDim2.new(0, 150, 0, 34)
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
sidebar.Size = UDim2.new(0, 140, 1, -38)
sidebar.Position = UDim2.new(0, 6, 0, 32)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
sidebar.Parent = main

local function log(text)
    local ts = os.date("%H:%M:%S")
    local line = "["..ts.."] "..text
    table.insert(currentLogs, line)
    if #currentLogs > 60 then table.remove(currentLogs, 1) end
    output.Text = table.concat(currentLogs, "\n")
    console.CanvasPosition = Vector2.new(0, console.AbsoluteCanvasSize.Y)
end

-- Wordbanks
local mainWordbank = {}
local priorityWordbank = {}

local function loadWordbanks()
    local s1, d1 = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/TunaCANNN/DeepSearch/refs/heads/main/wordbanks/main.json")
    end)
    if s1 and d1 then mainWordbank = HttpService:JSONDecode(d1) end

    local s2, d2 = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/TunaCANNN/DeepSearch/refs/heads/main/wordbanks/priority.json")
    end)
    if s2 and d2 then priorityWordbank = HttpService:JSONDecode(d2) end

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

-- High Value Items
local HighValue = {
    ["FireEvent"] = "RemoteEvent → Rapid fire / No recoil",
    ["ReloadEvent"] = "RemoteEvent → Instant reload",
    ["Stats"] = "Weapon stats folder → Can modify damage",
    ["IsAmmo"] = "Ammo marker",
    ["MaxAmmo"] = "Max ammo value",
}

local function getFlag(obj)
    if obj:IsA("Script") or obj:IsA("LocalScript") then
        if obj.Disabled == false then return "Active Script" end
    end
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        return "Remote Event/Function"
    end
    return nil
end

-- Main Scan
local function runScan(mode)
    log("Starting " .. mode .. " scan (" .. currentWordbankType .. ")...")
    local keywords = getKeywords()
    local found = 0

    for _, v in ipairs(game:GetDescendants()) do
        for _, kw in ipairs(keywords) do
            if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                local high = HighValue[v.Name]
                local flag = getFlag(v)

                if high then
                    log("→ " .. v:GetFullName() .. " | " .. high)
                    table.insert(importantFindings, v:GetFullName() .. " → " .. high)
                elseif flag then
                    log("→ " .. v:GetFullName() .. " | " .. flag)
                else
                    log("→ " .. v:GetFullName())
                end
                found += 1
                break
            end
        end
    end

    log("Scan complete. Found " .. found .. " matches.")
end

-- Important UI
local function showImportantUI()
    local importantGui = Instance.new("ScreenGui")
    importantGui.Name = "ImportantFindings"
    importantGui.ResetOnSpawn = false
    importantGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 500, 0, 400)
    frame.Position = UDim2.new(0.5, -250, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    frame.BorderSizePixel = 0
    frame.Parent = importantGui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    topBar.Parent = frame

    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

    local icon = Instance.new("Frame")
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.Position = UDim2.new(1, -26, 0.5, -9)
    icon.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    icon.Rotation = 45
    icon.Parent = topBar
    Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 3)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Important Findings"
    titleLabel.TextColor3 = Color3.fromRGB(220, 100, 100)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.Code
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -40)
    content.Position = UDim2.new(0, 10, 0, 35)
    content.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    content.ScrollBarThickness = 5
    content.Parent = frame

    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -10, 1, 0)
    contentLabel.BackgroundTransparency = 1
    contentLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.Font = Enum.Font.Code
    contentLabel.TextSize = 14
    contentLabel.TextWrapped = true
    contentLabel.Parent = content

    if #importantFindings == 0 then
        contentLabel.Text = "No important items found yet.\nRun a scan first."
    else
        local text = ""
        for _, finding in ipairs(importantFindings) do
            text = text .. finding .. "\n\n"
        end
        contentLabel.Text = text
    end
end

-- Button Creator
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 28)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 10, 42)
    btn.TextColor3 = Color3.fromRGB(200, 150, 255)
    btn.Text = text
    btn.Font = Enum.Font.Code
    btn.TextSize = 12
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- Buttons
local y = 6
createButton("Quick Scan", y, function() runScan("quick") end); y += 32
createButton("Deep Scan", y, function() runScan("deep") end); y += 32
createButton("Full Scan", y, function() runScan("full") end); y += 32
createButton("Main Wordbank", y, function()
    currentWordbankType = "main"
    log("Switched to Main Wordbank")
end); y += 32
createButton("Priority Wordbank", y, function()
    currentWordbankType = "priority"
    log("Switched to Priority Wordbank")
end); y += 32
createButton("Important", y, function()
    showImportantUI()
end); y += 32
createButton("Copy Logs", y, function()
    if setclipboard then setclipboard(table.concat(currentLogs, "\n")) end
end); y += 32
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
log("DeepSearch v12 Full loaded.")
log("Press RightShift to toggle UI.")
