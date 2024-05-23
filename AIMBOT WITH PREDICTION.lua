--// Preventing Multiple Processes

pcall(function()
	getgenv().Aimbot.Functions:Exit()
end)

--// Environment

getgenv().Aimbot = {}
local Environment = getgenv().Aimbot

--// Services

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera

--// Variables

local LocalPlayer = Players.LocalPlayer
local Title = "MODIFIED AIMBOT|BRICKMANE"
local FileNames = {"Aimbot", "Configuration.json", "Drawing.json"}
local Typing, Running, Animation, RequiredDistance, ServiceConnections = false, false, nil, 2000, {}

--// Support Functions

local mousemoverel = mousemoverel or (Input and Input.MouseMove)
local queueonteleport = queue_on_teleport or syn.queue_on_teleport

--// Script Settings

Environment.Settings = {
	SendNotifications = true,
	SaveSettings = true, -- Re-execute upon changing
	ReloadOnTeleport = false,
	Enabled = true,
	TeamCheck = false,
	AliveCheck = true,
	WallCheck = false, -- Laggy
	Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
	ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
	ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
	TriggerKey = "MouseButton2",
	Toggle = false,
	LockPart = "Head" -- Body part to lock on
}

Environment.FOVSettings = {
	Enabled = true,
	Visible = true,
	Amount = 480,
	Color = "255, 255, 255",
	LockedColor = "255, 70, 70",
	Transparency = 0.5,
	Sides = 60,
	Thickness = 1,
	Filled = false
}

Environment.FOVCircle = Drawing.new("Circle")
Environment.Locked = nil

--// Core Functions

local function Encode(Table)
	if Table and type(Table) == "table" then
		local EncodedTable = HttpService:JSONEncode(Table)

		return EncodedTable
	end
end

local function Decode(String)
	if String and type(String) == "string" then
		local DecodedTable = HttpService:JSONDecode(String)

		return DecodedTable
	end
end

local function GetColor(Color)
	local R = tonumber(string.match(Color, "([%d]+)[%s]*,[%s]*[%d]+[%s]*,[%s]*[%d]+"))
	local G = tonumber(string.match(Color, "[%d]+[%s]*,[%s]*([%d]+)[%s]*,[%s]*[%d]+"))
	local B = tonumber(string.match(Color, "[%d]+[%s]*,[%s]*[%d]+[%s]*,[%s]*([%d]+)"))

	return Color3.fromRGB(R, G, B)
end

local function SendNotification(TitleArg, DescriptionArg, DurationArg)
	if Environment.Settings.SendNotifications then
		StarterGui:SetCore("SendNotification", {
			Title = TitleArg,
			Text = DescriptionArg,
			Duration = DurationArg
		})
	end
end

--// Functions

local function SaveSettings()
	if Environment.Settings.SaveSettings then
		if isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
			writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
		end

		if isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
			writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.FOVSettings))
		end
	end
end

local function GetClosestPlayer()
	if not Environment.Locked then
		if Environment.FOVSettings.Enabled then
			RequiredDistance = Environment.FOVSettings.Amount
		else
			RequiredDistance = 2000
		end

		for _, v in next, Players:GetPlayers() do
			if v ~= LocalPlayer then
				if v.Character and v.Character:FindFirstChild(Environment.Settings.LockPart) and v.Character:FindFirstChildOfClass("Humanoid") then
					if Environment.Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
					if Environment.Settings.AliveCheck and v.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
					if Environment.Settings.WallCheck and #(Camera:GetPartsObscuringTarget({v.Character[Environment.Settings.LockPart].Position}, v.Character:GetDescendants())) > 0 then continue end

					local Vector, OnScreen = Camera:WorldToViewportPoint(v.Character[Environment.Settings.LockPart].Position)
					local Distance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude

					if Distance < RequiredDistance and OnScreen then
						RequiredDistance = Distance
						Environment.Locked = v
					end
				end
			end
		end
	elseif (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).X, Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).Y)).Magnitude > RequiredDistance then
		Environment.Locked = nil
		Animation:Cancel()
		Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
	end
end

--// Typing Check

ServiceConnections.TypingStartedConnection = UserInputService.TextBoxFocused:Connect(function()
	Typing = true
end)

