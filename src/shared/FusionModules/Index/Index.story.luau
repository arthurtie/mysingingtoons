local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fusion = require(ReplicatedStorage.Packages.fusion)
local Index = require(script.Parent)
local Scope = fusion.scoped(fusion)
return function(Parent)
	local Frame = Index(Scope)
	Frame.Frame.Parent = Parent
	return function()
		Frame.Frame:Destroy()
	end
end
