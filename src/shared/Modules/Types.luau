local module = {}

export type CharacterSettings = {
	Name: string,
	Audio: number,
	id: number,
	Income: number,
	Rarity: string,
}
export type EggSettings = {
	Name: string,
	id: number,
	Price: number,
	Weight: number,
	RarityTable: { { Name: string, Weight: number } },
	Time: number,
}

return module
