local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GamePass = require(script.GamePass)
local CloseButton = require(script.Parent.CloseButton)
local fusion = require(ReplicatedStorage.Packages.fusion)
local ImageIds = require(ReplicatedStorage.Shared.Modules.ImageIds)
local Settings = require(ReplicatedStorage.Shared.Modules.Settings)

return function(Scope: fusion.Scope<typeof(fusion)>)
	local Visible = Scope:Value(false)
	return {
		Visible = Visible,
		Frame = Scope:New("Frame")({
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = Scope:Spring(Scope:Computed(function(use)
				return use(Visible) and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0.5, 1.5)
			end)),
			BackgroundColor3 = Color3.fromRGB(109, 138, 177),
			BackgroundTransparency = 0.4,
			Size = Scope:Spring(Scope:Computed(function(use)
				return use(Visible) and UDim2.fromScale(0.8, 0.65) or UDim2.fromScale(0, 0)
			end)),
			Name = "Settings",
			[fusion.Children] = {

				Scope:New("UICorner")({
					CornerRadius = UDim.new(0.02, 0),
				}),

				Scope:New("Frame")({
					Position = UDim2.fromScale(0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					Size = UDim2.fromScale(1, 0.2),
					BackgroundColor3 = Color3.fromRGB(109, 138, 177),
					BackgroundTransparency = 0.5,
					Name = "Bar",
					[fusion.Children] = {
						Scope:New("UICorner")({
							CornerRadius = UDim.new(0.15, 0),
						}),
						Scope:New("TextLabel")({
							Text = "Shop",
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
						Scope:New("Frame")({
							Size = UDim2.fromScale(1, 0.4),
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Name = "GamePasses",
							[fusion.Children] = {
								Scope:New("TextLabel")({
									Text = "GamePasses",
									TextScaled = true,
									TextColor3 = Color3.new(1, 1, 1),
									Font = Enum.Font.FredokaOne,
									Name = "ProductName",
									BackgroundTransparency = 1,
									Size = UDim2.fromScale(1, 0.2),
									[fusion.Children] = {

										Scope:New("UIStroke")({
											Thickness = 4,
										}),
									},
								}),
								Scope:New("Frame")({
									Size = UDim2.fromScale(0.85, 0.7),
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.fromScale(0.5, 0.6),
									ClipsDescendants = false,
									BackgroundTransparency = 1,
									[fusion.Children] = {
										Scope:Hydrate(
											GamePass(
												Scope,
												"VIP!",
												Settings.Robux.GamePass.VIP,
												ImageIds.GamePassVIP,
												Color3.fromRGB(255, 217, 0)
											)
										)({ Position = UDim2.fromScale(0.76, 0.77) }),
										Scope:Hydrate(
											GamePass(
												Scope,
												"2XCash",
												Settings.Robux.GamePass.Cash,
												ImageIds.GamePassCash,
												Color3.fromRGB(44, 190, 25)
											)
										)({ Position = UDim2.fromScale(0.24, 0.23) }),
										Scope:Hydrate(
											GamePass(
												Scope,
												"Lucky!",
												Settings.Robux.GamePass.Luck,
												ImageIds.GamePassLuck,
												Color3.fromRGB(77, 255, 122)
											)
										)({ Position = UDim2.fromScale(0.76, 0.23) }),
										Scope:Hydrate(
											GamePass(
												Scope,
												"Size!",
												Settings.Robux.GamePass.Size,
												ImageIds.GamePassSize,
												Color3.fromRGB(17, 239, 255)
											)
										)({ Position = UDim2.fromScale(0.24, 0.77) }),
									},
								}),
							},
						}),
						Scope:New("UIListLayout")({
							FillDirection = "Vertical",
							HorizontalAlignment = "Center",
							--Padding = UDim.new(0.03, 0),
						}),
					},
				}),
				CloseButton(Scope, Visible),

				Scope:New("UIAspectRatioConstraint")({ AspectRatio = 1.4 }),
			},
		}),
	}
end
