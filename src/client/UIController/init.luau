local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataController = require(script.Parent.DataController)
local fusion = require(ReplicatedStorage.Packages.fusion)
local Utils = require(ReplicatedStorage.Shared.Modules.Utils)
local OnEvent, peek = fusion.OnEvent, fusion.peek

local Scope = fusion.scoped(fusion)

local module = {}
local Frames = {}

for _, v in script:GetChildren() do
	Frames[v.Name] = require(v)
end

for _, v in Frames do
	if v.Init then
		v:Init(Scope)
	end
end

Scope:Hydrate(Frames.SideButtons.Settings.Button)({
	[OnEvent("MouseButton1Click")] = function()
		for _, v in Frames do
			if v ~= Frames.Settings and v.Visible then
				v.Visible:set(false)
			end
		end
		Frames.Settings.Visible:set(not peek(Frames.Settings.Visible))
	end,
})
Scope:Hydrate(Frames.SideButtons.RobuxShop.Button)({
	[OnEvent("MouseButton1Click")] = function()
		for _, v in Frames do
			if v ~= Frames.RobuxShop and v.Visible then
				v.Visible:set(false)
			end
		end
		Frames.RobuxShop.Visible:set(not peek(Frames.RobuxShop.Visible))
	end,
})

function module:Start()
	DataController:Subscribe(function(data)
		Frames.Stats.Money:set(Utils.en(data.Profile.Money))
		Frames.Stats.Gem:set(Utils.en(data.Profile.Gems))
	end)

	local Data = DataController:GetData()
	Frames.Stats.Money:set(Utils.en(Data.Profile.Money))
	Frames.Stats.Gem:set(Utils.en(Data.Profile.Gems))

	local UI = Scope:New("ScreenGui")({
		Parent = Players.LocalPlayer.PlayerGui,
		IgnoreGuiInset = true,
	})
	for _, v in Frames do
		if v.Frame then
			v.Frame.Parent = UI
		end
	end
end

return module
