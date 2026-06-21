local AttackData = require(script.Parent.AttackData)
local StateMachine = require(script.Parent.Parent.StateMachine)
local Types = require(script.Parent.Parent.Types)

local AttackState = {}
AttackState.__index = AttackState

function AttackState.new(character, attackConfig)
	local self = setmetatable({}, AttackState)
	self._character = character
	self._attackData = AttackData.new(attackConfig)
	self._frame = 0
	self._active = false
	self._hitConfirmed = false
	self._hitCharacters = {}

	self._stateMachine = StateMachine.new({
		[Types.AttackPhase.STARTUP] = {
			Enter = function() self._frame = 0 end,
			Update = function() self:_OnStartup() end,
			Transitions = {Types.AttackPhase.ACTIVE},
		},
		[Types.AttackPhase.ACTIVE] = {
			Enter = function() self:_OnActiveEnter() end,
			Update = function() self:_OnActive() end,
			Transitions = {Types.AttackPhase.RECOVERY},
		},
		[Types.AttackPhase.RECOVERY] = {
			Enter = function() self:_OnRecoveryEnter() end,
			Update = function() self:_OnRecovery() end,
			Transitions = {Types.AttackPhase.NEUTRAL},
		},
		[Types.AttackPhase.NEUTRAL] = {
			Enter = function() self:_OnNeutral() end,
		},
	}, Types.AttackPhase.STARTUP)

	return self
end

function AttackState:Start()
	self._active = true
	self._frame = 0
	self._hitConfirmed = false
	self._hitCharacters = {}
	self._stateMachine:Change(Types.AttackPhase.STARTUP)
end

function AttackState:IsActive()
	return self._active
end

function AttackState:GetCurrentPhase()
	return self._stateMachine:GetCurrent()
end

function AttackState:GetCurrentFrame()
	return self._frame
end

function AttackState:GetData()
	return self._attackData
end

function AttackState:Update(dt)
	if not self._active then
		return
	end

	self._frame += 1
	self._stateMachine:Update(dt)

	local phase = self._stateMachine:GetCurrent()
	local data = self._attackData

	if phase == Types.AttackPhase.STARTUP and self._frame >= data.startupFrames then
		self._stateMachine:Change(Types.AttackPhase.ACTIVE)
	elseif phase == Types.AttackPhase.ACTIVE and self._frame >= data.startupFrames + data.activeFrames then
		self._stateMachine:Change(Types.AttackPhase.RECOVERY)
	elseif phase == Types.AttackPhase.RECOVERY and self._frame >= data.startupFrames + data.activeFrames + data.recoveryFrames then
		self._stateMachine:Change(Types.AttackPhase.NEUTRAL)
	end
end

function AttackState:WasCharacterHit(character)
	return self._hitCharacters[character] ~= nil
end

function AttackState:RegisterHit(character)
	self._hitCharacters[character] = true
	self._hitConfirmed = true
end

function AttackState:IsHitConfirmed()
	return self._hitConfirmed
end

function AttackState:Cancel()
	self._active = false
	self._stateMachine:Change(Types.AttackPhase.NEUTRAL)
end

function AttackState:_OnStartup()
end

function AttackState:_OnActiveEnter()
	self._hitCharacters = {}
end

function AttackState:_OnActive()
end

function AttackState:_OnRecoveryEnter()
end

function AttackState:_OnRecovery()
end

function AttackState:_OnNeutral()
	self._active = false
	self._frame = 0
	self._hitConfirmed = false
end

return AttackState
