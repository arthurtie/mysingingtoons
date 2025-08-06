local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopFrame = require(ReplicatedStorage.Shared.FusionModules.ShopFrame)
local module = {}

function module:Init(Scope)
	local Frame = ShopFrame(Scope)
	module.Frame = Frame.Frame
	module.Visible = Frame.Visible
end

return module
