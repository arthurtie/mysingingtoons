--!strict
type module = {
	__index: module,
	new: (RemoteEvent) -> Event,
	Fire: (Event, Player, ...any) -> (),
	Connect: (Event, (...any) -> ...any) -> (() -> ())?,
	Once: (Event, (...any) -> ...any) -> (() -> ())?,
	Destroy: (Event) -> (),
}

export type Event = typeof(setmetatable({} :: { Event: RemoteEvent, Connections: { (...any) -> ...any } }, {} :: module))

local Module = {} :: module
Module.__index = Module

function Module.new(RemoteEvent)
	local Table = { Event = RemoteEvent, Connections = {} }

	setmetatable(Table, Module)

	RemoteEvent.Destroying:Once(function()
		Table:Destroy()
	end)

	RemoteEvent.OnClientEvent:Connect(function(...)
		for _, v in Table.Connections do
			task.spawn(v, ...)
		end
	end)

	return Table :: Event
end

function Module:Fire(...)
	self.Event:FireServer(...)
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
