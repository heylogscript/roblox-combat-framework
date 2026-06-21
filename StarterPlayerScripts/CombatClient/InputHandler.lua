local InputHandler = {}
InputHandler.__index = InputHandler

function InputHandler.new(player)
	local self = setmetatable({}, InputHandler)
	self._player = player
	self._controls = {
		M1 = {Key = Enum.KeyCode.ButtonR2, Active = false},
		M2 = {Key = Enum.KeyCode.ButtonL2, Active = false},
		Block = {Key = Enum.KeyCode.ButtonL1, Active = false},
		Dash = {Key = Enum.KeyCode.ButtonB, Active = false},
		Parry = {Key = Enum.KeyCode.ButtonX, Active = false},
		Ability1 = {Key = Enum.KeyCode.ButtonY, Active = false},
		Ability2 = {Key = Enum.KeyCode.ButtonA, Active = false},
	}
	self._contextActionService = game:GetService("ContextActionService")
	self._userInputService = game:GetService("UserInputService")
	self._remoteEvent = game:GetService("ReplicatedStorage"):FindFirstChild("CombatRemoteEvents")
	self._inputQueue = {}
	self._onInput = nil
	return self
end

function InputHandler:Bind()
	self._userInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end
		self:_HandleInput(input, true)
	end)

	self._userInputService.InputEnded:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end
		self:_HandleInput(input, false)
	end)
end

function InputHandler:_HandleInput(input, began)
	local action = nil
	for name, control in pairs(self._controls) do
		if input.KeyCode == control.Key or input.UserInputType == control.Key then
			action = name
			control.Active = began
			break
		end
	end

	if action and began then
		table.insert(self._inputQueue, {
			action = action,
			time = os.clock(),
		})

		if self._onInput then
			self._onInput(action)
		end

		if self._remoteEvent and self._remoteEvent:FindFirstChild(action) then
			self._remoteEvent[action]:FireServer()
		end
	end
end

function InputHandler:GetBufferedInputs(timeWindow)
	local now = os.clock()
	local recent = {}
	for i = #self._inputQueue, 1, -1 do
		if now - self._inputQueue[i].time <= timeWindow then
			table.insert(recent, 1, table.remove(self._inputQueue, i))
		end
	end
	return recent
end

function InputHandler:IsActionActive(action)
	local control = self._controls[action]
	return control and control.Active
end

function InputHandler:OnInput(callback)
	self._onInput = callback
end

function InputHandler:GetMoveVector()
	return self._userInputService:GetActiveTouchInputs()
end

return InputHandler
