local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local function MakeBar(name, position, color)
	local frame = Instance.new("Frame")
	frame.Name = name .. "Frame"
	frame.Size = UDim2.new(0, 200, 0, 20)
	frame.Position = position
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = name .. ": 100/100"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.Parent = frame

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(1, 0, 1, 0)
	fill.BackgroundColor3 = color
	fill.BackgroundTransparency = 0.5
	fill.BorderSizePixel = 0
	fill.Parent = frame

	return {Frame = frame, Fill = fill, Label = label}
end

local bars = {
	Health = MakeBar("HP", UDim2.new(0.5, -100, 0.8, -60), Color3.fromRGB(50, 200, 50)),
	Stamina = MakeBar("STA", UDim2.new(0.5, -100, 0.8, -35), Color3.fromRGB(50, 150, 255)),
	Guard = MakeBar("GUARD", UDim2.new(0.5, -100, 0.8, -10), Color3.fromRGB(200, 200, 50)),
}

local combatStateLabel = Instance.new("TextLabel")
combatStateLabel.Name = "CombatStateLabel"
combatStateLabel.Size = UDim2.new(0, 150, 0, 24)
combatStateLabel.Position = UDim2.new(0.5, -75, 0.7, 0)
combatStateLabel.BackgroundTransparency = 1
combatStateLabel.Text = "State: Idle"
combatStateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
combatStateLabel.Font = Enum.Font.GothamBold
combatStateLabel.TextSize = 16
combatStateLabel.Parent = screenGui

local logBox = Instance.new("ScrollingFrame")
logBox.Name = "CombatLog"
logBox.Size = UDim2.new(0, 300, 0, 120)
logBox.Position = UDim2.new(0.02, 0, 0.7, 0)
logBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
logBox.BackgroundTransparency = 0.5
logBox.BorderSizePixel = 0
logBox.CanvasSize = UDim2.new(0, 0, 0, 0)
logBox.ScrollBarThickness = 4
logBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
logBox.Parent = screenGui

local logLayout = Instance.new("UIListLayout")
logLayout.Parent = logBox

local function AddLog(text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 18)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.Parent = logBox

	task.delay(5, function()
		label:Destroy()
	end)

	logBox.CanvasPosition = Vector2.new(0, logBox.CanvasSize.Y.Offset)
end

local CombatRemoteEvents = require(game:GetService("ReplicatedStorage").CombatRemoteEvents.Main)

CombatRemoteEvents.ApplyHitEffects.OnClientEvent:Connect(function(data)
	AddLog("Hit! Damage: " .. tostring(data.damage))
end)

local runService = game:GetService("RunService")
runService.Heartbeat:Connect(function()
	local character = player.Character
	if not character then return end

	local stats = character:FindFirstChild("CombatStats")
	if not stats then return end

	local healthVal = stats:FindFirstChild("Health")
	local staminaVal = stats:FindFirstChild("Stamina")
	local guardVal = stats:FindFirstChild("GuardBar")
	local stateVal = stats:FindFirstChild("CombatState")

	if healthVal then
		local pct = healthVal.Value / 100
		bars.Health.Fill.Size = UDim2.new(pct, 0, 1, 0)
		bars.Health.Label.Text = "HP: " .. tostring(healthVal.Value) .. "/100"
	end
	if staminaVal then
		local pct = staminaVal.Value / 100
		bars.Stamina.Fill.Size = UDim2.new(pct, 0, 1, 0)
		bars.Stamina.Label.Text = "STA: " .. tostring(staminaVal.Value) .. "/100"
	end
	if guardVal then
		local pct = guardVal.Value / 100
		bars.Guard.Fill.Size = UDim2.new(pct, 0, 1, 0)
		bars.Guard.Label.Text = "GUARD: " .. tostring(guardVal.Value) .. "/100"
	end
	if stateVal then
		combatStateLabel.Text = "State: " .. stateVal.Value
	end

	for _, dummy in ipairs(workspace:GetChildren()) do
		if dummy.Name == "TestDummy" then
			local dStats = dummy:FindFirstChild("CombatStats")
			if dStats then
				local h = dStats:FindFirstChild("Health")
				if h then
					local bar = dummy:FindFirstChild("HealthBar")
					if not bar then
						bar = Instance.new("BillboardGui")
						bar.Name = "HealthBar"
						bar.Size = UDim2.new(0, 100, 0, 12)
						bar.StudsOffset = Vector3.new(0, 3, 0)
						bar.Adornee = dummy.PrimaryPart
						bar.Parent = dummy

						local bg = Instance.new("Frame")
						bg.Size = UDim2.new(1, 0, 1, 0)
						bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
						bg.BorderSizePixel = 0
						bg.Parent = bar

						local fill = Instance.new("Frame")
						fill.Name = "Fill"
						fill.Size = UDim2.new(1, 0, 1, 0)
						fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
						fill.BorderSizePixel = 0
						fill.Parent = bg
					else
						local fill = bar:FindFirstChild("Frame")
						if fill then
							fill.Fill.Size = UDim2.new(h.Value / 100, 0, 1, 0)
						end
					end
				end
			end
		end
	end
end)

local userInput = game:GetService("UserInputService")
userInput.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.R then
		AddLog("--- Dummies Reset ---")
	end
end)

return {
	AddLog = AddLog,
}
