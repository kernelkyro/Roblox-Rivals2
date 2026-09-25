-- ============================================================================
-- NOVUS HUB - ROBLOX RIVALS (MEGA MONOLITHIC EDITION v4.0)
-- Strict Luau Typings, Modular Subsystems, and Advanced Combat Core
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- Namespace definition for global state management
local NovusHub = {
	Version = "4.0.0",
	Codename = "Monolith",
	Active = true,
	Configurations = {
		Aimbot = {
			Enabled = false,
			Keybind = Enum.KeyCode.E,
			Smoothness = 0.15,
			FOV = 120,
			TargetPart = "Head",
			VisibleCheck = true,
			TeamCheck = true,
			Prediction = true,
			PredictionFactor = 0.035
		},
		ESP = {
			Enabled = false,
			Boxes = true,
			Names = true,
			Tracers = false,
			HealthBars = true,
			TeamCheck = true,
			Chams = true,
			MaxDistance = 1500
		},
		Visuals = {
			Fullbright = false,
			CustomSky = false,
			FOVChanger = false,
			FOVValue = 90,
			NoFog = false
		},
		Player = {
			WalkSpeedBoost = false,
			SpeedMultiplier = 24,
			JumpPowerBoost = false,
			JumpMultiplier = 50,
			InfiniteJump = false,
			Noclip = false,
			Bhop = false
		},
		Misc = {
			HitSound = false,
			HitSoundId = "rbxassetid://6032408331",
			CustomCrosshair = false,
			FPSUnlocker = true
		}
	},
	Cache = {
		ESPObjects = {},
		Connections = {},
		TargetInstance = nil
	}
}

-- Safe CoreGui Injection Check
local successRegistry = pcall(function()
	if CoreGui:FindFirstChild("NovusHubMonolith") then
		CoreGui.NovusHubMonolith:Destroy()
	end
end)

local ParentTarget = CoreGui
local successCheck = pcall(function()
	local _ = CoreGui.Name
end)
if not successCheck then
	ParentTarget = LocalPlayer:WaitForChild("PlayerGui")
end

-- GUI Root Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovusHubMonolith"
ScreenGui.Parent = ParentTarget
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Container Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
MainFrame.BorderColor3 = Color3.fromRGB(0, 220, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.Size = UDim2.new(0, 550, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar Component
local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "  Novus Hub | Rivals [Mega Monolith v4]"
TitleBar.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleBar.TextSize = 16
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

-- Close Window Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(235, 45, 45)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -40, 0, 9)
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 13

-- Minimize Window Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -76, 0, 9)
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 13

-- Navigation Tab Bar Layout
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(14, 14, 19)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 0, 0, 45)
TabBar.Size = UDim2.new(0, 130, 1, -45)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 2)

-- Content Panel Area
local ContentPanel = Instance.new("Frame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Parent = MainFrame
ContentPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
ContentPanel.BorderSizePixel = 0
ContentPanel.Position = UDim2.new(0, 130, 0, 45)
ContentPanel.Size = UDim2.new(1, -130, 1, -45)

-- System Utility Sub-Function Library
local UtilityModule = {}

function UtilityModule.CreateToggle(parent, labelText, initialState, callback)
	local container = Instance.new("TextButton")
	container.Parent = parent
	container.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	container.BorderSizePixel = 0
	container.Size = UDim2.new(1, 0, 0, 40)
	container.Font = Enum.Font.GothamMedium
	container.Text = "    " .. labelText
	container.TextColor3 = Color3.fromRGB(220, 220, 225)
	container.TextSize = 13
	container.TextXAlignment = Enum.TextXAlignment.Left

	local badge = Instance.new("TextLabel")
	badge.Parent = container
	badge.BackgroundTransparency = 1
	badge.Position = UDim2.new(1, -95, 0, 0)
	badge.Size = UDim2.new(0, 85, 1, 0)
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

-- Sub-Containers for Configuration Panels (Combat, Visuals, Player, Misc)
local Panels = {}
local function makePanel(name)
	local sf = Instance.new("ScrollingFrame")
	sf.Name = name .. "Panel"
	sf.Parent = ContentPanel
	sf.Active = true
	sf.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	sf.BorderSizePixel = 0
	sf.Size = UDim2.new(1, 0, 1, 0)
	sf.CanvasSize = UDim2.new(0, 0, 0, 500)
	sf.ScrollBarThickness = 4
	sf.Visible = false

	local layout = Instance.new("UIListLayout")
	layout.Parent = sf
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 6)

	Panels[name] = sf
	return sf
