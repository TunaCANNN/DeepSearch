--// DeepSearch v12 - Main Loader
print("[DeepSearch v12] Loading...")

-- Manually choose version: "full" or "lite"
local version = "full"

if version == "full" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TunaCANNN/DeepSearch/main/versions/full.lua"))()
elseif version == "lite" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TunaCANNN/DeepSearch/main/versions/lite.lua"))()
else
    warn("[DeepSearch] Invalid version selected. Use 'full' or 'lite'")
end
