local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "WestboundCheatHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 400)
frame.Position = UDim2.new(0, -250, 0.5, -200)
frame.AnchorPoint = Vector2.new(0, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Visible = true
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Text = "Westbound Cheat Hub"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 5)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

local function createToggle(name)
	local toggle = Instance.new("TextButton")
	toggle.Name = name .. "Toggle"
	toggle.Size = UDim2.new(0.9, 0, 0, 35)
	toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Font = Enum.Font.Gotham
	toggle.TextSize = 16
	toggle.TextXAlignment = Enum.TextXAlignment.Left
	toggle.AutoButtonColor = false
	toggle.Text = "  " .. name .. ": OFF"
	toggle.ClipsDescendants = true

	Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 0, 1, 0)
	indicator.Position = UDim2.new(0, 0, 0, 0)
	indicator.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	indicator.ZIndex = 0
	indicator.BorderSizePixel = 0
	indicator.Parent = toggle
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 8)

	toggle.ZIndex = 1

	local on = false
	toggle.MouseButton1Click:Connect(function()
		on = not on
		toggle.Text = "  " .. name .. ": " .. (on and "ON" or "OFF")
		TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Size = on and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 0, 1, 0)
		}):Play()
		_G[name .. "Enabled"] = on
	end)

	toggle.Parent = frame
end

createToggle("ESP")
createToggle("Boxes")
createToggle("Tracers")
createToggle("Aimbot")
createToggle("HitboxExpander")
createToggle("AntiAim")

local discord = Instance.new("TextLabel", frame)
discord.Size = UDim2.new(1, 0, 0, 20)
discord.Text = "discord.gg/TdA3egXnB3"
discord.BackgroundTransparency = 1
discord.TextColor3 = Color3.fromRGB(200, 200, 200)
discord.Font = Enum.Font.Gotham
discord.TextSize = 14

local nameTag = Instance.new("TextLabel", frame)
nameTag.Size = UDim2.new(1, 0, 0, 20)
nameTag.Text = "Bo's Westbound"
nameTag.BackgroundTransparency = 1
nameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
nameTag.Font = Enum.Font.GothamSemibold
nameTag.TextSize = 15

local open = false
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.K then
		open = not open
		local targetPos = open and UDim2.new(0, 20, 0.5, -200) or UDim2.new(0, -250, 0.5, -200)
		TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Position = targetPos
		}):Play()
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Global toggle (make sure this matches your GUI toggle)
_G.ESPEnabled = _G.ESPEnabled or false

-- === ESP (Highlight) ===
local function getTeamColor(player)
	if not player.Team or not LocalPlayer.Team then
		return Color3.fromRGB(255, 255, 255)
	end
	return player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

local function removeESP(player)
	local tag = "ESP_" .. player.Name
	local highlight = CoreGui:FindFirstChild(tag)
	if highlight then
		highlight:Destroy()
	end
end

local function updateESP(player)
	if not _G.ESPEnabled then
		removeESP(player)
		return
	end

	if player == LocalPlayer or not player.Character then return end

	local tag = "ESP_" .. player.Name
	local highlight = CoreGui:FindFirstChild(tag)

	if not highlight then
		highlight = Instance.new("Highlight")
		highlight.Name = tag
		highlight.FillColor = getTeamColor(player)
		highlight.OutlineColor = Color3.new(0, 0, 0)
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
		highlight.Adornee = player.Character
		highlight.Parent = CoreGui
	else
		-- Reattach if character changes
		if highlight.Adornee ~= player.Character then
			highlight.Adornee = player.Character
		end
		highlight.FillColor = getTeamColor(player)
	end
end

-- Set up ESP logic
local function setupESP(player)
	if player == LocalPlayer then return end

	player.CharacterAdded:Connect(function()
		wait(0.5)
		updateESP(player)
	end)
end

-- Setup existing and future players
for _, player in ipairs(Players:GetPlayers()) do
	setupESP(player)
end
Players.PlayerAdded:Connect(setupESP)

-- Constant refresh loop
RunService.RenderStepped:Connect(function()
	for _, player in ipairs(Players:GetPlayers()) do
		updateESP(player)
	end
end)


