local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)

return function(Scope: fusion.Scope<typeof(fusion)>)
	return Scope:New("Frame")({
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.45),
		Size = UDim2.fromScale(0.1, 0.45),
		BackgroundTransparency = 1,
		Name = "Side",
		[fusion.Children] = {
			Scope:New("UIListLayout")({
				HorizontalAlignment = "Center",
				VerticalAlignment = "Center",
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0.05, 0),
			}),
			Scope:New("UIAspectRatioConstraint")({ AspectRatio = 0.473 }),
		},
	})
end
