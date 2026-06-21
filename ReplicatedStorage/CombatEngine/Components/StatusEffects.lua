local StatusEffects = {}
StatusEffects.__index = StatusEffects

local StatusDefinitions = {
	Bleed = {
		damagePerTick = 2,
		interval = 1.0,
		duration = 5.0,
		stackable = true,
		maxStacks = 5,
	},
	Poison = {
		damagePerTick = 3,
		interval = 1.5,
		duration = 8.0,
		stackable = false,
		maxStacks = 1,
	},
	Burn = {
		damagePerTick = 4,
		interval = 0.5,
		duration = 4.0,
		stackable = true,
		maxStacks = 3,
	},
	Slow = {
		speedMultiplier = 0.5,
		duration = 3.0,
		stackable = false,
		maxStacks = 1,
	},
	Stun = {
		duration = 1.5,
		stackable = false,
		maxStacks = 1,
	},
}

function StatusEffects.new()
	local self = setmetatable({}, StatusEffects)
	self._effects = {}
	self._timers = {}
	self._stacks = {}
	return self
end

function StatusEffects:Apply(name, source)
	local def = StatusDefinitions[name]
	if not def then
		return
	end

	if not def.stackable and self._effects[name] then
		self._timers[name] = def.duration
		return
	end

	local currentStacks = self._stacks[name] or 0
	if currentStacks >= def.maxStacks then
		return
	end

	self._effects[name] = def
	self._timers[name] = def.duration
	self._stacks[name] = currentStacks + 1

	if name == "Stun" then
		self:_onStun(source)
	end
end

function StatusEffects:Remove(name)
	self._effects[name] = nil
	self._timers[name] = nil
	self._stacks[name] = nil

	if name == "Stun" then
		self:_onStunEnd()
	end
end

function StatusEffects:Has(name)
	return self._effects[name] ~= nil
end

function StatusEffects:GetStacks(name)
	return self._stacks[name] or 0
end

function StatusEffects:GetAll()
	local active = {}
	for name, def in pairs(self._effects) do
		table.insert(active, {
			name = name,
			stacks = self._stacks[name] or 1,
			timeLeft = self._timers[name] or 0,
		})
	end
	return active
end

function StatusEffects:Update(dt, health)
	for name, _ in pairs(self._effects) do
		self._timers[name] -= dt

		if name == "Bleed" or name == "Poison" or name == "Burn" then
			self._tickTimer = (self._tickTimer or {})
			self._tickTimer[name] = (self._tickTimer[name] or 0) - dt

			if self._tickTimer[name] <= 0 then
				local def = self._effects[name]
				local stacks = self._stacks[name] or 1
				local damage = def.damagePerTick * stacks
				if health then
					health:TakeDamage(damage)
				end
				self._tickTimer[name] = def.interval
			end
		end

		if self._timers[name] <= 0 then
			self:Remove(name)
		end
	end
end

function StatusEffects:_onStun(source)
end

function StatusEffects:_onStunEnd()
end

return StatusEffects
