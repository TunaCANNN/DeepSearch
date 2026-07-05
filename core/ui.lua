--// DeepSearch v12 - Modern UI Module

local TweenService = game:GetService("TweenService")

local UI = {}

function UI.createMainWindow()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeepSearchUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = "MainWindow"
    main.Size = UDim2.new(0, 900, 0, 580)
    main.Position = UDim2.new(0.5, -450, 0.5, -290)
    main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    main.BorderSizePixel = 0
    main.Parent = screenGui

    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 32)
    topBar.BackgroundColor3 = Color3.fromRGB(14, 14, 19)
    topBar.Parent = main

    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "DeepSearch v12"
    title.TextColor3 = Color3.fromRGB(200, 200, 220)
    title.TextScaled = true
    title.Font = Enum.Font.Code
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = topBar

    -- Content Area
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -16, 1, -44)
    content.Position = UDim2.new(0, 8, 0, 38)
    content.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    content.Parent = main

    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 10)

    return {
        ScreenGui = screenGui,
        Main = main,
        Content = content,
        TopBar = topBar
    }
end

return UI
