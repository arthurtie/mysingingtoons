local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IndexFrame = require(ReplicatedStorage.Shared.FusionModules.Index)
local module = {}

function module:Init(Scope)
	local Frame = IndexFrame(Scope)
	module.Frame = Frame.Frame
	module.Visible = Frame.Visible
end

return module
