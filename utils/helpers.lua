--// DeepSearch v12 - Helper Functions

local Helpers = {}

-- Safe function caller
function Helpers.safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[DeepSearch] Error: " .. tostring(result))
    end
    return success, result
end

-- Safe HTTP Get
function Helpers.safeHttpGet(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        return result
    else
        warn("[DeepSearch] HTTP Error: " .. tostring(result))
        return nil
    end
end

-- Check if executor supports a function
function Helpers.hasFunction(funcName)
    return _G[funcName] ~= nil or getgenv and getgenv()[funcName] ~= nil
end

return Helpers
