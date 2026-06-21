local CombatRemoteEvents = {}

local events = {
	-- Client -> Server
	Attack = {type = "RemoteEvent"},
	Block = {type = "RemoteEvent"},
	Dash = {type = "RemoteEvent"},
	Parry = {type = "RemoteEvent"},
	Ability1 = {type = "RemoteEvent"},
	Ability2 = {type = "RemoteEvent"},
	Ultimate = {type = "RemoteEvent"},
	RequestRespawn = {type = "RemoteEvent"},

	-- Server -> Client
	ApplyHitEffects = {type = "RemoteEvent"},
	SyncCombatState = {type = "RemoteEvent"},
	ApplyStatusEffect = {type = "RemoteEvent"},
	RemoveStatusEffect = {type = "RemoteEvent"},
	CombatLog = {type = "RemoteEvent"},

	-- Client <-> Server (bidirectional with return)
	RequestFrameData = {type = "RemoteFunction"},
	ValidatePosition = {type = "RemoteFunction"},
}

local folder = script:FindFirstAncestor("CombatRemoteEvents")
if not folder then
	folder = Instance.new("Folder")
	folder.Name = "CombatRemoteEvents"
	folder.Parent = script
end

for name, config in pairs(events) do
	local existing = folder:FindFirstChild(name)
	if existing then
		CombatRemoteEvents[name] = existing
		continue
	end

	local instance
	if config.type == "RemoteEvent" then
		instance = Instance.new("RemoteEvent")
	elseif config.type == "RemoteFunction" then
		instance = Instance.new("RemoteFunction")
	end

	if instance then
		instance.Name = name
		instance.Parent = folder
		CombatRemoteEvents[name] = instance
	end
end

function CombatRemoteEvents.GetFolder()
	return folder
end

return CombatRemoteEvents