-- === Tracers ===
local tracers = {}

local function clearTracers()
	for _, line in pairs(tracers) do
		if line and line.Remove then
			line:Remove()
		elseif line and line.Destroy then
			line:Destroy()
		end
	end
	tracers = {}
end

-- === Box ESP ===
local drawingBoxes = {}

local function removeBoxes()
	for _, tbl in pairs(drawingBoxes) do
		for _, obj in pairs(tbl) do
			if obj and obj.Remove then
				obj:Remove()
			elseif obj and obj.Destroy then
				obj:Destroy()
			end
		end
	end
	drawingBoxes = {}
end

local function drawBoxESP(player)
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = player.Character.HumanoidRootPart
	local humanoid = player.Character:FindFirstChild("Humanoid")
	if not humanoid then return end
	local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
	if not onScreen then return end
	local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
	local scaleFactor = 1 / distance * 100
	local width = 30 * scaleFactor
	local height = 60 * scaleFactor

	local box = Drawing.new("Square")
	box.Thickness = 1.5
	box.Size = Vector2.new(width, height)
	box.Position = Vector2.new(screenPos.X - width / 2, screenPos.Y - height / 2)
	box.Color = Color3.fromRGB(255, 255, 255)
	box.Transparency = 1
	box.Visible = true

	local healthbar = Drawing.new("Square")
	healthbar.Thickness = 1
	healthbar.Filled = true
	local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
	healthbar.Size = Vector2.new(2, height * healthPercent)
	healthbar.Position = Vector2.new(screenPos.X - width / 2 - 4, screenPos.Y - height / 2 + (height * (1 - healthPercent)))
	if player.Team == LocalPlayer.Team then
		healthbar.Color = Color3.fromRGB(0, 255, 0) -- Green for teammates
	else
		healthbar.Color = Color3.fromRGB(255, 0, 0) -- Red for enemies
	end
	healthbar.Transparency = 1
	healthbar.Visible = true

	drawingBoxes[player] = {box, healthbar}
end

-- === Unified Render Loop ===
RunService.RenderStepped:Connect(function()
	if not _G.ESPEnabled then
		for _, v in ipairs(CoreGui:GetChildren()) do
			if v:IsA("Highlight") and v.Name:match("^ESP_") then
				v:Destroy()
			end
		end
	end

	if not _G.TracersEnabled then
		clearTracers()
	end

	if not _G.BoxesEnabled then
		removeBoxes()
	end

	clearTracers()
	removeBoxes()

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if _G.ESPEnabled then
				updateESP(player)
			end

			if _G.TracersEnabled then
				local hrp = player.Character:FindFirstChild("HumanoidRootPart")
				local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
				if onScreen then
					local line = Drawing.new("Line")
					line.Thickness = 1.5
					line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
					line.To = Vector2.new(pos.X, pos.Y)
					line.Color = getTeamColor(player)
					line.Transparency = 1
					line.Visible = true
					table.insert(tracers, line)
				end
			end

			if _G.BoxesEnabled then
				drawBoxESP(player)
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local tag = CoreGui:FindFirstChild("ESP_" .. player.Name)
	if tag then tag:Destroy() end
	if drawingBoxes[player] then
		for _, d in pairs(drawingBoxes[player]) do
			if d and d.Remove then d:Remove() end
		end
		drawingBoxes[player] = nil
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.5)
		if _G.ESPEnabled then
			updateESP(player)
		end
	end)
end)

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local panelVisible = false
_G.FOVSize = _G.FOVSize or 120
_G.HitboxSize = _G.HitboxSize or 2

-- Create GUI
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "CheatSettingsGUI"
screenGui.ResetOnSpawn = false

local panel = Instance.new("Frame", screenGui)
panel.Size = UDim2.new(0, 220, 0, 130)
panel.Position = UDim2.new(0, 30, 0.5, -65)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panel.BorderSizePixel = 0
panel.Visible = false
panel.Active = true
panel.Draggable = true

local corner = Instance.new("UICorner", panel)
corner.CornerRadius = UDim.new(0, 10)

