local CombatHandler = {}
CombatHandler.__index = CombatHandler

function CombatHandler.new()
	local self = setmetatable({}, CombatHandler)
	self._players = {}
	self._validator = require(script.Parent.ServerValidator).new()
	self._remoteEvents = require(game:GetService("ReplicatedStorage").CombatRemoteEvents.Main)
	return self
end

function CombatHandler:RegisterPlayer(player)
	if self._players[player] then
		return
	end

	self._players[player] = {
		combatState = "Idle",
		attackData = nil,
		comboCount = 0,
		lastAttackTime = 0,
	}

	self._remoteEvents.Attack.OnServerEvent:Connect(function(plr, attackConfig)
		if plr ~= player then return end
		self:OnPlayerAttack(player, attackConfig)
	end)

	self._remoteEvents.Block.OnServerEvent:Connect(function(plr, active)
		if plr ~= player then return end
		self:OnPlayerBlock(player, active)
	end)

	self._remoteEvents.Dash.OnServerEvent:Connect(function(plr, direction)
		if plr ~= player then return end
		self:OnPlayerDash(player, direction)
	end)

	self._remoteEvents.Parry.OnServerEvent:Connect(function(plr)
		if plr ~= player then return end
		self:OnPlayerParry(player)
	end)
end

function CombatHandler:UnregisterPlayer(player)
	self._players[player] = nil
end

function CombatHandler:OnPlayerAttack(player, attackConfig)
	local data = self._players[player]
	if not data then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	if os.clock() - data.lastAttackTime < 0.05 then
		return
	end

	data.lastAttackTime = os.clock()
	data.combatState = "Attacking"
	data.comboCount += 1

	self:ProcessAttack(player, character, attackConfig)
end

function CombatHandler:OnPlayerBlock(player, active)
	local data = self._players[player]
	if not data then
		return
	end
	data.combatState = active and "Blocking" or "Idle"
end

function CombatHandler:OnPlayerDash(player, direction)
	local data = self._players[player]
	if not data then
		return
	end
	data.combatState = "Dashing"
	task.delay(0.3, function()
		if self._players[player] then
			self._players[player].combatState = "Idle"
		end
	end)
end

function CombatHandler:OnPlayerParry(player)
	local data = self._players[player]
	if not data then
		return
	end
	data.combatState = "Parrying"
	task.delay(0.2, function()
		if self._players[player] then
			self._players[player].combatState = "Idle"
		end
	end)
end

function CombatHandler:ProcessAttack(attackerPlayer, character, attackConfig)
	local hitData = attackConfig

	local targets = self:FindTargetsInRange(character, hitData.range)
	for _, target in ipairs(targets) do
		local result = self._validator:ProcessHit(character, target, hitData)
		if result.success then
			local targetPlayer = game:GetService("Players"):GetPlayerFromCharacter(target)
			if not targetPlayer and target.Name == "TestDummy" then
				local combatFolder = target:FindFirstChild("CombatStats")
				if combatFolder then
					local health = combatFolder:FindFirstChild("Health")
					if health then
						health.Value = math.max(0, health.Value - result.damage)
					end
					local guardBar = combatFolder:FindFirstChild("GuardBar")
					if guardBar then
						guardBar.Value = math.max(0, guardBar.Value - result.damage * 0.5)
					end
				end
			elseif targetPlayer then
				self:ApplyHit(character, target, targetPlayer, result)
			end
		end
	end
end

function CombatHandler:FindTargetsInRange(character, range)
	local targets = {}
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return targets
	end

	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Character and player.Character ~= character then
			local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local dist = (root.Position - targetRoot.Position).Magnitude
				if dist <= range + 5 then
					table.insert(targets, player.Character)
				end
			end
		end
	end

	for _, child in ipairs(workspace:GetChildren()) do
		if child.Name == "TestDummy" and child ~= character then
			local targetRoot = child:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local dist = (root.Position - targetRoot.Position).Magnitude
				if dist <= range + 5 then
					table.insert(targets, child)
				end
			end
		end
	end

	return targets
end

function CombatHandler:ApplyHit(attacker, target, targetPlayer, result)
	local combatFolder = target:FindFirstChild("CombatStats")
	if not combatFolder then
		return
	end

	local health = combatFolder:FindFirstChild("Health")
	if health then
		health.Value = math.max(0, health.Value - result.damage)
	end

	local guardBar = combatFolder:FindFirstChild("GuardBar")
	if guardBar and result.knockbackForce.Magnitude > 0 then
		guardBar.Value = math.max(0, guardBar.Value - result.damage * 0.5)
	end

	if targetPlayer then
		self._remoteEvents.ApplyHitEffects:FireClient(targetPlayer, {
			damage = result.damage,
			knockbackForce = result.knockbackForce,
			hitstunFrames = result.hitstunFrames,
			statusEffects = result.statusEffects,
		})
	end
end

function CombatHandler:Start()
	local players = game:GetService("Players")
	players.PlayerAdded:Connect(function(player)
		self:RegisterPlayer(player)
	end)

	players.PlayerRemoving:Connect(function(player)
		self:UnregisterPlayer(player)
	end)

	for _, player in ipairs(players:GetPlayers()) do
		self:RegisterPlayer(player)
	end
end

return CombatHandler
