local Hitstun = {}
Hitstun.__index = Hitstun

function Hitstun.new(character)
	local self = setmetatable({}, Hitstun)
	self._character = character
	self._active = false
	self._duration = 0
	self._elapsed = 0
	self._flinchChance = 0
	self._onStart = nil
	self._onEnd = nil
	return self
end

function Hitstun:Apply(duration, flinchChance)
	if self._active then
		return
	end

	self._active = true
	self._duration = duration
	self._elapsed = 0
	self._flinchChance = flinchChance or 0.3

	local humanoid = self._character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:SetAttribute("Hitstun", true)
		humanoid.WalkSpeed = 0
	end

	if self._onStart then
		self._onStart(duration)
	end
end

function Hitstun:IsActive()
	return self._active
end

function Hitstun:Cancel()
	self._active = false
	self._elapsed = 0

	local humanoid = self._character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:SetAttribute("Hitstun", false)
	end

	if self._onEnd then
		self._onEnd()
	end
end

function Hitstun:Update(dt)
	if not self._active then
		return false
	end

	self._elapsed += dt
	if self._elapsed >= self._duration then
		self:Cancel()
		return false
	end

	return true
end

function Hitstun:OnStart(callback)
	self._onStart = callback
end

function Hitstun:OnEnd(callback)
	self._onEnd = callback
end

return Hitstun
