--// DeepSearch v12 - Wordbank Manager

local HttpService = game:GetService("HttpService")

local Wordbank = {}

local MAIN_WORDBANK_URL = "https://raw.githubusercontent.com/TunaCANNN/DeepSearch/main/wordbanks/main.json"
local PRIORITY_WORDBANK_URL = "https://raw.githubusercontent.com/TunaCANNN/DeepSearch/main/wordbanks/priority.json"

-- Load a wordbank from URL
function Wordbank.load(url)
    local success, data = pcall(function()
        return game:HttpGet(url)
    end)

    if success and data then
        return HttpService:JSONDecode(data)
    end

    warn("[DeepSearch] Failed to load wordbank from: " .. url)
    return {}
end

-- Load main wordbank
function Wordbank.loadMain()
    return Wordbank.load(MAIN_WORDBANK_URL)
end

-- Load priority wordbank
function Wordbank.loadPriority()
    return Wordbank.load(PRIORITY_WORDBANK_URL)
end

-- Get all keywords from a wordbank (flattened)
function Wordbank.getAllKeywords(wordbank)
    local keywords = {}
    for _, category in pairs(wordbank) do
        if type(category) == "table" then
            for _, word in ipairs(category) do
                table.insert(keywords, word)
            end
        end
    end
    return keywords
end

-- Get keywords from a specific category
function Wordbank.getCategory(wordbank, categoryName)
    return wordbank[categoryName] or {}
end

return Wordbank
