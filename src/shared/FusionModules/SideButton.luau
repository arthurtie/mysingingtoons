local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)

return function(Scope: fusion.Scope<typeof(fusion)>)
	local Size = Scope:Value(UDim2.fromScale(0.9, 0.3))

	return Scope:New("Frame")({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = Scope:Spring(Size, 20),
		BackgroundColor3 = Color3.new(0.258824, 0.258824, 0.258824),
		BackgroundTransparency = 0.3,
		[fusion.Children] = {
			Scope:New("UIStroke")({ Thickness = 3 }),
			Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
			Scope:New("UIAspectRatioConstraint")({ AspectRatio = 1 }),
			Scope:New("ImageLabel")({
				Name = "Icon",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.4),
				Size = UDim2.fromScale(0.7, 0.7),
				BackgroundTransparency = 1,
			}),
			Scope:New("ImageButton")({
				Name = "Button",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				[fusion.OnEvent("MouseEnter")] = function()
					Size:set(UDim2.fromScale(0.95, 0.33))
				end,
				[fusion.OnEvent("MouseLeave")] = function()
					Size:set(UDim2.fromScale(0.9, 0.3))
				end,
				[fusion.OnEvent("MouseButton1Down")] = function()
					Size:set(UDim2.fromScale(0.9, 0.3))
				end,
				[fusion.OnEvent("MouseButton1Up")] = function()
					Size:set(UDim2.fromScale(0.95, 0.33))
				end,
			}),
			Scope:New("TextButton")({
				Name = "ButtonName",
				Text = "PlaceHolder",
				Font = Enum.Font.FredokaOne,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.85),
				Size = UDim2.fromScale(0.9, 0.25),
				BackgroundTransparency = 1,
				[fusion.Children] = {
					Scope:New("UIStroke")({ Thickness = 2 }),
					Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
				},
			}),
		},
	})
end
