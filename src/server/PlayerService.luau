local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Network = require(ReplicatedStorage.Shared.Modules.Network)
local StateManager = require(ReplicatedStorage.Shared.Modules.StateManager)
local Types = require(script.Parent.Types)
local Utils = require(ReplicatedStorage.Shared.Modules.Utils)
local profilestore = require(ServerScriptService.Packages.ProfileStore)
local GameService = {} :: Types.GameService
local ServiceNetwork = Network.new("PlayerService")
ServiceNetwork:AddRE("Update")
local Store = profilestore.New("0.0.1", {
	Money = 25,
	Inventory = {},
	PlacedPots = {},
	Characters = {},
	Rebirth = 0,
	Multiplier = 1,
	Index = {},
	PlayTime = os.time(),
	LastSeen = os.time(),
	PlayTimeReward = false,
	Favorite = false,
	Tutorial = 0,
	Tools = { "Bat" },
})

local Service = {
	Name = "PlayerService",
	Profiles = {},
	Client = {},
} :: Types.PlayerService

local zeroWidthSpace = "​"

local function UpdateLeaderboardStats()
	local Profiles = {}

	for _, Obj in Service.Profiles do
		if Obj.Profile then
			table.insert(Profiles, {

				Money = Obj.Profile.Data.Money,
				MoneyStringValue = Obj.Leaderstats.Cash,
			})
		end
	end

	table.sort(Profiles, function(statInfo1, statInfo2)
		return statInfo1.Money < statInfo2.Money
	end)

	for index, statInfo in Profiles do
		statInfo.MoneyStringValue.Value = `{zeroWidthSpace:rep(index - 1)}{Utils.en(statInfo.Money)}`
	end
end

function Service:LoadPlayer(Player)
	if Service.Profiles[Player.UserId] then
		return
	end

	local Profile = Store:StartSessionAsync("Player_" .. Player.UserId)
	if Profile == nil then
		Player:Kick("Data Issue, try again shortly. if issue persists, Contact Us! ")
		return
	end

	Profile:AddUserId(Player.UserId)
	Profile:Reconcile()

	Profile.OnSessionEnd:Connect(function()
		Player:Kick("Another instance of your acount joined!")
	end)

	if Profile.SessionLoadCount > 1 then
		Profile.Data.PlayTime += os.time() - Profile.Data.LastSeen
	end

	local Leaderstats = Instance.new("Folder")
	Leaderstats.Parent = Player
	Leaderstats.Name = "leaderstats"
	local Value = Instance.new("StringValue")
	Value.Parent = Leaderstats
	Value.Name = "Cash"
	Value.Value = Utils.en(Profile.Data.Money)

	self.Profiles[Player.UserId] = {
		Profile = Profile,
		Player = Player,
		Leaderstats = Leaderstats,
		Update = function()
			UpdateLeaderboardStats()
			ServiceNetwork:GetRE("Update"):Fire(Player, Profile.Data.Money)
		end,
		Friendlys = {},
		Friends = {},
		StateObj = StateManager:CreateObj("Player_" .. Player.UserId),
	}

	for _, v in GameService.Plots do
		print(v)
		if v:Claim(Player) then
			break
		end
	end

	task.delay(5, self.Profiles[Player.UserId].Update, self.Profiles[Player.UserId])

	return self.Profiles[Player.UserId]
end

function Service:Remove(Player)
	if not self.Profiles[Player.UserId] then
		return
	end
	local Profile = Service:GetPlayer(Player)
	if Profile.Tycoon then
		Profile.Tycoon:UnClaim()
	end
	Profile.StateObj:Destroy()
	Profile.Profile.Data.LastSeen = os.time()
	Profile.Profile:EndSession()
	self.Profiles[Player.UserId] = nil
end

function Service:GetPlayer(plr)
	if not plr then
		return
	end
	return self.Profiles[plr] or self.Profiles[plr.UserId]
end

function Service:Start()
	for _, v in Players:GetChildren() do
		Service:LoadPlayer(v)
	end
	GameService = require(ServerScriptService.Server.GameService)
end

Players.PlayerAdded:Connect(function(plr)
	local PlayerObj = Service:LoadPlayer(plr)
	if not PlayerObj then
		return
	end
	for _, v in Service.Profiles do
		if plr:IsFriendsWith(v.Player.UserId) then
			table.insert(v.Friends, plr.UserId)
			table.insert(PlayerObj.Friends, v.Player.UserId)
			v:Update()
		end
	end
end)

Players.PlayerRemoving:Connect(function(Player)
	Service:Remove(Player)
end)

return Service :: Types.PlayerService
