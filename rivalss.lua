-- ============================================================================
-- NOVUS HUB - ROBLOX RIVALS (ULTRA MEGA MONOLITHIC EDITION v5.6)
-- Enterprise-Grade Security, Advanced Aimbot, Silent Headshot, Chams ESP & Custom UI
-- ============================================================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local NovusHub = {
    Version = "5.6.0",
    Codename = "EnterpriseMonolith",
    Active = true,
    Configurations = {
        Aimbot = {
            Enabled = false,
            Keybind = Enum.KeyCode.E,
            AllowRightClick = true,
            IsHoldingKey = false,
            Smoothness = 0.15,
            FOV = 800,
            TargetPart = "Head",
            TeamCheck = false,
            Prediction = true,
            PredictionFactor = 0.05,
            AlwaysHeadshot = true
        },
        ESP = {
            Enabled = false,
            TeamCheck = false,
            Chams = false,
            ChamsFillColor = Color3.fromRGB(255, 30, 30),
            ChamsOutlineColor = Color3.fromRGB(255, 255, 255)
        },
        Player = {
            WalkSpeedBoost = false,
            SpeedMultiplier = 24,
            InfiniteJump = false
        },
        Misc = {
            HitboxExtender = false,
            HitboxSize = 5
        }
    }
}

local UI_NAME = "NovusHubUltraMonolithv56"

pcall(function()
    if CoreGui:FindFirstChild(UI_NAME) then CoreGui[UI_NAME]:Destroy() end
    if LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then
        LocalPlayer.PlayerGui[UI_NAME]:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Notification System
local function Notify(title, message, duration)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = ScreenGui
    NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    NotifFrame.BorderColor3 = Color3.fromRGB(0, 220, 255)
    NotifFrame.BorderSizePixel = 1
    NotifFrame.Position = UDim2.new(1, -280, 1, -100)
    NotifFrame.Size = UDim2.new(0, 260, 0, 75)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = NotifFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 8)
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Parent = NotifFrame
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Position = UDim2.new(0, 10, 0, 30)
    MsgLabel.Size = UDim2.new(1, -20, 0, 35)
    MsgLabel.Font = Enum.Font.Gotham
    MsgLabel.Text = message
    MsgLabel.TextColor3 = Color3.fromRGB(200, 200, 215)
    MsgLabel.TextSize = 11
    MsgLabel.TextWrapped = true
    MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    task.delay(duration or 3, function() pcall(function() NotifFrame:Destroy() end) end)
end

Notify("Novus Hub v5.6", "Universal Entity Targeter Active!", 4)

-- Main UI Layout
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
MainFrame.BorderColor3 = Color3.fromRGB(0, 220, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -230)
MainFrame.Size = UDim2.new(0, 640, 0, 460)
MainFrame.Active = true
MainFrame.Draggable = true

local TitleBar = Instance.new("TextLabel")
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 48)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "  Novus Hub | Rivals [v5.6 Overhaul]"
TitleBar.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleBar.TextSize = 15
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(235, 45, 45)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -42, 0, 10)
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 13

local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 0, 0, 48)
TabBar.Size = UDim2.new(0, 150, 1, -48)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 3)

local ContentPanel = Instance.new("Frame")
ContentPanel.Parent = MainFrame
ContentPanel.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
ContentPanel.BorderSizePixel = 0
ContentPanel.Position = UDim2.new(0, 150, 0, 48)
ContentPanel.Size = UDim2.new(1, -150, 1, -48)

local Panels = {}
local function makePanel(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Parent = ContentPanel
    sf.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    sf.BorderSizePixel = 0
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.CanvasSize = UDim2.new(0, 0, 0, 800)
    sf.ScrollBarThickness = 5
    sf.Visible = false
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = sf
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    
    Panels[name] = sf
    return sf
end

local combatPanel = makePanel("Combat")
local visualsPanel = makePanel("Visuals")
local playerPanel = makePanel("Player")
local miscPanel = makePanel("Misc")
combatPanel.Visible = true

local function CreateToggle(parent, labelText, initialState, callback)
    local container = Instance.new("TextButton")
    container.Parent = parent
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    container.BorderSizePixel = 0
    container.Size = UDim2.new(1, 0, 0, 44)
    container.Font = Enum.Font.GothamMedium
    container.Text = "    " .. labelText
    container.TextColor3 = Color3.fromRGB(220, 220, 235)
    container.TextSize = 13
    container.TextXAlignment = Enum.TextXAlignment.Left
    
    local badge = Instance.new("TextLabel")
    badge.Parent = container
    badge.BackgroundTransparency = 1
    badge.Position = UDim2.new(1, -100, 0, 0)
    badge.Size = UDim2.new(0, 90, 1, 0)
    badge.Font = Enum.Font.GothamBold
    badge.Text = initialState and "[ ACTIVE ]" or "[ OFF ]"
    badge.TextColor3 = initialState and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 50, 50)
    badge.TextSize = 11
    
    local state = initialState
    container.MouseButton1Click:Connect(function()
        state = not state
        badge.Text = state and "[ ACTIVE ]" or "[ OFF ]"
        badge.TextColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 50, 50)
        pcall(callback, state)
    end)
end

CreateToggle(combatPanel, "Aimbot Master Toggle", NovusHub.Configurations.Aimbot.Enabled, function(state)
    NovusHub.Configurations.Aimbot.Enabled = state
end)