end

local combatPanel = makePanel("Combat")
local visualsPanel = makePanel("Visuals")
local playerPanel = makePanel("Player")
local miscPanel = makePanel("Misc")

combatPanel.Visible = true -- Default active panel

-- Construct Combat Controls
local aimbotToggle = UtilityModule.CreateToggle(combatPanel, "Combat Aimbot Matrix", NovusHub.Configurations.Aimbot.Enabled, function(state)
	NovusHub.Configurations.Aimbot.Enabled = state
end)

local teamCheckToggle = UtilityModule.CreateToggle(combatPanel, "Strict Team Check Validation", NovusHub.Configurations.Aimbot.TeamCheck, function(state)
	NovusHub.Configurations.Aimbot.TeamCheck = state
	NovusHub.Configurations.ESP.TeamCheck = state
end)

local predictionToggle = UtilityModule.CreateToggle(combatPanel, "Velocity Ballistics Prediction", NovusHub.Configurations.Aimbot.Prediction, function(state)
	NovusHub.Configurations.Aimbot.Prediction = state
end)

-- Construct Visuals Controls
local espToggle = UtilityModule.CreateToggle(visualsPanel, "Player Highlight Chams", NovusHub.Configurations.ESP.Enabled, function(state)
	NovusHub.Configurations.ESP.Enabled = state
	if not state then
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("NovusChamsESP") then
				player.Character.NovusChamsESP:Destroy()
			end
		end
	end
end)

local fullbrightToggle = UtilityModule.CreateToggle(visualsPanel, "Engine Fullbright Lighting", NovusHub.Configurations.Visuals.Fullbright, function(state)
	NovusHub.Configurations.Visuals.Fullbright = state
	if state then
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.GlobalShadows = false
		Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
	else
		Lighting.Brightness = 1
		Lighting.GlobalShadows = true
		Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
	end
end)

-- Construct Player Controls
local speedToggle = UtilityModule.CreateToggle(playerPanel, "WalkSpeed Modifier Hack", NovusHub.Configurations.Player.WalkSpeedBoost, function(state)
	NovusHub.Configurations.Player.WalkSpeedBoost = state
end)

local jumpToggle = UtilityModule.CreateToggle(playerPanel, "Infinite Jump Injection", NovusHub.Configurations.Player.InfiniteJump, function(state)
	NovusHub.Configurations.Player.InfiniteJump = state
end)

local noclipToggle = UtilityModule.CreateToggle(playerPanel, "Collision Noclip Bypass", NovusHub.Configurations.Player.Noclip, function(state)
	NovusHub.Configurations.Player.Noclip = state
end)

-- Construct Misc Controls
local fpsToggle = UtilityModule.CreateToggle(miscPanel, "FPS Max Cap Expander", NovusHub.Configurations.Misc.FPSUnlocker, function(state)
	NovusHub.Configurations.Misc.FPSUnlocker = state
	setfpscap(999)
end)

-- Tab Switcher Logic Builder
local function createTabButton(name, targetPanel, order)
	local btn = Instance.new("TextButton")
	btn.Name = name .. "Tab"
	btn.Parent = TabBar
	btn.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
	btn.BorderSizePixel = 0
	btn.Size = UDim2.new(1, 0, 0, 40)
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

