-- ============================================================================
-- NOVUS HUB - ROBLOX RIVALS (ULTIMATE ADVANCED EDITION)
-- Compatible with Android & PC | Robust Error Handling & Extended Features
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- Safety check for CoreGui access
local successRegistry, registryError = pcall(function()
	if CoreGui:FindFirstChild("NovusHubUltimate") then
		CoreGui.NovusHubUltimate:Destroy()
	end
end)

if not successRegistry then
	warn("NovusHub: CoreGui restricted, falling back to PlayerGui.")
end

local ParentTarget = CoreGui
if not pcall(function() local _ = CoreGui.Name end) then
	ParentTarget = LocalPlayer:WaitForChild("PlayerGui")
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovusHubUltimate"
ScreenGui.Parent = ParentTarget
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Floating Panel
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.BorderColor3 = Color3.fromRGB(0, 190, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Header
local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "  Novus Hub | Rivals [Ultimate v2]"
TitleBar.TextColor3 = Color3.fromRGB(0, 190, 255)
TitleBar.TextSize = 15.000
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

-- Action Buttons Container
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(235, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -35, 0, 7)
CloseButton.Size = UDim2.new(0, 26, 0, 26)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 13.000

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -70, 0, 7)
MinimizeButton.Size = UDim2.new(0, 26, 0, 26)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 13.000

-- Tab Container Frame
local ScrollingContainer = Instance.new("ScrollingFrame")
ScrollingContainer.Name = "ScrollingContainer"
ScrollingContainer.Parent = MainFrame
ScrollingContainer.Active = true
ScrollingContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
ScrollingContainer.BorderSizePixel = 0
ScrollingContainer.Position = UDim2.new(0, 12, 0, 52)
ScrollingContainer.Size = UDim2.new(1, -24, 1, -64)
ScrollingContainer.CanvasSize = UDim2.new(0, 0, 0, 220)
ScrollingContainer.ScrollBarThickness = 5

-- Layout Engine for Elements
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Feature Configurations & States
local ScriptConfig = {
	Aimbot = false,
	ESP = false,
	AimbotFOV = 120,
	TeamCheck = true
}

-- Utility: Create Custom Modern Toggles
local function buildToggleUI(labelText, defaultState, callback)
	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Parent = ScrollingContainer
	ToggleButton.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
	ToggleButton.BorderSizePixel = 0
	ToggleButton.Size = UDim2.new(1, 0, 0, 42)
	ToggleButton.Font = Enum.Font.GothamMedium
	ToggleButton.Text = "    " .. labelText
	ToggleButton.TextColor3 = Color3.fromRGB(230, 230, 230)
	ToggleButton.TextSize = 14.000
	ToggleButton.TextXAlignment = Enum.TextXAlignment.Left

	local StatusBadge = Instance.new("TextLabel")
	StatusBadge.Parent = ToggleButton
	StatusBadge.BackgroundTransparency = 1.000
	StatusBadge.Position = UDim2.new(1, -95, 0, 0)
	StatusBadge.Size = UDim2.new(0, 85, 1, 0)
	StatusBadge.Font = Enum.Font.GothamBold
	StatusBadge.Text = defaultState and "[ ACTIVE ]" else "[ OFF ]"
	StatusBadge.TextColor3 = defaultState and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 60, 60)
	StatusBadge.TextSize = 12.000

	local currentState = defaultState
	
	local function updateVisuals(state)
		currentState = state
		StatusBadge.Text = state and "[ ACTIVE ]" or "[ OFF ]"
		StatusBadge.TextColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 60, 60)
		pcall(callback, state)
	end

	ToggleButton.MouseButton1Click:Connect(function()
		updateVisuals(not currentState)
	end)

	return {
		Set = updateVisuals,
		Get = function() return currentState end
	}
end

-- Build Toggles on UI Layout
local AimbotControl = buildToggleUI("Enemy Aimbot [Key: E]", false, function(state)
	ScriptConfig.Aimbot = state
end)

local ESPControl = buildToggleUI("Enemy Highlight ESP [Key: R]", false, function(state)
	ScriptConfig.ESP = state
	if not state then
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("NovusHighlightESP") then
				player.Character.NovusHighlightESP:Destroy()
			end
		end
	end
end)

