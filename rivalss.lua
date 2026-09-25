-- Novus Hub - Roblox Rivals
-- Compatible with Android & PC

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Prevent multiple instances
if CoreGui:FindFirstChild("NovusHub") then
	CoreGui.NovusHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovusHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar
local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "  Novus Hub | Rivals"
TitleBar.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleBar.TextSize = 16.000
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14.000

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -60, 0, 5)
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14.000

-- Container for toggles
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Parent = MainFrame
Container.Active = true
Container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Container.BorderSizePixel = 0
Container.Position = UDim2.new(0, 10, 0, 45)
Container.Size = UDim2.new(1, -20, 1, -55)
Container.CanvasSize = UDim2.new(0, 0, 0, 120)
Container.ScrollBarThickness = 4

-- UI Toggle Creator Function
local function createToggle(name, defaultState, callback)
	local yPos = (#Container:GetChildren() - 1) * 45
	
	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Name = name .. "Toggle"
	ToggleBtn.Parent = Container
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	ToggleBtn.BorderSizePixel = 0
	ToggleBtn.Position = UDim2.new(0, 0, 0, yPos)
	ToggleBtn.Size = UDim2.new(1, 0, 0, 35)
	ToggleBtn.Font = Enum.Font.Gotham
	ToggleBtn.Text = "  " .. name
	ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToggleBtn.TextSize = 14.000
	ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

	local StatusLabel = Instance.new("TextLabel")
	StatusLabel.Name = "Status"
	StatusLabel.Parent = ToggleBtn
	StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	StatusLabel.BackgroundTransparency = 1.000
	StatusLabel.Position = UDim2.new(1, -80, 0, 0)
	StatusLabel.Size = UDim2.new(0, 70, 1, 0)
	StatusLabel.Font = Enum.Font.GothamBold
	StatusLabel.Text = defaultState and "ON" or "OFF"
	StatusLabel.TextColor3 = defaultState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	StatusLabel.TextSize = 14.000

	local state = defaultState
	ToggleBtn.MouseButton1Click:Connect(function()
		state = not state
		StatusLabel.Text = state and "ON" or "OFF"
		StatusLabel.TextColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		callback(state)
	end)
	
	return function(newState)
		if newState ~= nil then state = newState end
		StatusLabel.Text = state and "ON" or "OFF"
		StatusLabel.TextColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		callback(state)
		return state
	end
end

-- Feature States
local AimbotEnabled = false
local ESPEnabled = false

-- Toggle Callbacks
local toggleAimbot = createToggle("Enemy Aimbot [Key: E]", false, function(state)
	AimbotEnabled = state
end)

local toggleESP = createToggle("Enemy ESP [Key: R]", false, function(state)
	ESPEnabled = state
	if not state then
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("NovusESP") then
				player.Character.NovusESP:Destroy()
			end
		end
	end
end)

-- Mobile Toggle Button (Floating UI icon for Android/Mobile users)
local MobileButton = Instance.new("TextButton")
MobileButton.Name = "MobileButton"
MobileButton.Parent = ScreenGui
MobileButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MobileButton.BorderColor3 = Color3.fromRGB(0, 170, 255)
MobileButton.BorderSizePixel = 2
MobileButton.Position = UDim2.new(0, 10, 0.4, 0)
MobileButton.Size = UDim2.new(0, 50, 0, 50)
MobileButton.Font = Enum.Font.GothamBold
MobileButton.Text = "NOVUS"
MobileButton.TextColor3 = Color3.fromRGB(0, 170, 255)
MobileButton.TextSize = 10.000
MobileButton.Draggable = true

MobileButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Close UI Action
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Minimize UI Action
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	Container.Visible = not minimized
	MainFrame.Size = minimized and UDim2.new(0, 350, 0, 35) or UDim2.new(0, 350, 0, 250)
end)

-- PC Hotkeys Logic
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.E then
		AimbotEnabled = toggleAimbot()
	elseif input.KeyCode == Enum.KeyCode.R then
		ESPEnabled = toggleESP()
	elseif input.KeyCode == Enum.KeyCode.RightShift then
		minimized = not minimized
		Container.Visible = not minimized
		MainFrame.Size = minimized and UDim2.new(0, 350, 0, 35) or UDim2.new(0, 350, 0, 250)
	end
end)

-- ESP Implementation
RunService.RenderStepped:Connect(function()
	if ESPEnabled then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local char = player.Character
				if not char:FindFirstChild("NovusESP") then
					local highlight = Instance.new("Highlight")
					highlight.Name = "NovusESP"
					highlight.Adornee = char
					highlight.FillColor = Color3.fromRGB(255, 0, 0)
					highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
					highlight.FillTransparency = 0.5
					highlight.Parent = char
				end
			end
		end
	end
end)

-- Aimbot Implementation (Targets closest enemy player)
RunService.RenderStepped:Connect(function()
	if AimbotEnabled then
		local camera = workspace.CurrentCamera
		local closestTarget = nil
		local shortestDistance = math.huge
		
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
				local targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
				if targetPart then
					local screenPoint, onScreen = camera:WorldToViewportPoint(targetPart.Position)
					if onScreen then
						local mousePos = UserInputService:GetMouseLocation()
						local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
						if distance < shortestDistance then
							shortestDistance = distance
							closestTarget = targetPart
						end
					end
				end
			end
		end
		
		if closestTarget then
			camera.CFrame = CFrame.new(camera.CFrame.Position, closestTarget.Position)
		end
	end
end)
