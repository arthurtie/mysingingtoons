local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Network = require(ReplicatedStorage.Shared.Modules.Network)
local module = {}

repeat
	task.wait()
until Network:GetNetwork("GameService")

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.P then
		Network:GetNetwork("GameService"):GetRE("Place"):Fire(1, CFrame.new(0, 10, 1))
	end
end)

return module
