local Players = game:GetService("Players")
local ReplicaClient = require(script.Parent.ReplicaClient)
local Types = require(script.Parent.Types)
local module = { Subscribtions = {} } :: Types.DataController

function module:Start()
	ReplicaClient.OnNew("PlayerData", function(replica)
		if replica.Tags.UserId ~= Players.LocalPlayer.UserId then
			return
		end
		module.Replica = replica

		replica:OnChange(function()
			for _, v in self.Subscribtions do
				v(replica.Data)
			end
		end)
	end)

	ReplicaClient.RequestData()
end

function module:GetData()
	return self.Replica.Data
end

function module:Subscribe(callback)
	if type(callback) ~= "function" then
		return
	end
	local id = #self.Subscribtions + 1
	self.Subscribtions[id] = callback
	return function()
		self.Subscribtions[id] = nil
	end
end

return module
