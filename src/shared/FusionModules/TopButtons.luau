local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)

return function(Scope: fusion.Scope<typeof(fusion)>)
	return Scope:New("Frame")({
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.fromScale(0.4, 0.1),
		BackgroundTransparency = 1,
		[fusion.Children] = {
			Scope:New("UIListLayout")({
				HorizontalAlignment = "Center",
				VerticalAlignment = "Center",
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0.03, 0),
			}),
			Scope:New("UIAspectRatioConstraint")({ AspectRatio = 10.373 }),
		},
	})
end
