local CombatEngine = {}

local root = script.Parent

CombatEngine.Types = require(root.Types)
CombatEngine.StateMachine = require(root.StateMachine)

CombatEngine.HitDetection = {
	Shapecaster = require(root.HitDetection.Shapecaster),
	Raycaster = require(root.HitDetection.Raycaster),
	PredictiveCaster = require(root.HitDetection.PredictiveCaster),
	Hitbox = require(root.HitDetection.Hitbox),
}

CombatEngine.Components = {
	Health = require(root.Components.Health),
	Stamina = require(root.Components.Stamina),
	GuardBar = require(root.Components.GuardBar),
	Movement = require(root.Components.Movement),
	StatusEffects = require(root.Components.StatusEffects),
}

CombatEngine.Attack = {
	AttackData = require(root.Attack.AttackData),
	AttackState = require(root.Attack.AttackState),
}

CombatEngine.Effects = {
	Hitstun = require(root.Effects.Hitstun),
	Knockback = require(root.Effects.Knockback),
}

CombatEngine.Network = {
	LagCompensation = require(root.Network.LagCompensation),
	AntiCheat = require(root.Network.AntiCheat),
}

CombatEngine.Characters = root.Characters

return CombatEngine
