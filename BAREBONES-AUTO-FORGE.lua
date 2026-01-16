-- THIS IS BAREBONES SO EXPECT SHIT TO NOT BE PERFECT
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Controllers = ReplicatedStorage:WaitForChild("Controllers", 30)
local ForgeController = Controllers:WaitForChild("ForgeController", 30)
local MeltMini = ForgeController:WaitForChild("MeltMinigame", 30)
local PourMini = ForgeController:WaitForChild("PourMinigame", 30)
local HammerMini = ForgeController:WaitForChild("HammerMinigame", 30)

local Debris = workspace:WaitForChild("Debris", 30)

-- Initialized Modules
local InitMelt = require(MeltMini)
local InitPour = require(PourMini)
local InitHammer = require(HammerMini)

-- Variables
local OldMelt
local OldPour
local OldHammer

-- Replacements
-- Replacement functions for hooks

local MiniReplacement = function()
	return workspace:GetServerTimeNow()
end

local NoteReplacement = function(...)
	local args = {...}
	local data = args[2]
  -- i suck at making things perfect so pray that you'll get a 100% masterwork
	local pp = workspace:GetServerTimeNow() + data.Lifetime * 25 / 44

	task.wait(math.max(pp - workspace:GetServerTimeNow(), 0))
	
	return true
end

-- Init
OldMelt = hookfunction(rawget(InitMelt, "Start"), MiniReplacement)
OldPour = hookfunction(rawget(InitPour, "Start"), MiniReplacement)
OldNote = hookfunction(rawget(InitHammer, "CreateNote"), NoteReplacement)


Debris.ChildAdded:Connect(function(instance)
	if instance.Name == "Mold" then
		local clicker = instance:FindFirstChildOfClass("ClickDetector")
		if not clicker then return end
		repeat
			task.wait(1/8) -- 8 Hz gaming XDDDDD
			fireclickdetector(clicker)
		until not instance:IsDescendantOf(workspace)
	end
end)

