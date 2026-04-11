local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/repo/main/lib.lua"))()

local Window = Library:CreateWindow("SUPREMACY")
local Aimbot = Window:CreateTab("aimbot")
local AntiAim = Window:CreateTab("anti-aim")
local Players = Window:CreateTab("players")
local Visuals = Window:CreateTab("visuals")
local Movement = Window:CreateTab("movement")
local Skins = Window:CreateTab("skins")
local Misc = Window:CreateTab("misc")
local Config = Window:CreateTab("config")

-- Aimbot Tab
local AimbotMain = Aimbot:CreateSector("main", "left")
AimbotMain:CreateToggle("enabled aimbot", false, "aimbot_enabled")
AimbotMain:CreateKeybind("aimbot key", Enum.KeyCode.V, "aimbot_key")
AimbotMain:CreateCombo("target part", {"head", "torso", "legs"}, "head", "aimbot_target")
AimbotMain:CreateSlider("head hitbox scale", 0, 100, 75, "%", "aimbot_scale")

-- Players Tab (Boxes Sector)
local Boxes = Players:CreateSector("boxes", "left")
Boxes:CreateDropdown("boxes", {"enemy", "friendly"}, {"enemy", "friendly"}, "players_boxes")
Boxes:CreateColorpicker("box enemy color", Color3.fromRGB(180, 220, 80), "players_enemy_color")
Boxes:CreateColorpicker("box friendly color", Color3.fromRGB(220, 180, 60), "players_friendly_color")

-- Config Tab
local ConfigMain = Config:CreateSector("configs", "left")
local SelectedConfig = ""

local List
local NameBox

List = ConfigMain:CreateCombo("config list", Library:GetConfigs(), "", nil, function(v)
	SelectedConfig = v
	NameBox:Set(v)
end)

NameBox = ConfigMain:CreateTextbox("config name", "", nil, function(v)
	SelectedConfig = v
end)

ConfigMain:CreateButton("save config", function()
	if SelectedConfig ~= "" then
		Library:SaveConfig(SelectedConfig)
		Library:Notify("saved " .. SelectedConfig)
		List:SetOptions(Library:GetConfigs())
	end
end)

ConfigMain:CreateButton("load config", function()
	if SelectedConfig ~= "" then
		Library:LoadConfig(SelectedConfig)
		Library:Notify("loaded " .. SelectedConfig)
	end
end)

ConfigMain:CreateButton("refresh configs", function()
	List:SetOptions(Library:GetConfigs())
	Library:Notify("refreshed configs")
end)

ConfigMain:CreateButton("delete config", function()
	if SelectedConfig ~= "" then
		Library:DeleteConfig(SelectedConfig)
		Library:Notify("deleted " .. SelectedConfig)
		List:SetOptions(Library:GetConfigs())
	end
end)

ConfigMain:CreateButton("unload menu", function()
	Library.GUI:Destroy()
end)
