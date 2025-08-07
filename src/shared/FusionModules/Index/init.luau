local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CloseButton = require(script.Parent.CloseButton)
local Template = require(script.Template)
local fusion = require(ReplicatedStorage.Packages.fusion)
local Settings = require(ReplicatedStorage.Shared.Modules.Settings)

return function(Scope: fusion.Scope<typeof(fusion)>)
	local ChildrenTable = {}
	for _, v in Settings.Character do
		local Frame = Template(Scope, v.id)
		ChildrenTable[v.id] = Frame
	end
	local Visible = Scope:Value(false)
	return {
		Visible = Visible,
		Frames = ChildrenTable,
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
							Text = "Index",
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
						ChildrenTable,
						Scope:New("UIGridLayout")({
							HorizontalAlignment = "Left",
							CellPadding = UDim2.fromScale(0.022, 0.02),
							CellSize = UDim2.fromScale(0.24, 0.17),
						}),
					},
				}),
				CloseButton(Scope, Visible),

				Scope:New("UIAspectRatioConstraint")({ AspectRatio = 1.4 }),
			},
		}),
	},
		ChildrenTable
end
