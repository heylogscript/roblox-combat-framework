local Types = {}

Types.AttackType = {
	MELEE_LIGHT = "MeleeLight",
	MELEE_HEAVY = "MeleeHeavy",
	PROJECTILE = "Projectile",
	GUN = "Gun",
	GUN_MELEE = "GunMelee",
	GRAPPLE = "Grapple",
	DASH_ATTACK = "DashAttack",
	SPECIAL = "Special",
	ULTIMATE = "Ultimate",
}

Types.HitDetectionMethod = {
	SHAPECAST = "Shapecast",
	RAYCAST = "Raycast",
	PREDICTIVE_PATH = "PredictivePath",
	HITBOX = "Hitbox",
}

Types.AttackPhase = {
	STARTUP = "Startup",
	ACTIVE = "Active",
	RECOVERY = "Recovery",
	NEUTRAL = "Neutral",
}

Types.CombatState = {
	IDLE = "Idle",
	ATTACKING = "Attacking",
	BLOCKING = "Blocking",
	DASHING = "Dashing",
	PARRYING = "Parrying",
	HITSTUN = "Hitstun",
	KNOCKBACK = "Knockback",
	STAGGERED = "Staggered",
	DOWNED = "Downed",
}

Types.InteractionResult = {
	HIT = "Hit",
	BLOCKED = "Blocked",
	PARRY = "Parry",
	COUNTER = "Counter",
	CLASH = "Clash",
	DODGE = "Dodge",
	PERFECT_DODGE = "PerfectDodge",
	WHIFF = "Whiff",
}

return Types
