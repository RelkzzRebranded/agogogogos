local G2L = {}


--[[
    Instances:
--]]
G2L["0"] = Instance.new("ScreenGui")
G2L["1"] = Instance.new("Frame")
G2L["2"] = Instance.new("UICorner")
G2L["3"] = Instance.new("TextLabel")
G2L["4"] = Instance.new("UITextSizeConstraint")
G2L["5"] = Instance.new("TextLabel")
G2L["6"] = Instance.new("UITextSizeConstraint")
G2L["7"] = Instance.new("UIAspectRatioConstraint")



--[[
    Properties:
--]]
G2L["0"].Name = [[InventoryViewerGUI]]
G2L["0"].Enabled = true
G2L["0"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
G2L["0"].Parent = game.Players.LocalPlayer.PlayerGui

G2L["1"].Name = [[MainFrame]]
G2L["1"].Active = false
G2L["1"].AnchorPoint = Vector2.new(0, 0)
G2L["1"].BackgroundColor3 = Color3.fromRGB(49.000004, 49.000004, 49.000004)
G2L["1"].BackgroundTransparency = 0.8
G2L["1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["1"].BorderSizePixel = 0
G2L["1"].ClipsDescendants = false
G2L["1"].Draggable = false
G2L["1"].Position = UDim2.new(0.010560989, 0, 0.10067936, 0)
G2L["1"].Rotation = 0
G2L["1"].Selectable = false
G2L["1"].SelectionOrder = 0
G2L["1"].Size = UDim2.new(0.17903277, 0, 0.8200124, 0)
G2L["1"].Visible = true
G2L["1"].ZIndex = 5
G2L["1"].Parent = G2L["0"]

G2L["2"].Name = [[UICorner]]
G2L["2"].CornerRadius = UDim.new(0, 10)
G2L["2"].Parent = G2L["1"]

G2L["3"].Name = [[VictimName]]
G2L["3"].FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G2L["3"].Text = [[RandomMansName]]
G2L["3"].TextColor3 = Color3.fromRGB(255, 255, 255)
G2L["3"].TextScaled = true
G2L["3"].TextSize = 14
G2L["3"].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
G2L["3"].TextStrokeTransparency = 0
G2L["3"].TextWrapped = true
G2L["3"].TextXAlignment = Enum.TextXAlignment.Center
G2L["3"].TextYAlignment = Enum.TextYAlignment.Center
G2L["3"].Active = false
G2L["3"].AnchorPoint = Vector2.new(0, 0)
G2L["3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["3"].BackgroundTransparency = 1
G2L["3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["3"].BorderSizePixel = 0
G2L["3"].ClipsDescendants = false
G2L["3"].Draggable = false
G2L["3"].Position = UDim2.new(0, 0, 0, 0)
G2L["3"].Rotation = 0
G2L["3"].Selectable = false
G2L["3"].SelectionOrder = 0
G2L["3"].Size = UDim2.new(1, 0, 0.05, 0)
G2L["3"].Visible = true
G2L["3"].ZIndex = 1
G2L["3"].Parent = G2L["1"]

G2L["4"].Name = [[UITextSizeConstraint]]
G2L["4"].MaxTextSize = 44
G2L["4"].Parent = G2L["3"]

G2L["5"].Name = [[List]]
G2L["5"].FontFace = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G2L["5"].Text = [[INVENTORY: {}]]
G2L["5"].TextColor3 = Color3.fromRGB(255, 255, 255)
G2L["5"].TextScaled = true
G2L["5"].TextSize = 30
G2L["5"].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
G2L["5"].TextStrokeTransparency = 0
G2L["5"].TextWrapped = true
G2L["5"].TextXAlignment = Enum.TextXAlignment.Center
G2L["5"].TextYAlignment = Enum.TextYAlignment.Top
G2L["5"].Active = false
G2L["5"].AnchorPoint = Vector2.new(0, 0)
G2L["5"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G2L["5"].BackgroundTransparency = 1
G2L["5"].BorderColor3 = Color3.fromRGB(0, 0, 0)
G2L["5"].BorderSizePixel = 0
G2L["5"].ClipsDescendants = false
G2L["5"].Draggable = false
G2L["5"].Position = UDim2.new(0, 0, 0.1, 0)
G2L["5"].Rotation = 0
G2L["5"].Selectable = false
G2L["5"].SelectionOrder = 0
G2L["5"].Size = UDim2.new(1, 0, 0.9, 0)
G2L["5"].Visible = true
G2L["5"].ZIndex = 1
G2L["5"].Parent = G2L["1"]

G2L["6"].Name = [[UITextSizeConstraint]]
G2L["6"].MaxTextSize = 30
G2L["6"].Parent = G2L["5"]

G2L["7"].Name = [[UIAspectRatioConstraint]]
G2L["7"].AspectRatio = 1.7810761
G2L["7"].Parent = G2L["0"]

return G2L["0"]
-- wtf HUH?
