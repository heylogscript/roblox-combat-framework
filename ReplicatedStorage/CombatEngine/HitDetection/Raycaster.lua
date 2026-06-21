local Raycaster = {}

function Raycaster.CastMultiRay(origin, directions, range, ignoreList)
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = ignoreList
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local hits = {}
	for _, dir in ipairs(directions) do
		local result = workspace:Raycast(origin, dir * range, params)
		if result then
			table.insert(hits, result)
		end
	end
	return hits
end

function Raycaster.CastFan(origin, direction, count, spreadAngle, range, ignoreList)
	local right = direction:Cross(Vector3.new(0, 1, 0)).Unit
	local up = right:Cross(direction).Unit

	local dirs = {}
	local halfSpread = spreadAngle / 2
	for i = 0, count - 1 do
		local angle = -halfSpread + (spreadAngle / (count - 1)) * i
		local rad = math.rad(angle)
		local rotated = direction * math.cos(rad) + right * math.sin(rad)
		table.insert(dirs, rotated)
	end

	return Raycaster.CastMultiRay(origin, dirs, range, ignoreList)
end

function Raycaster.CastBoneSword(character, swordAttachment, rayCount, range, spread)
	local attachment = character:FindFirstChild(swordAttachment, true)
	if not attachment then
		return {}
	end

	local origin = attachment.WorldPosition
	local direction = attachment.WorldCFrame.LookVector

	return Raycaster.CastFan(origin, direction, rayCount, spread, range, {character})
end

function Raycaster.CastHairAttack(character, hairAttachments, range)
	local hits = {}
	for _, attachment in ipairs(hairAttachments) do
		local origin = attachment.WorldPosition
		local dirs = {
			attachment.WorldCFrame.LookVector,
			attachment.WorldCFrame.UpVector,
			-attachment.WorldCFrame.UpVector,
		}
		local results = Raycaster.CastMultiRay(origin, dirs, range, {character})
		for _, result in ipairs(results) do
			table.insert(hits, result)
		end
	end
	return hits
end

return Raycaster
