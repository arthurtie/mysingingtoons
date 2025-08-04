local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StateManager = require(ReplicatedStorage.Shared.Modules.StateManager)
StateManager:CreateObj("Player")
print(StateManager)
for _, v in script:GetChildren() do
	require(v)
end
