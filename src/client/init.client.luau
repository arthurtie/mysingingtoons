local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StateManager = require(ReplicatedStorage.Shared.Modules.StateManager)
StateManager:CreateObj("Player")
StateManager:CreateObj("Settings")
local Controllers = {}
for _, v in script:GetChildren() do
	table.insert(Controllers, require(v))
end

for _, v in Controllers do
	if type(v) == "table" and type(v.Start) == "function" then
		task.spawn(v.Start, v)
	end
end
