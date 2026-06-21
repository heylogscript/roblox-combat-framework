local AntiCheat = {}
AntiCheat.__index = AntiCheat

function AntiCheat.new()
	local self = setmetatable({}, AntiCheat)
	self._thresholds = {
		maxDamagePerHit = 100,
		maxHitSpeed = 0.01,
		minComboDelay = 0.05,
		maxAttacksPerSecond = 15,
		maxStaminaPerSecond = 200,
	}
	self._playerStats = {}
	return self
end

function AntiCheat:SetThreshold(key, value)
	if self._thresholds[key] ~= nil then
		self._thresholds[key] = value
	end
end

function AntiCheat:ValidateHit(attacker, hitData)
	local stats = self:_GetStats(attacker)
	local now = os.clock()

	if hitData.damage > self._thresholds.maxDamagePerHit then
		return false, "Damage exceeds threshold"
	end

	if hitData.timestamp and (now - hitData.timestamp) < self._thresholds.minComboDelay then
		return false, "Attack too fast"
	end

	stats.lastHitTime = now
	stats.hitsInLastSecond = stats.hitsInLastSecond or {}

	table.insert(stats.hitsInLastSecond, now)
	while #stats.hitsInLastSecond > 0 and stats.hitsInLastSecond[1] < now - 1 do
		table.remove(stats.hitsInLastSecond, 1)
	end

	if #stats.hitsInLastSecond > self._thresholds.maxAttacksPerSecond then
		return false, "Too many attacks per second"
	end

	return true, "Valid"
end

function AntiCheat:ValidateStamina(attacker, amount)
	local stats = self:_GetStats(attacker)
	local now = os.clock()

	stats.staminaUsed = stats.staminaUsed or {}
	table.insert(stats.staminaUsed, {time = now, amount = amount})

	while #stats.staminaUsed > 0 and stats.staminaUsed[1].time < now - 1 do
		table.remove(stats.staminaUsed, 1)
	end

	local totalStamina = 0
	for _, entry in ipairs(stats.staminaUsed) do
		totalStamina += entry.amount
	end

	if totalStamina > self._thresholds.maxStaminaPerSecond then
		return false
	end

	return true
end

function AntiCheat:ValidatePosition(character, newPosition)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return true
	end

	local currentPos = root.Position
	local distance = (newPosition - currentPos).Magnitude

	if distance > 50 then
		return false
	end

	return true
end

function AntiCheat:_GetStats(player)
	if not self._playerStats[player] then
		self._playerStats[player] = {}
	end
	return self._playerStats[player]
end

function AntiCheat:ResetPlayer(player)
	self._playerStats[player] = nil
end

return AntiCheat
