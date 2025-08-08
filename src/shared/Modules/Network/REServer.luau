--!strict
local Players = game:GetService("Players")
local Types = require(script.Parent.Types)

local Module = {} :: Types.EventModule
Module.__index = Module

function Module.new(RemoteEvent)
	local Table = { Event = RemoteEvent, Connections = {} }

	setmetatable(Table, Module)

	RemoteEvent.Destroying:Once(function()
		Table:Destroy()
	end)

	RemoteEvent.OnServerEvent:Connect(function(plr, ...)
		for _, v in Table.Connections do
			task.spawn(v, plr, ...)
		end
	end)

	return Table
end

function Module:Fire(Player, ...)
	Player = typeof(Player) ~= Player and Players:GetPlayerByUserId(Player) or Player

	if not Player or not Player:IsA("Player") then
		return
	end

	self.Event:FireClient(Player, ...)
end

function Module:FireAll(...)
	self.Event:FireAllClients(...)
end

function Module:Destroy()
	table.clear(self.Connections)
end

function Module:Once(callback)
	if typeof(callback) ~= "function" then
		return
	end

	local id = #self.Connections + 1

	self.Connections[id] = function()
		self.Connections[id] = nil
		callback()
	end

	return function()
		self.Connections[id] = nil
	end
end

function Module:Connect(callback)
	if typeof(callback) ~= "function" then
		return
	end
	local id = #self.Connections + 1

	self.Connections[id] = callback

	return function()
		self.Connections[id] = nil
	end
end

return Module
