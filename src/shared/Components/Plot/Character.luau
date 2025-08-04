--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Settings = require(ReplicatedStorage.Shared.Modules.Settings)
local Types = require(ServerScriptService.Server.Types)
local Component = {} :: Types.CharacterComp
Component.__index = Component

function Component.new(Tycoon, id, CFrame)
	local instance = ReplicatedStorage.Assets.Characters:FindFirstChild(id):Clone()
	if not instance then
		return
	end
	instance:PivotTo(CFrame)

	local Table = {
		Instance = instance,
		Tycoon = Tycoon,
		Settings = Settings.Character[tonumber(instance.Name)],
	}

	Table.Instance.Parent = Table.Tycoon.Instance.Characters

	setmetatable(Table, Component)

	return Table :: Types.Character
end

function Component:Sell() end

function Component:Destroy() end

return Component
