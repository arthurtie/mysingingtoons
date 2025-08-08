local Module = {}

type Setting = {
	Weight: number,
	Color: Color3,
	StrokeColor: Color3,
	Characters: { number },
}

Module.Common = {
	Weight = 50,
	Color = Color3.fromRGB(110, 110, 110),
	StrokeColor = Color3.fromRGB(75, 75, 75),
	Characters = { 1, 2 },
}
Module.UnCommon = {
	Weight = 50,
	Color = Color3.fromRGB(110, 110, 110),
	StrokeColor = Color3.fromRGB(75, 75, 75),
	Characters = { 1, 2 },
}
Module.Rare = {
	Weight = 50,
	Color = Color3.fromRGB(110, 110, 110),
	StrokeColor = Color3.fromRGB(75, 75, 75),
	Characters = { 1, 2 },
}
Module.Epic = {
	Weight = 50,
	Color = Color3.fromRGB(110, 110, 110),
	StrokeColor = Color3.fromRGB(75, 75, 75),
	Characters = { 1, 2 },
}

return Module :: { Setting }
