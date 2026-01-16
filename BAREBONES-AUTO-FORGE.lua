-- THIS IS BAREBONES SO EXPECT SHIT TO NOT BE PERFECT
local Player = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Controllers = ReplicatedStorage:WaitForChild("Controllers", 30)
local ForgeController = Controllers:WaitForChild("ForgeController", 30)
local MeltMini = ForgeController:WaitForChild("MeltMinigame", 30)
local PourMini = ForgeController:WaitForChild("PourMinigame", 30)

local LocalPlayer = Player.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local ForgeApp = PlayerGui:WaitForChild("Forge", 30)
local HammerMiniLayout = ForgeApp:WaitForChild("HammerMinigame", 30) 
local Debris = workspace:WaitForChild("Debris", 30)

-- Initialized Modules
local InitMelt = require(MeltMini)
local InitPour = require(PourMini)

-- Variables
local OldMelt
local OldPour

-- Replacements
-- Replacement functions for hooks

local MiniReplacement = function(...)
	return workspace:GetServerTimeNow()
end

-- Math 
local function nearlyEqual(a, b, tolerance)
	return math.abs(a - b) <= tolerance
end

local function UDimNearlyEqual(a, b, tolerance)
	return nearlyEqual(a.Scale, b.Scale, tolerance)
end

local function UDim2NearlyEqual(a, b, tolerance)
	return UDimNearlyEqual(a.X, b.X, tolerance)
		and UDimNearlyEqual(a.Y, b.Y, tolerance)
end

-- Manager

-- get it? because the minigame is basically osu itself
local OSUManager = {
	Buttons = {}
}

function OSUManager:Add(button)
	if button:IsA("TextButton") then
		table.insert(self.Buttons, button)
	end
end

function OSUManager:Remove(button)
	local t = self.Buttons
	for i = 1, #t do
		if t[i] == button then
			t[i] = t[#t]
			t[#t] = nil
			break
		end
	end
end

function OSUManager:Pulse()
	local validButtons = {}
	local tIdx = 0

	for i = 1, #self.Buttons do
        local t = self.Buttons[i]
        if t.Parent == HammerMiniLayout then
            tIdx = tIdx + 1
            validButtons[tIdx] = t
        end
    end
	local clicked = {}
	for i = 1, tIdx do
		local main = validButtons[i]
		local frame = main.Frame
		local circle = frame.Circle
		if not clicked[main] and (circle.Size.X.Scale <= frame.Size.X.Scale and circle.Size.Y.Scale <= frame.Size.Y.Scale) then
			firesignal(main.MouseButton1Click)
			clicked[main] = true
		end
	end
end

-- Init
OldMelt = hookfunction(rawget(InitMelt, "Start"), MiniReplacement)
OldPour = hookfunction(rawget(InitPour, "Start"), MiniReplacement)

HammerMiniLayout.ChildAdded:Connect(function(inst)
	OSUManager:Add(inst)
end)

HammerMiniLayout.ChildRemoved:Connect(function(inst)
	if inst:IsA("TextButton") then
		OSUManager:Remove(inst)
	end
end)

Debris.ChildAdded:Connect(function(instance)
	if instance.Name == "Mold" and instance:IsA("Model") then
		local clicker = instance:FindFirstChildOfClass("ClickDetector")
		while clicker.Parent do
			task.wait(0.05)
			fireclickdetector(clicker)
		end
	end
end)

local last = 0
RunService.RenderStepped:Connect(function()
	if tick() - last < 1/24 then return end
	last = tick()
	OSUManager:Pulse()
end)

