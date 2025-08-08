local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fusion = require(ReplicatedStorage.Packages.fusion)
local Setting = require(ReplicatedStorage.Shared.FusionModules.Setting)
local SettingsFrame = require(ReplicatedStorage.Shared.FusionModules.SettingsFrame)
local ImageIds = require(ReplicatedStorage.Shared.Modules.ImageIds)
local StateManager = require(ReplicatedStorage.Shared.Modules.StateManager)
local SettingsStates = StateManager:GetObj("Settings")
local Children, peek = fusion.Children, fusion.peek
local module = {}

function module:Init(Scope)
	local Frame = SettingsFrame(Scope)
	module.Frame = Frame.Frame
	module.Visible = Frame.Visible

	local MusicValue, MusicSetting = Setting(Scope, "Slider", { Title = "Music" })
	MusicSetting.Frame.Icon.Image = ImageIds.Music
	local SoundValue, SoundSetting = Setting(Scope, "Slider", { Title = "Sound" })
	Scope:Observer(SoundValue):onBind(function()
		SettingsStates:SetState("Sound", peek(SoundValue))
	end)
	Scope:Observer(MusicValue):onBind(function()
		SettingsStates:SetState("Music", peek(MusicValue))
	end)
	Scope:Hydrate(module.Frame.Settings)({
		[Children] = {
			MusicSetting,
			SoundSetting,
		},
	})
end

return module
