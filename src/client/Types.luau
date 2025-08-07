local ReplicaClient = require(script.Parent.ReplicaClient)
export type PlacementController = {
	StopPlacing: (PlacementController) -> (),
	StartPlacing: (PlacementController) -> (),
	Place: (PlacementController) -> (),
	Currentid: number,
	Instance: Model?,
	Rotation: number,
}
export type UIController = { ScreenGui: ScreenGui, PlayerObj: PlayerObj }

export type DataController = {
	PlayerObj: PlayerObj,
	Start: (DataController) -> (),
	GetData: (DataController) -> PlayerObj,
	Replica: ReplicaClient.Replica,
	Subscribe: (DataController, (PlayerObj) -> ()) -> () -> (),
	Subscribtions: { (any) -> () },
}

export type MusicController = {
	Loaded: { Sound },
	SongStart: number,
	Start: (DataController) -> (),
	LoadMusic: (MusicController, PlayerObj) -> (),
}
export type PlayerObj = {
	Profile: {
		Money: number,
		Gems: number,
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
	Tycoon: typeof(game.Workspace.Plots["1"]),
}
local module = {}
return module
