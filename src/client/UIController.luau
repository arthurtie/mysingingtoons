local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local DataController = require(script.Parent.DataController)
local fusion = require(ReplicatedStorage.Packages.fusion)
local CloseButton = require(ReplicatedStorage.Shared.FusionModules.CloseButton)
local FrameModule = require(ReplicatedStorage.Shared.FusionModules.Frame)
local Stat = require(ReplicatedStorage.Shared.FusionModules.Stat)
local StatsFrame = require(ReplicatedStorage.Shared.FusionModules.StatsFrame)
local TopButton = require(ReplicatedStorage.Shared.FusionModules.TopButton)
local TopFrame = require(ReplicatedStorage.Shared.FusionModules.TopButtons)
local ImageIds = require(ReplicatedStorage.Shared.Modules.ImageIds)
local Network = require(ReplicatedStorage.Shared.Modules.Network)
local Utils = require(ReplicatedStorage.Shared.Modules.Utils)

local Children, OnEvent, peek = fusion.Children, fusion.OnEvent, fusion.peek

local Scope = fusion.scoped(fusion)

local module = {}

local Money = Scope:Value(0)
local Gem = Scope:Value(0)

local MoneyStat = Stat(Scope)
MoneyStat.Icon.Image = ImageIds.Cash
local GemStat = Stat(Scope)
GemStat.Icon.Image = ImageIds.Gem

Scope:Hydrate(MoneyStat.Value)({
	Text = Money,
})

Scope:Hydrate(GemStat.Value)({
	Text = Gem,
	TextColor3 = Color3.fromRGB(0, 150, 255),
})

local Stats = Scope:Hydrate(StatsFrame(Scope))({
	[Children] = { MoneyStat, GemStat },
})

local ToPlot = TopButton(Scope)
ToPlot.BackgroundColor3 = Color3.fromRGB(105, 129, 196)
Scope:Hydrate(ToPlot.Button)({
	Text = "To Plot",
	[OnEvent("MouseButton1Click")] = function()
		Network:GetNetwork("GameService"):GetRE("Teleport"):Fire("Plot")
	end,
})
local ToShop = TopButton(Scope)
ToShop.BackgroundColor3 = Color3.fromRGB(54, 158, 63)
Scope:Hydrate(ToShop.Button)({
	Text = "To Shop",
	[OnEvent("MouseButton1Click")] = function()
		Network:GetNetwork("GameService"):GetRE("Teleport"):Fire("Shop")
	end,
})

local TopButtons = Scope:Hydrate(TopFrame(Scope))({
	[Children] = { ToPlot, ToShop },
})

function module:Start()
	DataController:Subscribe(function(data)
		Money:set(Utils.en(data.Profile.Money))
		Gem:set(Utils.en(data.Profile.Gems))
	end)

	local Data = DataController:GetData()
	Money:set(Utils.en(Data.Profile.Money))
	Gem:set(Utils.en(Data.Profile.Gems))

	local FrameVisible = Scope:Value(false)
	local Frame = Scope:Value()
	Scope:New("ScreenGui")({
		Parent = Players.LocalPlayer.PlayerGui,
		IgnoreGuiInset = true,
		[Children] = {
			Frame,
			Stats,
			TopButtons,
		},
	})

	Frame:set(Scope:Hydrate(FrameModule(Scope))({
		Size = Scope:Spring(
			Scope:Computed(function(use)
				return use(FrameVisible) and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0, 0)
			end),
			20
		),
		Position = Scope:Spring(
			Scope:Computed(function(use)
				return use(FrameVisible) and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.5, 1.2)
			end),
			20
		),
	}))

	Scope:Hydrate(peek(Frame).Close)({
		[OnEvent("MouseButton1Click")] = function()
			FrameVisible:set(false)
		end,
	})

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.G then
			FrameVisible:set(not peek(FrameVisible))
		end
	end)
end

return module
