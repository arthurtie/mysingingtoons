local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Types = require(script.Parent.Types)
local Network = require(ReplicatedStorage.Shared.Modules.Network)
local Settings = require(ReplicatedStorage.Shared.Modules.Settings)
local PlayerService = {} :: Types.PlayerService
local Service = { Plots = {}, Network = Network.new("GameService") }

local _, RE = Service.Network:AddRE("Place")
RE:Connect(function(plr, id, CFrame)
	print(plr, id, CFrame)
	local PlayerObj = PlayerService:GetPlayer(plr)
	if not PlayerObj then
		print("PlayerObj for ", plr, " does not exist")
		return
	end
	print(PlayerObj)
	if not PlayerObj.StateObj:GetState("InPlot") then
		print(plr, "Not in plot while trying to build")
		return
	end
	if not Settings.Character[id] then
		print("Settings for id: " .. id .. "does not exist")
		return
	end

	CFrame = PlayerObj.Tycoon.Instance.Base.CFrame:ToObjectSpace(CFrame)

	PlayerObj.Tycoon:AddCharacter(id, CFrame)
end)

function Service:Start()
	PlayerService = require(ServerScriptService.Server.PlayerService)
end

return Service :: Types.GameService
