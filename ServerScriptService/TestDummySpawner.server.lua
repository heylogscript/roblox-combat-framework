local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CombatRemoteEvents = require(ReplicatedStorage.CombatRemoteEvents.Main)

local dummies = {}

local function SpawnDummy(position)
	local root = Instance.new("Part")
	root.Name = "HumanoidRootPart"
	root.Size = Vector3.new(3, 4, 2)
	root.Position = position
	root.Anchored = true
	root.CanCollide = false
	root.BrickColor = BrickColor.new("Bright red")
	root.Transparency = 0.3

	local model = Instance.new("Model")
	model.Name = "TestDummy"
	root.Parent = model

	local humanoid = Instance.new("Humanoid")
	humanoid.Name = "Humanoid"
	humanoid.Parent = model

	model.PrimaryPart = root
	model.Parent = workspace

	local combatFolder = Instance.new("Folder")
	combatFolder.Name = "CombatStats"
	combatFolder.Parent = model

	Instance.new("NumberValue", combatFolder).Name = "Health"
	combatFolder.Health.Value = 100
	Instance.new("NumberValue", combatFolder).Name = "Stamina"
	combatFolder.Stamina.Value = 100
	Instance.new("NumberValue", combatFolder).Name = "GuardBar"
	combatFolder.GuardBar.Value = 100
	Instance.new("StringValue", combatFolder).Name = "CombatState"
	combatFolder.CombatState.Value = "Idle"

	table.insert(dummies, model)
	return model
end

local players = game:GetService("Players")
players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(2)
		local pos = character:GetPivot().Position + character:GetPivot().LookVector * 6
		SpawnDummy(pos)
	end)
end)

local function InitDummies()
	for _, player in ipairs(players:GetPlayers()) do
		if player.Character then
			local pos = player.Character:GetPivot().Position + player.Character:GetPivot().LookVector * 6
			SpawnDummy(pos)
		end
	end
end

task.wait(2)
InitDummies()

print("[TestDummy] Spawned! Walk near the red dummy and press 1-5 to attack.")
