local ServerValidator = {}
ServerValidator.__index = ServerValidator

function ServerValidator.new()
	local self = setmetatable({}, ServerValidator)
	self._antiCheat = require(game:GetService("ReplicatedStorage").CombatEngine.Network.AntiCheat).new()
	self._lagCompensation = require(game:GetService("ReplicatedStorage").CombatEngine.Network.LagCompensation).new()
	self._pendingHits = {}
	return self
end

function ServerValidator:ValidateHit(attacker, target, hitData)
	local valid, reason = self._antiCheat:ValidateHit(attacker, hitData)
	if not valid then
		return false, reason
	end

	local distance = (attacker.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude
	if distance > hitData.range + 5 then
		return false, "Target out of range"
	end

	if not self._antiCheat:ValidateStamina(attacker, hitData.staminaCost) then
		return false, "Stamina cheat detected"
	end

	return true, "Valid"
end

function ServerValidator:ProcessHit(attacker, target, hitData)
	local valid, reason = self:ValidateHit(attacker, target, hitData)
	if not valid then
		return {success = false, reason = reason}
	end

	local damage = self:CalculateDamage(attacker, target, hitData)
	local knockbackForce = self:CalculateKnockback(attacker, target, hitData)

	return {
		success = true,
		damage = damage,
		knockbackForce = knockbackForce,
		hitstunFrames = hitData.hitstunFrames,
		statusEffects = hitData.statusEffects,
	}
end

function ServerValidator:CalculateDamage(attacker, target, hitData)
	local baseDamage = hitData.damage
	local multiplier = 1

	local targetStats = target:FindFirstChild("CombatStats")
	if targetStats and targetStats:FindFirstChild("GuardBar") then
		local guardBar = targetStats.GuardBar.Value
		local guardPercent = (targetStats:FindFirstChild("GuardPercent") and targetStats.GuardPercent.Value) or 1
		if guardBar and guardPercent < 0.3 then
			multiplier = 1.2
		end
	end

	return math.floor(baseDamage * multiplier)
end

function ServerValidator:CalculateKnockback(attacker, target, hitData)
	local baseForce = hitData.knockbackForce
	local attackDir = (target.HumanoidRootPart.Position - attacker.HumanoidRootPart.Position).Unit
	return attackDir * baseForce.Magnitude
end

function ServerValidator:RecordState(character, timestamp)
	self._lagCompensation:RecordState(character, timestamp)
end

return ServerValidator
