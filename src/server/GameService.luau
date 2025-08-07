local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")
local Types = require(script.Parent.Types)
local Network = require(ReplicatedStorage.Shared.Modules.Network)
local Settings = require(ReplicatedStorage.Shared.Modules.Settings)
local PlayerService = {} :: Types.PlayerService
local Service = { Plots = {}, Network = Network.new("GameService") }

function Service:PlaceObject(plr, id, CFrame)
	id = tonumber(id)

	local PlayerObj = PlayerService:GetPlayer(plr)
	if not PlayerObj then
		print("PlayerObj for ", plr, " does not exist")
		return
	end

	if not PlayerObj.StateObj:GetState("InPlot") then
		print(plr, "Not in plot while trying to build")
		return
	end

	if not Settings.Character[id] then
		print("Settings for id: " .. id .. "does not exist")
		return
	end

	CFrame = PlayerObj.Tycoon.Instance.Base.CFrame:ToObjectSpace(CFrame)
	if PlayerObj.Player.Character:FindFirstChild(id) then
		PlayerObj.Player.Character:FindFirstChild(id):Destroy()
	end

	PlayerObj.Tycoon:AddCharacter(id, CFrame)
end

function Service:RemoveObject(plr, id) end

local _, RE = Service.Network:AddRE("Place")
RE:Connect(function(plr, id, CFrame)
	Service:PlaceObject(plr, id, CFrame)
end)

local _, TeleportRE = Service.Network:AddRE("Teleport")
TeleportRE:Connect(function(plr, Destination)
	local PlayerObj = PlayerService:GetPlayer(plr)
	if not PlayerObj then
		return
	end
	if Destination == "Plot" and not PlayerObj.StateObj:GetState("InPlot") then
		plr.Character:PivotTo(PlayerService:GetPlayer(plr).Tycoon.Instance.Base.CFrame + Vector3.new(0, 5, 0))
	elseif Destination == "Shop" then
		plr.Character:PivotTo(Workspace.Shop.CFrame + Vector3.new(0, 5, 0))
	end
end)

function Service:Start()
	PlayerService = require(ServerScriptService.Server.PlayerService)
end

local IncomeDB = false

RunService.Heartbeat:Connect(function()
	if IncomeDB then
		return
	end
	IncomeDB = true
	task.delay(1, function()
		IncomeDB = false
	end)
	for _, v in Service.Plots do
		task.spawn(v.Income, v)
	end
end)

return Service :: Types.GameService
