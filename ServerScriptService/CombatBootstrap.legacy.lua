local CombatEngine = require(game:GetService("ReplicatedStorage").CombatEngine.Main)
local CombatRemoteEvents = require(game:GetService("ReplicatedStorage").CombatRemoteEvents.Main)
local CombatHandler = require(script.Parent.CombatServer.CombatHandler)
local Config = require(game:GetService("ReplicatedStorage").CombatEngine.Config)

local players = game:GetService("Players")
local combatHandler = CombatHandler.new()

function SetupPlayer(player)
	local character = player.Character or player.CharacterAdded:Wait()

	local combatFolder = Instance.new("Folder")
	combatFolder.Name = "CombatStats"
	combatFolder.Parent = character

	local healthValue = Instance.new("NumberValue")
	healthValue.Name = "Health"
	healthValue.Value = 100
	healthValue.Parent = combatFolder

	local staminaValue = Instance.new("NumberValue")
	staminaValue.Name = "Stamina"
	staminaValue.Value = 100
	staminaValue.Parent = combatFolder

	local guardValue = Instance.new("NumberValue")
	guardValue.Name = "GuardBar"
	guardValue.Value = 100
	guardValue.Parent = combatFolder

	local stateValue = Instance.new("StringValue")
	stateValue.Name = "CombatState"
	stateValue.Value = "Idle"
	stateValue.Parent = combatFolder

	combatHandler:RegisterPlayer(player)
end

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.1)
		SetupPlayer(player)
	end)

	if player.Character then
		SetupPlayer(player)
	end
end)

players.PlayerRemoving:Connect(function(player)
	combatHandler:UnregisterPlayer(player)
end)

for _, player in ipairs(players:GetPlayers()) do
	task.spawn(function()
		if player.Character then
			SetupPlayer(player)
		end
	end)
end

combatHandler:Start()

game:GetService("RunService").Heartbeat:Connect(function()
	--- 60 FPS validation loop
end)

print("[CombatEngine] Server bootstrapper initialized")