-- FOV Size
local fovLabel = Instance.new("TextLabel", panel)
fovLabel.Text = "FOV Size: " .. tostring(_G.FOVSize)
fovLabel.Position = UDim2.new(0, 10, 0, 10)
fovLabel.Size = UDim2.new(0, 140, 0, 25)
fovLabel.BackgroundTransparency = 1
fovLabel.TextColor3 = Color3.new(1, 1, 1)
fovLabel.TextXAlignment = Enum.TextXAlignment.Left

local minusFOV = Instance.new("TextButton", panel)
minusFOV.Text = "-"
minusFOV.Size = UDim2.new(0, 25, 0, 25)
minusFOV.Position = UDim2.new(0, 160, 0, 10)
minusFOV.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minusFOV.TextColor3 = Color3.fromRGB(255, 255, 255)

local plusFOV = Instance.new("TextButton", panel)
plusFOV.Text = "+"
plusFOV.Size = UDim2.new(0, 25, 0, 25)
plusFOV.Position = UDim2.new(0, 190, 0, 10)
plusFOV.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
plusFOV.TextColor3 = Color3.fromRGB(255, 255, 255)

minusFOV.MouseButton1Click:Connect(function()
	_G.FOVSize = math.max(10, _G.FOVSize - 10)
	fovLabel.Text = "FOV Size: " .. tostring(_G.FOVSize)
end)

plusFOV.MouseButton1Click:Connect(function()
	_G.FOVSize = math.min(1000, _G.FOVSize + 10)
	fovLabel.Text = "FOV Size: " .. tostring(_G.FOVSize)
end)

-- Hitbox Size
local hitboxLabel = Instance.new("TextLabel", panel)
hitboxLabel.Text = "Hitbox Size: " .. tostring(_G.HitboxSize)
hitboxLabel.Position = UDim2.new(0, 10, 0, 50)
hitboxLabel.Size = UDim2.new(0, 140, 0, 25)
hitboxLabel.BackgroundTransparency = 1
hitboxLabel.TextColor3 = Color3.new(1, 1, 1)
hitboxLabel.TextXAlignment = Enum.TextXAlignment.Left

local minusHitbox = Instance.new("TextButton", panel)
minusHitbox.Text = "-"
minusHitbox.Size = UDim2.new(0, 25, 0, 25)
minusHitbox.Position = UDim2.new(0, 160, 0, 50)
minusHitbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minusHitbox.TextColor3 = Color3.fromRGB(255, 255, 255)

local plusHitbox = Instance.new("TextButton", panel)
plusHitbox.Text = "+"
plusHitbox.Size = UDim2.new(0, 25, 0, 25)
plusHitbox.Position = UDim2.new(0, 190, 0, 50)
plusHitbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
plusHitbox.TextColor3 = Color3.fromRGB(255, 255, 255)

minusHitbox.MouseButton1Click:Connect(function()
	_G.HitboxSize = math.max(1, _G.HitboxSize - 1.0)
	hitboxLabel.Text = "Hitbox Size: " .. string.format("%.1f", _G.HitboxSize)
end)

plusHitbox.MouseButton1Click:Connect(function()
	_G.HitboxSize = math.min(20, _G.HitboxSize + 1.0)
	hitboxLabel.Text = "Hitbox Size: " .. string.format("%.1f", _G.HitboxSize)
end)

-- Toggle GUI with L
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.L then
		panelVisible = not panelVisible
		panel.Visible = panelVisible
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Defaults
_G.FOVSize = _G.FOVSize or 120
_G.AimbotEnabled = _G.AimbotEnabled or false

-- FOV Circle
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(255, 0, 0)
circle.Thickness = 1.5
circle.NumSides = 100
circle.Filled = false
circle.Visible = false
circle.Radius = _G.FOVSize

-- Target Check
local function isValidTarget(player)
	if not player or player == LocalPlayer then return false end
	local character = player.Character
	if not character then return false end
	local head = character:FindFirstChild("Head")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not head or not humanoid or humanoid.Health <= 0 then return false end

	-- Team check
	if LocalPlayer.Team and player.Team then
		local teamA, teamB = tostring(LocalPlayer.Team), tostring(player.Team)
		if teamA == "Cowboys" and teamB == "Cowboys" then return false end
	end

	return true