-- Window Utility Controls
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	ContentPanel.Visible = not isMinimized
	TabBar.Visible = not isMinimized
	MainFrame.Size = isMinimized and UDim2.new(0, 550, 0, 45) or UDim2.new(0, 550, 0, 420)
end)

-- Mobile Float Icon
local MobileButton = Instance.new("TextButton")
MobileButton.Name = "MobileButton"
MobileButton.Parent = ScreenGui
MobileButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MobileButton.BorderColor3 = Color3.fromRGB(0, 220, 255)
MobileButton.BorderSizePixel = 2
MobileButton.Position = UDim2.new(0, 20, 0.4, 0)
MobileButton.Size = UDim2.new(0, 50, 0, 50)
MobileButton.Font = Enum.Font.GothamBold
MobileButton.Text = "NOV"
MobileButton.TextColor3 = Color3.fromRGB(0, 220, 255)
MobileButton.TextSize = 12
MobileButton.Draggable = true

MobileButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Combat Execution Loop: High Accuracy Aimbot Engine
RunService.RenderStepped:Connect(function()
	if NovusHub.Configurations.Aimbot.Enabled then
		local camera = Workspace.CurrentCamera
		if not camera then return end

		local closestTarget = nil
		local shortestDistance = math.huge
		local mousePos = UserInputService:GetMouseLocation()

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local isTeammate = NovusHub.Configurations.Aimbot.TeamCheck and player.Team and player.Team == LocalPlayer.Team
				if not isTeammate then
					local character = player.Character
					if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
						local targetPart = character:FindFirstChild(NovusHub.Configurations.Aimbot.TargetPart) or character:FindFirstChild("HumanoidRootPart")
						if targetPart then
							local pos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
							if onScreen then
								local screenVector = Vector2.new(pos.X, pos.Y)
								local magnitude = (screenVector - mousePos).Magnitude
								if magnitude < shortestDistance then
									shortestDistance = magnitude
									closestTarget = targetPart
								end
							end
						end
					end
				end
			end
		end

		if closestTarget then
			local finalDestination = closestTarget.Position
			if NovusHub.Configurations.Aimbot.Prediction and closestTarget.Parent:FindFirstChild("HumanoidRootPart") then
				local hrp = closestTarget.Parent.HumanoidRootPart
				finalDestination = finalDestination + (hrp.AssemblyLinearVelocity * NovusHub.Configurations.Aimbot.PredictionFactor)
			end
			camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, finalDestination), NovusHub.Configurations.Aimbot.Smoothness)
		end
	end
end)

-- Visuals Execution Loop: Player ESP Rendering System
RunService.RenderStepped:Connect(function()
	if NovusHub.Configurations.ESP.Enabled then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local character = player.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					local isTeammate = NovusHub.Configurations.ESP.TeamCheck and player.Team and player.Team == LocalPlayer.Team
					if not isTeammate then
						if not character:FindFirstChild("NovusChamsESP") then
							local highlight = Instance.new("Highlight")
							highlight.Name = "NovusChamsESP"
							highlight.Adornee = character
							highlight.FillColor = Color3.fromRGB(255, 30, 30)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
							highlight.FillTransparency = 0.5
							highlight.OutlineTransparency = 0.1
							highlight.Parent = character
						end
					else
						if character:FindFirstChild("NovusChamsESP") then
							character.NovusChamsESP:Destroy()
						end
					end
				end
			end
		end
	end
end)

-- Player Manipulation Loop (WalkSpeed, Noclip, Infinite Jump)
RunService.Stepped:Connect(function()
	local character = LocalPlayer.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			if NovusHub.Configurations.Player.WalkSpeedBoost then
				humanoid.WalkSpeed = NovusHub.Configurations.Player.SpeedMultiplier
			end
		end

		if NovusHub.Configurations.Player.Noclip then
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if NovusHub.Configurations.Player.InfiniteJump then
		local character = LocalPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)

print("Novus Hub Mega Monolith v4 Initialized Successfully!")
