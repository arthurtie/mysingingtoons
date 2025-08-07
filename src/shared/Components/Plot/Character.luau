--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerService = require(ServerScriptService.Server.PlayerService)
local Settings = require(ReplicatedStorage.Shared.Modules.Settings)
local Types = require(ServerScriptService.Server.Types)
local Component = {} :: Types.CharacterComp
Component.__index = Component

local function CreateUI()
	local UI = Instance.new("BillboardGui")
	UI.Size = UDim2.fromScale(4, 4)
	UI.MaxDistance = 25
	local CollectLabel = Instance.new("TextLabel")
	CollectLabel.Parent = UI
	CollectLabel.Name = "Collect"
	CollectLabel.Size = UDim2.fromScale(1, 0.3)
	CollectLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	CollectLabel.Position = UDim2.fromScale(0.5, 0.5)
	CollectLabel.Font = Enum.Font.FredokaOne
	CollectLabel.TextScaled = true
	CollectLabel.BackgroundTransparency = 1
	CollectLabel.TextColor3 = Color3.fromRGB(0, 188, 0)
	Instance.new("UIStroke", CollectLabel).Thickness = 2
	local IncomeLabel = Instance.new("TextLabel")
	IncomeLabel.Parent = UI
	IncomeLabel.Name = "Income"
	IncomeLabel.Size = UDim2.fromScale(1, 0.2)
	IncomeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	IncomeLabel.Position = UDim2.fromScale(0.5, 0.73)
	IncomeLabel.Font = Enum.Font.FredokaOne
	IncomeLabel.TextScaled = true
	IncomeLabel.BackgroundTransparency = 1
	IncomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UIStroke", IncomeLabel).Thickness = 2
	local RarityLabel = Instance.new("TextLabel")
	RarityLabel.Parent = UI
	RarityLabel.Name = "Rarity"
	RarityLabel.Size = UDim2.fromScale(1, 0.3)
	RarityLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	RarityLabel.Position = UDim2.fromScale(0.5, 0.25)
	RarityLabel.Font = Enum.Font.FredokaOne
	RarityLabel.TextScaled = true
	RarityLabel.BackgroundTransparency = 1
	RarityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UIStroke", RarityLabel).Thickness = 2
	return UI :: any
end

function Component.new(Tycoon, id, CFrame)
	local Character = ReplicatedStorage.Assets.Character:FindFirstChild(id)
	if not Character then
		return
	end
	Character = Character:Clone()
	Character:PivotTo(CFrame)
	Character.PrimaryPart.Anchored = true
	local Table = {
		Instance = Character,
		Tycoon = Tycoon,
		Settings = Settings.Character[tonumber(id)],
		Money = 0,
		UI = CreateUI(),
	}
	local RaritySettings = Settings.Rarity[Table.Settings.Rarity]

	Table.UI.Income.Text = "$" .. Table.Settings.Income .. "/s"
	Table.UI.Rarity.Text = Table.Settings.Rarity
	Table.UI.Rarity.TextColor3 = RaritySettings.Color
	Table.UI.Rarity.UIStroke.Color = RaritySettings.StrokeColor
	setmetatable(Table, Component)

	local CF, Size = Character:GetBoundingBox()

	local HitBox = Instance.new("Part")
	HitBox.Name = "HitBox"
	HitBox.Size = Size
	HitBox.CFrame = CF
	HitBox.Parent = Character
	HitBox.Anchored = true
	HitBox.Transparency = 1
	HitBox.Touched:Connect(function(part)
		local Player = Players:GetPlayerFromCharacter(part.Parent)
		Table:Collect(Player)
	end)
	local UIPart = Instance.new("Part")
	UIPart.Name = "UIPart"
	UIPart.Size = Vector3.new(1, 1, 1)
	UIPart.CFrame = CF + Vector3.new(0, Size.Y * 0.5 + 2, 0)
	UIPart.Parent = Character
	UIPart.Anchored = true
	UIPart.Transparency = 1
	Table.UI.Parent = UIPart

	Table.Instance.Parent = Table.Tycoon.Instance.Characters

	for _, v in Character:GetDescendants() do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end

	return Table :: Types.Character
end

function Component:Sell() end

function Component:Destroy()
	if self.Instance.Parent then
		self.Instance:Destroy()
	end
	for i, _ in pairs(self) do
		self[i] = nil
	end
end

function Component:Update()
	self.UI.Collect.Text = "Collect: " .. self.Money
end

function Component:Collect(Player)
	if not Player or Player.UserId ~= self.Tycoon.Player then
		return
	end
	local Obj = PlayerService:GetPlayer(Player)
	Obj.Profile.Data.Money += self.Money
	self.Money = 0
	Obj:Update()
	self:Update()
end

return Component