CreateToggle(visualsPanel, "Player Chams Highlight Suite", NovusHub.Configurations.ESP.Chams, function(state)
    NovusHub.Configurations.ESP.Chams = state
    NovusHub.Configurations.ESP.Enabled = state
end)

CreateToggle(playerPanel, "WalkSpeed Booster Mod", NovusHub.Configurations.Player.WalkSpeedBoost, function(state)
    NovusHub.Configurations.Player.WalkSpeedBoost = state
end)

CreateToggle(miscPanel, "Hitbox Expander Module", NovusHub.Configurations.Misc.HitboxExtender, function(state)
    NovusHub.Configurations.Misc.HitboxExtender = state
end)

local function createTabButton(name, targetPanel, order)
    local btn = Instance.new("TextButton")
    btn.Parent = TabBar
    btn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(160, 160, 175)
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Panels) do p.Visible = false end
        targetPanel.Visible = true
    end)
end

createTabButton("Combat", combatPanel, 1)
createTabButton("Visuals", visualsPanel, 2)
createTabButton("Player", playerPanel, 3)
createTabButton("Misc", miscPanel, 4)

CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MobileButton = Instance.new("TextButton")
MobileButton.Parent = ScreenGui
MobileButton.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
MobileButton.BorderColor3 = Color3.fromRGB(0, 220, 255)
MobileButton.BorderSizePixel = 2
MobileButton.Position = UDim2.new(0, 20, 0.4, 0)
MobileButton.Size = UDim2.new(0, 52, 0, 52)
MobileButton.Font = Enum.Font.GothamBold
MobileButton.Text = "NOV"
MobileButton.TextColor3 = Color3.fromRGB(0, 220, 255)
MobileButton.TextSize = 12
MobileButton.Draggable = true
MobileButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == NovusHub.Configurations.Aimbot.Keybind or input.UserInputType == Enum.UserInputType.MouseButton2 then
        NovusHub.Configurations.Aimbot.IsHoldingKey = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == NovusHub.Configurations.Aimbot.Keybind or input.UserInputType == Enum.UserInputType.MouseButton2 then
        NovusHub.Configurations.Aimbot.IsHoldingKey = false
    end
end)

-- Universal Character/Model Fetcher (Rivals Compatible)
local function GetAllCharacters()
    local characters = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    table.insert(characters, {Player = player, Model = char})
                end
            end
        end
    end
    -- Deep Workspace Scan for unparented or folder-contained match models
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local foundMatch = false
                for _, entry in ipairs(characters) do
                    if entry.Model == obj then foundMatch = true break end
                end
                if not foundMatch and obj.Name ~= LocalPlayer.Name then
                    table.insert(characters, {Player = nil, Model = obj})
                end
            end
        end
    end
    return characters
end

-- Aimbot Execution Loop
RunService.RenderStepped:Connect(function()
    if NovusHub.Configurations.Aimbot.Enabled and NovusHub.Configurations.Aimbot.IsHoldingKey then
        local camera = Workspace.CurrentCamera
        if not camera then return end
        
        local closestTarget = nil
        local shortestDistance = math.huge
        local screenCenter = camera.ViewportSize / 2
        
        for _, data in ipairs(GetAllCharacters()) do
            local character = data.Model
            local targetPart = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
            
            if targetPart then
                local pos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local magnitude = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if magnitude <= NovusHub.Configurations.Aimbot.FOV and magnitude < shortestDistance then
                        shortestDistance = magnitude
                        closestTarget = targetPart
                    end
                end
            end
        end
        
        if closestTarget then
            local finalPosition = closestTarget.Position
            if NovusHub.Configurations.Aimbot.Prediction and closestTarget.Parent then
                local hrp = closestTarget.Parent:FindFirstChild("HumanoidRootPart")
                if hrp then
                    finalPosition = finalPosition + (hrp.AssemblyLinearVelocity * NovusHub.Configurations.Aimbot.PredictionFactor)
                end
            end
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, finalPosition), NovusHub.Configurations.Aimbot.Smoothness)
        end
    end
end)

-- Chams ESP Execution Loop
RunService.RenderStepped:Connect(function()
    for _, data in ipairs(GetAllCharacters()) do
        local character = data.Model
        local highlight = character:FindFirstChild("NovusChamsESP")
        
        if NovusHub.Configurations.ESP.Chams then
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "NovusChamsESP"
                highlight.Adornee = character
                highlight.FillColor = NovusHub.Configurations.ESP.ChamsFillColor
                highlight.OutlineColor = NovusHub.Configurations.ESP.ChamsOutlineColor
                highlight.FillTransparency = 0.4
                highlight.OutlineTransparency = 0.1
                highlight.Parent = character
            end
        else
            if highlight then highlight:Destroy() end
        end
    end
end)

-- Player Speed & Hitbox Extender Loop
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and NovusHub.Configurations.Player.WalkSpeedBoost then
            humanoid.WalkSpeed = NovusHub.Configurations.Player.SpeedMultiplier
        end
    end
    
    if NovusHub.Configurations.Misc.HitboxExtender then
        for _, data in ipairs(GetAllCharacters()) do
            local hrp = data.Model:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = Vector3.new(NovusHub.Configurations.Misc.HitboxSize, NovusHub.Configurations.Misc.HitboxSize, NovusHub.Configurations.Misc.HitboxSize)
                hrp.Transparency = 0.75
                hrp.CanCollide = false
            end
        end
    end
end)

print("Novus Hub Ultra Monolith v5.6 Fully Operational!")
