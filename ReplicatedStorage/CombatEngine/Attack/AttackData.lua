local AttackData = {}
AttackData.__index = AttackData

function AttackData.new(config)
	local self = setmetatable({}, AttackData)

	self.name = config.name or "UnnamedAttack"
	self.type = config.type or "MeleeLight"
	self.hitMethod = config.hitMethod or "Shapecast"

	self.damage = config.damage or 10
	self.staminaCost = config.staminaCost or 5
	self.guardDamage = config.guardDamage or 5

	self.startupFrames = config.startupFrames or 5
	self.activeFrames = config.activeFrames or 3
	self.recoveryFrames = config.recoveryFrames or 8

	self.range = config.range or 5
	self.hitboxSize = config.hitboxSize or Vector3.new(2, 2, 2)

	self.knockbackForce = config.knockbackForce or Vector3.new(0, 0, 0)
	self.knockbackDuration = config.knockbackDuration or 0.3
	self.hitstunFrames = config.hitstunFrames or 10

	self.statusEffects = config.statusEffects or {}
	self.canBeParried = config.canBeParried ~= false
	self.canBeClashed = config.canBeClashed ~= false
	self.canBeCountered = config.canBeCountered ~= false

	self.hitCount = config.hitCount or 1
	self.hitInterval = config.hitInterval or 0

	self.animationId = config.animationId or nil
	self.soundId = config.soundId or nil
	self.vfxId = config.vfxId or nil

	self.nextAttack = config.nextAttack or nil

	return self
end

function AttackData:GetTotalFrames()
	return self.startupFrames + self.activeFrames + self.recoveryFrames
end

function AttackData:GetPhaseAtFrame(frame)
	if frame < self.startupFrames then
		return "Startup"
	elseif frame < self.startupFrames + self.activeFrames then
		return "Active"
	else
		return "Recovery"
	end
end

return AttackData
