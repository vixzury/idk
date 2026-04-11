local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

local Library = {
	ToggleKey = Enum.KeyCode.RightShift,
	CanDrag = true,
	Accent = Color3.fromRGB(220, 25, 25),
	Dark = Color3.fromRGB(12, 12, 12),
	OpenPopups = {},
	Flags = {},
	Registry = {}
}

local HttpService = game:GetService("HttpService")
if not isfolder("Supremacy") then makefolder("Supremacy") end
if not isfolder("Supremacy/Configs") then makefolder("Supremacy/Configs") end

function Library:SaveConfig(name)
	local str = HttpService:JSONEncode(Library.Flags)
	writefile("Supremacy/Configs/" .. name .. ".json", str)
end

function Library:LoadConfig(name)
	if isfile("Supremacy/Configs/" .. name .. ".json") then
		local status, data = pcall(function() return HttpService:JSONDecode(readfile("Supremacy/Configs/" .. name .. ".json")) end)
		if status and data then
			for i, v in pairs(data) do
				if Library.Registry[i] then
					Library.Registry[i](v)
				end
			end
		end
	end
end

function Library:DeleteConfig(name)
	if isfile("Supremacy/Configs/" .. name .. ".json") then
		delfile("Supremacy/Configs/" .. name .. ".json")
	end
end

function Library:GetConfigs()
	local configs = {}
	if isfolder("Supremacy/Configs") then
		for _, v in pairs(listfiles("Supremacy/Configs")) do
			local name = v:match("([^\\/]+)%..+$") or v:match("([^\\/]+)$") or v
			name = name:gsub("%.json", "")
			table.insert(configs, name)
		end
	end
	return configs
end

function Library:Notify(text)
	local NotifyFrame = Instance.new("Frame")
	NotifyFrame.Size = UDim2.fromOffset(200, 30)
	NotifyFrame.Position = UDim2.new(1, 10, 1, -40)
	NotifyFrame.BackgroundColor3 = Library.Dark
	NotifyFrame.BorderSizePixel = 1
	NotifyFrame.Parent = Library.GUI
	local NotifyStroke = Instance.new("UIStroke")
	NotifyStroke.Color = Library.Accent
	NotifyStroke.Parent = NotifyFrame
	local NotifyLabel = Instance.new("TextLabel")
	NotifyLabel.Size = UDim2.new(1, 0, 1, 0)
	NotifyLabel.BackgroundTransparency = 1
	NotifyLabel.Text = text:lower()
	NotifyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	NotifyLabel.Font = Enum.Font.Code
	NotifyLabel.TextSize = 13
	NotifyLabel.Parent = NotifyFrame

	NotifyFrame:TweenPosition(UDim2.new(1, -210, 1, -40), "Out", "Quad", 0.3, true)
	task.delay(3, function()
		NotifyFrame:TweenPosition(UDim2.new(1, 10, 1, -40), "In", "Quad", 0.3, true, function()
			NotifyFrame:Destroy()
		end)
	end)
end

function Library:ClosePopups()
	for _, v in pairs(Library.OpenPopups) do
		v.Visible = false
	end
	Library.OpenPopups = {}
end

