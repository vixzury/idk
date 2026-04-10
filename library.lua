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

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
			Update(input)
		end
	end)
end

function Library:CreateWindow(name)
	local GUI = Instance.new("ScreenGui")
	GUI.Name = "CustomMenu"
	GUI.Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui"))
	GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Size = UDim2.new(0, 550, 0, 450)
	Main.Position = UDim2.new(0.5, -275, 0.5, -225)
	Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Main.BorderSizePixel = 0
	Main.Parent = GUI

	local MainBorder = Instance.new("UIStroke")
	MainBorder.Color = Color3.fromRGB(45, 45, 45)
	MainBorder.Thickness = 1
	MainBorder.Parent = Main

	-- Simple title or drag area if needed
	local DragArea = Instance.new("Frame")
	DragArea.Name = "DragArea"
	DragArea.Size = UDim2.new(1, 0, 0, 5)
	DragArea.BackgroundTransparency = 1
	DragArea.Parent = Main
	MakeDraggable(DragArea, Main)

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
		LeftLayout.Padding = UDim.new(0, 10)
		LeftLayout.Parent = LeftColumn

		local RightLayout = Instance.new("UIListLayout")
		RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
		RightLayout.Padding = UDim.new(0, 10)
		RightLayout.Parent = RightColumn

		local Tab = {
			Sectors = {}
		}

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
			Title.Position = UDim2.new(0, 10, 0, -8)
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
			Content.Position = UDim2.new(0, 10, 0, 10)
			Content.BackgroundTransparency = 1
			Content.Parent = SectorFrame

			local ContentLayout = Instance.new("UIListLayout")
			ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ContentLayout.Padding = UDim.new(0, 5)
			ContentLayout.Parent = Content

			ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				SectorFrame.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
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
				Box.Position = UDim2.new(0, 0, 0.5, -6)
				Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Box.BorderSizePixel = 0
				Box.Parent = Checkbox

				local BoxStroke = Instance.new("UIStroke")
				BoxStroke.Color = Color3.fromRGB(50, 50, 50)
				BoxStroke.Thickness = 1
				BoxStroke.Parent = Box

				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, -20, 1, 0)
				Label.Position = UDim2.new(0, 20, 0, 0)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 12
				Label.XAlignment = Enum.TextXAlignment.Left
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
				Label.XAlignment = Enum.TextXAlignment.Left
				Label.Parent = Slider

				local Tray = Instance.new("Frame")
				Tray.Size = UDim2.new(1, 0, 0, 8)
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
				Label.XAlignment = Enum.TextXAlignment.Left
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
				ListFrame.Size = UDim2.new(1, 0, 0, 0)
				ListFrame.Position = UDim2.new(0, 0, 1, 1)
				ListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				ListFrame.BorderSizePixel = 0
				ListFrame.Visible = false
				ListFrame.ZIndex = 10
				ListFrame.Parent = Button

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
					Item.ZIndex = 11
					Item.Parent = ListFrame

					Item.MouseButton1Click:Connect(function()
						Button.Text = v:lower()
						ListFrame.Visible = false
						callback(v)
					end)
				end

				Button.MouseButton1Click:Connect(function()
					ListFrame.Visible = not ListFrame.Visible
					ListFrame.Size = UDim2.new(1, 0, 0, ListLayout.AbsoluteContentSize.Y)
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
				Label.XAlignment = Enum.TextXAlignment.Left
				Label.Parent = Colorpicker

				local Box = Instance.new("TextButton")
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

				-- Basic color cycling for demo purposes, or just a toggle
				Box.MouseButton1Click:Connect(function()
					-- In a real lib, this would open a picker GUI
					-- For this recreation, we'll just cycle through a few colors
					local colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 40, 40), Color3.fromRGB(40, 220, 40), Color3.fromRGB(40, 40, 220)}
					local index = 1
					for i, c in ipairs(colors) do
						if c == Box.BackgroundColor3 then
							index = (i % #colors) + 1
							break
						end
					end
					Box.BackgroundColor3 = colors[index]
					callback(colors[index])
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
