local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local DataController = require(script.Parent.DataController)
local SoundIds = require(ReplicatedStorage.Shared.Modules.SoundIds)
local StateManager = require(ReplicatedStorage.Shared.Modules.StateManager)
local Types = require(script.Parent.Types)
local SongLength = 10
local TimeStamp = 0
local SettingsStates = StateManager:GetObj("Settings")
SettingsStates:SetState("Music", 1)
local module = { Loaded = {}, SongStart = tick() } :: Types.MusicController

function module:Start()
	Instance.new("Folder", SoundService).Name = "Music"
	DataController:Subscribe(function(data)
		module:LoadMusic(data)
	end)
end

SettingsStates:Subscribe("Music", function(value)
	for _, v in module.Loaded do
		v.Volume = value
	end
end)

function module:LoadMusic(data)
	for i, Sound in module.Loaded do
		local Found = false
		for _, v in data.Profile.Characters do
			if v.id == tonumber(Sound.Name) then
				Found = true
				break
			end
		end

		if not Found then
			table.remove(module.Loaded, i)
			Sound:Destroy()
		end
	end
	for _, v in data.Profile.Characters do
		if v.Type == "Egg" then
			continue
		end
		if module.Loaded[v.id] then
			continue
		end

		local Sound = Instance.new("Sound")
		Sound.SoundId = SoundIds.Test[v.id]
		Sound.Parent = SoundService.Music
		Sound.TimePosition = TimeStamp
		print(TimeStamp)
		Sound:Play()
		Sound.Name = v.id
		Sound.Volume = SettingsStates:GetState("Music")
		module.Loaded[v.id] = Sound
	end
end

RunService.Heartbeat:Connect(function(dt)
	TimeStamp += dt
	if tick() - module.SongStart > SongLength then
		module.SongStart = tick()
		TimeStamp = 0
		for _, v in module.Loaded do
			v.TimePosition = 0

			task.spawn(v.Play, v)
		end
	end
end)

return module
