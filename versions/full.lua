--// DeepSearch v12 - Full Version (Modern UI + Staged Scanning)
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = game.Players.LocalPlayer

-- Variables
local currentLogs = {}
local perfMode = "normal"
local autoSave = true

local function log(text)
    local ts = os.date("%H:%M:%S")
    local line = "["..ts.."] "..text
    table.insert(currentLogs, line)
    if #currentLogs > 65 then table.remove(currentLogs, 1) end
    print(line) -- Will be replaced with UI later
end

-- WordBank
local WORDBANK_URL = "https://raw.githubusercontent.com/YOUR_USERNAME/DeepSearch/main/wordbanks/main.json"

local function loadWordBank()
    local success, data = pcall(function()
        return game:HttpGet(WORDBANK_URL)
    end)

    if success and data then
        local decoded = HttpService:JSONDecode(data)
        local keywords = {}
        for _, list in pairs(decoded) do
            for _, word in ipairs(list) do
                table.insert(keywords, word)
            end
        end
        log("Word bank loaded (" .. #keywords .. " words)")
        return keywords
    else
        log("Failed to load word bank")
        return {}
    end
end

-- High Value Detection
local HighValue = {
    ["FireEvent"] = "RemoteEvent → Rapid fire / No recoil",
    ["ReloadEvent"] = "RemoteEvent → Instant reload",
    ["Stats"] = "Weapon stats folder",
    ["IsAmmo"] = "Ammo marker",
    ["MaxAmmo"] = "Max ammo value",
}

local function getFlagInfo(obj)
    if obj:IsA("Script") or obj:IsA("LocalScript") then
        if obj.Disabled == false then return "Active Script" end
        if obj:FindFirstChild("RunContext") then return "Has RunContext" end
    end
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        return "Remote Event/Function"
    end
    return nil
end

-- Main Scan Function
local function runScan(mode)
    log("Starting " .. mode .. " scan...")
    local keywords = loadWordBank()

    local found = 0
    for _, v in ipairs(game:GetDescendants()) do
        if perfMode == "light" and math.random() > 0.5 then continue end

        for _, kw in ipairs(keywords) do
            if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                local flag = getFlagInfo(v)
                local high = HighValue[v.Name]

                if high then
                    log("→ " .. v:GetFullName() .. " | " .. high)
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

    if autoSave and writefile then
        local name = "DeepSearch_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"
        writefile(name, table.concat(currentLogs, "\n"))
    end
end

-- Keybind (RightShift)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        print("[DeepSearch] Toggle UI (UI will be added)")
    end
end)

-- Startup
log("DeepSearch Full Version loaded.")
log("Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown"))
log("User: " .. player.Name)
