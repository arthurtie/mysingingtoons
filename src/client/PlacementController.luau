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

local UIController = {} :: Types.UIController

local PlacementController = { Rotation = 0 } :: Types.PlacementController
repeat
	task.wait()
until Network:GetNetwork("GameService")

function PlacementController:Place()
	if not PlayerStates:GetState("Placing") or not PlacementController.Instance then
		return
	end
	Network:GetNetwork("GameService")
		:GetRE("Place")
		:Fire(PlacementController.Currentid, PlacementController.Instance:GetPivot())
	PlayerStates:SetState("Placing", false)
end

function PlacementController:StartPlacing(id)
	if PlayerStates:GetState("Placing") then
		PlayerStates:SetState("Placing", false)
	end
	local Instance = ReplicatedStorage.Assets.Character:FindFirstChild(id)
	if not Instance then
		return
	end

	PlayerStates:SetState("Placing", true)

	Instance = Instance:Clone()
	Instance.Parent = workspace
	Instance:PivotTo(Player:GetMouse().Hit)
	for _, v in Instance:GetChildren() do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
		end
	end

	Player:GetMouse().TargetFilter = Instance
	PlacementController.Currentid = id
	PlacementController.Instance = Instance
end

function PlacementController:StopPlacing()
	if not PlacementController.Instance then
		return
	end
	PlacementController.Currentid = nil
	PlacementController.Instance:Destroy()
end

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.R then
		PlacementController.Rotation += 90
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		PlacementController:Place()
	end
end)

PlayerStates:Subscribe("Placing", function(value)
	if not value then
		PlacementController:StopPlacing()
	end
end)
RunService.Heartbeat:Connect(function()
	if not PlacementController.Instance then
		return
	end
	local Object = PlacementController.Instance

	local Position = Player:GetMouse().Hit.Position
	Position = Vector3.new(math.round(Position.X), math.round(Position.Y), math.round(Position.Z))

	local CFrame = Object:GetPivot()
		:Lerp(CFrame.new(Position) * CFrame.Angles(0, math.rad(PlacementController.Rotation), 0), 0.5)

	Object:PivotTo(CFrame)
end)

repeat
	task.wait()
until Player.Character

Player.Backpack.ChildAdded:Connect(function()
	PlayerStates:SetState("Placing", false)
end)

Player.Backpack.ChildRemoved:Connect(function(child)
	print(child)
	PlacementController:StartPlacing(child.Name)
end)

return PlacementController