ServiceConnections.TypingEndedConnection = UserInputService.TextBoxFocusReleased:Connect(function()
	Typing = false
end)

--// Create, Save & Load Settings

if Environment.Settings.SaveSettings then
	if not isfolder(Title) then
		makefolder(Title)
	end

	if not isfolder(Title.."/"..FileNames[1]) then
		makefolder(Title.."/"..FileNames[1])
	end

	if not isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
		writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
	else
		Environment.Settings = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[2]))
	end

	if not isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
		writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.FOVSettings))
	else
		Environment.Visuals = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[3]))
	end

	coroutine.wrap(function()
		while wait(10) and Environment.Settings.SaveSettings do
			SaveSettings()
		end
	end)()
else
	if isfolder(Title) then
		delfolder(Title)
	end
end

local CHEAT_CLIENT = {} do
	do
		CHEAT_CLIENT.player = game.Players.LocalPlayer
		CHEAT_CLIENT.camera = game.Workspace.CurrentCamera
		CHEAT_CLIENT.mouse = CHEAT_CLIENT.player:GetMouse()
	end
 
	do
		function CHEAT_CLIENT:get_target()
			local current_target = nil
			local maximum_distance = math.huge
	
			for i,v in pairs(game.Players:GetPlayers()) do
				if v == game.Players.LocalPlayer then continue end
				if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
					local position, on_screen = CHEAT_CLIENT.camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
					if not on_screen then continue end
					local distance = (Vector2.new(position.X, position.Y - game.GuiService:GetGuiInset(game.GuiService).Y) - Vector2.new(CHEAT_CLIENT.mouse.X, CHEAT_CLIENT.mouse.Y)).Magnitude
					if distance > maximum_distance then continue end
					current_target = v
					maximum_distance = distance
				end
			end
	
			return current_target
		end
	
		function CHEAT_CLIENT:predict_velocity(target_part, projectile_speed)
				local velocity = target_part.Velocity
	
				local distance = (CHEAT_CLIENT.camera.CFrame.p - target_part.CFrame.p).Magnitude
				local time_to_hit = (distance / projectile_speed)
	
				local predicted_position = target_part.CFrame.p + (velocity * time_to_hit)
				local delta = (predicted_position - target_part.CFrame.p).Magnitude
	
				local final_projectile_speed = projectile_speed - 0.013 * projectile_speed ^ 2 * time_to_hit ^ 2
	
				time_to_hit += (delta / final_projectile_speed)
	
				return target_part.CFrame.p + (velocity * time_to_hit)
		end
	
		function CHEAT_CLIENT:predict_drop(target_part, projectile_speed, projectile_drop)
				local distance = (CHEAT_CLIENT.camera.CFrame.p - target_part.CFrame.p).Magnitude
				local time_to_hit = (distance / projectile_speed)
	
				local final_projectile_speed = projectile_speed - 0.013 * projectile_speed ^ 2 * time_to_hit ^ 2
				time_to_hit += (distance / final_projectile_speed)
	
				local drop_timing = projectile_drop * time_to_hit ^ 2
	
				if not tostring(drop_timing):find("nan") then
					return drop_timing
				end
				return 0
		end
	
		function CHEAT_CLIENT:get_bullet_atributes()
			local attribute_value = nil
			local status = game.ReplicatedStorage.Players[CHEAT_CLIENT.player.Name]:FindFirstChild("Status")
			if status then
				local equipped_tool = status.GameplayVariables.EquippedTool.Value
				if equipped_tool then
					local inventory_equipped_tool = game.ReplicatedStorage.Players[CHEAT_CLIENT.player.Name].Inventory:FindFirstChild(tostring(equipped_tool))
					if inventory_equipped_tool then
						local mag = inventory_equipped_tool.Attachments:FindFirstChild("Magazine") and inventory_equipped_tool.Attachments:FindFirstChild("Magazine"):FindFirstChildOfClass("StringValue") and inventory_equipped_tool.Attachments:FindFirstChild("Magazine"):FindFirstChildOfClass("StringValue"):FindFirstChild("ItemProperties").LoadedAmmo or inventory_equipped_tool.ItemProperties:FindFirstChild("LoadedAmmo")
						if mag then
							local first_bullet_type = mag:FindFirstChild("1")
							if first_bullet_type then
								attribute_value = game.ReplicatedStorage.AmmoTypes[first_bullet_type:GetAttribute("AmmoType")]:GetAttributes()
							end
						end
					end
				end
			end
			return attribute_value
		end

		function CHEAT_CLIENT:get_bullet_atribute(attribute)
			local attribute_value = nil
			local status = game.ReplicatedStorage.Players[CHEAT_CLIENT.player.Name]:FindFirstChild("Status")
			if status then
				local equipped_tool = status.GameplayVariables.EquippedTool.Value
				if equipped_tool then
					local inventory_equipped_tool = game.ReplicatedStorage.Players[CHEAT_CLIENT.player.Name].Inventory:FindFirstChild(tostring(equipped_tool))
					if inventory_equipped_tool then
						local mag = inventory_equipped_tool.Attachments:FindFirstChild("Magazine") and inventory_equipped_tool.Attachments:FindFirstChild("Magazine"):FindFirstChildOfClass("StringValue") and inventory_equipped_tool.Attachments:FindFirstChild("Magazine"):FindFirstChildOfClass("StringValue"):FindFirstChild("ItemProperties").LoadedAmmo or inventory_equipped_tool.ItemProperties:FindFirstChild("LoadedAmmo")
						if mag then
							local first_bullet_type = mag:FindFirstChild("1")
							if first_bullet_type then
								attribute_value = game.ReplicatedStorage.AmmoTypes[first_bullet_type:GetAttribute("AmmoType")]:GetAttribute(attribute)
							end
						end
					end
				end
			end
			return attribute_value
		end

		function CHEAT_CLIENT:set_bullet_atribute(attribute, val)
			local attribute_value = nil
			local status = game.ReplicatedStorage.Players[CHEAT_CLIENT.player.Name]:FindFirstChild("Status")
			if status then
				local equipped_tool = status.GameplayVariables.EquippedTool.Value
				if equipped_tool then
					local inventory_equipped_tool = game.ReplicatedStorage.Players[CHEAT_CLIENT.player.Name].Inventory:FindFirstChild(tostring(equipped_tool))
					if inventory_equipped_tool then
						local mag = inventory_equipped_tool.Attachments:FindFirstChild("Magazine") and inventory_equipped_tool.Attachments:FindFirstChild("Magazine"):FindFirstChildOfClass("StringValue") and inventory_equipped_tool.Attachments:FindFirstChild("Magazine"):FindFirstChildOfClass("StringValue"):FindFirstChild("ItemProperties").LoadedAmmo or inventory_equipped_tool.ItemProperties:FindFirstChild("LoadedAmmo")
						if mag then
							for _,bbbbb in next, mag:GetChildren() do
								attribute_value = game.ReplicatedStorage.AmmoTypes[bbbbb:GetAttribute("AmmoType")]:SetAttribute(attribute, val)
							end
						end
					end
				end
			end
			return attribute_value
		end
	end
 end

 coroutine.wrap(function()
	while task.wait(1) do
		CHEAT_CLIENT:set_bullet_atribute('RecoilStrength', 0)
		CHEAT_CLIENT:set_bullet_atribute('ProjectileDrop', 0)
	end
end)()

