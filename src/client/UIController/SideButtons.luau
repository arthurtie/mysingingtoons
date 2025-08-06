local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fusion = require(ReplicatedStorage.Packages.fusion)
local SideButton = require(ReplicatedStorage.Shared.FusionModules.SideButton)
local SideFrame = require(ReplicatedStorage.Shared.FusionModules.SideButtons)
local ImageIds = require(ReplicatedStorage.Shared.Modules.ImageIds)

local Children = fusion.Children
local module = {}

function module:Init(Scope)
	local RobuxShop = SideButton(Scope)
	RobuxShop.ButtonName.Text = "Shop"
	RobuxShop.Icon.Image = ImageIds.Shop2
	local Index = SideButton(Scope)
	Index.ButtonName.Text = "Index"
	Index.Icon.Image = ImageIds.Index2
	local Settings = SideButton(Scope)
	Settings.ButtonName.Text = "Settings"
	Settings.Icon.Image = ImageIds.Settings2

	module.RobuxShop = RobuxShop
	module.Index = Index
	module.Settings = Settings
	module.Frame = Scope:Hydrate(SideFrame(Scope))({
		[Children] = { RobuxShop, Index, Settings },
	})
end

return module
