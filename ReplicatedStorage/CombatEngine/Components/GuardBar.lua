local GuardBar = {}
GuardBar.__index = GuardBar

function GuardBar.new(maxGuard)
	local self = setmetatable({}, GuardBar)
	self._max = maxGuard or 100
	self._current = self._max
	self._regenRate = 10
	self._regenDelay = 2.0
	self._regenTimer = 0
	self._broken = false
	self._breakTimer = 0
	self._onBreak = nil
	self._onRestore = nil
	return self
end

function GuardBar:GetCurrent()
	return self._current
end

function GuardBar:GetMax()
	return self._max
end

function GuardBar:GetPercent()
	return self._current / self._max
end

function GuardBar:IsBroken()
	return self._broken
end

function GuardBar:TakeGuardDamage(amount)
	if self._broken then
		return true
	end

	self._current = math.max(0, self._current - amount)
	self._regenTimer = self._regenDelay

	if self._current <= 0 then
		self._broken = true
		self._breakTimer = 3.0
		if self._onBreak then
			self._onBreak()
		end
		return true
	end

	return false
end

function GuardBar:Restore(amount)
	self._current = math.min(self._max, self._current + amount)
end

function GuardBar:Update(dt)
	if self._broken then
		self._breakTimer -= dt
		if self._breakTimer <= 0 then
			self._broken = false
			self._current = self._max
			if self._onRestore then
				self._onRestore()
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

function GuardBar:OnBreak(callback)
	self._onBreak = callback
end

function GuardBar:OnRestore(callback)
	self._onRestore = callback
end

return GuardBar
