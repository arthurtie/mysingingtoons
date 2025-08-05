local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CloseButton = require(script.Parent.CloseButton)
local fusion = require(ReplicatedStorage.Packages.fusion)

return function(Scope: fusion.Scope<typeof(fusion)>)
	return Scope:New("Frame")({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(240, 240, 240),
		Size = UDim2.fromScale(0.5, 0.5),
		[fusion.Children] = {
			CloseButton(Scope),
			Scope:New("UICorner")({
				CornerRadius = UDim.new(0.05, 0),
			}),
			Scope:New("UIStroke")({
				Thickness = 5,
				Color = Color3.fromRGB(0, 0, 0),
			}),
			Scope:New("UIAspectRatioConstraint")({ AspectRatio = 1.5 }),
		},
	})
end
