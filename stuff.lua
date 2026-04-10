local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}

-- Utility for dragging
local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPos = nil

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			-- Fix: Check if we're clicking an interactive element or the settings area
			local objects = LocalPlayer:WaitForChild("PlayerGui"):GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
			local interactive = false
			for _, v in pairs(objects) do
				if v:IsA("TextButton") or v:IsA("ScrollingFrame") or v:IsA("TextBox") or v.Name == "Container" or v.Name:find("Slider") or v.Name:find("Colorpicker") then
					if v ~= topbarobject and v.Name ~= "Sidebar" then
						interactive = true
						break
					end
				end
			end
			if interactive then return end

			Dragging = true
			DragStart = input.Position
			StartPos = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			local Delta = input.Position - DragStart
			object.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		end
	end)
end

function Library:CreateWindow(name)
	local GUI = Instance.new("ScreenGui")
	GUI.Name = "CustomMenu"
	GUI.Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui"))
	GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- Global Dropdown/Colorpicker Container (Stays on top)
	local Overlay = Instance.new("Frame")
	Overlay.Name = "Overlay"
	Overlay.Size = UDim2.new(1, 0, 1, 0)
	Overlay.BackgroundTransparency = 1
	Overlay.ZIndex = 100
	Overlay.Parent = GUI

	local MainOutline = Instance.new("Frame")
	MainOutline.Name = "MainOutline"
	MainOutline.Size = UDim2.new(0, 556, 0, 456)
	MainOutline.Position = UDim2.new(0.5, -278, 0.5, -228)
	MainOutline.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MainOutline.BorderSizePixel = 0
	MainOutline.Parent = GUI

	local MainInline = Instance.new("Frame")
	MainInline.Name = "MainInline"
	MainInline.Size = UDim2.new(1, -2, 1, -2)
	MainInline.Position = UDim2.new(0, 1, 0, 1)
	MainInline.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	MainInline.BorderSizePixel = 0
	MainInline.Parent = MainOutline

	local MainRing = Instance.new("Frame")
	MainRing.Name = "MainRing"
	MainRing.Size = UDim2.new(1, -2, 1, -2)
	MainRing.Position = UDim2.new(0, 1, 0, 1)
	MainRing.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MainRing.BorderSizePixel = 0
	MainRing.Parent = MainInline

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Size = UDim2.new(1, -2, 1, -2)
	Main.Position = UDim2.new(0, 1, 0, 1)
	Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Main.BorderSizePixel = 0
	Main.Parent = MainRing

	MakeDraggable(Main, MainOutline)

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 100, 1, -20)
	Sidebar.Position = UDim2.new(0, 10, 0, 10)
	Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = Main

	local SidebarBorder = Instance.new("UIStroke")
	SidebarBorder.Color = Color3.fromRGB(35, 35, 35)
	SidebarBorder.Thickness = 1
	SidebarBorder.Parent = Sidebar

	local SidebarLayout = Instance.new("UIListLayout")
	SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SidebarLayout.Padding = UDim.new(0, 2)
	SidebarLayout.Parent = Sidebar

	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.Size = UDim2.new(1, -130, 1, -20)
	Container.Position = UDim2.new(0, 120, 0, 10)
	Container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Container.BorderSizePixel = 0
	Container.Parent = Main

	local ContainerBorder = Instance.new("UIStroke")
	ContainerBorder.Color = Color3.fromRGB(35, 35, 35)
	ContainerBorder.Thickness = 1
	ContainerBorder.Parent = Container

	local Window = {
		Tabs = {},
		ActiveTab = nil
	}

	function Window:CreateTab(name)
		local TabButton = Instance.new("TextButton")
		TabButton.Name = name .. "Tab"
		TabButton.Size = UDim2.new(1, 0, 0, 25)
		TabButton.BackgroundTransparency = 1
		TabButton.Text = name:lower()
		TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		TabButton.Font = Enum.Font.Code
		TabButton.TextSize = 13
		TabButton.Parent = Sidebar

		local TabFrame = Instance.new("ScrollingFrame")
		TabFrame.Name = name .. "Frame"
		TabFrame.Size = UDim2.new(1, -10, 1, -10)
		TabFrame.Position = UDim2.new(0, 5, 0, 5)
		TabFrame.BackgroundTransparency = 1
		TabFrame.BorderSizePixel = 0
		TabFrame.Visible = false
		TabFrame.ScrollBarThickness = 2
		TabFrame.ScrollBarImageColor3 = Color3.fromRGB(220, 40, 40)
		TabFrame.ScrollBarImageTransparency = 0.6
		TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		TabFrame.Parent = Container

		local LeftColumn = Instance.new("Frame")
		LeftColumn.Name = "LeftColumn"
		LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
		LeftColumn.BackgroundTransparency = 1
		LeftColumn.Parent = TabFrame

		local RightColumn = Instance.new("Frame")
		RightColumn.Name = "RightColumn"
		RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
		RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
		RightColumn.BackgroundTransparency = 1
		RightColumn.Parent = TabFrame

		local LeftLayout = Instance.new("UIListLayout")
		LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
		LeftLayout.Padding = UDim.new(0, 15)
		LeftLayout.Parent = LeftColumn

		local RightLayout = Instance.new("UIListLayout")
		RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
		RightLayout.Padding = UDim.new(0, 15)
		RightLayout.Parent = RightColumn

		local Tab = {}

		TabButton.MouseButton1Click:Connect(function()
			for _, v in pairs(Window.Tabs) do
				v.Frame.Visible = false
				v.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
			end
			TabFrame.Visible = true
			TabButton.TextColor3 = Color3.fromRGB(220, 40, 40)
			Window.ActiveTab = Tab
		end)

		function Tab:CreateSector(name, side)
			local SectorFrame = Instance.new("Frame")
			SectorFrame.Name = name .. "Sector"
			SectorFrame.Size = UDim2.new(1, 0, 0, 0)
			SectorFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			SectorFrame.BorderSizePixel = 0
			SectorFrame.Parent = (side:lower() == "left" and LeftColumn or RightColumn)

			local SectorStroke = Instance.new("UIStroke")
			SectorStroke.Color = Color3.fromRGB(40, 40, 40)
			SectorStroke.Thickness = 1
			SectorStroke.Parent = SectorFrame

			local Title = Instance.new("TextLabel")
			Title.Size = UDim2.new(0, 0, 0, 15)
			Title.Position = UDim2.new(0, 10, 0, -4) -- Fix: Lowered header
			Title.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			Title.Text = "  " .. name:lower() .. "  "
			Title.TextColor3 = Color3.fromRGB(200, 200, 200)
			Title.Font = Enum.Font.Code
			Title.TextSize = 12
			Title.AutomaticSize = Enum.AutomaticSize.X
			Title.Parent = SectorFrame

			local Content = Instance.new("Frame")
			Content.Name = "Content"
			Content.Size = UDim2.new(1, -20, 1, -20)
			Content.Position = UDim2.new(0, 10, 0, 12) -- Fix: Lowered content start
			Content.BackgroundTransparency = 1
			Content.Parent = SectorFrame

			local ContentLayout = Instance.new("UIListLayout")
			ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ContentLayout.Padding = UDim.new(0, 8)
			ContentLayout.Parent = Content

			ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				SectorFrame.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 25)
			end)

			local Sector = {}

			function Sector:CreateCheckbox(name, default, callback)
				local Checkbox = Instance.new("TextButton")
				Checkbox.Name = name .. "Checkbox"
				Checkbox.Size = UDim2.new(1, 0, 0, 20)
				Checkbox.BackgroundTransparency = 1
				Checkbox.Text = ""
				Checkbox.Parent = Content

				local Box = Instance.new("Frame")
				Box.Size = UDim2.new(0, 12, 0, 12)
				Box.Position = UDim2.new(1, -12, 0.5, -6)
				Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Box.BorderSizePixel = 0
				Box.Parent = Checkbox

				local BoxStroke = Instance.new("UIStroke")
				BoxStroke.Color = Color3.fromRGB(50, 50, 50)
				BoxStroke.Thickness = 1
				BoxStroke.Parent = Box

				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, -20, 1, 0)
				Label.Position = UDim2.new(0, 0, 0, 0)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 12
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Checkbox

				local Enabled = default or false
				local function Update()
					Box.BackgroundColor3 = Enabled and Color3.fromRGB(220, 40, 40) or Color3.fromRGB(30, 30, 30)
					callback(Enabled)
				end

				Checkbox.MouseButton1Click:Connect(function()
					Enabled = not Enabled
					Update()
				end)

				Update()
			end

			function Sector:CreateSlider(name, min, max, default, dec, callback)
				local Slider = Instance.new("Frame")
				Slider.Name = name .. "Slider"
				Slider.Size = UDim2.new(1, 0, 0, 30)
				Slider.BackgroundTransparency = 1
				Slider.Parent = Content

				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, 0, 0, 15)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 12
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Slider

				local Tray = Instance.new("Frame")
				Tray.Name = "Tray_Slider"
				Tray.Size = UDim2.new(1, 0, 0, 10)
				Tray.Position = UDim2.new(0, 0, 0, 18)
				Tray.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Tray.BorderSizePixel = 0
				Tray.Parent = Slider

				local TrayStroke = Instance.new("UIStroke")
				TrayStroke.Color = Color3.fromRGB(50, 50, 50)
				TrayStroke.Thickness = 1
				TrayStroke.Parent = Tray

				local Bar = Instance.new("Frame")
				Bar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
				Bar.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
				Bar.BorderSizePixel = 0
				Bar.Parent = Tray

				local ValueLabel = Instance.new("TextLabel")
				ValueLabel.Size = UDim2.new(1, 0, 1, 0)
				ValueLabel.BackgroundTransparency = 1
				ValueLabel.Text = tostring(default) .. (dec and "%" or "")
				ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				ValueLabel.Font = Enum.Font.Code
				ValueLabel.TextSize = 10
				ValueLabel.Parent = Tray

				local function Move(input)
					local Pos = math.clamp((input.Position.X - Tray.AbsolutePosition.X) / Tray.AbsoluteSize.X, 0, 1)
					local Val = math.floor(((max - min) * Pos + min) * (10 ^ (0))) / (10 ^ (0))
					Bar.Size = UDim2.new(Pos, 0, 1, 0)
					ValueLabel.Text = tostring(Val) .. (dec and "%" or "")
					callback(Val)
				end

				local Dragging = false
				Tray.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = true
						Move(input)
					end
				end)
				Tray.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = false
					end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						Move(input)
					end
				end)
			end

			function Sector:CreateDropdown(name, list, default, callback)
				local Dropdown = Instance.new("Frame")
				Dropdown.Name = name .. "Dropdown"
				Dropdown.Size = UDim2.new(1, 0, 0, 35)
				Dropdown.BackgroundTransparency = 1
				Dropdown.Parent = Content

				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, 0, 0, 15)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 12
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Dropdown

				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(1, 0, 0, 18)
				Button.Position = UDim2.new(0, 0, 0, 18)
				Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Button.Text = default or "none"
				Button.TextColor3 = Color3.fromRGB(200, 200, 200)
				Button.Font = Enum.Font.Code
				Button.TextSize = 11
				Button.Parent = Dropdown

				local ButtonStroke = Instance.new("UIStroke")
				ButtonStroke.Color = Color3.fromRGB(50, 50, 50)
				ButtonStroke.Thickness = 1
				ButtonStroke.Parent = Button

				local ListFrame = Instance.new("Frame")
				ListFrame.Name = "DropdownList"
				ListFrame.Size = UDim2.new(0, Button.AbsoluteSize.X, 0, 0)
				ListFrame.Position = UDim2.new(0, Button.AbsolutePosition.X, 0, Button.AbsolutePosition.Y + Button.AbsoluteSize.Y + 2)
				ListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				ListFrame.BorderSizePixel = 0
				ListFrame.Visible = false
				ListFrame.ZIndex = 200
				ListFrame.Parent = Overlay

				local ListStroke = Instance.new("UIStroke")
				ListStroke.Color = Color3.fromRGB(50, 50, 50)
				ListStroke.Thickness = 1
				ListStroke.Parent = ListFrame

				local ListLayout = Instance.new("UIListLayout")
				ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ListLayout.Parent = ListFrame

				for _, v in pairs(list) do
					local Item = Instance.new("TextButton")
					Item.Size = UDim2.new(1, 0, 0, 18)
					Item.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
					Item.Text = v:lower()
					Item.TextColor3 = Color3.fromRGB(180, 180, 180)
					Item.Font = Enum.Font.Code
					Item.TextSize = 11
					Item.ZIndex = 201
					Item.Parent = ListFrame

					Item.MouseButton1Click:Connect(function()
						Button.Text = v:lower()
						ListFrame.Visible = false
						callback(v)
					end)
				end

				Button.MouseButton1Click:Connect(function()
					-- Update position in case window moved
					ListFrame.Position = UDim2.new(0, Button.AbsolutePosition.X, 0, Button.AbsolutePosition.Y + Button.AbsoluteSize.Y + 1)
					ListFrame.Size = UDim2.new(0, Button.AbsoluteSize.X, 0, ListLayout.AbsoluteContentSize.Y)
					ListFrame.Visible = not ListFrame.Visible
				end)
			end

			function Sector:CreateColorpicker(name, default, callback)
				local Colorpicker = Instance.new("Frame")
				Colorpicker.Name = name .. "Colorpicker"
				Colorpicker.Size = UDim2.new(1, 0, 0, 20)
				Colorpicker.BackgroundTransparency = 1
				Colorpicker.Parent = Content

				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, -25, 1, 0)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 12
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Colorpicker

				local Box = Instance.new("TextButton")
				Box.Name = "Colorpicker_Trigger"
				Box.Size = UDim2.new(0, 20, 0, 12)
				Box.Position = UDim2.new(1, -20, 0.5, -6)
				Box.BackgroundColor3 = default or Color3.fromRGB(255, 255, 255)
				Box.BorderSizePixel = 0
				Box.Text = ""
				Box.Parent = Colorpicker

				local BoxStroke = Instance.new("UIStroke")
				BoxStroke.Color = Color3.fromRGB(50, 50, 50)
				BoxStroke.Thickness = 1
				BoxStroke.Parent = Box

				-- Color Picker UI
				local Picker = Instance.new("Frame")
				Picker.Name = "AdvancedColorPicker"
				Picker.Size = UDim2.new(0, 150, 0, 170)
				Picker.Position = UDim2.new(0, Box.AbsolutePosition.X - 160, 0, Box.AbsolutePosition.Y)
				Picker.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				Picker.BorderSizePixel = 0
				Picker.Visible = false
				Picker.ZIndex = 200
				Picker.Parent = Overlay

				local PickerStroke = Instance.new("UIStroke")
				PickerStroke.Color = Color3.fromRGB(50, 50, 50)
				PickerStroke.Thickness = 1
				PickerStroke.Parent = Picker

				local RLabel = Instance.new("TextLabel")
				RLabel.Size = UDim2.new(0, 20, 0, 20)
				RLabel.Position = UDim2.new(0, 5, 0, 5)
				RLabel.Text = "R"
				RLabel.TextColor3 = Color3.fromRGB(200, 40, 40)
				RLabel.Font = Enum.Font.Code
				RLabel.Parent = Picker

				local RSlider = Instance.new("TextBox")
				RSlider.Size = UDim2.new(1, -30, 0, 20)
				RSlider.Position = UDim2.new(0, 25, 0, 5)
				RSlider.Text = tostring(math.floor(Box.BackgroundColor3.R * 255))
				RSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				RSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
				RSlider.Parent = Picker

				local GLabel = RLabel:Clone()
				GLabel.Position = UDim2.new(0, 5, 0, 30)
				GLabel.Text = "G"
				GLabel.TextColor3 = Color3.fromRGB(40, 200, 40)
				GLabel.Parent = Picker

				local GSlider = RSlider:Clone()
				GSlider.Position = UDim2.new(0, 25, 0, 30)
				GSlider.Text = tostring(math.floor(Box.BackgroundColor3.G * 255))
				GSlider.Parent = Picker

				local BLabel = RLabel:Clone()
				BLabel.Position = UDim2.new(0, 5, 0, 55)
				BLabel.Text = "B"
				BLabel.TextColor3 = Color3.fromRGB(40, 40, 200)
				BLabel.Parent = Picker

				local BSlider = RSlider:Clone()
				BSlider.Position = UDim2.new(0, 25, 0, 55)
				BSlider.Text = tostring(math.floor(Box.BackgroundColor3.B * 255))
				BSlider.Parent = Picker

				local ALabel = RLabel:Clone()
				ALabel.Position = UDim2.new(0, 5, 0, 80)
				ALabel.Text = "A"
				ALabel.TextColor3 = Color3.fromRGB(200, 200, 200)
				ALabel.Parent = Picker

				local ASlider = RSlider:Clone()
				ASlider.Position = UDim2.new(0, 25, 0, 80)
				ASlider.Text = "100"
				ASlider.Parent = Picker

				local Preview = Instance.new("Frame")
				Preview.Size = UDim2.new(1, -10, 0, 30)
				Preview.Position = UDim2.new(0, 5, 0, 105)
				Preview.BackgroundColor3 = Box.BackgroundColor3
				Preview.BorderSizePixel = 0
				Preview.Parent = Picker

				local Update = function()
					local r = tonumber(RSlider.Text) or 255
					local g = tonumber(GSlider.Text) or 255
					local b = tonumber(BSlider.Text) or 255
					local a = tonumber(ASlider.Text) or 100
					local col = Color3.fromRGB(r, g, b)
					Preview.BackgroundColor3 = col
					Preview.BackgroundTransparency = (100 - a) / 100
					Box.BackgroundColor3 = col
					Box.BackgroundTransparency = (100 - a) / 100
					callback(col, a / 100)
				end

				RSlider.FocusLost:Connect(Update)
				GSlider.FocusLost:Connect(Update)
				BSlider.FocusLost:Connect(Update)
				ASlider.FocusLost:Connect(Update)

				Box.MouseButton1Click:Connect(function()
					Picker.Position = UDim2.new(0, Box.AbsolutePosition.X - 160, 0, Box.AbsolutePosition.Y)
					Picker.Visible = not Picker.Visible
				end)
			end

			return Sector
		end

		Window.Tabs[name] = {
			Button = TabButton,
			Frame = TabFrame
		}

		if not Window.ActiveTab then
			TabFrame.Visible = true
			TabButton.TextColor3 = Color3.fromRGB(220, 40, 40)
			Window.ActiveTab = Tab
		end

		return Tab
	end

	return Window
end

return Library
