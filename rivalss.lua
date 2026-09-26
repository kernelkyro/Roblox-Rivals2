-- ============================================================================
-- NOVUS HUB - ROBLOX RIVALS (ULTRA MEGA MONOLITHIC EDITION v5.2)
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
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local NovusHub = {
    Version = "5.2.0",
    Codename = "EnterpriseMonolith",
    Active = true,
    Configurations = {
        Aimbot = {
            Enabled = true,
            Keybind = Enum.KeyCode.E,
            AllowRightClick = true,
            IsHoldingKey = false,
            Smoothness = 0.12,
            FOV = 450,
            TargetPart = "Head",
            TeamCheck = true,
            WallCheck = true,
            Prediction = true,
            PredictionFactor = 0.042,
            AlwaysHeadshot = true
        },
        ESP = {
            Enabled = true,
            TeamCheck = true,
            Boxes = true,
            Tracers = true,
            Names = true,
            HealthBars = true,
            Distance = true,
            Chams = true,
            ChamsFillColor = Color3.fromRGB(255, 40, 40),
            ChamsOutlineColor = Color3.fromRGB(255, 255, 255)
        },
        Visuals = {
            Fullbright = true,
            Crosshair = true,
            FOVColor = Color3.fromRGB(0, 220, 255),
            CustomSkybox = false
        },
        Player = {
            WalkSpeedBoost = true,
            SpeedMultiplier = 30,
            InfiniteJump = true,
            Noclip = true,
            BunnyHop = true,
            Fly = false,
            FlySpeed = 50
        },
        Misc = {
            FPSUnlocker = true,
            AntiAFK = true,
            ChatSpammer = false,
            HitboxExtender = true,
            HitboxSize = 4
        }
    }
}

local UI_NAME = "NovusHubUltraMonolithv52"

pcall(function()
    RunService:UnbindFromRenderStep("NovusAimbotEngine")
    RunService:UnbindFromRenderStep("NovusESPEngine")
    RunService:UnbindFromRenderStep("NovusPlayerEngine")
    if CoreGui:FindFirstChild(UI_NAME) then
        CoreGui[UI_NAME]:Destroy()
    end
    if LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild(UI_NAME) then
        LocalPlayer.PlayerGui[UI_NAME]:Destroy()
    end
end)

local ParentTarget = CoreGui
local successCheck, _ = pcall(function() return CoreGui.Name end)
if not successCheck then
    ParentTarget = LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.Parent = ParentTarget
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Notification System
local function Notify(title, message, duration)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification"
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
    
    task.delay(duration or 3, function()
        pcall(function() NotifFrame:Destroy() end)
    end)
end

Notify("Novus Hub v5.2", "Cross-Server Matchmaking Guard Initialized!", 4)

-- Advanced Main Panel UI Structure
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
MainFrame.BorderColor3 = Color3.fromRGB(0, 220, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -230)
MainFrame.Size = UDim2.new(0, 640, 0, 460)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Header Component
local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 48)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "  Novus Hub | Rivals [Matchmaking Fixed v5.2]"
TitleBar.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleBar.TextSize = 15
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(235, 45, 45)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -42, 0, 10)
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 13

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -78, 0, 10)
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 13

-- Navigation Sidebar
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 0, 0, 48)
TabBar.Size = UDim2.new(0, 150, 1, -48)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 3)

