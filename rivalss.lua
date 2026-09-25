-- ============================================================
-- NOVUS AIM ASSIST + ESP CORE
-- For your own Roblox Studio experience
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local Config = {
	Aimbot = {
		Enabled = false,
		Keybind = Enum.KeyCode.E,
		IsHoldingKey = false,

		Smoothness = 0.15,
		FOV = 400,
		TargetPart = "Head",

		TeamCheck = true,

		Prediction = true,
		PredictionFactor = 0.038,

		RequireLineOfSight = false
	},

	ESP = {
		Enabled = false,
		TeamCheck = true
	}
}

-- ============================================================
-- TEAM / ENEMY VALIDATION
-- ============================================================

local function IsEnemy(player)
	if not player or player == LocalPlayer then
		return false
	end

	if not Config.Aimbot.TeamCheck then
		return true
	end

	-- Never treat an unknown team as an enemy.
	if not player.Team or not LocalPlayer.Team then
		return false
	end

	return player.Team ~= LocalPlayer.Team
end

local function IsESPEnemy(player)
	if not player or player == LocalPlayer then
		return false
	end

	if not Config.ESP.TeamCheck then
		return true
	end

	if not player.Team or not LocalPlayer.Team then
		return false
	end

	return player.Team ~= LocalPlayer.Team
end

-- ============================================================
-- CHARACTER VALIDATION
-- ============================================================

local function GetValidCharacter(player)
	if not player then
		return nil, nil, nil
	end

	local character = player.Character
	if not character then
		return nil, nil, nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return nil, nil, nil
	end

	local targetPart =
		character:FindFirstChild(Config.Aimbot.TargetPart)
		or character:FindFirstChild("HumanoidRootPart")

	if not targetPart or not targetPart:IsA("BasePart") then
		return nil, nil, nil
	end

	return character, humanoid, targetPart
end

-- ============================================================
-- LINE OF SIGHT
-- ============================================================

local function HasLineOfSight(camera, character, targetPart)
	if not Config.Aimbot.RequireLineOfSight then
		return true
	end

	local origin = camera.CFrame.Position
	local direction = targetPart.Position - origin

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {
		LocalPlayer.Character
	}

	local result = Workspace:Raycast(origin, direction, params)

	if not result then
		return true
	end

	return result.Instance:IsDescendantOf(character)
end

-- ============================================================
-- TARGET SELECTION
-- ============================================================

local function FindBestTarget(camera)
	local screenCenter = camera.ViewportSize / 2

	local bestTarget = nil
	local bestDistance = Config.Aimbot.FOV

	for _, player in ipairs(Players:GetPlayers()) do

		if IsEnemy(player) then

			local character, humanoid, targetPart =
				GetValidCharacter(player)

			if character and humanoid and targetPart then

				local screenPosition, onScreen =
					camera:WorldToViewportPoint(targetPart.Position)

				if onScreen and screenPosition.Z > 0 then

					local screenPoint =
						Vector2.new(screenPosition.X, screenPosition.Y)

					local distance =
						(screenPoint - screenCenter).Magnitude

					if distance <= bestDistance then

						if HasLineOfSight(
							camera,
							character,
							targetPart
						) then

							bestDistance = distance

							bestTarget = {
								Player = player,
								Character = character,
								Humanoid = humanoid,
								Part = targetPart
							}
						end
					end
				end
			end
		end
	end

	return bestTarget
end

-- ============================================================
-- AIM ASSIST
-- ============================================================

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.KeyCode == Config.Aimbot.Keybind then
		Config.Aimbot.IsHoldingKey = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Config.Aimbot.Keybind then
		Config.Aimbot.IsHoldingKey = false
	end
end)

local CurrentTarget = nil

RunService.RenderStepped:Connect(function()

	if not Config.Aimbot.Enabled then
		CurrentTarget = nil
		return
	end

	if not Config.Aimbot.IsHoldingKey then
		CurrentTarget = nil
		return
	end

	local camera = Workspace.CurrentCamera

	if not camera then
		return
	end

	-- Validate existing target first.
	if CurrentTarget then

		local player = CurrentTarget.Player

		if not IsEnemy(player) then
			CurrentTarget = nil
		else
			local character, humanoid, targetPart =
				GetValidCharacter(player)

			if not character
				or not humanoid
				or not targetPart
				or not HasLineOfSight(
					camera,
					character,
					targetPart
				) then

				CurrentTarget = nil
			else
				CurrentTarget.Character = character
				CurrentTarget.Humanoid = humanoid
				CurrentTarget.Part = targetPart
			end
		end
	end

	-- Only acquire a new target when necessary.
	if not CurrentTarget then
		CurrentTarget = FindBestTarget(camera)
	end

	if not CurrentTarget then
		return
	end

	local targetPart = CurrentTarget.Part

	if not targetPart or not targetPart.Parent then
		CurrentTarget = nil
		return
	end

	local finalPosition = targetPart.Position

	-- Velocity prediction.
	if Config.Aimbot.Prediction then

		local root =
			CurrentTarget.Character:FindFirstChild(
				"HumanoidRootPart"
			)

		if root then
			finalPosition =
				finalPosition
				+ root.AssemblyLinearVelocity
				* Config.Aimbot.PredictionFactor
		end
	end

	local targetCFrame =
		CFrame.lookAt(
			camera.CFrame.Position,
			finalPosition
		)

	camera.CFrame =
		camera.CFrame:Lerp(
			targetCFrame,
			math.clamp(
				Config.Aimbot.Smoothness,
				0,
				1
			)
		)
end)

-- ============================================================
-- ESP
-- ============================================================

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "NovusESP"
ESPFolder.Parent = Workspace

local function RemoveESP(character)
	if not character then
		return
	end

	local highlight =
		character:FindFirstChild("NovusChamsESP")

	if highlight then
		highlight:Destroy()
	end
end

local function AddESP(character)
	if not character then
		return
	end

	if character:FindFirstChild("NovusChamsESP") then
		return
	end

	local highlight = Instance.new("Highlight")

	highlight.Name = "NovusChamsESP"
	highlight.Adornee = character

	highlight.FillColor =
		Color3.fromRGB(255, 40, 40)

	highlight.OutlineColor =
		Color3.fromRGB(255, 255, 255)

	highlight.FillTransparency = 0.45
	highlight.OutlineTransparency = 0.1

	highlight.DepthMode =
		Enum.HighlightDepthMode.AlwaysOnTop

	highlight.Parent = character
end

RunService.RenderStepped:Connect(function()

	for _, player in ipairs(Players:GetPlayers()) do

		if player ~= LocalPlayer then

			local character = player.Character

			if Config.ESP.Enabled
				and character
				and IsESPEnemy(player) then

				AddESP(character)

			elseif character then

				RemoveESP(character)
			end
		end
	end
end)

-- ============================================================
-- CLEANUP WHEN PLAYERS LEAVE
-- ============================================================

Players.PlayerRemoving:Connect(function(player)

	if CurrentTarget
		and CurrentTarget.Player == player then

		CurrentTarget = nil
	end
end)

print("Novus Aim Assist / ESP core loaded.")
