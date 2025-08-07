local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")
local Types = require(script.Parent.Types)
local Network = require(ReplicatedStorage.Shared.Modules.Network)
local Settings = require(ReplicatedStorage.Shared.Modules.Settings)
local PlayerService = {} :: Types.PlayerService
local Service = { Plots = {}, Network = Network.new("GameService") }

local function Collision(id, CFrame, Type)
	local Object = ReplicatedStorage.Assets[Type][id]:Clone()
	Object.Parent = workspace
	Object:PivotTo(CFrame)
	for _, v in workspace:GetPartBoundsInBox(Object:GetBoundingBox()) do
		if v.Parent:HasTag("Character") and v.Parent ~= Object then
			Object:Destroy()
			return true
		end
	end
	Object:Destroy()
	return false
end

function Service:PlaceObject(plr, id, CFrame, Type)
	id = tonumber(id)

	if Collision(id, CFrame, Type) then
		return
	end

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

	local Found = false

	for i, v in PlayerObj.Profile.Data.Inventory do
		if v.id == id then
			Found = true
			table.remove(PlayerObj.Profile.Data.Inventory, i)
			break
		end
	end

	if not Found then
		print("Not in inv")
		return
	end

	CFrame = PlayerObj.Tycoon.Instance.Base.CFrame:ToObjectSpace(CFrame)
	if PlayerObj.Player.Character:FindFirstChild(id) then
		PlayerObj.Player.Character:FindFirstChild(id):Destroy()
	end

	local Succes, CF = PlayerObj.Tycoon:AddCharacter(id, CFrame, Type)

	if not Succes then
		return
	end

	table.insert(PlayerObj.Profile.Data.Characters, { id = id, Type = Type, CFrame = CF })
	PlayerObj:Update()
end

function Service:PickupObject(plr, Instance)
	local obj = PlayerService:GetPlayer(plr)
	if not Instance or Instance.Parent ~= obj.Tycoon.Instance.Characters then
		return
	end

	PlayerService:AddTool(plr, ReplicatedStorage.Assets.Character[Instance.Name])
	table.insert(obj.Profile.Data.Inventory, { id = tonumber(Instance.Name), Type = "Character" })
	obj.Tycoon:Pickup(Instance)

	local CF = obj.Tycoon.Instance.Base.CFrame:ToObjectSpace(Instance:GetPivot())

	for i, v in obj.Profile.Data.Characters do
		if v.CFrame == CF then
			table.remove(obj.Profile.Data.Characters, i)
			break
		end
	end
	obj:Update()
end

local _, PlaceRE = Service.Network:AddRE("Place")
PlaceRE:Connect(function(plr, id, CFrame, Type)
	print(Type)
	Service:PlaceObject(plr, id, CFrame, Type)
end)

local _, PickupRE = Service.Network:AddRE("Pickup")
PickupRE:Connect(function(plr, Instance)
	Service:PickupObject(plr, Instance)
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
local SpawnDB = false
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

	if SpawnDB then
		return
	end
	SpawnDB = true
	task.delay(4, function()
		SpawnDB = false
	end)
	for _, v in Service.Plots do
		task.spawn(v.SpawnEgg, v)
	end
end)

return Service :: Types.GameService
