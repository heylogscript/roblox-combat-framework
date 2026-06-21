local LagCompensation = {}
LagCompensation.__index = LagCompensation

function LagCompensation.new()
	local self = setmetatable({}, LagCompensation)
	self._history = {}
	self._maxHistory = 60
	return self
end

function LagCompensation:RecordState(character, timestamp)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	local entry = {
		timestamp = timestamp or os.clock(),
		position = root.Position,
		cframe = root.CFrame,
		velocity = root.AssemblyLinearVelocity,
	}

	table.insert(self._history, entry)
	if #self._history > self._maxHistory then
		table.remove(self._history, 1)
	end
end

function LagCompensation:Rewind(target, ping, duration)
	local rewindTime = os.clock() - (ping / 1000) - (duration / 2)

	local bestEntry = nil
	for i = #self._history, 1, -1 do
		local entry = self._history[i]
		if entry.timestamp <= rewindTime then
			bestEntry = entry
			break
		end
	end

	return bestEntry
end

function LagCompensation:GetPositionAtTime(target, ping)
	local targetTime = os.clock() - (ping / 1000)

	for i = #self._history, 1, -1 do
		local entry = self._history[i]
		if entry.timestamp <= targetTime then
			return entry.position, entry.cframe
		end
	end

	local root = target:FindFirstChild("HumanoidRootPart")
	if root then
		return root.Position, root.CFrame
	end
	return nil, nil
end

function LagCompensation:Clear()
	self._history = {}
end

return LagCompensation
