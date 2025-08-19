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
	AddCharacter: (Tycoon, number, CFrame, string) -> (),
	Income: (Tycoon) -> (),
	Pickup: (Tycoon, Instance) -> (),
	SpawnEgg: (Tycoon, Types.EggSettings) -> (),
}

export type Tycoon = typeof(setmetatable(
	{} :: {
		Claimed: boolean,
		Player: number?,
		Instance: typeof(workspace.Plots["1"]),
		Characters: { Character | Egg },
		HitBox: Part,
	},
	{} :: TycoonComp
))

export type CharacterComp = {
	__index: CharacterComp,
	Sell: (Character, Player) -> (),
	Destroy: (Character) -> (),
	new: (Tycoon, number, CFrame) -> Character?,
	Update: (Character) -> (),
	Collect: (Character, Player) -> (),
}

export type Character = typeof(setmetatable(
	{} :: { UI: any, Tycoon: Tycoon, Instance: Instance, Settings: Types.CharacterSettings, Money: number },
	{} :: CharacterComp
))

export type EggComp = {
	__index: EggComp,
	Destroy: (Egg, boolean?) -> (),
	new: (Tycoon, number, CFrame) -> Egg?,
	Update: (Egg) -> (),
	Hatch: (Egg) -> (),
}

export type Egg = typeof(setmetatable(
	{} :: {
		UI: any,
		Tycoon: Tycoon,
		Instance: Model,
		Settings: Types.EggSettings,
		Time: number,
		Proximity: ProximityPrompt,
	},
	{} :: EggComp
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
			Characters: { { id: number, CFrame: typeof({ CFrame.new():GetComponents() }), Type: string } },
			Index: {},
			PlayTime: number,
			LastSeen: number,
			PlayTimeReward: false,
			Favorite: false,
			Tutorial: number,
			Tools: { string },
			Boosts: { { Boost: string, Duration: number, Amount: number, Start: number } },
		},
		[any]: any,
	},
	Replica: ReplicaServer.Replica,
	Tycoon: Tycoon,
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
	GetPlayer: (PlayerService, Player | number?) -> PlayerObj,
	Remove: (PlayerService, Player) -> (),
	Start: (PlayerService) -> (),
	LoadInventory: (PlayerService, Player) -> (),
	AddTool: (PlayerService, Player, Model, string) -> (),
	Index: (PlayerService, number) -> (),
	Boost: (PlayerService, Player: Player | number, Boost: "Luck" | "Money", Duration: number, Amount: number) -> (),
}
export type GameService = {
	Plots: { Tycoon },
	Network: NetWork.Network,
	Start: (PlayerService) -> (),
	PlaceObject: (GameService, { Player: Player, id: number, CFrame: CFrame, Type: string, Force: boolean? }) -> (),
	PickupObject: (GameService, Player, Model) -> (),
}

return module
