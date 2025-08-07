local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fusion = require(ReplicatedStorage.Packages.fusion)

return function(Scope, id)
	local Clone = ReplicatedStorage.Assets.Characters:FindFirstChild(id)
	if not Clone then
		return
	end
	Clone = Clone:Clone()
	Clone:PivotTo(CFrame.new(0, 0, 0))
	local _, Size = Clone:GetBoundingBox()
	local Camera = Scope:New("Camera")({
		CFrame = CFrame.new(Vector3.new(Size.X * 1.2, math.max(Size.Y * 1.2, 2), 0), Vector3.new(0, 0, 0)),
	})
	return Scope:New("Frame")({
		BackgroundTransparency = 1,
		[fusion.Children] = {
			Scope:New("Frame")({
				Size = UDim2.fromScale(0.9, 0.9),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 0.7,
				[fusion.Children] = {
					Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
					Scope:New("UIStroke")({ Thickness = 4 }),
				},
			}),
			Scope:New("TextLabel")({
				Size = UDim2.fromScale(0.32, 0.32),
				Position = UDim2.fromScale(0.7, 0.78),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Text = "$?/s",
				TextScaled = true,
				Font = Enum.Font.FredokaOne,
			}),
			Scope:New("ViewportFrame")({
				Name = "CartoonImage",
				Size = UDim2.fromScale(0.8, 0.8),
				Position = UDim2.fromScale(0.5, 0.45),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 1,
				CurrentCamera = Camera,
				[fusion.Children] = {
					Clone,
					Camera,
				},
			}),
		},
	})
end
