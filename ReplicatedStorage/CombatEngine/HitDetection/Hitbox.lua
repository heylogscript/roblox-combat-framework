local Hitbox = {}
Hitbox.__index = Hitbox

function Hitbox.new(part, duration)
	local self = setmetatable({}, Hitbox)
	self._part = part
	self._duration = duration or 0.1
	self._elapsed = 0
	self._hitBuffer = {}
	self._enabled = false
	return self
end

function Hitbox:Enable()
	self._enabled = true
	self._elapsed = 0
end

function Hitbox:Disable()
	self._enabled = false
end

function Hitbox:IsEnabled()
	return self._enabled
end

function Hitbox:GetOverlapping(ignoreList)
	if not self._enabled or not self._part then
		return {}
	end

	local params = OverlapParams.new()
	params.FilterDescendantsInstances = ignoreList
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local parts = workspace:GetPartBoundsInBox(self._part.CFrame, self._part.Size, params)
	local hits = {}
	for _, part in ipairs(parts) do
		local character = part:FindFirstAncestorOfClass("Model")
		if character and not self._hitBuffer[character] then
			self._hitBuffer[character] = true
			table.insert(hits, character)
		end
	end
	return hits
end

function Hitbox:Update(dt)
	if not self._enabled then
		return
	end

	self._elapsed += dt
	if self._elapsed >= self._duration then
		self:Disable()
	end
end

function Hitbox:ResetBuffer()
	self._hitBuffer = {}
end

return Hitbox
