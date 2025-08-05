local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)

return function(Scope: fusion.Scope<typeof(fusion)>)
	return Scope:New("Frame")({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.7),
		Size = UDim2.fromScale(0.8, 0.3),
		BackgroundTransparency = 1,
		[fusion.Children] = {
			Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
			Scope:New("UIAspectRatioConstraint")({ AspectRatio = 2.4 }),
			Scope:New("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			Scope:New("ImageLabel")({
				Name = "Icon",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0.02, 0.5),
				Size = UDim2.fromScale(0.35, 0.9),
				BackgroundTransparency = 1,
				[fusion.Children] = {
					Scope:New("UIAspectRatioConstraint")({}),
				},
			}),
			Scope:New("TextLabel")({
				Name = "Value",
				Text = "9.9m",
				Font = Enum.Font.FredokaOne,
				TextColor3 = Color3.fromRGB(57, 181, 74),
				TextScaled = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.68, 0.5),
				Size = UDim2.fromScale(0.7, 0.6),
				BackgroundTransparency = 1,
				[fusion.Children] = {
					Scope:New("UIStroke")({ Thickness = 3 }),
					Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
					Scope:New("UIAspectRatioConstraint")({ AspectRatio = 2 }),
				},
			}),
		},
	})
end
