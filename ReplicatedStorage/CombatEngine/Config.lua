local Config = {}

Config.TickRate = 60
Config.TickDelta = 1 / Config.TickRate

Config.Network = {
	ClientPrediction = true,
	ServerAuthoritative = true,
	InputBufferWindow = 0.15,
	MaxPingForPrediction = 300,
	ReconcileDelay = 0.1,
}

Config.HitDetection = {
	DefaultRadius = 0.5,
	MaxHitResults = 3,
	DebugDraw = false,
}

Config.Combat = {
	MaxComboWindow = 0.5,
	MinAttackInterval = 0.05,
	MaxAttacksPerSecond = 15,
	PerfectDodgeWindow = 0.1,
	ParryWindow = 0.15,
	ClashWindow = 0.05,
	StaminaRecoverOnHit = 5,
}

Config.Damage = {
	FlinchThreshold = 0.3,
	CounterMultiplier = 1.5,
	BackAttackMultiplier = 1.2,
	GuardBreakMultiplier = 1.5,
	MinimumDamage = 1,
}

Config.AntiCheat = {
	MaxDamagePerHit = 100,
	MaxSpeedHackDistance = 50,
	PositionHistorySize = 60,
	ValidateEveryNHits = 3,
}

return Config
