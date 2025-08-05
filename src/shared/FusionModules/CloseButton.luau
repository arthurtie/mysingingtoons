local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fusion = require(ReplicatedStorage.Packages.fusion)

return function(Scope: fusion.Scope<typeof(fusion)>)
	local Size = Scope:Value(UDim2.fromScale(0.12, 0.12))
	return Scope:New("TextButton")({
		Name = "Close",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(1, 0),
		Text = "X",
		Font = Enum.Font.FredokaOne,
		BackgroundColor3 = Color3.fromRGB(255, 0, 0),
		TextColor3 = Color3.new(1, 1, 1),
		Size = Scope:Tween(Size, TweenInfo.new(0.1)),
		TextScaled = true,
		[fusion.OnEvent("MouseEnter")] = function()
			Size:set(UDim2.fromScale(0.15, 0.15))
		end,
		[fusion.OnEvent("MouseLeave")] = function()
			Size:set(UDim2.fromScale(0.12, 0.12))
		end,
		[fusion.OnEvent("MouseButton1Down")] = function()
			Size:set(UDim2.fromScale(0.08, 0.08))
		end,
		[fusion.OnEvent("MouseButton1Up")] = function()
			Size:set(UDim2.fromScale(0.15, 0.15))
		end,
		[fusion.Children] = {
			Scope:New("UICorner")({
				CornerRadius = UDim.new(0.2, 0),
			}),
			Scope:New("UIStroke")({
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 5,
				Color = Color3.fromRGB(155, 0, 0),
			}),
			Scope:New("UIAspectRatioConstraint")({}),
		},
	})
end
