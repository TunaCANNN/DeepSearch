--// DeepSearch v12 - Scanner Module (Staged + Prioritized)

local HttpService = game:GetService("HttpService")

local Scanner = {}

-- Load wordbank
function Scanner.loadWordBank(url)
    local success, data = pcall(function()
        return game:HttpGet(url)
    end)

    if success and data then
        return HttpService:JSONDecode(data)
    end
    return {}
end

-- Flatten all keywords from categories
function Scanner.getAllKeywords(wordbank)
    local keywords = {}
    for _, list in pairs(wordbank) do
        for _, word in ipairs(list) do
            table.insert(keywords, word)
        end
    end
    return keywords
end

-- Get keywords from specific category
function Scanner.getCategoryKeywords(wordbank, category)
    return wordbank[category] or {}
end

-- High value detection
local HighValueMap = {
    ["FireEvent"] = "RemoteEvent → Rapid fire / No recoil potential",
    ["ReloadEvent"] = "RemoteEvent → Instant reload potential",
    ["Stats"] = "Contains weapon stats (damage, etc.)",
    ["IsAmmo"] = "Ammo marker",
    ["MaxAmmo"] = "Max ammo value",
}

function Scanner.getHighValueInfo(name)
    return HighValueMap[name]
end

-- Flag detection
function Scanner.getFlagInfo(obj)
    if obj:IsA("Script") or obj:IsA("LocalScript") then
        if obj.Disabled == false then
            return "Active Script"
        end
        if obj:FindFirstChild("RunContext") then
            return "Has RunContext"
        end
    end

    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        return "Remote Event/Function"
    end

    return nil
end

return Scanner
