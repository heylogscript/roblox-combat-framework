local Shapecaster = {}

function Shapecaster.CastPunch(character, limbName, range)
	local limb = character:FindFirstChild(limbName, true)
	if not limb then
		return {}
	end

	local startPos = limb.Position
	local direction = character:GetAttribute("FacingDirection") or character.HumanoidRootPart.CFrame.LookVector

	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {character}
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.BruteForceAllSlow = true

	local result = workspace:Spherecast(startPos, 0.5, direction * range, params)
	if result then
		return {result}
	end
	return {}
end

function Shapecaster.CastKick(character, legName, range)
	local limb = character:FindFirstChild(legName, true)
	if not limb then
		return {}
	end

	local startPos = limb.Position
	local direction = character:GetAttribute("FacingDirection") or character.HumanoidRootPart.CFrame.LookVector

	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {character}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Spherecast(startPos, 0.6, direction * range, params)
	if result then
		return {result}
	end
	return {}
end

function Shapecaster.CastAlongLimb(character, limbPath, radius, range)
	local limb = character:FindFirstChild(limbPath, true)
	if not limb then
		return {}
	end

	local origin = character.HumanoidRootPart.Position
	local target = limb.Position
	local direction = (target - origin).Unit
	local distance = (target - origin).Magnitude

	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {character}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local results = {}
	local segments = math.max(1, math.floor(distance / (radius * 2)))
	for i = 0, segments do
		local t = i / segments
		local pos = origin + direction * (distance * t)
		local result = workspace:Spherecast(pos, radius, direction * 2, params)
		if result then
			table.insert(results, result)
		end
	end
	return results
end

return Shapecaster