local TeamCheckControl = buildToggleUI("Strict Team Validation", true, function(state)
	ScriptConfig.TeamCheck = state
end)

-- Mobile Floating Icon Handler (Android Compatibility)
local MobileFloatingBtn = Instance.new("TextButton")
MobileFloatingBtn.Name = "MobileFloatingBtn"
MobileFloatingBtn.Parent = ScreenGui
MobileFloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MobileFloatingBtn.BorderColor3 = Color3.fromRGB(0, 190, 255)
MobileFloatingBtn.BorderSizePixel = 2
MobileFloatingBtn.Position = UDim2.new(0, 15, 0.35, 0)
MobileFloatingBtn.Size = UDim2.new(0, 55, 0, 55)
MobileFloatingBtn.Font = Enum.Font.GothamBold
MobileFloatingBtn.Text = "NOVUS"
MobileFloatingBtn.TextColor3 = Color3.fromRGB(0, 190, 255)
MobileFloatingBtn.TextSize = 11.000
MobileFloatingBtn.Draggable = true

MobileFloatingBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- UI Interactive Controls
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	ScrollingContainer.Visible = not isMinimized
	MainFrame.Size = isMinimized and UDim2.new(0, 400, 0, 40) or UDim2.new(0, 400, 0, 320)
end)

-- Hotkey System (PC Input Handling)
UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent)
	if gameProcessedEvent then return end
	
	if inputObject.KeyCode == Enum.KeyCode.E then
		AimbotControl.Set(not AimbotControl.Get())
	elseif inputObject.KeyCode == Enum.KeyCode.R then
		ESPControl.Set(not ESPControl.Get())
	elseif inputObject.KeyCode == Enum.KeyCode.RightShift then
		isMinimized = not isMinimized
		ScrollingContainer.Visible = not isMinimized
		MainFrame.Size = isMinimized and UDim2.new(0, 400, 0, 40) or UDim2.new(0, 400, 0, 320)
	end
end)

-- Core Feature Loop: Advanced ESP System
RunService.RenderStepped:Connect(function()
	if ScriptConfig.ESP then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local character = player.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					local isTeammate = ScriptConfig.TeamCheck and player.Team and player.Team == LocalPlayer.Team
					if not isTeammate then
						if not character:FindFirstChild("NovusHighlightESP") then
							local highlightInstance = Instance.new("Highlight")
							highlightInstance.Name = "NovusHighlightESP"
							highlightInstance.Adornee = character
							highlightInstance.FillColor = Color3.fromRGB(255, 30, 30)
							highlightInstance.OutlineColor = Color3.fromRGB(255, 255, 255)
							highlightInstance.FillTransparency = 0.45
							highlightInstance.OutlineTransparency = 0.1
							highlightInstance.Parent = character
						end
					else
						if character:FindFirstChild("NovusHighlightESP") then
							character.NovusHighlightESP:Destroy()
						end
					end
				end
			end
		end
	end
end)

-- Core Feature Loop: Robust Enemy Aim Locking System
RunService.RenderStepped:Connect(function()
	if ScriptConfig.Aimbot then
		if not CurrentCamera then 
			CurrentCamera = Workspace.CurrentCamera 
			return 
		end
		
		local targetPart = nil
		local minDistanceToCenter = math.huge
		local mouseLocation = UserInputService:GetMouseLocation()

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local isTeammate = ScriptConfig.TeamCheck and player.Team and player.Team == LocalPlayer.Team
				if not isTeammate then
					local char = player.Character
					if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
						local aimPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
						if aimPart then
							local screenPoint, onScreen = CurrentCamera:WorldToViewportPoint(aimPart.Position)
							if onScreen then
								local screenVector = Vector2.new(screenPoint.X, screenPoint.Y)
								local distanceFromMouse = (screenVector - mouseLocation).Magnitude
								
								if distanceFromMouse < minDistanceToCenter then
									minDistanceToCenter = distanceFromMouse
									targetPart = aimPart
								end
							end
						end
					end
				end
			end
		end

		if targetPart then
			CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, targetPart.Position)
		end
	end
end)

print("Novus Hub Ultimate Loaded Successfully!")
