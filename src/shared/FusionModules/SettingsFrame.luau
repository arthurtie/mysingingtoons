local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CloseButton = require(script.Parent.CloseButton)
local fusion = require(ReplicatedStorage.Packages.fusion)

return function(Scope: fusion.Scope<typeof(fusion)>)
	local Visible = Scope:Value(false)
	return {
		Visible = Visible,
		Frame = Scope:New("Frame")({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = Scope:Spring(Scope:Computed(function(use)
				return use(Visible) and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.5, 1.5)
			end)),
			BackgroundColor3 = Color3.fromRGB(58, 60, 85),
			BackgroundTransparency = 0.3,
			Size = Scope:Spring(Scope:Computed(function(use)
				return use(Visible) and UDim2.fromScale(0.6, 0.5) or UDim2.fromScale(0, 0)
			end)),
			Name = "Settings",
			[fusion.Children] = {

				Scope:New("UICorner")({
					CornerRadius = UDim.new(0.05, 0),
				}),

				Scope:New("Frame")({
					Position = UDim2.fromScale(0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					Size = UDim2.fromScale(1, 0.2),
					BackgroundColor3 = Color3.fromRGB(58, 60, 85),
					BackgroundTransparency = 0.3,
					Name = "Bar",
					[fusion.Children] = {
						Scope:New("UICorner")({
							CornerRadius = UDim.new(0.2, 0),
						}),
						Scope:New("TextLabel")({
							Text = "Settings",
							TextScaled = true,
							TextColor3 = Color3.new(1, 1, 1),
							Font = Enum.Font.FredokaOne,
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.fromScale(0.5, 0.8),
							BackgroundTransparency = 1,
							[fusion.Children] = {
								Scope:New("UIStroke")({
									Thickness = 5,
									Color = Color3.fromRGB(32, 33, 46),
								}),
							},
						}),
					},
				}),
				Scope:New("UIStroke")({
					Thickness = 5,
					Color = Color3.fromRGB(32, 33, 46),
				}),
				Scope:New("ScrollingFrame")({
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, 0.6),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromScale(0.95, 0.8),
					Name = "Settings",
					[fusion.Children] = {
						Scope:New("UIListLayout")({
							FillDirection = "Vertical",
							HorizontalAlignment = "Center",
							--Padding = UDim.new(0.03, 0),
						}),
					},
				}),
				CloseButton(Scope, Visible),

				Scope:New("UIAspectRatioConstraint")({ AspectRatio = 0.85 }),
			},
		}),
	}
end
