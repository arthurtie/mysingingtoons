--!strict
export type Manager = {
	__index: Manager,
	StateObjects: { [string]: StateObject },
	CreateObj: (Manager, string) -> StateObject?,
	GetObj: (Manager, string) -> StateObject?,
	GetState: (StateObject, string) -> any,
	SetState: (StateObject, string, any) -> (),
	Subscribe: (StateObject, string, (any) -> ()) -> (() -> ())?,
	Destroy: (StateObject) -> (),
}

export type StateObject = typeof(setmetatable(
	{} :: { Name: string, States: { [string]: { Value: any, Subscriptions: { (any) -> ...any } } } },
	{} :: Manager
))

local Manager = { StateObjects = {} } :: Manager
Manager.__index = Manager

function Manager:CreateObj(name)
	if type(name) ~= "string" then
		return
	end

	local PlayerObj = { States = {}, Name = name }
	setmetatable(PlayerObj, Manager)

	Manager.StateObjects[name] = PlayerObj
	return PlayerObj
end

function Manager:GetObj(name)
	if not name or type(name) ~= "string" then
		return
	end
	return Manager.StateObjects[name]
end

function Manager:SetState(State, Value)
	if type(State) ~= "string" or Value == nil then
		return
	end
	if not self.States[State] then
		self.States[State] = { Value = Value, Subscriptions = {} }
	else
		if self.States[State].Value == Value then
			return
		end
		self.States[State].Value = Value
	end

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
		self.States[name] = { Value = nil, Subscriptions = {} }
	end

	local id = #self.States[name].Subscriptions + 1
	self.States[name].Subscriptions[id] = callback

	return function()
		self.States[name].Subscriptions[id] = nil
	end
end

function Manager:Destroy()
	Manager.StateObjects[self.Name] = nil
	setmetatable({ self }, {})
	for i, _ in pairs(self) do
		self[i] = nil
	end
end

return Manager
