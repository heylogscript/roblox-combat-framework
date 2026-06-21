local ExampleFighter = {}

ExampleFighter.Name = "ExampleFighter"
ExampleFighter.DisplayName = "Example Fighter"

ExampleFighter.Stats = {
	MaxHealth = 100,
	MaxStamina = 100,
	StaminaRegen = 15,
	StaminaRegenDelay = 1.0,
	MaxGuard = 100,
	GuardRegen = 10,
	GuardRegenDelay = 2.0,
	WalkSpeed = 16,
	RunSpeed = 32,
	DashSpeed = 60,
	DashDuration = 0.3,
	DashCooldown = 1.0,
}

ExampleFighter.Attacks = {
	Jab = {
		name = "Jab",
		type = "MeleeLight",
		hitMethod = "Shapecast",
		damage = 8,
		staminaCost = 5,
		guardDamage = 4,
		startupFrames = 3,
		activeFrames = 2,
		recoveryFrames = 5,
		range = 4,
		hitstunFrames = 6,
		knockbackForce = Vector3.new(5, 0, 0),
		knockbackDuration = 0.2,
		statusEffects = {},
		canBeParried = true,
		canBeClashed = true,
		canBeCountered = true,
		nextAttack = "Cross",
	},

	Cross = {
		name = "Cross",
		type = "MeleeLight",
		hitMethod = "Shapecast",
		damage = 12,
		staminaCost = 7,
		guardDamage = 6,
		startupFrames = 5,
		activeFrames = 2,
		recoveryFrames = 7,
		range = 5,
		hitstunFrames = 8,
		knockbackForce = Vector3.new(10, 2, 0),
		knockbackDuration = 0.3,
		statusEffects = {},
		canBeParried = true,
		canBeClashed = true,
		canBeCountered = true,
		nextAttack = "Hook",
	},

	Hook = {
		name = "Hook",
		type = "MeleeHeavy",
		hitMethod = "Shapecast",
		damage = 18,
		staminaCost = 12,
		guardDamage = 15,
		startupFrames = 8,
		activeFrames = 3,
		recoveryFrames = 10,
		range = 4,
		hitstunFrames = 12,
		knockbackForce = Vector3.new(15, 5, 0),
		knockbackDuration = 0.4,
		statusEffects = {},
		canBeParried = true,
		canBeClashed = false,
		canBeCountered = true,
	},

	Kick = {
		name = "Kick",
		type = "MeleeLight",
		hitMethod = "Shapecast",
		damage = 10,
		staminaCost = 8,
		guardDamage = 5,
		startupFrames = 6,
		activeFrames = 3,
		recoveryFrames = 8,
		range = 6,
		hitstunFrames = 8,
		knockbackForce = Vector3.new(12, 3, 0),
		knockbackDuration = 0.3,
		statusEffects = {},
		canBeParried = true,
		canBeClashed = true,
		canBeCountered = true,
	},

	BoneSwordSlash = {
		name = "BoneSwordSlash",
		type = "MeleeHeavy",
		hitMethod = "Raycast",
		damage = 22,
		staminaCost = 15,
		guardDamage = 20,
		startupFrames = 10,
		activeFrames = 3,
		recoveryFrames = 12,
		range = 8,
		hitstunFrames = 14,
		knockbackForce = Vector3.new(20, 5, 0),
		knockbackDuration = 0.5,
		statusEffects = {name = "Bleed", chance = 0.5},
		canBeParried = true,
		canBeClashed = true,
		canBeCountered = false,
	},

	DashStrike = {
		name = "DashStrike",
		type = "DashAttack",
		hitMethod = "PredictivePath",
		damage = 15,
		staminaCost = 20,
		guardDamage = 10,
		startupFrames = 4,
		activeFrames = 4,
		recoveryFrames = 6,
		range = 15,
		hitstunFrames = 10,
		knockbackForce = Vector3.new(8, 0, 0),
		knockbackDuration = 0.3,
		statusEffects = {},
		canBeParried = false,
		canBeClashed = false,
		canBeCountered = true,
	},

	Grapple = {
		name = "Grapple",
		type = "Grapple",
		hitMethod = "Hitbox",
		damage = 5,
		staminaCost = 15,
		guardDamage = 0,
		startupFrames = 6,
		activeFrames = 5,
		recoveryFrames = 10,
		range = 4,
		hitstunFrames = 0,
		knockbackForce = Vector3.new(0, 0, 0),
		knockbackDuration = 0,
		statusEffects = {},
		canBeParried = false,
		canBeClashed = false,
		canBeCountered = false,
		hitCount = 1,
	},
}

ExampleFighter.ComboRoutes = {
	Jab = {"Cross", "Kick"},
	Cross = {"Hook", "Kick"},
	Hook = {"BoneSwordSlash"},
	Kick = {"Jab", "DashStrike"},
}

function ExampleFighter.GetAttack(name)
	return ExampleFighter.Attacks[name]
end

function ExampleFighter.GetComboRoute(currentAttack)
	return ExampleFighter.ComboRoutes[currentAttack] or {}
end

return ExampleFighter
