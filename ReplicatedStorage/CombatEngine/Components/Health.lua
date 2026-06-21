local Health = {}
Health.__index = Health

function Health.new(maxHealth)
	local self = setmetatable({}, Health)
	self._max = maxHealth or 100
	self._current = self._max
	self._invulnerable = false
	self._invulnerableTimer = 0
	self._onDamage = nil
	self._onDeath = nil
	self._onHeal = nil
	return self
end

function Health:GetCurrent()
	return self._current
end

function Health:GetMax()
	return self._max
end

function Health:GetPercent()
	return self._current / self._max
end

function Health:IsAlive()
	return self._current > 0
end

function Health:IsInvulnerable()
	return self._invulnerable
end

function Health:TakeDamage(amount, source)
	if self._invulnerable or not self:IsAlive() then
		return 0
	end

	local actual = math.min(amount, self._current)
	self._current -= actual

	if self._onDamage then
		self._onDamage(actual, source)
	end

	if self._current <= 0 and self._onDeath then
		self._onDeath(source)
	end

	return actual
end

function Health:Heal(amount, source)
	if not self:IsAlive() then
		return 0
	end

	local healed = math.min(amount, self._max - self._current)
	self._current += healed

	if self._onHeal and healed > 0 then
		self._onHeal(healed, source)
	end

	return healed
end

function Health:SetInvulnerable(duration)
	self._invulnerable = true
	self._invulnerableTimer = duration or 0
end

function Health:Update(dt)
	if self._invulnerable and self._invulnerableTimer > 0 then
		self._invulnerableTimer -= dt
		if self._invulnerableTimer <= 0 then
			self._invulnerable = false
		end
	end
end

function Health:OnDamage(callback)
	self._onDamage = callback
end

function Health:OnDeath(callback)
	self._onDeath = callback
end

function Health:OnHeal(callback)
	self._onHeal = callback
end

return Health