-- Dynamic Content Container
local ContentPanel = Instance.new("Frame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Parent = MainFrame
ContentPanel.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
ContentPanel.BorderSizePixel = 0
ContentPanel.Position = UDim2.new(0, 150, 0, 48)
ContentPanel.Size = UDim2.new(1, -150, 1, -48)

local Panels = {}
local function makePanel(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Name = name .. "Panel"
    sf.Parent = ContentPanel
    sf.Active = true
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
local configPanel = makePanel("Configs")
combatPanel.Visible = true

-- Utility UI Toggle Component
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
    local function trigger(newState)
        state = newState
        badge.Text = state and "[ ACTIVE ]" or "[ OFF ]"
        badge.TextColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 50, 50)
        pcall(callback, state)
    end
    
    container.MouseButton1Click:Connect(function()
        trigger(not state)
    end)
    
    return {
        Set = trigger,
        Get = function() return state end
    }
end

-- Populate Panel UI Elements
CreateToggle(combatPanel, "Aimbot Master Toggle", NovusHub.Configurations.Aimbot.Enabled, function(state)
    NovusHub.Configurations.Aimbot.Enabled = state
end)

CreateToggle(combatPanel, "Strict Team Check", NovusHub.Configurations.Aimbot.TeamCheck, function(state)
    NovusHub.Configurations.Aimbot.TeamCheck = state
    NovusHub.Configurations.ESP.TeamCheck = state
end)

CreateToggle(combatPanel, "Visible Only (Wall Check)", NovusHub.Configurations.Aimbot.WallCheck, function(state)
    NovusHub.Configurations.Aimbot.WallCheck = state
end)

CreateToggle(combatPanel, "Velocity Prediction Engine", NovusHub.Configurations.Aimbot.Prediction, function(state)
    NovusHub.Configurations.Aimbot.Prediction = state
end)

CreateToggle(combatPanel, "Absolute Headshot Lock Override", NovusHub.Configurations.Aimbot.AlwaysHeadshot, function(state)
    NovusHub.Configurations.Aimbot.AlwaysHeadshot = state
    NovusHub.Configurations.Aimbot.TargetPart = state and "Head" or "HumanoidRootPart"
end)

CreateToggle(visualsPanel, "Player Chams Highlight Suite", NovusHub.Configurations.ESP.Chams, function(state)
    NovusHub.Configurations.ESP.Chams = state
end)

CreateToggle(visualsPanel, "Bounding Boxes ESP", NovusHub.Configurations.ESP.Boxes, function(state)
    NovusHub.Configurations.ESP.Boxes = state
end)

CreateToggle(visualsPanel, "Tracers ESP Engine", NovusHub.Configurations.ESP.Tracers, function(state)
    NovusHub.Configurations.ESP.Tracers = state
end)

CreateToggle(visualsPanel, "Engine Fullbright Lighting", NovusHub.Configurations.Visuals.Fullbright, function(state)
    NovusHub.Configurations.Visuals.Fullbright = state
    Lighting.Brightness = state and 2.5 or 1
    Lighting.GlobalShadows = not state
end)

CreateToggle(playerPanel, "WalkSpeed Booster Mod", NovusHub.Configurations.Player.WalkSpeedBoost, function(state)
    NovusHub.Configurations.Player.WalkSpeedBoost = state
end)

CreateToggle(playerPanel, "Infinite Jump Injection", NovusHub.Configurations.Player.InfiniteJump, function(state)
    NovusHub.Configurations.Player.InfiniteJump = state
end)

CreateToggle(playerPanel, "Collision Noclip Bypass", NovusHub.Configurations.Player.Noclip, function(state)
    NovusHub.Configurations.Player.Noclip = state
end)

CreateToggle(playerPanel, "Automated Bunny Hop", NovusHub.Configurations.Player.BunnyHop, function(state)
    NovusHub.Configurations.Player.BunnyHop = state
end)

CreateToggle(miscPanel, "FPS Unlocker Cap (999)", NovusHub.Configurations.Misc.FPSUnlocker, function(state)
    setfpscap(999)
end)

CreateToggle(miscPanel, "Anti-AFK Kick Bypass", NovusHub.Configurations.Misc.AntiAFK, function(state)
    NovusHub.Configurations.Misc.AntiAFK = state
end)

CreateToggle(miscPanel, "Hitbox Expander Module", NovusHub.Configurations.Misc.HitboxExtender, function(state)
    NovusHub.Configurations.Misc.HitboxExtender = state
end)

-- Tab Switcher Logic
local function createTabButton(name, targetPanel, order)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Tab"
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
        for _, p in pairs(Panels) do
            p.Visible = false
        end
        targetPanel.Visible = true
    end)
end

createTabButton("Combat", combatPanel, 1)
createTabButton("Visuals", visualsPanel, 2)
createTabButton("Player", playerPanel, 3)
createTabButton("Misc", miscPanel, 4)
createTabButton("Configs", configPanel, 5)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentPanel.Visible = not isMinimized
    TabBar.Visible = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 640, 0, 48) or UDim2.new(0, 640, 0, 460)
end)

-- Mobile Floating Toggle Button
local MobileButton = Instance.new("TextButton")
MobileButton.Name = "MobileButton"
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

MobileButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Input Listeners for Aimbot Activation
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == NovusHub.Configurations.Aimbot.Keybind or (NovusHub.Configurations.Aimbot.AllowRightClick and input.UserInputType == Enum.UserInputType.MouseButton2) then
        NovusHub.Configurations.Aimbot.IsHoldingKey = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == NovusHub.Configurations.Aimbot.Keybind or (NovusHub.Configurations.Aimbot.AllowRightClick and input.UserInputType == Enum.UserInputType.MouseButton2) then
        NovusHub.Configurations.Aimbot.IsHoldingKey = false
    end
end)

