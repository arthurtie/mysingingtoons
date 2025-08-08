local module = {}

module[1] = {
	Name = "Basic Egg",
	id = 1,
	Price = 50,
	Weight = 50,
	Time = 10,
	RarityTable = {
		{ Name = "Common", Weight = 60 },
		{ Name = "Uncommon", Weight = 30 },
		{ Name = "Rare", Weight = 9 },
		{ Name = "Epic", Weight = 1 },
	},
}

return module
