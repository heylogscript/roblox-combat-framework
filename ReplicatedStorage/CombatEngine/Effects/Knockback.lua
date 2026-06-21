local Knockback = {}
Knockback.__index = Knockback

function Knockback.new(character)
	local self = setmetatable({}, Knockback)
	self._character = character
	self._active = false
	self._force = Vector3.new(0, 0, 0)
	self._duration = 0
	self._elapsed = 0
	self._onStart = nil
	self._onEnd = nil
	return self
end

function Knockback:Apply(force, duration)
	self._active = true
	self._force = force
	self._duration = duration or 0.3
	self._elapsed = 0

	local root = self._character:FindFirstChild("HumanoidRootPart")
	if root then
		root.AssemblyLinearVelocity = force
	end

	local humanoid = self._character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:SetAttribute("Knockback", true)
		humanoid.WalkSpeed = 0
		humanoid.AutoRotate = false
	end

	if self._onStart then
		self._onStart(force, duration)
	end
end

function Knockback:IsActive()
	return self._active
end

function Knockback:Cancel()
	self._active = false
	self._elapsed = 0

	local humanoid = self._character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:SetAttribute("Knockback", false)
		humanoid.AutoRotate = true
	end

	if self._onEnd then
		self._onEnd()
	end
end

function Knockback:Update(dt)
	if not self._active then
		return false
	end

	self._elapsed += dt

	local root = self._character:FindFirstChild("HumanoidRootPart")
	if root then
		local percent = 1 - (self._elapsed / self._duration)
		percent = math.max(0, percent)
		root.AssemblyLinearVelocity = self._force * percent
	end

	if self._elapsed >= self._duration then
		self:Cancel()
		return false
	end

	return true
end

function Knockback:OnStart(callback)
	self._onStart = callback
end

function Knockback:OnEnd(callback)
	self._onEnd = callback
end

return Knockback
