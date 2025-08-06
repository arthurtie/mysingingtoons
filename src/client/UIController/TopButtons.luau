local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fusion = require(ReplicatedStorage.Packages.fusion)
local TopButton = require(ReplicatedStorage.Shared.FusionModules.TopButton)
local TopFrame = require(ReplicatedStorage.Shared.FusionModules.TopButtons)
local Network = require(ReplicatedStorage.Shared.Modules.Network)
local OnEvent, Children = fusion.OnEvent, fusion.Children
local module = {}

function module:Init(Scope)
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

	module.Frame = Scope:Hydrate(TopFrame(Scope))({
		[Children] = { ToPlot, ToShop },
	})
end

return module
