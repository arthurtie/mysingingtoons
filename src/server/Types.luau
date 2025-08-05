--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicaServer = require(script.Parent.ReplicaServer)
local Types = require(ReplicatedStorage.Shared.Modules.Types)
local NetWork = require(ReplicatedStorage.Shared.Modules.Network)
local StateManager = require(ReplicatedStorage.Shared.Modules.StateManager)
type module = {}
local module: module = {}

export type TycoonComp = {
	__index: TycoonComp,
	Claim: (Tycoon, Player) -> (),
	UnClaim: (Tycoon) -> (),
	new: (typeof(workspace.Plots["1"])) -> Tycoon,
	AddCharacter: (Tycoon, number, CFrame) -> (),
}

export type Tycoon = typeof(setmetatable(
	{} :: {
		Claimed: boolean,
		Player: number?,
		Instance: typeof(workspace.Plots["1"]),
		Characters: { Character },
		HitBox: Part,
	},
	{} :: TycoonComp
))

export type CharacterComp = {
	__index: CharacterComp,
	Sell: (Character, Player) -> (),
	Destroy: (Character) -> (),
	new: (Tycoon, number, CFrame) -> Character?,
}

export type Character = typeof(setmetatable(
	{} :: { Tycoon: Tycoon, Instance: Instance, Settings: Types.CharacterSettings },
	{} :: CharacterComp
))

export type PlayerObj = {
	Profile: {
		Data: {
			Gems: number,
			Money: number,
			Multiplier: number,
			Rebirth: number,
			Inventory: {},
			PlacedPots: {},
			Characters: { { id: number, CFrame: typeof({ CFrame.new():GetComponents() }) } },
			Index: {},
			PlayTime: number,
			LastSeen: number,
			PlayTimeReward: false,
			Favorite: false,
			Tutorial: number,
			Tools: { string },
		},
		[any]: any,
	},
	Replica: ReplicaServer.Replica,
	Tycoon: Tycoon?,
	Player: Player,
	Leaderstats: Folder,
	StateObj: StateManager.StateObject,
	Update: (PlayerObj) -> (),
}
export type PlayerService = {
	Name: string,
	Profiles: { PlayerObj },
	Client: {},
	LoadPlayer: (PlayerService, Player) -> PlayerObj?,
	GetPlayer: (PlayerService, Player | number) -> PlayerObj,
	Remove: (PlayerService, Player) -> (),
	Start: (PlayerService) -> (),
}
export type GameService = {
	Plots: { Tycoon },
	Network: NetWork.Network,
	Start: (PlayerService) -> (),
	PlaceObject: (Player, number, CFrame) -> (),
	RemoveObject: (Player, number) -> (),
}

return module
