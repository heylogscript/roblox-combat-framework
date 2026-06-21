local PredictiveCaster = {}

function PredictiveCaster.CastDash(character, startPos, endPos, speed, ignoreList)
	local direction = (endPos - startPos).Unit
	local distance = (endPos - startPos).Magnitude
	local travelTime = distance / speed

	local params = RaycastParams.new()
	params.FilterDescendantsInstances = ignoreList
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local steps = math.max(1, math.floor(travelTime * 60))
	local stepSize = distance / steps

	local hits = {}
	for i = 0, steps do
		local t = i / steps
		local predictedPos = startPos + direction * (distance * t)

		local result = workspace:Spherecast(predictedPos, 2, direction * stepSize * 1.5, params)
		if result then
			table.insert(hits, result)
			if #hits >= 3 then
				break
			end
		end
	end
	return hits
end

function PredictiveCaster.PredictTargetPosition(target, leadTime)
	local root = target:FindFirstChild("HumanoidRootPart")
	if not root then
		return target:GetPivot().Position
	end

	local velocity = root.AssemblyLinearVelocity
	local predictedPos = root.Position + velocity * leadTime
	return predictedPos
end

function PredictiveCaster.CastDashWithPrediction(character, target, speed, range, ignoreList)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return {}
	end

	local startPos = root.Position
	local predictedTargetPos = PredictiveCaster.PredictTargetPosition(target, range / speed)
	local direction = (predictedTargetPos - startPos).Unit
	local endPos = startPos + direction * range

	return PredictiveCaster.CastDash(character, startPos, endPos, speed, ignoreList)
end

return PredictiveCaster
