local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fusion = require(ReplicatedStorage.Packages.fusion)
local ImageIds = require(ReplicatedStorage.Shared.Modules.ImageIds)

return function(Scope: fusion.Scope<typeof(fusion)>, Name, GamePass, Image, BGColor)
	local Size = Scope:Value(UDim2.fromScale(0.5, 0.49))
	return Scope:New("Frame")({
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = Scope:Spring(Size, 30),
		[fusion.Children] = {
			Scope:New("UICorner")({
				CornerRadius = UDim.new(0.1, 0),
			}),
			Scope:New("CanvasGroup")({
				ClipsDescendants = true,
				Size = UDim2.fromScale(0.93, 0.93),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				[fusion.Children] = {
					Scope:New("ImageButton")({
						Name = "Button",
						Size = UDim2.fromScale(1.5, 1.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.25, 0.5),
						Image = ImageIds.GamePassBG,
						ImageColor3 = BGColor,
						[fusion.OnEvent("MouseEnter")] = function()
							Size:set(UDim2.fromScale(0.53, 0.52))
						end,
						[fusion.OnEvent("MouseLeave")] = function()
							Size:set(UDim2.fromScale(0.5, 0.49))
						end,
						[fusion.OnEvent("MouseButton1Click")] = function()
							MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, GamePass)
						end,
					}),
					Scope:New("UIStroke")({ Thickness = 3 }),
					Scope:New("UICorner")({
						CornerRadius = UDim.new(0.1, 0),
					}),
				},
			}),

			Scope:New("ImageLabel")({
				Size = UDim2.fromScale(0.35, 0.9),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.25, 0.5),
				BackgroundTransparency = 1,
				Image = Image,
				[fusion.Children] = {
					Scope:New("UIAspectRatioConstraint")({}),
				},
			}),
			Scope:New("TextLabel")({
				Name = "PassName",
				Size = UDim2.fromScale(0.3, 0.9),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.67, 0.3),
				BackgroundTransparency = 1,
				Text = Name,
				TextScaled = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.FredokaOne,
				[fusion.Children] = {
					Scope:New("UIStroke")({ Thickness = 2, Color = Color3.fromRGB(0, 0, 0) }),
				},
			}),
			Scope:New("TextButton")({
				Name = "PassName",
				Size = UDim2.fromScale(0.4, 0.7),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.67, 0.7),
				BackgroundTransparency = 1,
				Text = "\u{E002} "
					.. MarketplaceService:GetProductInfo(GamePass, Enum.InfoType.GamePass).PriceInRobux,
				TextScaled = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.FredokaOne,
				[fusion.Children] = {
					Scope:New("UIStroke")({ Thickness = 2, Color = Color3.fromRGB(0, 0, 0) }),
					Scope:New("UICorner")({ CornerRadius = UDim.new(0.1, 0) }),
				},
			}),
		},
	})
end