function Library:CreateWindow(name)
	local GUI = Instance.new("ScreenGui")
	GUI.Name = "Supremacy_Final_" .. math.random(1, 1000)
	GUI.ResetOnSpawn = false
	GUI.Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or CoreGui)
	Library.GUI = GUI

	local MainOutline = Instance.new("Frame")
	MainOutline.Name = "MainOutline"
	MainOutline.Size = UDim2.fromOffset(500, 600)
	MainOutline.Position = UDim2.new(0.5, -250, 0.5, -300)
	MainOutline.BackgroundColor3 = Library.Dark
	MainOutline.BorderSizePixel = 0
	MainOutline.Parent = GUI

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Color3.fromRGB(40, 40, 40)
	MainStroke.Thickness = 1
	MainStroke.Parent = MainOutline

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 25)
	TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	TopBar.BorderSizePixel = 0
	TopBar.Parent = MainOutline

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -10, 1, 0)
	Title.Position = UDim2.fromOffset(10, 0)
	Title.BackgroundTransparency = 1
	Title.Text = name:lower()
	Title.TextColor3 = Color3.fromRGB(200, 200, 200)
	Title.Font = Enum.Font.Code
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TopBar

	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, -20, 1, -55)
	Container.Position = UDim2.fromOffset(10, 45)
	Container.BackgroundTransparency = 1
	Container.Parent = MainOutline

	local TabBar = Instance.new("Frame")
	TabBar.Size = UDim2.new(1, 0, 0, 20)
	TabBar.Position = UDim2.fromOffset(0, 25)
	TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	TabBar.BorderSizePixel = 0
	TabBar.Parent = MainOutline

	local TabList = Instance.new("UIListLayout")
	TabList.FillDirection = Enum.FillDirection.Horizontal
	TabList.SortOrder = Enum.SortOrder.LayoutOrder
	TabList.Parent = TabBar

	local Overlay = Instance.new("Frame")
	Overlay.Name = "Overlay"
	Overlay.Size = UDim2.new(1, 0, 1, 0)
	Overlay.BackgroundTransparency = 1
	Overlay.ZIndex = 1000
	Overlay.Parent = MainOutline

	local Window = { Tabs = {}, ActiveTab = nil }

	if Library.CanDrag then
		local dragging, dragInput, dragStart, startPos
		TopBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = MainOutline.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		TopBar.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - dragStart
				MainOutline.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end

	function Window:CreateTab(name)
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(0, 0, 1, 0)
		TabButton.AutomaticSize = Enum.AutomaticSize.X
		TabButton.BackgroundTransparency = 1
		TabButton.Text = "  " .. name:lower() .. "  "
		TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		TabButton.Font = Enum.Font.Code
		TabButton.TextSize = 13
		TabButton.Parent = TabBar

		local TabFrame = Instance.new("Frame")
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.BackgroundTransparency = 1
		TabFrame.Visible = false
		TabFrame.Parent = Container

		local LeftSide = Instance.new("ScrollingFrame")
		LeftSide.Size = UDim2.new(0.5, -5, 1, 0)
		LeftSide.BackgroundTransparency = 1
		LeftSide.CanvasSize = UDim2.new(0, 0, 0, 0)
		LeftSide.ScrollBarThickness = 0
		LeftSide.Parent = TabFrame
		local LeftList = Instance.new("UIListLayout")
		LeftList.Padding = UDim.new(0, 10)
		LeftList.Parent = LeftSide

		local RightSide = Instance.new("ScrollingFrame")
		RightSide.Size = UDim2.new(0.5, -5, 1, 0)
		RightSide.Position = UDim2.new(0.5, 5, 0, 0)
		RightSide.BackgroundTransparency = 1
		RightSide.CanvasSize = UDim2.new(0, 0, 0, 0)
		RightSide.ScrollBarThickness = 0
		RightSide.Parent = TabFrame
		local RightList = Instance.new("UIListLayout")
		RightList.Padding = UDim.new(0, 10)
		RightList.Parent = RightSide

		local Tab = {}
		function Tab:CreateSector(name, side)
			local SectorFrame = Instance.new("Frame")
			SectorFrame.Size = UDim2.new(1, 0, 0, 0)
			SectorFrame.AutomaticSize = Enum.AutomaticSize.Y
			SectorFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			SectorFrame.BorderSizePixel = 0
			SectorFrame.Parent = (side == "left" and LeftSide or RightSide)
			local SectorStroke = Instance.new("UIStroke")
			SectorStroke.Color = Color3.fromRGB(35, 35, 35)
			SectorStroke.Parent = SectorFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -10, 0, 20)
			Label.Position = UDim2.fromOffset(10, -10)
			Label.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			Label.Text = " " .. name:lower() .. " "
			Label.TextColor3 = Color3.fromRGB(200, 200, 200)
			Label.Font = Enum.Font.Code
			Label.TextSize = 13
			Label.AutomaticSize = Enum.AutomaticSize.X
			Label.Parent = SectorFrame

			local Content = Instance.new("Frame")
			Content.Size = UDim2.new(1, -20, 0, 0)
			Content.Position = UDim2.fromOffset(10, 15)
			Content.AutomaticSize = Enum.AutomaticSize.Y
			Content.BackgroundTransparency = 1
			Content.Parent = SectorFrame
			local ContentLayout = Instance.new("UIListLayout")
			ContentLayout.Padding = UDim.new(0, 8)
			ContentLayout.Parent = Content
			local BottomPadding = Instance.new("UIPadding")
			BottomPadding.PaddingBottom = UDim.new(0, 10)
			BottomPadding.Parent = Content

			local Sector = {}

			function Sector:CreateToggle(name, default, flag, callback)
				local Toggle = Instance.new("TextButton")
				Toggle.Size = UDim2.new(1, 0, 0, 15)
				Toggle.BackgroundTransparency = 1
				Toggle.Text = ""
				Toggle.Parent = Content

				local Box = Instance.new("Frame")
				Box.Size = UDim2.fromOffset(10, 10)
				Box.Position = UDim2.new(0, 0, 0.5, -5)
				Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Box.BorderSizePixel = 1
				Box.Parent = Toggle
				local BoxStroke = Instance.new("UIStroke")
				BoxStroke.Color = Color3.fromRGB(50, 50, 50)
				BoxStroke.Parent = Box

				local Inner = Instance.new("Frame")
				Inner.Size = UDim2.new(1, -2, 1, -2)
				Inner.Position = UDim2.fromOffset(1, 1)
				Inner.BackgroundColor3 = Library.Accent
				Inner.BorderSizePixel = 0
				Inner.Visible = default or false
				Inner.Parent = Box

				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, -20, 1, 0)
				Label.Position = UDim2.fromOffset(20, 0)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Toggle

				local enabled = default or false
				if flag then Library.Flags[flag] = enabled end

				local function set(v)
					enabled = v
					Inner.Visible = enabled
					if flag then Library.Flags[flag] = enabled end
					if callback then callback(enabled) end
				end

				Toggle.MouseButton1Click:Connect(function()
					set(not enabled)
				end)

				if flag then Library.Registry[flag] = set end
			end

			function Sector:CreateCombo(name, list, default, flag, callback)
				local Combo = Instance.new("Frame")
				Combo.Size = UDim2.new(1, 0, 0, 32)
				Combo.BackgroundTransparency = 1
				Combo.Parent = Content
				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, 0, 0, 13)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Combo
				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(1, 0, 0, 16)
				Button.Position = UDim2.fromOffset(0, 15)
				Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Button.BorderSizePixel = 0
				Button.Text = "  " .. tostring(default or "none"):lower()
				Button.TextColor3 = Color3.fromRGB(200, 200, 200)
				Button.Font = Enum.Font.Code
				Button.TextSize = 12
				Button.TextXAlignment = Enum.TextXAlignment.Left
				Button.Parent = Combo
				local Arrow = Instance.new("TextLabel")
				Arrow.Size = UDim2.fromOffset(16, 16)
				Arrow.Position = UDim2.new(1, -16, 0, 0)
				Arrow.BackgroundTransparency = 1
				Arrow.Text = "\226\150\188"
				Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
				Arrow.TextSize = 8
				Arrow.Parent = Button
				local ListFrame = Instance.new("Frame")
				ListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				ListFrame.BorderSizePixel = 1
				ListFrame.Visible = false
				ListFrame.ZIndex = 1200
				ListFrame.Parent = Overlay
				local ListLayout = Instance.new("UIListLayout")
				ListLayout.Parent = ListFrame
				local Selected = default
				if flag then Library.Flags[flag] = Selected end

				local function updateVisuals()
					Button.Text = "  " .. tostring(Selected):lower()
					for _, it in pairs(ListFrame:GetChildren()) do
						if it:IsA("TextButton") then it.TextColor3 = (it.Text:find(tostring(Selected):lower()) and Library.Accent or Color3.fromRGB(180, 180, 180)) end
					end
				end

				local function set(v)
					Selected = v
					updateVisuals()
					if flag then Library.Flags[flag] = Selected end
					if callback then callback(v) end
				end

				local DropdownObj = {}
				function DropdownObj:SetOptions(newlist)
					list = newlist
					for _, v in pairs(ListFrame:GetChildren()) do
						if v:IsA("TextButton") then v:Destroy() end
					end
					for _, v in pairs(list) do
						local Item = Instance.new("TextButton")
						Item.Size = UDim2.new(1, 0, 0, 18)
						Item.BackgroundTransparency = 1
						Item.Text = "  " .. v:lower()
						Item.TextColor3 = (tostring(Selected):lower() == v:lower()) and Library.Accent or Color3.fromRGB(180, 180, 180)
						Item.Font = Enum.Font.Code
						Item.TextSize = 12
						Item.TextXAlignment = Enum.TextXAlignment.Left
						Item.ZIndex = 1201
						Item.Parent = ListFrame
						Item.MouseButton1Click:Connect(function()
							set(v)
							ListFrame.Visible = false
						end)
					end
				end

				DropdownObj:SetOptions(list)

				Button.MouseButton1Click:Connect(function()
					if ListFrame.Visible then ListFrame.Visible = false else
						Library:ClosePopups()
						ListFrame.Position = UDim2.fromOffset(Button.AbsolutePosition.X, Button.AbsolutePosition.Y + Button.AbsoluteSize.Y + 1)
						ListFrame.Size = UDim2.fromOffset(Button.AbsoluteSize.X, math.min(#list * 18, 200))
						ListFrame.Visible = true
						table.insert(Library.OpenPopups, ListFrame)
					end
				end)

				if flag then Library.Registry[flag] = set end
				return DropdownObj
			end

			function Sector:CreateKeybind(name, default, flag, callback)
				local Keybind = Instance.new("Frame")
				Keybind.Size = UDim2.new(1, 0, 0, 15)
				Keybind.BackgroundTransparency = 1
				Keybind.Parent = Content
				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, 0, 1, 0)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Keybind
				local BindButton = Instance.new("TextButton")
				BindButton.Size = UDim2.new(0, 0, 1, 0)
				BindButton.AutomaticSize = Enum.AutomaticSize.X
				BindButton.Position = UDim2.new(1, 0, 0, 0)
				BindButton.AnchorPoint = Vector2.new(1, 0)
				BindButton.BackgroundTransparency = 1
				local currentKey = default
				local currentMode = "Toggle"
				if flag then Library.Flags[flag] = {Key = currentKey and currentKey.Name or "NONE", Mode = currentMode} end

				BindButton.Text = "[" .. (currentKey and currentKey.Name:gsub("MouseButton", "MB") or "NONE") .. "]"
				BindButton.TextColor3 = Color3.fromRGB(120, 120, 120)
				BindButton.Font = Enum.Font.Code
				BindButton.TextSize = 12
				BindButton.TextXAlignment = Enum.TextXAlignment.Right
				BindButton.Parent = Keybind

				local ModeFrame = Instance.new("Frame")
				ModeFrame.Size = UDim2.fromOffset(60, 54)
				ModeFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				ModeFrame.BorderSizePixel = 1
				ModeFrame.Visible = false
				ModeFrame.ZIndex = 1300
				ModeFrame.Parent = Overlay
				local ModeLayout = Instance.new("UIListLayout")
				ModeLayout.Parent = ModeFrame

				local function updateFlag()
					if flag then Library.Flags[flag] = {Key = currentKey and currentKey.Name or "NONE", Mode = currentMode} end
					if callback then callback({Key = currentKey, Mode = currentMode}) end
				end

				local function setMode(m)
					currentMode = m
					ModeFrame.Visible = false
					updateFlag()
					for _, b in pairs(ModeFrame:GetChildren()) do
						if b:IsA("TextButton") then b.TextColor3 = (b.Text:lower() == m:lower() and Library.Accent or Color3.fromRGB(180, 180, 180)) end
					end
				end

				for _, m in pairs({"Always", "Toggle", "Hold"}) do
					local b = Instance.new("TextButton")
					b.Size = UDim2.new(1, 0, 0, 18)
					b.BackgroundTransparency = 1
					b.Text = m
					b.TextColor3 = (m == currentMode and Library.Accent or Color3.fromRGB(180, 180, 180))
					b.Font = Enum.Font.Code
					b.TextSize = 12
					b.ZIndex = 1301
					b.Parent = ModeFrame
					b.MouseButton1Click:Connect(function() setMode(m) end)
				end

				local listening = false
				BindButton.MouseButton1Click:Connect(function()
					listening = true
					BindButton.Text = "[...]"
				end)

				BindButton.MouseButton2Click:Connect(function()
					Library:ClosePopups()
					ModeFrame.Position = UDim2.fromOffset(BindButton.AbsolutePosition.X - 65, BindButton.AbsolutePosition.Y)
					ModeFrame.Visible = true
					table.insert(Library.OpenPopups, ModeFrame)
				end)

				UserInputService.InputBegan:Connect(function(input)
					if listening then
						if input.UserInputType == Enum.UserInputType.Keyboard then
							if input.KeyCode == Enum.KeyCode.Escape then
								currentKey = nil
								listening = false
							elseif input.KeyCode ~= Library.ToggleKey then
								currentKey = input.KeyCode
								listening = false
							end
						elseif input.UserInputType:IsA("UserInputType") and input.UserInputType.Name:find("MouseButton") then
							currentKey = input.UserInputType
							listening = false
						end
						if not listening then
							BindButton.Text = "[" .. (currentKey and currentKey.Name:gsub("MouseButton", "MB") or "NONE") .. "]"
							updateFlag()
						end
					end
				end)

				if flag then
					Library.Registry[flag] = function(data)
						if data.Key then
							if data.Key:find("MB") or data.Key:find("MouseButton") then
								currentKey = Enum.UserInputType[data.Key:gsub("MB", "MouseButton")]
							else
								currentKey = Enum.KeyCode[data.Key]
							end
						end
						currentMode = data.Mode or "Toggle"
						BindButton.Text = "[" .. (currentKey and currentKey.Name:gsub("MouseButton", "MB") or "NONE") .. "]"
						setMode(currentMode)
					end
				end
			end

			function Sector:CreateDropdown(name, list, default, flag, callback)
				local Dropdown = Instance.new("Frame")
				Dropdown.Size = UDim2.new(1, 0, 0, 32)
				Dropdown.BackgroundTransparency = 1
				Dropdown.Parent = Content
				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, 0, 0, 13)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Dropdown
				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(1, 0, 0, 16)
				Button.Position = UDim2.fromOffset(0, 15)
				Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Button.BorderSizePixel = 0
				Button.Text = "  " .. (type(default) == "table" and table.concat(default, ", ") or default or "none")
				Button.TextColor3 = Color3.fromRGB(200, 200, 200)
				Button.Font = Enum.Font.Code
				Button.TextSize = 12
				Button.TextXAlignment = Enum.TextXAlignment.Left
				Button.Parent = Dropdown
				local Arrow = Instance.new("TextLabel")
				Arrow.Size = UDim2.fromOffset(16, 16)
				Arrow.Position = UDim2.new(1, -16, 0, 0)
				Arrow.BackgroundTransparency = 1
				Arrow.Text = "\226\150\188"
				Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
				Arrow.TextSize = 8
				Arrow.Parent = Button
				local ListFrame = Instance.new("Frame")
				ListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				ListFrame.BorderSizePixel = 1
				ListFrame.Visible = false
				ListFrame.ZIndex = 1200
				ListFrame.Parent = Overlay
				local ListLayout = Instance.new("UIListLayout")
				ListLayout.Parent = ListFrame
				local Selected = type(default) == "table" and default or { default }
				if flag then Library.Flags[flag] = Selected end

				local function UpdateLabel()
					if #Selected == 0 then Button.Text = "  none" else Button.Text = "  " .. table.concat(Selected, ", ") end
					if flag then Library.Flags[flag] = Selected end
					if callback then callback(Selected) end
				end
				for _, v in pairs(list) do
					local Item = Instance.new("TextButton")
					Item.Size = UDim2.new(1, 0, 0, 18)
					Item.BackgroundTransparency = 1
					Item.Text = "  " .. v:lower()
					Item.TextColor3 = table.find(Selected, v) and Library.Accent or Color3.fromRGB(180, 180, 180)
					Item.Font = Enum.Font.Code
					Item.TextSize = 12
					Item.TextXAlignment = Enum.TextXAlignment.Left
					Item.ZIndex = 1201
					Item.Parent = ListFrame
					Item.MouseButton1Click:Connect(function()
						local idx = table.find(Selected, v)
						if idx then table.remove(Selected, idx) Item.TextColor3 = Color3.fromRGB(180, 180, 180) else table.insert(Selected, v) Item.TextColor3 = Library.Accent end
						UpdateLabel()
					end)
				end
				Button.MouseButton1Click:Connect(function()
					if ListFrame.Visible then ListFrame.Visible = false else
						Library:ClosePopups()
						ListFrame.Position = UDim2.fromOffset(Button.AbsolutePosition.X, Button.AbsolutePosition.Y + Button.AbsoluteSize.Y + 1)
						local count = #list
						ListFrame.Size = UDim2.fromOffset(Button.AbsoluteSize.X, math.min(count * 18, 200))
						ListFrame.Visible = true
						table.insert(Library.OpenPopups, ListFrame)
					end
				end)

				local DropdownObj = {}
				function DropdownObj:SetOptions(newlist)
					list = newlist
					for _, v in pairs(ListFrame:GetChildren()) do
						if v:IsA("TextButton") then v:Destroy() end
					end
					for _, v in pairs(list) do
						local Item = Instance.new("TextButton")
						Item.Size = UDim2.new(1, 0, 0, 18)
						Item.BackgroundTransparency = 1
						Item.Text = "  " .. v:lower()
						Item.TextColor3 = table.find(Selected, v) and Library.Accent or Color3.fromRGB(180, 180, 180)
						Item.Font = Enum.Font.Code
						Item.TextSize = 12
						Item.TextXAlignment = Enum.TextXAlignment.Left
						Item.ZIndex = 1201
						Item.Parent = ListFrame
						Item.MouseButton1Click:Connect(function()
							local idx = table.find(Selected, v)
							if idx then table.remove(Selected, idx) Item.TextColor3 = Color3.fromRGB(180, 180, 180) else table.insert(Selected, v) Item.TextColor3 = Library.Accent end
							UpdateLabel()
						end)
					end
				end

				if flag then
					Library.Registry[flag] = function(v)
						Selected = v
						DropdownObj:SetOptions(list)
						UpdateLabel()
					end
				end

				return DropdownObj
			end

			function Sector:CreateColorpicker(name, default, flag, callback)
				local Colorpicker = Instance.new("Frame")
				Colorpicker.Size = UDim2.new(1, 0, 0, 12)
				Colorpicker.BackgroundTransparency = 1
				Colorpicker.Parent = Content
				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, -20, 1, 0)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Colorpicker
				local Box = Instance.new("TextButton")
				Box.Size = UDim2.fromOffset(18, 8)
				Box.Position = UDim2.new(1, -18, 0.5, -4)
				Box.BackgroundColor3 = default or Library.Accent
				Box.BorderSizePixel = 1
				Box.Text = ""
				Box.Parent = Colorpicker
				local PickerFrame = Instance.new("Frame")
				PickerFrame.Size = UDim2.fromOffset(160, 190)
				PickerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				PickerFrame.BorderSizePixel = 1
				PickerFrame.Visible = false
				PickerFrame.ZIndex = 1100
				PickerFrame.Parent = Overlay
				local curH, curS, curV = Box.BackgroundColor3:ToHSV()
				if flag then Library.Flags[flag] = {curH, curS, curV} end

				local SVGrid = Instance.new("TextButton")
				SVGrid.Size = UDim2.fromOffset(140, 140)
				SVGrid.Position = UDim2.fromOffset(10, 10)
				SVGrid.BackgroundColor3 = Color3.fromHSV(curH, 1, 1)
				SVGrid.Text = ""
				SVGrid.ZIndex = 1101
				SVGrid.Parent = PickerFrame
				local SVGradient = Instance.new("ImageLabel")
				SVGradient.Size = UDim2.new(1, 0, 1, 0)
				SVGradient.BackgroundTransparency = 1
				SVGradient.Image = "rbxassetid://4155801252"
				SVGradient.ZIndex = 1102
				SVGradient.Parent = SVGrid
				local SVPicker = Instance.new("Frame")
				SVPicker.Size = UDim2.fromOffset(4, 4)
				SVPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SVPicker.Position = UDim2.new(curS, -2, 1 - curV, -2)
				SVPicker.ZIndex = 1103
				SVPicker.Parent = SVGrid
				local HueSlider = Instance.new("TextButton")
				HueSlider.Size = UDim2.fromOffset(140, 15)
				HueSlider.Position = UDim2.fromOffset(10, 160)
				HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				HueSlider.Text = ""
				HueSlider.ZIndex = 1101
				HueSlider.Parent = PickerFrame
				local HueGradient = Instance.new("UIGradient")
				HueGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)), ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16, 1, 1)), ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)), ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66, 1, 1)), ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))})
				HueGradient.Parent = HueSlider
				local function updateColor()
					local color = Color3.fromHSV(curH, curS, curV)
					Box.BackgroundColor3 = color
					SVGrid.BackgroundColor3 = Color3.fromHSV(curH, 1, 1)
					SVPicker.Position = UDim2.new(curS, -2, 1 - curV, -2)
					if flag then Library.Flags[flag] = {curH, curS, curV} end
					if callback then callback(color) end
				end
				SVGrid.MouseButton1Down:Connect(function()
					local connection
					connection = RunService.RenderStepped:Connect(function()
						if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then connection:Disconnect() return end
						local mousePos = UserInputService:GetMouseLocation() - SVGrid.AbsolutePosition - Vector2.new(0, 36)
						curS = math.clamp(mousePos.X / SVGrid.AbsoluteSize.X, 0, 1)
						curV = 1 - math.clamp(mousePos.Y / SVGrid.AbsoluteSize.Y, 0, 1)
						updateColor()
					end)
				end)
				HueSlider.MouseButton1Down:Connect(function()
					local connection
					connection = RunService.RenderStepped:Connect(function()
						if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then connection:Disconnect() return end
						local mousePos = UserInputService:GetMouseLocation() - HueSlider.AbsolutePosition - Vector2.new(0, 36)
						curH = math.clamp(mousePos.X / HueSlider.AbsoluteSize.X, 0, 1)
						updateColor()
					end)
				end)
				Box.MouseButton1Click:Connect(function()
					if PickerFrame.Visible then PickerFrame.Visible = false else
						Library:ClosePopups()
						PickerFrame.Position = UDim2.fromOffset(Box.AbsolutePosition.X - 165, Box.AbsolutePosition.Y)
						PickerFrame.Visible = true
						table.insert(Library.OpenPopups, PickerFrame)
					end
				end)

				if flag then
					Library.Registry[flag] = function(v)
						curH, curS, curV = v[1], v[2], v[3]
						updateColor()
					end
				end
			end

			function Sector:CreateSlider(name, min, max, default, unit, flag, callback)
				local Slider = Instance.new("Frame")
				Slider.Size = UDim2.new(1, 0, 0, 25)
				Slider.BackgroundTransparency = 1
				Slider.Parent = Content

				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, 0, 0, 13)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Slider

				local Tray = Instance.new("TextButton")
				Tray.Size = UDim2.new(1, 0, 0, 10)
				Tray.Position = UDim2.fromOffset(0, 14)
				Tray.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Tray.BorderSizePixel = 0
				Tray.Text = ""
				Tray.AutoButtonColor = false
				Tray.Parent = Slider
				local TrayStroke = Instance.new("UIStroke")
				TrayStroke.Color = Color3.fromRGB(50, 50, 50)
				TrayStroke.Parent = Tray

				local Bar = Instance.new("Frame")
				Bar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
				Bar.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
				Bar.BorderSizePixel = 0
				Bar.Parent = Tray
				local BarGradient = Instance.new("UIGradient")
				BarGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))})
				BarGradient.Rotation = 90
				BarGradient.Parent = Bar

				local ValueLabel = Instance.new("TextLabel")
				ValueLabel.Size = UDim2.new(1, 0, 1, 0)
				ValueLabel.BackgroundTransparency = 1
				ValueLabel.Text = tostring(default) .. (unit or "")
				ValueLabel.TextColor3 = Color3.fromRGB(60, 60, 60)
				ValueLabel.Font = Enum.Font.Code
				ValueLabel.TextSize = 10
				ValueLabel.ZIndex = 3
				ValueLabel.Parent = Tray

				local val = default
				if flag then Library.Flags[flag] = val end

				local function set(v)
					val = v
					local delta = (val - min) / (max - min)
					Bar.Size = UDim2.new(delta, 0, 1, 0)
					ValueLabel.Text = tostring(val) .. (unit or "")
					if flag then Library.Flags[flag] = val end
					if callback then callback(val) end
				end

				local dragging = false
				local function Update(input)
					local delta = math.clamp((input.Position.X - Tray.AbsolutePosition.X) / Tray.AbsoluteSize.X, 0, 1)
					set(math.floor(min + (max - min) * delta))
				end

				Tray.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						Update(input)
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						Update(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)

				if flag then Library.Registry[flag] = set end
			end

			function Sector:CreateTextbox(name, default, flag, callback)
				local Textbox = Instance.new("Frame")
				Textbox.Size = UDim2.new(1, 0, 0, 32)
				Textbox.BackgroundTransparency = 1
				Textbox.Parent = Content
				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, 0, 0, 13)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Textbox
				local Box = Instance.new("TextBox")
				Box.Size = UDim2.new(1, 0, 0, 16)
				Box.Position = UDim2.fromOffset(0, 15)
				Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Box.BorderSizePixel = 0
				Box.Text = default or ""
				Box.PlaceholderText = "type here..."
				Box.TextColor3 = Color3.fromRGB(200, 200, 200)
				Box.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
				Box.Font = Enum.Font.Code
				Box.TextSize = 12
				Box.TextXAlignment = Enum.TextXAlignment.Left
				Box.ClearTextOnFocus = false
				Box.Parent = Textbox
				local Padding = Instance.new("UIPadding")
				Padding.PaddingLeft = UDim.new(0, 5)
				Padding.Parent = Box

				if flag then Library.Flags[flag] = Box.Text end

				local function set(v)
					Box.Text = v
					if flag then Library.Flags[flag] = v end
					if callback then callback(v) end
				end

				Box.FocusLost:Connect(function()
					set(Box.Text)
				end)

				if flag then Library.Registry[flag] = set end

				local TextboxObj = {}
				function TextboxObj:Set(v)
					set(v)
				end
				return TextboxObj
			end

			function Sector:CreateButton(name, callback)
				local ButtonFrame = Instance.new("Frame")
				ButtonFrame.Size = UDim2.new(1, 0, 0, 20)
				ButtonFrame.BackgroundTransparency = 1
				ButtonFrame.Parent = Content

				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(1, 0, 1, 0)
				Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Button.BorderSizePixel = 1
				Button.Text = name:lower()
				Button.TextColor3 = Color3.fromRGB(200, 200, 200)
				Button.Font = Enum.Font.Code
				Button.TextSize = 13
				Button.Parent = ButtonFrame
				local ButtonStroke = Instance.new("UIStroke")
				ButtonStroke.Color = Color3.fromRGB(50, 50, 50)
				ButtonStroke.Parent = Button

				Button.MouseButton1Click:Connect(function()
					if callback then callback() end
				end)
			end

			return Sector
		end

		TabButton.MouseButton1Click:Connect(function()
			for _, v in pairs(Window.Tabs) do
				v.Frame.Visible = false
				v.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
			end
			TabFrame.Visible = true
			TabButton.TextColor3 = Library.Accent
		end)

		Window.Tabs[name] = { Button = TabButton, Frame = TabFrame, Tab = Tab }
		if not Window.ActiveTab then TabFrame.Visible = true TabButton.TextColor3 = Library.Accent Window.ActiveTab = name end
		return Tab
	end
	return Window
end

return Library
-- yam is a femboy twink that loves exhale and sanetys dick
