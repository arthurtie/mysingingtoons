local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataController = require(script.Parent.DataController)
local fusion = require(ReplicatedStorage.Packages.fusion)
local Setting = require(ReplicatedStorage.Shared.FusionModules.Setting)
local SettingsFrame = require(ReplicatedStorage.Shared.FusionModules.SettingsFrame)
local ShopFrame = require(ReplicatedStorage.Shared.FusionModules.ShopFrame)
local SideButton = require(ReplicatedStorage.Shared.FusionModules.SideButton)
local SideFrame = require(ReplicatedStorage.Shared.FusionModules.SideButtons)
local Stat = require(ReplicatedStorage.Shared.FusionModules.Stat)
local StatsFrame = require(ReplicatedStorage.Shared.FusionModules.StatsFrame)
local TopButton = require(ReplicatedStorage.Shared.FusionModules.TopButton)
local TopFrame = require(ReplicatedStorage.Shared.FusionModules.TopButtons)
local ImageIds = require(ReplicatedStorage.Shared.Modules.ImageIds)
local Network = require(ReplicatedStorage.Shared.Modules.Network)
local StateManager = require(ReplicatedStorage.Shared.Modules.StateManager)
local Utils = require(ReplicatedStorage.Shared.Modules.Utils)

local SettingsStates = StateManager:GetObj("Settings")
local Children, OnEvent, peek = fusion.Children, fusion.OnEvent, fusion.peek

local Scope = fusion.scoped(fusion)

local module = {}
local Frames = {}

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

local MusicValue, MusicSetting = Setting(Scope, "Slider")
MusicSetting.Frame.Icon.Image = ImageIds.Music
local SoundValue, SoundSetting = Setting(Scope, "Slider")

Scope:Observer(SoundValue):onBind(function()
	SettingsStates:SetState("Sound", peek(SoundValue))
end)
Scope:Observer(MusicValue):onBind(function()
	SettingsStates:SetState("Music", peek(MusicValue))
end)

local SettingsVisible = Scope:Value(false)

Frames.SettingsFrame = {
	Frame = Scope:Hydrate(SettingsFrame(Scope))({
		Size = Scope:Spring(
			Scope:Computed(function(use)
				return use(SettingsVisible) and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0, 0)
			end),
			20
		),
		Position = Scope:Spring(
			Scope:Computed(function(use)
				return use(SettingsVisible) and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.5, 1.2)
			end),
			20
		),
	}),
	Visible = SettingsVisible,
}

Scope:Hydrate(Frames.SettingsFrame.Frame.Settings)({
	[Children] = {
		MusicSetting,
		SoundSetting,
	},
})

local Shop = SideButton(Scope)
Shop.ButtonName.Text = "Shop"
Shop.Icon.Image = ImageIds.Shop2
local Index = SideButton(Scope)
Index.ButtonName.Text = "Index"
Index.Icon.Image = ImageIds.Index2
local Settings = SideButton(Scope)
Settings.ButtonName.Text = "Settings"
Settings.Icon.Image = ImageIds.Settings2
Scope:Hydrate(Settings.Button)({
	[OnEvent("MouseButton1Click")] = function()
		SettingsVisible:set(not peek(SettingsVisible))
	end,
})

local SideButtons = Scope:Hydrate(SideFrame(Scope))({
	[Children] = { Shop, Index, Settings },
})

function module:Start()
	DataController:Subscribe(function(data)
		Money:set(Utils.en(data.Profile.Money))
		Gem:set(Utils.en(data.Profile.Gems))
	end)

	local Data = DataController:GetData()
	Money:set(Utils.en(Data.Profile.Money))
	Gem:set(Utils.en(Data.Profile.Gems))

	Scope:New("ScreenGui")({
		Parent = Players.LocalPlayer.PlayerGui,
		IgnoreGuiInset = true,
		[Children] = {
			Stats,
			TopButtons,
			SideButtons,
			Frames.SettingsFrame.Frame,
			ShopFrame(Scope),
		},
	})
end

return module
