--!strict
type module = {
	__index: module,
	new: (RemoteFunction) -> RF,
	Connect: (RF, (...any) -> ...any) -> (),
	Fire: (RF, ...any) -> ...any,
}

export type RF = typeof(setmetatable({} :: { Remote: RemoteFunction }, {} :: module))

local Module = {} :: module
Module.__index = Module

function Module.new(RemoteFunction)
	local Table = { Remote = RemoteFunction }

	setmetatable(Table, Module)

	return Table :: RF
end

function Module:Connect(callback)
	if typeof(callback) ~= "function" then
		return
	end
	self.Remote.OnClientInvoke = callback
end

function Module:Fire(...)
	return self.Remote:InvokeServer(...)
end

return Module
