--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Modules.Types)
type module = {}
local module: module = {}

export type TycoonComp = {
	__index: TycoonComp,
	Claim: (Tycoon, Player) -> (),
	UnClaim: (Tycoon) -> (),
	new: (Instance) -> Tycoon,
	AddCharacter: (Tycoon, number, CFrame) -> (),
}

export type Tycoon = typeof(setmetatable(
	{} :: { Claimed: boolean, Player: number?, Instance: typeof(workspace.Plots["1"]), Characters: { Character } },
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
	Tycoon: Tycoon?,
	Player: Player,
	Leaderstats: Folder,
	Update: () -> (),
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
	Start: (PlayerService) -> (),
}

return module
