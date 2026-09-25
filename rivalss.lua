-- ============================================================================
-- NOVUS HUB - ROBLOX RIVALS (MEGA MONOLITHIC EDITION v4.4)
-- Fully Rewritten Mouse-Locked Aimbot Engine with Raw Camera CFrame Override
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

local NovusHub = {
	Version = "4.4.0",
	Codename = "Monolith",
	Active = true,
	Configurations = {
		Aimbot = {
			Enabled = false,
			Keybind = Enum.KeyCode.E,
			Smoothness = 0.15,
			FOV = 400,
			TargetPart = "Head",
			TeamCheck = true,
			Prediction = true,
			PredictionFactor = 0.038
		},
		ESP = {
			Enabled = false,
			TeamCheck = true
		},
		Visuals = {
			Fullbright = false
		},
		Player = {
			WalkSpeedBoost = false,
			SpeedMultiplier = 28,
			InfiniteJump = false,
			Noclip = false
		},
		Misc = {
			FPSUnlocker = true
		}
	}
}

-- Safe CoreGui Root Cleanup & Injection
pcall(function()
	if CoreGui:FindFirstChild("NovusHubMonolithLocked") then
		CoreGui.NovusHubMonolithLocked:Destroy()
	end
end)

local ParentTarget = CoreGui
local successCheck, _ = pcall(function() return CoreGui.Name end)
if not successCheck then
	ParentTarget = LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovusHubMonolithLocked"
ScreenGui.Parent = ParentTarget
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Extended Main Panel UI
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.BorderColor3 = Color3.fromRGB(0, 220, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
MainFrame.Size = UDim2.new(0, 580, 0, 440)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Header Component
local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "  Novus Hub | Rivals [Locked Override v4.4]"
TitleBar.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleBar.TextSize = 15
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

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

-- Navigation Sidebar
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 0, 0, 45)
TabBar.Size = UDim2.new(0, 140, 1, -45)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 2)

-- Dynamic Content Container
local ContentPanel = Instance.new("Frame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Parent = MainFrame
ContentPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
ContentPanel.BorderSizePixel = 0
ContentPanel.Position = UDim2.new(0, 140, 0, 45)
ContentPanel.Size = UDim2.new(1, -140, 1, -45)

local Panels = {}
local function makePanel(name)
	local sf = Instance.new("ScrollingFrame")
	sf.Name = name .. "Panel"
	sf.Parent = ContentPanel
	sf.Active = true
	sf.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
	sf.BorderSizePixel = 0
	sf.Size = UDim2.new(1, 0, 1, 0)
	sf.CanvasSize = UDim2.new(0, 0, 0, 600)
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
combatPanel.Visible = true

-- Utility UI Function
local function CreateToggle(parent, labelText, initialState, callback)
	local container = Instance.new("TextButton")
	container.Parent = parent
	container.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	container.BorderSizePixel = 0
	container.Size = UDim2.new(1, 0, 0, 42)
	container.Font = Enum.Font.GothamMedium
	container.Text = "    " .. labelText
	container.TextColor3 = Color3.fromRGB(220, 220, 230)
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

	return { Set = trigger, Get = function() return state end }
end

-- Populate Panels
CreateToggle(combatPanel, "Aimbot Matrix Execution", NovusHub.Configurations.Aimbot.Enabled, function(state)
	NovusHub.Configurations.Aimbot.Enabled = state
end)
CreateToggle(combatPanel, "Strict Team Check Validation", NovusHub.Configurations.Aimbot.TeamCheck, function(state)
	NovusHub.Configurations.Aimbot.TeamCheck = state
	NovusHub.Configurations.ESP.TeamCheck = state
end)
CreateToggle(combatPanel, "Velocity Ballistics Prediction", NovusHub.Configurations.Aimbot.Prediction, function(state)
	NovusHub.Configurations.Aimbot.Prediction = state
end)

CreateToggle(visualsPanel, "Player Chams Highlight Suite", NovusHub.Configurations.ESP.Enabled, function(state)
	NovusHub.Configurations.ESP.Enabled = state
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

CreateToggle(miscPanel, "FPS Unlocker Cap (999)", NovusHub.Configurations.Misc.FPSUnlocker, function(state)
	setfpscap(999)
end)

-- Tab Switcher Logic
local function createTabButton(name, targetPanel, order)
	local btn = Instance.new("TextButton")
	btn.Name = name .. "Tab"
	btn.Parent = TabBar
	btn.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
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

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	ContentPanel.Visible = not isMinimized
	TabBar.Visible = not isMinimized
	MainFrame.Size = isMinimized and UDim2.new(0, 580, 0, 45) or UDim2.new(0, 580, 0, 440)
end)

local MobileButton = Instance.new("TextButton")
MobileButton.Name = "MobileButton"
MobileButton.Parent = ScreenGui
MobileButton.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
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

-- ABSOLUTE BULLETPROOF AIMBOT ENGINE (v4.4)
-- Bypasses dead viewports by using absolute screen centers and direct Camera CFrame vector tracking.
RunService.RenderStepped:Connect(function()
	if NovusHub.Configurations.Aimbot.Enabled then
		local camera = Workspace.CurrentCamera
		if not camera then return end

		local closestTarget = nil
		local shortestDistance = math.huge
		local screenCenter = camera.ViewportSize / 2

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local isTeammate = NovusHub.Configurations.Aimbot.TeamCheck and player.Team and player.Team == LocalPlayer.Team
				if not isTeammate then
					local character = player.Character
					if character then
						local humanoid = character:FindFirstChildOfClass("Humanoid")
						local targetPart = character:FindFirstChild(NovusHub.Configurations.Aimbot.TargetPart) or character:FindFirstChild("HumanoidRootPart")

						if humanoid and humanoid.Health > 0 and targetPart then
							local pos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
							if onScreen then
								local screenVector = Vector2.new(pos.X, pos.Y)
								local magnitude = (screenVector - screenCenter).Magnitude
								if magnitude <= NovusHub.Configurations.Aimbot.FOV and magnitude < shortestDistance then
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

-- ESP Chams Rendering Engine
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
							highlight.FillColor = Color3.fromRGB(255, 40, 40)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
							highlight.FillTransparency = 0.45
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

-- Player Modifier Loop
RunService.Stepped:Connect(function()
	local character = LocalPlayer.Character
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

print("Novus Hub Mega Monolith v4.4 Locked Override Deployed!")
