--// DeepSearch v12 - Lite Version (For weaker executors)
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = game.Players.LocalPlayer

local currentLogs = {}
local perfMode = "light"
local autoSave = true

local function log(text)
    local ts = os.date("%H:%M:%S")
    local line = "["..ts.."] "..text
    table.insert(currentLogs, line)
    if #currentLogs > 50 then table.remove(currentLogs, 1) end
    print(line)
end

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
        return keywords
    end
    return {}
end

local function runScan(mode)
    log("Starting " .. mode .. " scan (Lite)...")
    local keywords = loadWordBank()

    local found = 0
    for _, v in ipairs(game:GetDescendants()) do
        if perfMode == "light" and math.random() > 0.6 then continue end

        for _, kw in ipairs(keywords) do
            if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                log("→ " .. v:GetFullName())
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

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        print("[DeepSearch Lite] Toggle UI (UI not included in lite version)")
    end
end)

log("DeepSearch Lite Version loaded.")
log("Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown"))
log("User: " .. player.Name)
