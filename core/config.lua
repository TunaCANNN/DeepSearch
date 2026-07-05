--// DeepSearch v12 - Configuration

local Config = {}

Config.Version = "v12"
Config.DefaultPerformanceMode = "normal" -- "normal" or "light"

Config.Wordbank = {
    MainURL = "https://raw.githubusercontent.com/TunaCANNN/DeepSearch/main/wordbanks/main.json",
    PriorityURL = "https://raw.githubusercontent.com/TunaCANNN/DeepSearch/main/wordbanks/priority.json"
}

Config.UI = {
    Theme = "Dark",
    AccentColor = Color3.fromRGB(180, 100, 255)
}

Config.Scanning = {
    MaxResults = 500,           -- Limit results to avoid lag
    UsePriorityFirst = true,    -- Scan high priority items first
    EnableStagedScanning = true
}

return Config
