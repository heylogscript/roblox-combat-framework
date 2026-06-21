local ClientPredictor = {}
ClientPredictor.__index = ClientPredictor

function ClientPredictor.new(player)
	local self = setmetatable({}, ClientPredictor)
	self._player = player
	self._pendingAttacks = {}
	self._localAttackId = 0
	self._roundTripTime = 0
	return self
end

function ClientPredictor:PredictedAttack(attackConfig)
	self._localAttackId += 1
	local attackId = self._localAttackId

	local entry = {
		id = attackId,
		config = attackConfig,
		time = os.clock(),
		predicted = true,
		frame = 0,
	}

	self._pendingAttacks[attackId] = entry

	self:SimulateAttack(entry)

	return entry
end

function ClientPredictor:SimulateAttack(entry)
	local character = self._player.Character
	if not character then
		return
	end

	entry.frame += 1

	local totalFrames = entry.config.startupFrames + entry.config.activeFrames + entry.config.recoveryFrames
	if entry.frame >= totalFrames then
		self._pendingAttacks[entry.id] = nil
	end
end

function ClientPredictor:ConfirmAttack(attackId, serverResult)
	local entry = self._pendingAttacks[attackId]
	if not entry then
		return
	end

	if serverResult.success then
		entry.predicted = false
		entry.serverConfirmed = true
	else
		self:RevertPrediction(entry)
		self._pendingAttacks[attackId] = nil
	end
end

function ClientPredictor:RevertPrediction(entry)
	local character = self._player.Character
	if not character then
		return
	end
end

function ClientPredictor:Update(dt)
	self._roundTripTime = self._player:GetNetworkPing() * 1000

	for id, entry in pairs(self._pendingAttacks) do
		self:SimulateAttack(entry)
	end
end

function ClientPredictor:GetRoundTripTime()
	return self._roundTripTime
end

return ClientPredictor
