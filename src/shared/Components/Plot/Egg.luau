--!strict
local NetworkServer = game:GetService("NetworkServer")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local GameService = require(ServerScriptService.Server.GameService)
local Network = require(ReplicatedStorage.Shared.Modules.Network)
local PlayerService = require(ServerScriptService.Server.PlayerService)
local Settings = require(ReplicatedStorage.Shared.Modules.Settings)
local Utils = require(ReplicatedStorage.Shared.Modules.Utils)
local Types = require(ServerScriptService.Server.Types)
local Component = {} :: Types.EggComp
Component.__index = Component

local function CreateUI()
	local UI = Instance.new("BillboardGui")
	UI.Size = UDim2.fromScale(4, 4)
	UI.MaxDistance = 25
	local TimeLabel = Instance.new("TextLabel")
	TimeLabel.Parent = UI
	TimeLabel.Name = "Time"
	TimeLabel.Size = UDim2.fromScale(1, 0.3)
	TimeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	TimeLabel.Position = UDim2.fromScale(0.5, 0.5)
	TimeLabel.Font = Enum.Font.FredokaOne
	TimeLabel.TextScaled = true
	TimeLabel.BackgroundTransparency = 1
	TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UIStroke", TimeLabel).Thickness = 2
	return UI :: any
end

local function CreateProx()
	local Proximity = Instance.new("ProximityPrompt")
	Proximity.Enabled = false
	Proximity.ObjectText = ""
	Proximity.ActionText = "Hatch"
	Proximity.HoldDuration = 0.5

	return Proximity
end

function Component.new(Tycoon, id, CFrame)
	local Character = ReplicatedStorage.Assets.Egg:FindFirstChild(id)
	if not Character then
		return
	end
	Character = Character:Clone()
	Character:PivotTo(CFrame)
	Character.PrimaryPart.Anchored = true
	Character:SetAttribute("Type", "Egg")
	local Table = {
		Instance = Character,
		Tycoon = Tycoon,
		Settings = Settings.Egg[tonumber(id)],
		Time = 0,
		UI = CreateUI(),
		Proximity = CreateProx(),
	}

	Table.UI.Time.Text = "Time: " .. Table.Settings.Time .. "s"
	setmetatable(Table, Component)

	Table.Proximity.Triggered:Connect(function(plr)
		if plr.UserId ~= Table.Tycoon.Player or Table.Time < Table.Settings.Time then
			return
		end
		Table:Hatch()
	end)

	local CF, Size = Character:GetBoundingBox()

	local HitBox = Instance.new("Part")
	HitBox.Name = "HitBox"
	HitBox.Size = Size
	HitBox.CFrame = CF
	HitBox.Parent = Character
	HitBox.Anchored = true
	HitBox.Transparency = 1
	local UIPart = Instance.new("Part")
	UIPart.Name = "UIPart"
	UIPart.Size = Vector3.new(1, 1, 1)
	UIPart.CFrame = CF + Vector3.new(0, Size.Y * 0.5 + 2, 0)
	UIPart.Parent = Character
	UIPart.Anchored = true
	UIPart.Transparency = 1
	Table.UI.Parent = UIPart
	Table.Proximity.Parent = Table.Instance.PrimaryPart

	Table.Instance.Parent = Table.Tycoon.Instance.Characters

	for _, v in Character:GetDescendants() do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end

	return Table :: Types.Egg
end

function Component:Hatch()
	local OutCome = Utils.Roll(self.Settings.RarityTable)
	local Rarity = Settings.Rarity[OutCome.Name]

	GameService:PlaceObject({
		Player = Players:GetPlayerByUserId(self.Tycoon.Player),
		id = Rarity.Characters[math.random(1, #Rarity.Characters)],
		CFrame = self.Instance:GetPivot(),
		Type = "Character",
		Force = true,
	})

	Network:GetNetwork("GameService"):GetRE("Hatch"):Fire(self.Tycoon.Player, self.Settings)
	self:Destroy(true)
end

function Component:Destroy(Hatch)
	if self.Instance.Parent then
		self.Instance:Destroy()
	end

	if Hatch then
		for i, v in self.Tycoon.Characters do
			if v.Instance == self.Instance then
				table.remove(self.Tycoon.Characters, i)
			end
		end
	end

	for i, _ in pairs(self) do
		self[i] = nil
	end
end

function Component:Update()
	if self.Time > self.Settings.Time then
		self.Proximity.Enabled = true
		self.UI.Time.Text = "Hatch!"
		return
	end
	self.UI.Time.Text = "Time: " .. self.Settings.Time - self.Time .. "s"
end

return Component
