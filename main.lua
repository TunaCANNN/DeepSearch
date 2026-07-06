--// DeepSearch v12 - Fixed GUI Loader
local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearchLoader"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 170)
frame.Position = UDim2.new(0.5, -160, 0.5, -85)
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
fullBtn.Size = UDim2.new(0.9, 0, 0, 45)
fullBtn.Position = UDim2.new(0.05, 0, 0, 55)
fullBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 70)
fullBtn.Text = "Load Full Version"
fullBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fullBtn.Font = Enum.Font.Code
fullBtn.TextSize = 18
fullBtn.Parent = frame
Instance.new("UICorner", fullBtn).CornerRadius = UDim.new(0, 8)

local liteBtn = Instance.new("TextButton")
liteBtn.Size = UDim2.new(0.9, 0, 0, 45)
liteBtn.Position = UDim2.new(0.05, 0, 0, 110)
liteBtn.BackgroundColor3 = Color3.fromRGB(50, 90, 140)
liteBtn.Text = "Load Lite Version"
liteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
liteBtn.Font = Enum.Font.Code
liteBtn.TextSize = 18
liteBtn.Parent = frame
Instance.new("UICorner", liteBtn).CornerRadius = UDim.new(0, 8)

-- Fixed Load Function
local function loadVersion(version)
    gui:Destroy()

    local url = "https://raw.githubusercontent.com/TunaCANNN/DeepSearch/refs/heads/main/versions/" .. version .. ".lua"

    local success, result = pcall(function()
        local code = game:HttpGet(url)
        if not code or code == "" then
            error("Empty response from GitHub")
        end
        return loadstring(code)()
    end)

    if not success then
        warn("[DeepSearch] Failed to load version: " .. tostring(result))
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DeepSearch Error",
            Text = "Failed to load version. Check console (F9).",
            Duration = 6
        })
    end
end

fullBtn.MouseButton1Click:Connect(function()
    loadVersion("full")
end)

liteBtn.MouseButton1Click:Connect(function()
    loadVersion("lite")
end)

print("[DeepSearch] Loader ready. Choose a version.")