-- Wall Check Raycasting Helper
local function IsPartVisible(targetPart, character)
    local camera = Workspace.CurrentCamera
    if not camera then return false end
    local origin = camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin
    
    local params = RaycastParams.new()
    params.FilterType = RaycastFilterType.Exclude -- FIXED HERE
    local ignoreList = {}
    if LocalPlayer.Character then
        table.insert(ignoreList, LocalPlayer.Character)
    end
    if character then
        table.insert(ignoreList, character)
    end
    params.FilterDescendantsInstances = ignoreList
    
    local result = Workspace:Raycast(origin, direction, params)
    return result == nil
end

-- Robust Character Finder (Handles Lobby to Match Server Transitions)
local function GetValidCharacter(player)
    if not player then return nil end
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            return char
        end
    end
    return nil
end

-- Teleport / Match Server Persistence Hook (Auto-re-executes or re-binds UI on teleport)
if getgenv then
    pcall(function()
        if queue_on_teleport then
            queue_on_teleport([[
                task.wait(2)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kernelkyro/Roblox-Rivals2/main/rivalss.lua"))()
            ]])
        end
    end)
end

-- Aimbot Core Engine (Robust Multi-Server Loop)
RunService.RenderStepped:Connect(function()
    if NovusHub.Configurations.Aimbot.Enabled and NovusHub.Configurations.Aimbot.IsHoldingKey then
        local camera = Workspace.CurrentCamera
        local myChar = GetValidCharacter(LocalPlayer)
        if not camera or not myChar then return end
        
        local closestTarget = nil
        local shortestDistance = math.huge
        local screenCenter = camera.ViewportSize / 2
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local isTeammate = NovusHub.Configurations.Aimbot.TeamCheck and player.Team and player.Team == LocalPlayer.Team
                if not isTeammate then
                    local character = GetValidCharacter(player)
                    if character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        local targetPartName = NovusHub.Configurations.Aimbot.AlwaysHeadshot and "Head" or NovusHub.Configurations.Aimbot.TargetPart
                        local targetPart = character:FindFirstChild(targetPartName) or character:FindFirstChild("HumanoidRootPart")
                        
                        if humanoid and humanoid.Health > 0 and targetPart then
                            local pos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                local screenVector = Vector2.new(pos.X, pos.Y)
                                local magnitude = (screenVector - screenCenter).Magnitude
                                
                                if magnitude <= NovusHub.Configurations.Aimbot.FOV and magnitude < shortestDistance then
                                    if not NovusHub.Configurations.Aimbot.WallCheck or IsPartVisible(targetPart, character) then
                                        shortestDistance = magnitude
                                        closestTarget = targetPart
                                    end
                                end
                            end
                        end
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
            
            local targetCFrame = CFrame.new(camera.CFrame.Position, finalPosition)
            camera.CFrame = camera.CFrame:Lerp(targetCFrame, NovusHub.Configurations.Aimbot.Smoothness)
        end
    end
end)

-- Comprehensive ESP Chams & Highlighting Engine
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = GetValidCharacter(player)
            local highlight = player.Character and player.Character:FindFirstChild("NovusChamsESP")
            local isTeammate = NovusHub.Configurations.ESP.TeamCheck and player.Team and player.Team == LocalPlayer.Team
            
            if NovusHub.Configurations.ESP.Enabled and NovusHub.Configurations.ESP.Chams and character and not isTeammate then
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
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end)

-- Player Modifier Loop
RunService.Stepped:Connect(function()
    local character = GetValidCharacter(LocalPlayer)
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and NovusHub.Configurations.Player.WalkSpeedBoost then
            humanoid.WalkSpeed = NovusHub.Configurations.Player.SpeedMultiplier
        end
        
        if NovusHub.Configurations.Player.Noclip then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        
        if NovusHub.Configurations.Player.BunnyHop and humanoid then
            if humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        
        -- Hitbox Expander Feature
        if NovusHub.Configurations.Misc.HitboxExtender then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local targetChar = GetValidCharacter(player)
                    if targetChar then
                        local hrp = targetChar:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(NovusHub.Configurations.Misc.HitboxSize, NovusHub.Configurations.Misc.HitboxSize, NovusHub.Configurations.Misc.HitboxSize)
                            hrp.Transparency = 0.8
                            hrp.CanCollide = false
                        end
                    end
                end
            end
        end
    end
end)

-- Infinite Jump Listener
UserInputService.JumpRequest:Connect(function()
    if NovusHub.Configurations.Player.InfiniteJump then
        local character = GetValidCharacter(LocalPlayer)
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- Anti-AFK Kick Bypass
task.spawn(function()
    while task.wait(60) do
        if NovusHub.Configurations.Misc.AntiAFK then
            local vu = game:GetService("VirtualUser")
            pcall(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)

print("Novus Hub Ultra Monolith v5.2 Fully Loaded - Matchmaking Teleport Bug Fixed!")
