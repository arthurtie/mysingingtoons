local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Setting = require(ReplicatedStorage.Shared.FusionModules.Setting)
local SettingsFrame = require(ReplicatedStorage.Shared.FusionModules.SettingsFrame)
local fusion = require(ReplicatedStorage.Packages.fusion)
local ImageIds = require(ReplicatedStorage.Shared.Modules.ImageIds)

local Scope = fusion.scoped(fusion)
local MusicValue, MusicSetting = Setting(Scope, "Slider")
MusicSetting.Frame.Icon.Image = ImageIds.Music
local SoundValue, SoundSetting = Setting(Scope, "Slider")

Scope:Observer(MusicValue):onBind(function()
	print("MusicValue Set To:", fusion.peek(MusicValue))
end)
Scope:Observer(SoundValue):onBind(function()
	print("SoundValue Set To:", fusion.peek(SoundValue))
end)

return function(Parent)
	local Frame = Scope:Hydrate(SettingsFrame(Scope))({
		Parent = Parent,
	})
	Scope:Hydrate(Frame.Settings)({
		[fusion.Children] = { MusicSetting, SoundSetting },
	})

	return function()
		Frame:Destroy()
	end
end
