local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new(states, initial)
	local self = setmetatable({}, StateMachine)
	self._states = states
	self._current = initial or next(states)
	self._previous = nil
	self._timers = {}
	return self
end

function StateMachine:GetCurrent()
	return self._current
end

function StateMachine:GetPrevious()
	return self._previous
end

function StateMachine:Change(state, ...)
	if not self._states[state] then
		return false
	end

	local currentDef = self._states[self._current]
	if currentDef and currentDef.Exit then
		currentDef.Exit(self._current)
	end

	self._previous = self._current
	self._current = state

	local newDef = self._states[state]
	if newDef and newDef.Enter then
		newDef.Enter(...)
	end

	return true
end

function StateMachine:Update(dt)
	local def = self._states[self._current]
	if def and def.Update then
		def.Update(dt)
	end
end

function StateMachine:CanTransition(target)
	local def = self._states[self._current]
	if not def then
		return true
	end
	if not def.Transitions then
		return false
	end
	for _, allowed in ipairs(def.Transitions) do
		if allowed == target then
			return true
		end
	end
	return false
end

return StateMachine
