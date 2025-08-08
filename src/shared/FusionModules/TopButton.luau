local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)
local ImageIds = require(ReplicatedStorage.Shared.Modules.ImageIds)

return function(Scope: fusion.Scope<typeof(fusion)>)
	local Size = Scope:Value(UDim2.fromScale(0.3, 0.8))

	return Scope:New("Frame")({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.7),
		Size = Scope:Spring(Size, 20),
		BackgroundTransparency = 0.3,
		ClipsDescendants = true,
		[fusion.Children] = {
			Scope:New("UIStroke")({ Thickness = 3 }),
			Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
			Scope:New("ImageLabel")({
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				Image = ImageIds.Studs,
				BackgroundTransparency = 0.6,
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.fromOffset(50, 50),
			}),
			--Scope:New("UIAspectRatioConstraint")({ AspectRatio = 2 }),
			Scope:New("TextButton")({
				Name = "Button",
				Text = "PlaceHolder",
				Font = Enum.Font.FredokaOne,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.9, 0.9),
				BackgroundTransparency = 1,
				[fusion.Children] = {
					Scope:New("UIStroke")({ Thickness = 2 }),
					Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
				},
				[fusion.OnEvent("MouseEnter")] = function()
					Size:set(UDim2.fromScale(0.35, 0.9))
				end,
				[fusion.OnEvent("MouseLeave")] = function()
					Size:set(UDim2.fromScale(0.3, 0.8))
				end,
				[fusion.OnEvent("MouseButton1Down")] = function()
					Size:set(UDim2.fromScale(0.3, 0.8))
				end,
				[fusion.OnEvent("MouseButton1Up")] = function()
					Size:set(UDim2.fromScale(0.35, 0.9))
				end,
			}),
		},
	})
end