local function Load()
	ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
		if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
			Environment.FOVCircle.Radius = Environment.FOVSettings.Amount
			Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness
			Environment.FOVCircle.Filled = Environment.FOVSettings.Filled
			Environment.FOVCircle.NumSides = Environment.FOVSettings.Sides
			Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
			Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency
			Environment.FOVCircle.Visible = Environment.FOVSettings.Visible
			Environment.FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
		else
			Environment.FOVCircle.Visible = false
		end

		if Running and Environment.Settings.Enabled then
			GetClosestPlayer()

			if Environment.Settings.ThirdPerson then
				Environment.Settings.ThirdPersonSensitivity = math.clamp(Environment.Settings.ThirdPersonSensitivity, 0.1, 5)

				local Vector = Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position)
				mousemoverel((Vector.X - UserInputService:GetMouseLocation().X) * Environment.Settings.ThirdPersonSensitivity, (Vector.Y - UserInputService:GetMouseLocation().Y) * Environment.Settings.ThirdPersonSensitivity)
			else

				local attribute_velocity = CHEAT_CLIENT:get_bullet_atribute("MuzzleVelocity")
     			local attribute_drop = CHEAT_CLIENT:get_bullet_atribute("ProjectileDrop")
       			local target_part = Environment.Locked and Environment.Locked.Character:FindFirstChild(Environment.Settings.LockPart)

				if attribute_velocity and attribute_drop and target_part then
					if Environment.Settings.Sensitivity > 0 then
						Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position,  CHEAT_CLIENT:predict_velocity(target_part, attribute_velocity) + Vector3.new(0, CHEAT_CLIENT:predict_drop(target_part, attribute_velocity, attribute_drop), 0))})
						Animation:Play()
					else
						Camera.CFrame = CFrame.new(Camera.CFrame.Position,  CHEAT_CLIENT:predict_velocity(target_part, attribute_velocity) + Vector3.new(0, CHEAT_CLIENT:predict_drop(target_part, attribute_velocity, attribute_drop), 0))
					end
				end
			end

			Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.LockedColor)
		end
	end)

	ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
		if not Typing then
			pcall(function()
				if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
					if Environment.Settings.Toggle then
						Running = not Running

						if not Running then
							Environment.Locked = nil
							Animation:Cancel()
							Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
						end
					else
						Running = true
					end
				end
			end)

			pcall(function()
				if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
					if Environment.Settings.Toggle then
						Running = not Running

						if not Running then
							Environment.Locked = nil
							Animation:Cancel()
							Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
						end
					else
						Running = true
					end
				end
			end)
		end
	end)

	ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
		if not Typing then
			pcall(function()
				if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
					if not Environment.Settings.Toggle then
						Running = false
						Environment.Locked = nil
						Animation:Cancel()
						Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
					end
				end
			end)

			pcall(function()
				if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
					if not Environment.Settings.Toggle then
						Running = false
						Environment.Locked = nil
						Animation:Cancel()
						Environment.FOVCircle.Color = GetColor(Environment.FOVSettings.Color)
					end
				end
			end)
		end
	end)
