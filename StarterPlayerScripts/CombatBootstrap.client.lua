local CombatEngine = require(game:GetService("ReplicatedStorage").CombatEngine.Main)
local CombatRemoteEvents = require(game:GetService("ReplicatedStorage").CombatRemoteEvents.Main)
local InputHandler = require(script.Parent.CombatClient.InputHandler)
local ClientPredictor = require(script.Parent.CombatClient.ClientPredictor)
local VisualFeedback = require(script.Parent.CombatClient.VisualFeedback)
local Config = require(game:GetService("ReplicatedStorage").CombatEngine.Config)

local player = game:GetService("Players").LocalPlayer

local inputHandler = InputHandler.new(player)
local clientPredictor = ClientPredictor.new(player)
local visualFeedback = VisualFeedback.new(player)

inputHandler:OnInput(function(action)
	if action == "M1" then
		local attackConfig = {
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
		}

		if Config.Network.ClientPrediction then
			clientPredictor:PredictedAttack(attackConfig)
		end

		CombatRemoteEvents.Attack:FireServer(attackConfig)
	end
end)

CombatRemoteEvents.ApplyHitEffects.OnClientEvent:Connect(function(hitData)
	visualFeedback:PlayHitEffect(hitData)
end)

CombatRemoteEvents.SyncCombatState.OnClientEvent:Connect(function(stateData)
end)

CombatRemoteEvents.ApplyStatusEffect.OnClientEvent:Connect(function(character, effectName)
	visualFeedback:ShowStatusEffect(character, effectName, true)
end)

CombatRemoteEvents.RemoveStatusEffect.OnClientEvent:Connect(function(character, effectName)
	visualFeedback:ShowStatusEffect(character, effectName, false)
end)

local runService = game:GetService("RunService")
runService.Heartbeat:Connect(function(dt)
	if Config.Network.ClientPrediction then
		clientPredictor:Update(dt)
	end
end)

inputHandler:Bind()

task.spawn(function()
	local success = pcall(function()
		require(script.Parent.CombatClient.Tests.TestController)
	end)
	if not success then
		warn("[CombatEngine] TestController not loaded (safe to ignore in production)")
	end
end)

print("[CombatEngine] Client bootstrapper initialized")
