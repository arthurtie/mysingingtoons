local FriendService = game:GetService("FriendService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local DataController = require(script.Parent.DataController)
local Types = require(script.Parent.Types)
local Network = require(ReplicatedStorage.Shared.Modules.Network)
local StateManager = require(ReplicatedStorage.Shared.Modules.StateManager)
local PlayerStates = StateManager:GetObj("Player")
local Player = Players.LocalPlayer
local TargetHighlight = Instance.new("Highlight")
TargetHighlight.Parent = script
TargetHighlight.Name = "TargetHighlight"
TargetHighlight.FillColor = Color3.fromRGB(255, 0, 0)
TargetHighlight.OutlineTransparency = 1
TargetHighlight.FillTransparency = 0.6
local UIController = {} :: Types.UIController

local PlacementController = { Rotation = 0 } :: Types.PlacementController
repeat
	task.wait()
until Network:GetNetwork("GameService")

local function Collision(Object)
	for _, v in Object.HitBox:GetTouchingParts() do
		if v.Parent:HasTag("Character") and v.Parent ~= Object then
			TargetHighlight.Adornee = v.Parent
			return true
		end
	end
	return false
end

function PlacementController:Place()
	if not PlayerStates:GetState("Placing") or not PlacementController.Instance then
		return
	end

	if Collision(PlacementController.Instance) then
		return
	end
	print(PlacementController.Instance:GetAttribute("Type"))
	Network:GetNetwork("GameService"):GetRE("Place"):Fire(
		PlacementController.Currentid,
		PlacementController.Instance:GetPivot(),
		PlacementController.Instance:GetAttribute("Type")
	)
	PlayerStates:SetState("Placing", false)
end

function PlacementController:StartPlacing(model, type)
	if not model or not model.Parent then
		return
	end
	if PlayerStates:GetState("Placing") then
		PlayerStates:SetState("Placing", false)
	end
	local Character = ReplicatedStorage.Assets[type]:FindFirstChild(model.Name)
	if not Character then
		return
	end

	PlayerStates:SetState("Placing", true)

	Character = Character:Clone()
	Character.Parent = workspace
	Character:PivotTo(Player:GetMouse().Hit)
	Character:SetAttribute("Type", type)
	local CF, Size = Character:GetBoundingBox()
	local HitBox = Instance.new("Part")
	HitBox.Size = Size
	HitBox.CFrame = CF
	HitBox.Touched:Connect(function() end)
	HitBox.Name = "HitBox"
	HitBox.Parent = Character
	HitBox.Transparency = 1
	for _, v in Character:GetChildren() do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
		end
	end
	Player:GetMouse().TargetFilter = Character
	PlacementController.Currentid = model.Name
	PlacementController.Instance = Character
end

function PlacementController:StopPlacing()
	if not PlacementController.Instance then
		return
	end
	PlacementController.Currentid = nil
	PlacementController.Instance:Destroy()
	PlacementController.Instance = nil
end

function PlacementController:Pickup()
	if not PlayerStates:GetState("Pickup") then
		return
	end
	local Target = Player:GetMouse().Target
	if not Target.Parent or not Target.Parent:HasTag("Character") then
		return
	end
	Network:GetNetwork("GameService"):GetRE("Pickup"):Fire(Target.Parent)
end

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.R and PlayerStates:GetState("Placing") then
		PlacementController.Rotation += 90
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		PlacementController:Pickup()
		PlacementController:Place()
	end
end)

PlayerStates:Subscribe("Placing", function(value)
	if not value then
		PlacementController:StopPlacing()
	end
end)

RunService.Heartbeat:Connect(function()
	if PlayerStates:GetState("Pickup") then
		local Target = Player:GetMouse().Target
		if not Target or not Target.Parent then
			return
		end
		if not Target.Parent:HasTag("Character") then
			TargetHighlight.Adornee = nil
			return
		end

		TargetHighlight.Adornee = Target.Parent
		return
	else
		TargetHighlight.Adornee = nil
	end

	if not PlacementController.Instance then
		return
	end
	local Object = PlacementController.Instance
	Collision(Object)
	local Position = Player:GetMouse().Hit.Position
	local BaseSize, BasePos = DataController:GetData().Tycoon.Base.Size, DataController:GetData().Tycoon.Base.Position
	local HitBoxSize = Object.HitBox.Size
	local YPos = BasePos.Y + (BaseSize.Y + HitBoxSize.Y) * 0.5
	local MinX, MaxX, MinZ, MaxZ =
		BasePos.X - ((BaseSize.X - HitBoxSize.X) * 0.5),
		BasePos.X + ((BaseSize.X - HitBoxSize.X) * 0.5),
		BasePos.Z - ((BaseSize.Z - HitBoxSize.Z) * 0.5),
		BasePos.Z + ((BaseSize.Z - HitBoxSize.Z) * 0.5)
	Position = Vector3.new(
		math.clamp(math.round(Position.X), MinX, MaxX),
		YPos,
		math.clamp(math.round(Position.Z), MinZ, MaxZ)
	)

	local CFrame = Object:GetPivot()
		:Lerp(CFrame.new(Position) * CFrame.Angles(0, math.rad(PlacementController.Rotation), 0), 0.5)

	Object:PivotTo(CFrame)
end)

repeat
	task.wait()
until Player.Character

Player.CharacterAdded:Connect(function()
	Player.Backpack.ChildAdded:Connect(function(Child)
		PlayerStates:SetState("Placing", false)
		if Child.Name == "Hammer" then
			PlayerStates:SetState("Pickup", false)
		end
	end)

	Player.Backpack.ChildRemoved:Connect(function(child)
		if child.Name == "Hammer" then
			PlayerStates:SetState("Pickup", true)
			return
		end
		PlacementController:StartPlacing(child)
	end)
end)

Player.Backpack.ChildAdded:Connect(function(Child)
	PlayerStates:SetState("Placing", false)

	if Child.Name == "Hammer" then
		PlayerStates:SetState("Pickup", false)
	end
end)

Player.Backpack.ChildRemoved:Connect(function(Child)
	if Child.Name == "Hammer" then
		PlayerStates:SetState("Pickup", true)
		return
	end
	PlacementController:StartPlacing(Child, Child:GetAttribute("Type"))
end)
return PlacementController
