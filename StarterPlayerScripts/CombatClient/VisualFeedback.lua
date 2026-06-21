local VisualFeedback = {}
VisualFeedback.__index = VisualFeedback

function VisualFeedback.new(player)
	local self = setmetatable({}, VisualFeedback)
	self._player = player
	self._damageIndicators = {}
	self._hitEffects = {}
	self._statusIcons = {}
	return self
end

function VisualFeedback:PlayHitEffect(hitData)
	if hitData.damage > 0 then
		self:ShowDamageNumber(hitData.targetPosition, hitData.damage)
	end

	if hitData.knockbackForce.Magnitude > 0 then
		self:PlayKnockbackEffect(hitData.targetPosition, hitData.knockbackForce)
	end

	local hitColor = Color3.fromRGB(255, 50, 50)
	if hitData.blocked then
		hitColor = Color3.fromRGB(100, 100, 255)
	elseif hitData.counter then
		hitColor = Color3.fromRGB(255, 255, 50)
	end

	self:PlayImpactEffect(hitData.targetPosition, hitColor)
end

function VisualFeedback:PlayImpactEffect(position, color)
	local part = Instance.new("Part")
	part.Size = Vector3.new(0.5, 0.5, 0.5)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.BrickColor = BrickColor.new(color)
	part.Transparency = 0.3
	part.Parent = workspace

	local attachment = Instance.new("Attachment", part)
	local particle = Instance.new("ParticleEmitter", attachment)
	particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	particle.Lifetime = NumberRange.new(0.2, 0.5)
	particle.Rate = 50
	particle.Speed = NumberRange.new(5, 15)
	particle.Color = ColorSequence.new(color)
	particle.Enabled = true

	task.delay(1, function()
		particle.Enabled = false
		task.delay(2, function()
			part:Destroy()
		end)
	end)
end

function VisualFeedback:ShowDamageNumber(position, damage)
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 50, 0, 20)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.Adornee = nil
	billboard.Parent = workspace

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = tostring(damage)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextStrokeTransparency = 0.5
	label.Font = Enum.Font.GothamBold
	label.TextSize = 18

	local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = game:GetService("TweenService"):Create(billboard, tweenInfo, {
		StudsOffset = billboard.StudsOffset + Vector3.new(0, 4, 0),
	})

	tween:Play()
	task.delay(1, function()
		billboard:Destroy()
	end)
end

function VisualFeedback:PlayKnockbackEffect(position, force)
	local trail = Instance.new("Part")
	trail.Size = Vector3.new(0.2, 0.2, 0.2)
	trail.Position = position
	trail.Anchored = true
	trail.CanCollide = false
	trail.Transparency = 0.5
	trail.BrickColor = BrickColor.new("Really blue")
	trail.Parent = workspace

	task.delay(0.3, function()
		trail:Destroy()
	end)
end

function VisualFeedback:ShowStatusEffect(character, effectName, active)
	if active then
		if effectName == "Bleed" then
			self:ApplyBleedOverlay(character)
		elseif effectName == "Stun" then
			self:ApplyStunIndicator(character)
		end
	else
		self:RemoveStatusOverlay(character, effectName)
	end
end

function VisualFeedback:ApplyBleedOverlay(character)
end

function VisualFeedback:ApplyStunIndicator(character)
end

function VisualFeedback:RemoveStatusOverlay(character, effectName)
end

return VisualFeedback