end

--// Functions

Environment.Functions = {}

function Environment.Functions:Exit()
	SaveSettings()

	for _, v in next, ServiceConnections do
		v:Disconnect()
	end

	if Environment.FOVCircle.Remove then Environment.FOVCircle:Remove() end

	getgenv().Aimbot.Functions = nil
	getgenv().Aimbot = nil
end

function Environment.Functions:Restart()
	SaveSettings()

	for _, v in next, ServiceConnections do
		v:Disconnect()
	end

	Load()
end

function Environment.Functions:ResetSettings()
	Environment.Settings = {
		SendNotifications = true,
		SaveSettings = true, -- Re-execute upon changing
		ReloadOnTeleport = true,
		Enabled = true,
		TeamCheck = false,
		AliveCheck = true,
		WallCheck = false,
		Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
		ThirdPerson = false,
		ThirdPersonSensitivity = 3,
		TriggerKey = "MouseButton2",
		Toggle = false,
		LockPart = "Head" -- Body part to lock on
	}

	Environment.FOVSettings = {
		Enabled = true,
		Visible = true,
		Amount = 90,
		Color = "255, 255, 255",
		LockedColor = "255, 70, 70",
		Transparency = 0.5,
		Sides = 60,
		Thickness = 1,
		Filled = false
	}
end

--// Support Check

if not Drawing or not getgenv then
	SendNotification(Title, "Your exploit does not support this script", 3); return
end

--// Reload On Teleport

if Environment.Settings.ReloadOnTeleport then
	if queueonteleport then
		queueonteleport(game:HttpGet("https://raw.githubusercontent.com/RelkzzRebranded/agogogogos/main/AIMBOT%20WITH%20PREDICTION.lua"))
	else
		SendNotification(Title, "Your exploit does not support queueonteleport")
	end
end

--// Load

Load(); SendNotification(Title, "Aimbot script successfully loaded!", 5)
