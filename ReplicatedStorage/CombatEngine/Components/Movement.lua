local Movement = {}
Movement.__index = Movement

function Movement.new(humanoid)
	local self = setmetatable({}, Movement)
	self._humanoid = humanoid
	self._walkSpeed = 16
	self._runSpeed = 32
	self._dashSpeed = 60
	self._dashDuration = 0.3
	self._dashCooldown = 1.0
	self._dashTimer = 0
	self._dashActive = false
	self._canMove = true
	self._moveDirection = Vector3.new(0, 0, 0)
	return self
end

function Movement:CanMove()
	return self._canMove
end

function Movement:SetCanMove(value)
	self._canMove = value
	if not value and self._humanoid then
		self._humanoid:Move(Vector3.new(0, 0, 0), false)
	end
end

function Movement:Walk(direction)
	if not self._canMove then
		return
	end
	self._moveDirection = direction
	if self._humanoid then
		self._humanoid.WalkSpeed = self._walkSpeed
		self._humanoid:Move(direction, false)
	end
end

function Movement:Run(direction)
	if not self._canMove then
		return
	end
	self._moveDirection = direction
	if self._humanoid then
		self._humanoid.WalkSpeed = self._runSpeed
		self._humanoid:Move(direction, false)
	end
end

function Movement:Dash(direction)
	if not self._canMove or self._dashActive or self._dashTimer > 0 then
		return false
	end

	self._dashActive = true
	self._dashTimer = self._dashCooldown

	local root = self._humanoid and self._humanoid.Parent:FindFirstChild("HumanoidRootPart")
	if root and direction.Magnitude > 0 then
		root.AssemblyLinearVelocity = direction.Unit * self._dashSpeed
	end

	task.delay(self._dashDuration, function()
		self._dashActive = false
	end)

	return true
end

function Movement:Update(dt)
	if self._dashTimer > 0 then
		self._dashTimer -= dt
	end
end

function Movement:Stop()
	self._moveDirection = Vector3.new(0, 0, 0)
	if self._humanoid then
		self._humanoid:Move(Vector3.new(0, 0, 0), false)
	end
end

function Movement:GetMoveDirection()
	return self._moveDirection
end

return Movement
