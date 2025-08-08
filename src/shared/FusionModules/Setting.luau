local ExperienceStateRecordingService = game:GetService("ExperienceStateRecordingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local fusion = require(ReplicatedStorage.Packages.fusion)

return function(Scope: fusion.Scope<typeof(fusion)>, Type: string, Props)
	if Type == "Switch" then
		local ButtonSize = Scope:Value(UDim2.fromScale(0.5, 1))
		local SwitchValue = Scope:Value(true)
		return SwitchValue,
			Scope:New("Frame")({
				Name = "Setting",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.7),
				Size = UDim2.fromScale(1, 0.1),
				BackgroundTransparency = 1,
				[fusion.Children] = {
					Scope:New("Frame")({
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.475, 0.5),
						Size = UDim2.fromScale(0.9, 0.9),
						BackgroundColor3 = Color3.fromRGB(58, 60, 85),
						BackgroundTransparency = 0,
						[fusion.Children] = {
							Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
							Scope:New("UIAspectRatioConstraint")({ AspectRatio = 5 }),
							Scope:New("ImageLabel")({
								Name = "Icon",
								AnchorPoint = Vector2.new(0, 0.5),
								Position = UDim2.fromScale(0.02, 0.5),
								Size = UDim2.fromScale(0.3, 0.8),
								BackgroundTransparency = 1,
								[fusion.Children] = {
									Scope:New("UIAspectRatioConstraint")({}),
								},
							}),
							Scope:New("TextLabel")({
								Name = "Value",
								Text = Props.Title or "Placeholder",
								Font = Enum.Font.FredokaOne,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextScaled = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.47, 0.2),
								Size = UDim2.fromScale(0.5, 0.4),
								BackgroundTransparency = 1,
								[fusion.Children] = {
									Scope:New("UIStroke")({ Thickness = 3 }),
									Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
									Scope:New("UIAspectRatioConstraint")({ AspectRatio = 8 }),
								},
							}),
							Scope:New("TextLabel")({
								Name = "Description",
								Text = "Description",
								Font = Enum.Font.FredokaOne,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextScaled = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.47, 0.7),
								Size = UDim2.fromScale(0.5, 0.4),
								BackgroundTransparency = 1,
								[fusion.Children] = {
									Scope:New("UIStroke")({ Thickness = 3 }),
									Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
									Scope:New("UIAspectRatioConstraint")({ AspectRatio = 8 }),
								},
							}),

							Scope:New("Frame")({
								Name = "Switch",
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.872, 0.5),
								Size = UDim2.fromScale(0.2, 0.5),
								BackgroundColor3 = Color3.new(1, 1, 1),
								BackgroundTransparency = 0.7,
								[fusion.Children] = {
									Scope:New("TextButton")({
										Name = "Switch",
										Font = Enum.Font.FredokaOne,
										Text = Scope:Computed(function(use)
											return use(SwitchValue) and "ON" or "OFF"
										end),
										Size = Scope:Spring(ButtonSize, 50),
										AnchorPoint = Scope:Spring(
											Scope:Computed(function(use)
												return use(SwitchValue) and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
											end),
											50
										),
										Position = Scope:Spring(
											Scope:Computed(function(use)
												return use(SwitchValue) and UDim2.fromScale(1, 0.5)
													or UDim2.fromScale(0, 0.5)
											end),
											50
										),
										BackgroundColor3 = Scope:Computed(function(use)
											return use(SwitchValue) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
										end),
										[fusion.Children] = {
											Scope:New("UICorner")({ CornerRadius = UDim.new(0.4, 0) }),
										},
										[fusion.OnEvent("MouseEnter")] = function()
											ButtonSize:set(UDim2.fromScale(0.55, 1.1))
										end,
										[fusion.OnEvent("MouseLeave")] = function()
											ButtonSize:set(UDim2.fromScale(0.5, 1))
										end,
										[fusion.OnEvent("MouseButton1Click")] = function()
											SwitchValue:set(not fusion.peek(SwitchValue))
										end,
									}),
									Scope:New("UICorner")({ CornerRadius = UDim.new(0.4, 0) }),
								},
							}),
							Scope:New("UIStroke")({ Thickness = 3 }),
						},
					}),
				},
			})
	elseif Type == "Slider" then
		local ButtonSize = Scope:Value(UDim2.fromScale(1, 3))
		local SwitchValue = Scope:Value(false)
		local mousePos = Scope:Value(UserInputService:GetMouseLocation())
		local Frame = Scope:Value(Instance.new("Frame"))
		local SettingsValue = Scope:Value(1)

		Scope:Observer(mousePos):onBind(function()
			if not fusion.peek(Frame).Parent then
				return UDim2.fromScale(1, 0.5)
			end
			local Pos = (fusion.peek(mousePos) - fusion.peek(Frame).Frame.Slider.AbsolutePosition.X)
				/ fusion.peek(Frame).Frame.Slider.AbsoluteSize.X

			if fusion.peek(SwitchValue) then
				SettingsValue:set(math.clamp(Pos, 0, 1))
			end
			return
		end)

		table.insert(
			Scope,
			UserInputService.InputChanged:Connect(function(inputObject)
				if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
					mousePos:set(UserInputService:GetMouseLocation().X)
				end
			end)
		)
		table.insert(
			Scope,
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					SwitchValue:set(false)
				end
			end)
		)

		return SettingsValue,
			Frame:set(Scope:New("Frame")({
				Name = "Setting",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.7),
				Size = UDim2.fromScale(1, 0.1),
				BackgroundTransparency = 1,
				[fusion.Children] = {
					Scope:New("Frame")({
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.475, 0.5),
						Size = UDim2.fromScale(0.9, 0.9),
						BackgroundColor3 = Color3.fromRGB(58, 60, 85),
						BackgroundTransparency = 0,
						[fusion.Children] = {
							Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
							Scope:New("UIAspectRatioConstraint")({ AspectRatio = 5 }),
							Scope:New("ImageLabel")({
								Name = "Icon",
								AnchorPoint = Vector2.new(0, 0.5),
								Position = UDim2.fromScale(0.02, 0.5),
								Size = UDim2.fromScale(0.3, 0.8),
								BackgroundTransparency = 1,
								[fusion.Children] = {
									Scope:New("UIAspectRatioConstraint")({}),
								},
							}),
							Scope:New("TextLabel")({
								Name = "Value",
								Text = Props.Title or "Placeholder",
								Font = Enum.Font.FredokaOne,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextScaled = true,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.65, 0.25),
								Size = UDim2.fromScale(0.5, 0.4),
								BackgroundTransparency = 1,
								[fusion.Children] = {
									Scope:New("UIStroke")({ Thickness = 3 }),
									Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
									Scope:New("UIAspectRatioConstraint")({ AspectRatio = 8 }),
								},
							}),

							Scope:New("Frame")({
								Name = "Slider",
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.65, 0.75),
								Size = UDim2.fromScale(0.5, 0.1),
								BackgroundColor3 = Color3.new(1, 1, 1),
								BackgroundTransparency = 0.7,
								[fusion.Children] = {
									Scope:New("TextButton")({
										Name = "Switch",
										Font = Enum.Font.FredokaOne,
										Text = "",
										Size = Scope:Spring(ButtonSize, 50),
										AnchorPoint = Vector2.new(0.5, 0.5),
										Position = Scope:Computed(function(use)
											return UDim2.fromScale(use(SettingsValue), 0.5)
										end),
										BackgroundColor3 = Color3.new(0.533333, 0.533333, 0.533333),
										[fusion.Children] = {
											Scope:New("UICorner")({ CornerRadius = UDim.new(0.4, 0) }),
											Scope:New("UIAspectRatioConstraint")({}),
										},
										[fusion.OnEvent("MouseEnter")] = function()
											ButtonSize:set(UDim2.fromScale(1, 4))
										end,
										[fusion.OnEvent("MouseLeave")] = function()
											ButtonSize:set(UDim2.fromScale(1, 3))
										end,
										[fusion.OnEvent("MouseButton1Down")] = function()
											SwitchValue:set(true)
										end,
										[fusion.OnEvent("MouseButton1Up")] = function()
											SwitchValue:set(false)
										end,
									}),
									Scope:New("UICorner")({ CornerRadius = UDim.new(0.4, 0) }),
								},
							}),
							Scope:New("UIStroke")({ Thickness = 3 }),
						},
					}),
				},
			}))
	end
end
