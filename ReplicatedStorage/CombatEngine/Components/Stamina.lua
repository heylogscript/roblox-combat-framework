local Stamina = {}
Stamina.__index = Stamina

function Stamina.new(maxStamina)
	local self = setmetatable({}, Stamina)
	self._max = maxStamina or 100
	self._current = self._max
	self._regenRate = 15
	self._regenDelay = 1.0
	self._regenTimer = 0
	self._exhausted = false
	self._exhaustionTimer = 0
	self._onExhausted = nil
	self._onRecovered = nil
	return self
end

function Stamina:GetCurrent()
	return self._current
end

function Stamina:GetMax()
	return self._max
end

function Stamina:GetPercent()
	return self._current / self._max
end

function Stamina:IsExhausted()
	return self._exhausted
end

function Stamina:Consume(amount)
	if self._exhausted then
		return false
	end

	if self._current < amount then
		return false
	end

	self._current -= amount
	self._regenTimer = self._regenDelay

	if self._current <= 0 then
		self._exhausted = true
		self._exhaustionTimer = 2.0
		if self._onExhausted then
			self._onExhausted()
		end
	end

	return true
end

function Stamina:Update(dt)
	if self._exhausted then
		self._exhaustionTimer -= dt
		if self._exhaustionTimer <= 0 then
			self._exhausted = false
			self._current = self._max * 0.5
			if self._onRecovered then
				self._onRecovered()
			end
		end
		return
	end

	if self._regenTimer > 0 then
		self._regenTimer -= dt
		return
	end

	if self._current < self._max then
		self._current = math.min(self._max, self._current + self._regenRate * dt)
	end
end

function Stamina:SetRegenRate(rate)
	self._regenRate = rate
end

function Stamina:SetRegenDelay(delay)
	self._regenDelay = delay
end

function Stamina:OnExhausted(callback)
	self._onExhausted = callback
end

function Stamina:OnRecovered(callback)
	self._onRecovered = callback
end

return Stamina
