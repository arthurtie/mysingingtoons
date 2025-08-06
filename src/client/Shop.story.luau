local ReplicatedStorage = game:GetService("ReplicatedStorage")
--local Setting = require(ReplicatedStorage.Shared.FusionModules.Setting)
local ShopFrame = require(ReplicatedStorage.Shared.FusionModules.ShopFrame)
local fusion = require(ReplicatedStorage.Packages.fusion)
local ImageIds = require(ReplicatedStorage.Shared.Modules.ImageIds)

local Scope = fusion.scoped(fusion)

return function(Parent)
	local Frame = Scope:Hydrate(ShopFrame(Scope))({
		Parent = Parent,
	})
	Scope:Hydrate(Frame.Settings)({
		[fusion.Children] = {},
	})

	return function()
		Frame:Destroy()
	end
end
