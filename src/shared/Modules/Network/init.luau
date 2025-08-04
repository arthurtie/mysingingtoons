--!strict
local RunService = game:GetService("RunService")
local REServer = require(script.REServer)
local REClient = require(script.REClient)
export type Net = {
	__index: Net,
	new: (string) -> NetWork?,
	NetWorks: { [string]: NetWork },
	Update: RemoteEvent,
	AddRE: (NetWork, string) -> (RemoteEvent, REServer.Event)?,
	GetNetwork: (Net, string) -> NetWork,
	GetRE: (NetWork, string) -> REServer.Event | REClient.Event,
}

export type NetWork = typeof(setmetatable(
	{} :: { ServerEvents: { [string]: REServer.Event }, ClientEvents: { [string]: REClient.Event }, Name: string },
	{} :: Net
))

local Net = {
	NetWorks = {},
} :: Net
Net.__index = Net

if RunService:IsServer() then
	Net.Update = Instance.new("RemoteEvent")
	Net.Update.Name = "_NetworkUpdate"
	Net.Update.Parent = script
	script._NetworkUpdate.OnServerEvent:Connect(function(plr)
		for _, v in Net.NetWorks do
			for _, Event in v.ServerEvents do
				script._NetworkUpdate:FireClient(plr, v.Name, Event.Event)
			end
		end
	end)
end
if RunService:IsClient() then
	script._NetworkUpdate.OnClientEvent:Connect(function(Network, Event: RemoteEvent)
		if Net.NetWorks[Network] then
			Net.NetWorks[Network].ClientEvents[Event.Name] = REClient.new(Event)
		else
			Net.NetWorks[Network] = setmetatable(
				{ Name = Network, ServerEvents = {}, ClientEvents = { [Event.Name] = REClient.new(Event) } },
				Net
			)
		end
	end)
	script._NetworkUpdate:FireServer()
end

function Net.new(Name)
	if RunService:IsClient() then
		warn("Cannot create network from client")
		return
	end
	local Table = { Name = Name, ServerEvents = {}, ClientEvents = {} }
	Net.NetWorks[Name] = setmetatable(Table, Net)
	return Net.NetWorks[Name] :: NetWork
end

function Net:AddRE(Name)
	if RunService:IsClient() then
		warn("Cannot create remote event from client")
		return
	end

	if self.ServerEvents[Name] then
		warn("RE with that name already exists")
		return
	end
	local RE = Instance.new("RemoteEvent")
	RE.Name = Name
	RE.Parent = script
	self.ServerEvents[Name] = REServer.new(RE)

	Net.Update:FireAllClients(self.Name, RE)

	return self.ServerEvents[Name].Event, self.ServerEvents[Name]
end

function Net:GetNetwork(Name)
	if RunService:IsClient() then
		return self.NetWorks[Name]
	else
		return self.NetWorks[Name]
	end
end

function Net:GetRE(Name)
	if RunService:IsClient() then
		return self.ClientEvents[Name]
	else
		return self.ServerEvents[Name]
	end
end

return Net
