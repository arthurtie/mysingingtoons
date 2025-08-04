--!strict
export type Manager = {
	__index: Manager,
	Players: { [string]: PlayerObj },
	CreateObj: (Manager, string) -> PlayerObj?,
	GetObj: (Manager, string) -> PlayerObj?,
	GetState: (PlayerObj, string) -> any,
	SetState: (PlayerObj, string, any) -> (),
	Subscribe: (PlayerObj, string, (any) -> ()) -> (() -> ())?,
	Destroy: (PlayerObj) -> (),
}

export type PlayerObj = typeof(setmetatable(
	{} :: { Name: string, States: { [string]: { Value: any, Subscriptions: { (any) -> ...any } } } },
	{} :: Manager
))

local Manager = { Players = {} } :: Manager
Manager.__index = Manager

function Manager:CreateObj(name)
	if type(name) ~= "string" then
		return
	end

	local PlayerObj = { States = {}, Name = name }
	setmetatable(PlayerObj, Manager)

	Manager.Players[name] = PlayerObj
	print(PlayerObj)
	return PlayerObj
end

function Manager:GetObj(name)
	if not name or type(name) ~= "string" then
		return
	end

	return Manager.Players[name]
end

function Manager:SetState(State, Value)
	if type(State) ~= "string" or not Value then
		return
	end

	self.States[State].Value = Value

	for _, v in self.States[State].Subscriptions do
		v(Value)
	end
end

function Manager:GetState(State)
	if type(State) ~= "string" or not self.States[State] then
		return
	end
	return self.States[State].Value
end

function Manager:Subscribe(name, callback)
	if type(name) ~= "string" or type(callback) ~= "function" then
		warn("type name ~= string or type callback ~= function")
		return
	end

	if not self.States[name] then
		warn("State does not exist")
		return
	end

	local id = #self.States[name].Subscriptions + 1
	self.States[name].Subscriptions[id] = callback

	return function()
		self.States[name].Subscriptions[id] = nil
	end
end

function Manager:Destroy()
	Manager.Players[self.Name] = nil
	setmetatable({ self }, {})
	for i, _ in pairs(self) do
		self[i] = nil
	end
end

return Manager
