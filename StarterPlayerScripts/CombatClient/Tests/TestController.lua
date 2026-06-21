local userInput = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CombatRemoteEvents = require(ReplicatedStorage.CombatRemoteEvents.Main)
local player = game:GetService("Players").LocalPlayer

local HUD = require(script.Parent.CreateHUD)

local attacks = {
	[Enum.KeyCode.One] = {
		name = "Jab",
		type = "MeleeLight",
		hitMethod = "Shapecast",
		damage = 8,
		staminaCost = 5,
		guardDamage = 4,
		startupFrames = 3,
		activeFrames = 2,
		recoveryFrames = 5,
		range = 4,
		hitstunFrames = 6,
		knockbackForce = Vector3.new(5, 0, 0),
		knockbackDuration = 0.2,
		statusEffects = {},
		canBeParried = true,
		canBeClashed = true,
		canBeCountered = true,
	},
	[Enum.KeyCode.Two] = {
		name = "Cross",
		type = "MeleeLight",
		hitMethod = "Shapecast",
		damage = 12,
		staminaCost = 7,
		guardDamage = 6,
		startupFrames = 5,
		activeFrames = 2,
		recoveryFrames = 7,
		range = 5,
		hitstunFrames = 8,
		knockbackForce = Vector3.new(10, 2, 0),
		knockbackDuration = 0.3,
		statusEffects = {},
		canBeParried = true,
		canBeClashed = true,
		canBeCountered = true,
	},
	[Enum.KeyCode.Three] = {
		name = "Hook",
		type = "MeleeHeavy",
		hitMethod = "Shapecast",
		damage = 18,
		staminaCost = 12,
		guardDamage = 15,
		startupFrames = 8,
		activeFrames = 3,
		recoveryFrames = 10,
		range = 4,
		hitstunFrames = 12,
		knockbackForce = Vector3.new(15, 5, 0),
		knockbackDuration = 0.4,
		statusEffects = {},
		canBeParried = true,
		canBeClashed = false,
		canBeCountered = true,
	},
	[Enum.KeyCode.Four] = {
		name = "BoneSwordSlash",
		type = "MeleeHeavy",
		hitMethod = "Raycast",
		damage = 22,
		staminaCost = 15,
		guardDamage = 20,
		startupFrames = 10,
		activeFrames = 3,
		recoveryFrames = 12,
		range = 8,
		hitstunFrames = 14,
		knockbackForce = Vector3.new(20, 5, 0),
		knockbackDuration = 0.5,
		statusEffects = {name = "Bleed", chance = 0.5},
		canBeParried = true,
		canBeClashed = true,
		canBeCountered = false,
	},
	[Enum.KeyCode.Five] = {
		name = "DashStrike",
		type = "DashAttack",
		hitMethod = "PredictivePath",
		damage = 15,
		staminaCost = 20,
		guardDamage = 10,
		startupFrames = 4,
		activeFrames = 4,
		recoveryFrames = 6,
		range = 15,
		hitstunFrames = 10,
		knockbackForce = Vector3.new(8, 0, 0),
		knockbackDuration = 0.3,
		statusEffects = {},
		canBeParried = false,
		canBeClashed = false,
		canBeCountered = true,
	},
}

local function GetNearestTarget()
	local character = player.Character
	if not character then return nil end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end

	local nearest = nil
	local nearestDist = math.huge

	for _, child in ipairs(workspace:GetChildren()) do
		if child.Name == "TestDummy" then
			local dummyRoot = child:FindFirstChild("HumanoidRootPart")
			if dummyRoot then
				local dist = (root.Position - dummyRoot.Position).Magnitude
				if dist < nearestDist then
					nearestDist = dist
					nearest = child
				end
			end
		end
	end

	return nearest, nearestDist
end

userInput.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.R then
		CombatRemoteEvents.RequestRespawn:FireServer()
		HUD.AddLog("[Test] R pressed - can use for custom action")
		return
	end

	if input.KeyCode == Enum.KeyCode.Q then
		local target, dist = GetNearestTarget()
		if target then
			HUD.AddLog("[Test] Target found: " .. target.Name .. " (" .. math.floor(dist) .. " studs)")
		else
			HUD.AddLog("[Test] No target in range")
		end
		return
	end

	for keyCode, attackConfig in pairs(attacks) do
		if input.KeyCode == keyCode then
			HUD.AddLog("[Test] Attack: " .. attackConfig.name)
			CombatRemoteEvents.Attack:FireServer(attackConfig)
			return
		end
	end
end)

HUD.AddLog("=== Combat Test Ready ===")
HUD.AddLog("Keys: 1=Jab 2=Cross 3=Hook")
HUD.AddLog("Keys: 4=BoneSword 5=DashStrike")
HUD.AddLog("Q=Find target")

return true
