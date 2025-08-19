local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local Settings = require(ReplicatedStorage.Shared.Modules.Settings)
local Utils = require(ReplicatedStorage.Shared.Modules.Utils)
local PlayerService = require(ServerScriptService.Server.PlayerService)
local GameService = require(ServerScriptService.Server.GameService)
local Types = require(ServerScriptService.Server.Types)
local SharedTypes = require(ReplicatedStorage.Shared.Modules.Types)
local CharComp = require(script.Character)
local Egg = require(script.Egg)
local Component = {} :: Types.TycoonComp
Component.__index = Component

function Component.new(instance)
	local Table = {
		Instance = instance,
		Claimed = true,
		Player = nil,
		Characters = {},
		HitBox = Instance.new("Part"),
	}

	Table.HitBox.Parent = Table.Instance
	Table.HitBox.Size = Vector3.new(25, 25, 25)
	Table.HitBox.Position = Table.Instance.Base.Position + Vector3.new(0, 12.5, 0)
	Table.HitBox.Anchored = true
	Table.HitBox.CanCollide = false
	Table.HitBox.Transparency = 1
	Table.HitBox.CanQuery = false
	Table.HitBox.Touched:Connect(function(part)
		if not part.Parent or not Players:GetPlayerFromCharacter(part.Parent) then
			return
		end

		local PlayerObj = PlayerService:GetPlayer(Players:GetPlayerFromCharacter(part.Parent))
		if PlayerObj.Player.UserId ~= Table.Player then
			return
		end

		PlayerObj.StateObj:SetState("InPlot", true)
	end)

	Table.HitBox.TouchEnded:Connect(function(part)
		if not part.Parent or not Players:GetPlayerFromCharacter(part.Parent) then
			return
		end

		local PlayerObj = PlayerService:GetPlayer(Players:GetPlayerFromCharacter(part.Parent))
		if PlayerObj.Player.UserId ~= Table.Player then
			return
		end

		PlayerObj.StateObj:SetState("InPlot", false)
	end)

	setmetatable(Table, Component)

	Table:UnClaim()

	table.insert(GameService.Plots, Table)

	return Table :: Types.Tycoon
end

function Component:Claim(plr)
	if self.Claimed then
		return false
	end

	self.Player = plr.UserId
	local obj = PlayerService:GetPlayer(plr)
	obj.Tycoon = self
	for _, v in obj.Profile.Data.Characters do
		local CFrame = CFrame.new(table.unpack(v.CFrame))
		self:AddCharacter(v.id, CFrame, v.Type)
	end

	repeat
		task.wait()
	until plr.Character

	if plr.Character then
		plr.Character:PivotTo(self.Instance.Base.CFrame + Vector3.new(0, 2, 0))
	end

	plr.CharacterAdded:Connect(function(character)
		task.wait(0.01)
		character:PivotTo(self.Instance.Base.CFrame + Vector3.new(0, 2, 0))
	end)

	obj.Replica:Set({ "Tycoon" }, self.Instance)

	return true
end

function Component:Income()
	for _, v in self.Characters do
		if v.Money then
			v.Money += v.Settings.Income
		else
			v.Time += 1
		end

		v:Update()
	end
end

function Component:UnClaim()
	if not self.Claimed then
		return
	end

	self.Claimed = false

	for _, v in self.Characters do
		v.Instance:Destroy()
	end

	self.Player = nil
end

function Component:AddCharacter(id, CF, Type)
	local Instance = ReplicatedStorage.Assets[Type]:FindFirstChild(id)
	if not Instance then
		return
	end
	local _, Size = Instance:GetBoundingBox()
	CF = self.Instance.Base.CFrame:ToWorldSpace(CF)
	local YPos = self.Instance.Base.Size.Y + Size.Y * 0.5
	CF = CFrame.new(Vector3.new(math.round(CF.Position.X), YPos, math.round(CF.Position.Z)))
		* CFrame.Angles(CF.Rotation.X, 0, 0)
	local NewCharacter = Type == "Character" and CharComp.new(self, id, CF) or Egg.new(self, id, CF)
	if NewCharacter then
		table.insert(self.Characters, NewCharacter)
	end

	return true, self.Instance.Base.CFrame:ToObjectSpace(CF)
end

function Component:Pickup(Instance)
	for i, v in self.Characters do
		if v.Instance == Instance then
			v:Destroy()
			table.remove(self.Characters, i)
			break
		end
	end
end
function Component:SpawnEgg(ForcedEgg)
	local Egg
	if not ForcedEgg then
		Egg = Utils.Roll(Settings.Egg, 1) :: SharedTypes.EggSettings
	else
		Egg = ForcedEgg
	end
	local Model = ReplicatedStorage.Assets.Egg:FindFirstChild(Egg.id)
	if not Model then
		return
	end
	Model = Model:Clone()
	Model.Parent = self.Instance.Eggs
	Model:PivotTo(self.Instance.Conveyor.Begin:GetPivot())
	Utils.TweenModel(self.Instance.Conveyor.End:GetPivot(), TweenInfo.new(15, Enum.EasingStyle.Linear), Model).Completed
		:Connect(function()
			Model:Destroy()
		end)
	local Prompt = Instance.new("ProximityPrompt")
	Prompt.Name = "Buy"
	Prompt.ActionText = "$" .. Utils.en(Egg.Price)
	Prompt.ObjectText = "Buy"
	Prompt.Parent = Model.PrimaryPart
	Prompt.RequiresLineOfSight = false
	Prompt.HoldDuration = 1
	Prompt.Triggered:Connect(function(plr)
		if plr.UserId == self.Player then
			Prompt:Destroy()
			table.insert(PlayerService:GetPlayer(plr).Profile.Data.Inventory, { id = Egg.id, Type = "Egg" })
			PlayerService:AddTool(plr, Model, "Egg")
			Model:Destroy()
		end
	end)
end

workspace.DescendantAdded:Connect(function(instance)
	if instance:HasTag("Plot") then
		Component.new(instance)
	end
end)

for _, v in CollectionService:GetTagged("Plot") do
	Component.new(v)
end
return Component
