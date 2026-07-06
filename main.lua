--// DeepSearch v12 - GUI Loader
local HttpService = game:GetService("HttpService")

local player = game.Players.LocalPlayer

-- Create simple loader GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearchLoader"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0.5, -150, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "DeepSearch v12"
title.TextColor3 = Color3.fromRGB(200, 200, 220)
title.TextScaled = true
title.Font = Enum.Font.Code
title.Parent = frame

local fullBtn = Instance.new("TextButton")
fullBtn.Size = UDim2.new(0.9, 0, 0, 40)
fullBtn.Position = UDim2.new(0.05, 0, 0, 55)
fullBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 60)
fullBtn.Text = "Load Full Version"
fullBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fullBtn.Font = Enum.Font.Code
fullBtn.TextSize = 18
fullBtn.Parent = frame

Instance.new("UICorner", fullBtn).CornerRadius = UDim.new(0, 8)

local liteBtn = Instance.new("TextButton")
liteBtn.Size = UDim2.new(0.9, 0, 0, 40)
liteBtn.Position = UDim2.new(0.05, 0, 0, 105)
liteBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
liteBtn.Text = "Load Lite Version"
liteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
liteBtn.Font = Enum.Font.Code
liteBtn.TextSize = 18
liteBtn.Parent = frame

Instance.new("UICorner", liteBtn).CornerRadius = UDim.new(0, 8)

-- Load Function
local function loadVersion(version)
    gui:Destroy()
    
    local url = "https://raw.githubusercontent.com/TunaCANNN/DeepSearch/main/versions/" .. version .. ".lua"
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if not success then
        warn("[DeepSearch] Failed to load version: " .. tostring(result))
    end
end

-- Button Events
fullBtn.MouseButton1Click:Connect(function()
    loadVersion("full")
end)

liteBtn.MouseButton1Click:Connect(function()
    loadVersion("lite")
end)

print("[DeepSearch] Loader ready. Choose a version.")
