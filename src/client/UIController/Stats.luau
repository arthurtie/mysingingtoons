local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fusion = require(ReplicatedStorage.Packages.fusion)
local Stat = require(ReplicatedStorage.Shared.FusionModules.Stat)
local StatsFrame = require(ReplicatedStorage.Shared.FusionModules.StatsFrame)
local ImageIds = require(ReplicatedStorage.Shared.Modules.ImageIds)
local Children = fusion.Children
local module = {}

function module:Init(Scope)
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
	module.Money = Money
	module.Gem = Gem
	module.Frame = Stats
end

return module
