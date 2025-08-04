export type PlacementController = {
	StopPlacing: () -> (),
	StartPlacing: () -> (),
	Place: () -> (),
	Currentid: number,
	Instance: Model?,
}
export type UIController = {}

local module = {}
return module
