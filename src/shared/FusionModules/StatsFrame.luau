local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)

return function(Scope: fusion.Scope<typeof(fusion)>)
	return Scope:New("Frame")({
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.9),
		Size = UDim2.fromScale(0.3, 0.5),
		BackgroundTransparency = 1,
		[fusion.Children] = {
			Scope:New("UIListLayout")({
				HorizontalAlignment = "Center",
			}),
			Scope:New("UIAspectRatioConstraint")({ AspectRatio = 0.7 }),
		},
	})
end
