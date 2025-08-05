local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fusion = require(ReplicatedStorage.Packages.fusion)

local module = {}

function module.text(Scope: fusion.Scope)
	return Scope:new("TextButton")
end

return module
