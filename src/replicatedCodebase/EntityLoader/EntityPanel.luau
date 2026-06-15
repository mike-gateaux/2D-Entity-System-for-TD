local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactFont = require(ReplicatedStorage.Replicated.ReactFont)
local ReactReferences = require(ReplicatedStorage.Replicated.ReactReferences)
local Packets = require(ReplicatedStorage.Shared.Packets)

local createElement = React.createElement

return function()
	return createElement(React.Fragment, nil, {
		Render = createElement("Frame", {
			Size = UDim2.fromOffset(512, 512),
			Position = UDim2.new(0.5, 165, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(15, 17, 24),
		}, {
			Visual = createElement("ImageLabel", {
				ref = function(visualInstance)
					ReactReferences:setRef("entityPanelVisual", visualInstance)
				end,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
			}),
			UIScale = createElement("UIScale", {
				Scale = 0.75,
			}),
			UICorner = createElement("UICorner", {
				CornerRadius = UDim.new(0, 5),
			}),
			UIShadow = createElement("UIShadow", {
				BlurRadius = UDim.new(0, 5),
			}),
			UIStroke = createElement("UIStroke", {
				Color = Color3.new(0, 1, 0),
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}, {
				UIGradient = createElement("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(0.425, 0.425, 0.425)),
						ColorSequenceKeypoint.new(0.25, Color3.new(0.425, 0.425, 0.425)),
						ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
						ColorSequenceKeypoint.new(0.75, Color3.new(0.425, 0.425, 0.425)),
						ColorSequenceKeypoint.new(1, Color3.new(0.425, 0.425, 0.425)),
					}),
				}),
			}),
		}),
		Spawner = createElement("Frame", {
			Size = UDim2.fromOffset(220, 130),
			Position = UDim2.new(0.5, -165, 0.5, -25),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(24, 27, 38),
		}, {
			UICorner = createElement("UICorner", {
				CornerRadius = UDim.new(0, 5),
			}),
			UIShadow = createElement("UIShadow", {
				BlurRadius = UDim.new(0, 5),
			}),
			UIStroke = createElement("UIStroke", {
				Color = Color3.new(0, 1, 0),
			}, {
				UIGradient = createElement("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(0.5, 0.5, 0.5)),
						ColorSequenceKeypoint.new(0.35, Color3.new(0.5, 0.5, 0.5)),
						ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
						ColorSequenceKeypoint.new(0.65, Color3.new(0.5, 0.5, 0.5)),
						ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5)),
					}),
				}),
			}),
			Title = createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				Text = "Dispatcher",
			}),
			Amount = createElement("TextBox", {
				Size = UDim2.new(1, -20, 0, 35),
				Position = UDim2.new(0, 10, 1, -55),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Color3.fromRGB(230, 255, 213),
				BackgroundTransparency = 0.875,
				PlaceholderColor3 = Color3.fromRGB(154, 153, 153),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.Nunito,
				TextSize = 15,
				PlaceholderText = "Amount",
				Text = "",
				ClearTextOnFocus = true,
				ref = function(amountInstance)
					ReactReferences:setRef("entityPanelAmount", amountInstance)
				end,
			}, {
				UICorner = createElement("UICorner", {
					CornerRadius = UDim.new(0, 5),
				}),
				UIShadow = createElement("UIShadow", {
					BlurRadius = UDim.new(0, 5),
				}),
				UIStroke = createElement("UIStroke", {
					Color = Color3.new(0, 1, 0),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}, {
					UIGradient = createElement("UIGradient", {
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.new(0.575, 0.575, 0.575)),
							ColorSequenceKeypoint.new(0.35, Color3.new(0.575, 0.575, 0.575)),
							ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
							ColorSequenceKeypoint.new(0.65, Color3.new(0.575, 0.575, 0.575)),
							ColorSequenceKeypoint.new(1, Color3.new(0.575, 0.575, 0.575)),
						}),
					}),
				}),
			}),
			Activate = createElement("TextButton", {
				Size = UDim2.new(1, -20, 0, 35),
				Position = UDim2.new(0, 10, 1, -10),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Color3.new(0, 1, 0),
				BackgroundTransparency = 0.575,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				FontFace = Font.new(ReactFont("Nunito"), Enum.FontWeight.Bold),
				TextSize = 20,
				Text = "Spawn",
				[React.Event.Activated] = function()
					Packets.SpawnRequest:Fire({
						amount = ReactReferences:getRef("entityPanelAmount", function(amount)
							return tonumber(amount.Text)
						end) or 01,
						speed = 50,
						perSecond = 4096,
					})
				end,
			}, {
				UICorner = createElement("UICorner", {
					CornerRadius = UDim.new(0, 5),
				}),
				UIShadow = createElement("UIShadow", {
					BlurRadius = UDim.new(0, 5),
				}),
				UIStroke = createElement("UIStroke", {
					Color = Color3.new(0, 1, 0),
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				}, {
					UIGradient = createElement("UIGradient", {
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.new(0.575, 0.575, 0.575)),
							ColorSequenceKeypoint.new(0.35, Color3.new(0.575, 0.575, 0.575)),
							ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
							ColorSequenceKeypoint.new(0.65, Color3.new(0.575, 0.575, 0.575)),
							ColorSequenceKeypoint.new(1, Color3.new(0.575, 0.575, 0.575)),
						}),
					}),
				}),
			}),
		}),
		Statistics = createElement("Frame", {
			Size = UDim2.fromOffset(220, 45),
			Position = UDim2.new(0.5, -165, 0.5, 70),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(24, 27, 38),
		}, {
			UICorner = createElement("UICorner", {
				CornerRadius = UDim.new(0, 5),
			}),
			UIShadow = createElement("UIShadow", {
				BlurRadius = UDim.new(0, 5),
			}),
			UIStroke = createElement("UIStroke", {
				Color = Color3.new(0, 1, 0),
			}, {
				UIGradient = createElement("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(0.5, 0.5, 0.5)),
						ColorSequenceKeypoint.new(0.35, Color3.new(0.5, 0.5, 0.5)),
						ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
						ColorSequenceKeypoint.new(0.65, Color3.new(0.5, 0.5, 0.5)),
						ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5)),
					}),
				}),
			}),
			Information = createElement("TextLabel", {
				Size = UDim2.new(1, -20, 1, 0),
				Position = UDim2.fromOffset(10, 0),
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(230, 230, 240),
				Font = Enum.Font.Nunito,
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Center,
				Text = "FPS: ??\nEnemies: ???",
				ref = function(statsInstance)
					ReactReferences:setRef("entityPanelStatTr", statsInstance)
				end,
			}),
		}),
	})
end