end

-- Closest in FOV
local function getClosestInFOV()
	local closestPlayer = nil
	local closestDistance = math.huge
	local mousePos = UserInputService:GetMouseLocation()

	for _, player in pairs(Players:GetPlayers()) do
		if isValidTarget(player) then
			local headPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
			if onScreen then
				local headScreenPos = Vector2.new(headPos.X, headPos.Y)
				local dist = (headScreenPos - mousePos).Magnitude
				if dist <= _G.FOVSize and dist < closestDistance then
					closestDistance = dist
					closestPlayer = player
				end
			end
		end
	end

	return closestPlayer
end

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
	circle.Position = UserInputService:GetMouseLocation()
	circle.Radius = _G.FOVSize
	circle.Visible = _G.AimbotEnabled

	if _G.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		local target = getClosestInFOV()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)

-- Head Hitbox Expander (Mesh Scale Method – Fully Synced with GUI)

-- Head Hitbox Expander (Final Fixed with Reset on Team Change + Friend Check)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

_G.HitboxExpandEnabled = true
_G.HitboxSize = _G.HitboxSize or 2

-- Check if a player is an enemy
local function isEnemy(player)
	if player == LocalPlayer then return false end
	if LocalPlayer:IsFriendsWith(player.UserId) then return false end
	if not player.Team or not LocalPlayer.Team then return false end
	if LocalPlayer.Team.Name == "Outlaws" then
		return true -- Outlaws can target anyone (except friends)
	end
	return player.Team.Name ~= LocalPlayer.Team.Name -- Cowboys can't target Cowboys
end

-- Resets a head's size and visuals
local function resetHead(head)
	if head and head:IsA("BasePart") then
		head.Size = Vector3.new(2, 1, 1) -- Default head size in Roblox
		head.Transparency = 0
		head.Material = Enum.Material.Plastic
		head.Color = Color3.fromRGB(255, 255, 255)
		if head:FindFirstChild("HitboxTag") then
			head:FindFirstChild("HitboxTag"):Destroy()
		end
	end
end

-- Main hitbox loop
RunService.RenderStepped:Connect(function()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local character = player.Character
			local head = character and character:FindFirstChild("Head")
			local humanoid = character and character:FindFirstChild("Humanoid")

			if head and humanoid then
				if _G.HitboxExpandEnabled and humanoid.Health > 0 and isEnemy(player) then
					if head.Size ~= Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize) then
						head.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
					end
					head.Transparency = 0.5
					head.Color = Color3.fromRGB(255, 0, 0)
					head.Material = Enum.Material.ForceField
					head.CanCollide = false
					head.Massless = true
					if not head:FindFirstChild("HitboxTag") then
						local tag = Instance.new("BoolValue")
						tag.Name = "HitboxTag"
						tag.Parent = head
					end
				else
					-- Reset any leftover heads that aren't enemies or are dead
					if head:FindFirstChild("HitboxTag") then
						resetHead(head)
					end
				end
			end
		end
	end
end)

-- Fast Anti-Aim Spin (Main GUI Patched)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local RootPart = nil
local SpinAngle = 0

-- Defaults
_G.AntiAimEnabled = _G.AntiAimEnabled or false
_G.AntiAimSpinSpeed = _G.AntiAimSpinSpeed or 7000 -- Super fast spin

-- On character load
LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	RootPart = char:FindFirstChild("HumanoidRootPart")
	SpinAngle = 0
end)

-- Per-frame spin logic
RunService.RenderStepped:Connect(function()
	if not _G.AntiAimEnabled then return end
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

	RootPart = LocalPlayer.Character.HumanoidRootPart

	-- Update spin
	SpinAngle = (SpinAngle + _G.AntiAimSpinSpeed * RunService.RenderStepped:Wait()) % 360
	local spinRotation = CFrame.Angles(0, math.rad(SpinAngle), 0)
	RootPart.CFrame = CFrame.new(RootPart.Position) * spinRotation
end)
