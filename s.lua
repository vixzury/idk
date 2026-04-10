local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {
	CanDrag = true,
	ToggleKey = Enum.KeyCode.RightShift
}

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPos = nil

	topbarobject.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and Library.CanDrag then
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

	local Overlay = Instance.new("Frame")
	Overlay.Name = "Overlay"
	Overlay.Size = UDim2.new(1, 0, 1, 0)
	Overlay.BackgroundTransparency = 1
	Overlay.ZIndex = 100
	Overlay.Parent = GUI

	local MainOutline = Instance.new("Frame")
	MainOutline.Name = "MainOutline"
	MainOutline.Size = UDim2.new(0, 600, 0, 500)
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

	-- Menu Toggle Logic
	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == Library.ToggleKey then
			MainOutline.Visible = not MainOutline.Visible
			Overlay.Visible = MainOutline.Visible
		end
	end)

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

	local Window = { Tabs = {}, ActiveTab = nil }

	function Window:UpdateToggleKey(key)
		Library.ToggleKey = key
	end

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

		-- Disable dragging when mouse is over tab settings
		TabFrame.MouseEnter:Connect(function() Library.CanDrag = false end)
		TabFrame.MouseLeave:Connect(function() Library.CanDrag = true end)

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
			Title.Position = UDim2.new(0, 10, 0, -4)
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
			Content.Position = UDim2.new(0, 10, 0, 12)
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

				Checkbox.MouseEnter:Connect(function() Library.CanDrag = false end)
				Checkbox.MouseLeave:Connect(function() Library.CanDrag = true end)

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
				Slider.MouseEnter:Connect(function() Library.CanDrag = false end)
				Slider.MouseLeave:Connect(function() Library.CanDrag = true end)

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

				Button.MouseEnter:Connect(function() Library.CanDrag = false end)
				Button.MouseLeave:Connect(function() Library.CanDrag = true end)

				local ButtonStroke = Instance.new("UIStroke")
				ButtonStroke.Color = Color3.fromRGB(50, 50, 50)
				ButtonStroke.Thickness = 1
				ButtonStroke.Parent = Button

				local ListFrame = Instance.new("Frame")
				ListFrame.Name = "DropdownList"
				ListFrame.Size = UDim2.new(0, 0, 0, 0)
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

				local Picker = Instance.new("Frame")
				Picker.Size = UDim2.new(0, 180, 0, 200)
				Picker.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				Picker.BorderSizePixel = 0
				Picker.Visible = false
				Picker.ZIndex = 200
				Picker.Parent = Overlay

				local PickerStroke = Instance.new("UIStroke")
				PickerStroke.Color = Color3.fromRGB(50, 50, 50)
				PickerStroke.Thickness = 1
				PickerStroke.Parent = Picker

				-- SV Square
				local SVSquare = Instance.new("Frame")
				SVSquare.Size = UDim2.new(0, 140, 0, 140)
				SVSquare.Position = UDim2.new(0, 10, 0, 10)
				SVSquare.BackgroundColor3 = Box.BackgroundColor3
				SVSquare.BorderSizePixel = 0
				SVSquare.Parent = Picker

				local SatGradient = Instance.new("UIGradient")
				SatGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
				SatGradient.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
				SatGradient.Parent = SVSquare -- Horizontal (White -> Trans)

				-- We need another overlay for Value (Trans -> Black)
				local VOverlay = Instance.new("Frame")
				VOverlay.Size = UDim2.new(1, 0, 1, 0)
				VOverlay.BackgroundTransparency = 0
				VOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				VOverlay.BorderSizePixel = 0
				VOverlay.Parent = SVSquare

				local ValGradient = Instance.new("UIGradient")
				ValGradient.Rotation = 90
				ValGradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
				ValGradient.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
				ValGradient.Parent = VOverlay

				local SVPointer = Instance.new("Frame")
				SVPointer.Size = UDim2.new(0, 4, 0, 4)
				SVPointer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SVPointer.BorderSizePixel = 0
				SVPointer.Parent = SVSquare

				local SVStroke = Instance.new("UIStroke")
				SVStroke.Color = Color3.fromRGB(0, 0, 0)
				SVStroke.Parent = SVPointer

				-- Hue Slider
				local HueSlider = Instance.new("Frame")
				HueSlider.Size = UDim2.new(0, 12, 0, 140)
				HueSlider.Position = UDim2.new(0, 160, 0, 10)
				HueSlider.BorderSizePixel = 0
				HueSlider.Parent = Picker

				local HueGradient = Instance.new("UIGradient")
				HueGradient.Rotation = 90
				HueGradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
					ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16, 1, 1)),
					ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
					ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
					ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66, 1, 1)),
					ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
				})
				HueGradient.Parent = HueSlider

				local HuePointer = Instance.new("Frame")
				HuePointer.Size = UDim2.new(1, 4, 0, 2)
				HuePointer.Position = UDim2.new(-0, -2, 0, 0)
				HuePointer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				HuePointer.BorderSizePixel = 0
				HuePointer.Parent = HueSlider

				-- Alpha Slider
				local AlphaSlider = Instance.new("Frame")
				AlphaSlider.Size = UDim2.new(0, 140, 0, 12)
				AlphaSlider.Position = UDim2.new(0, 10, 0, 160)
				AlphaSlider.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
				AlphaSlider.BorderSizePixel = 0
				AlphaSlider.Parent = Picker

				local AlphaGradient = Instance.new("UIGradient")
				AlphaGradient.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
				AlphaGradient.Parent = AlphaSlider

				local AlphaPointer = Instance.new("Frame")
				AlphaPointer.Size = UDim2.new(0, 2, 1, 4)
				AlphaPointer.Position = UDim2.new(0, 0, 0, -2)
				AlphaPointer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				AlphaPointer.BorderSizePixel = 0
				AlphaPointer.Parent = AlphaSlider

				-- Inputs
				local RInput = Instance.new("TextBox")
				RInput.Size = UDim2.new(0, 35, 0, 15)
				RInput.Position = UDim2.new(0, 10, 0, 180)
				RInput.BackgroundColor3 = Color3.fromRGB(30,30,30)
				RInput.TextColor3 = Color3.fromRGB(200,200,200)
				RInput.Font = Enum.Font.Code
				RInput.TextSize = 10
				RInput.Text = "255"
				RInput.Parent = Picker

				local GInput = RInput:Clone()
				GInput.Position = UDim2.new(0, 50, 0, 180)
				GInput.Text = "255"
				GInput.Parent = Picker

				local BInput = RInput:Clone()
				BInput.Position = UDim2.new(0, 90, 0, 180)
				BInput.Text = "255"
				BInput.Parent = Picker

				local AInput = RInput:Clone()
				AInput.Position = UDim2.new(0, 130, 0, 180)
				AInput.Text = "100"
				AInput.Parent = Picker

				local H, S, V = Box.BackgroundColor3:ToHSV()
				local Alpha = 1

				local function Update()
					local Color = Color3.fromHSV(H, S, V)
					SVSquare.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
					Box.BackgroundColor3 = Color
					Box.BackgroundTransparency = 1 - Alpha
					
					RInput.Text = math.floor(Color.R * 255)
					GInput.Text = math.floor(Color.G * 255)
					BInput.Text = math.floor(Color.B * 255)
					AInput.Text = math.floor(Alpha * 100)
					
					AlphaSlider.BackgroundColor3 = Color
					callback(Color, Alpha)
				end

				local function UpdateSV(input)
					local PosX = math.clamp((input.Position.X - SVSquare.AbsolutePosition.X) / SVSquare.AbsoluteSize.X, 0, 1)
					local PosY = math.clamp((input.Position.Y - SVSquare.AbsolutePosition.Y) / SVSquare.AbsoluteSize.Y, 0, 1)
					S = PosX
					V = 1 - PosY
					SVPointer.Position = UDim2.new(PosX, -2, PosY, -2)
					Update()
				end

				local function UpdateHue(input)
					local PosY = math.clamp((input.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
					H = 1 - PosY
					HuePointer.Position = UDim2.new(0, -2, PosY, -1)
					Update()
				end

				local function UpdateAlpha(input)
					local PosX = math.clamp((input.Position.X - AlphaSlider.AbsolutePosition.X) / AlphaSlider.AbsoluteSize.X, 0, 1)
					Alpha = 1 - PosX
					AlphaPointer.Position = UDim2.new(PosX, -1, 0, -2)
					Update()
				end

				-- Dragging Logic
				local SVDragging = false
				SVSquare.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						SVDragging = true
						UpdateSV(input)
					end
				end)

				local HueDragging = false
				HueSlider.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						HueDragging = true
						UpdateHue(input)
					end
				end)

				local AlphaDragging = false
				AlphaSlider.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						AlphaDragging = true
						UpdateAlpha(input)
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if SVDragging then UpdateSV(input) end
						if HueDragging then UpdateHue(input) end
						if AlphaDragging then UpdateAlpha(input) end
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						SVDragging = false
						HueDragging = false
						AlphaDragging = false
					end
				end)

				-- Connect safety lock
				Picker.MouseEnter:Connect(function() Library.CanDrag = false end)
				Picker.MouseLeave:Connect(function() Library.CanDrag = true end)

				Box.MouseButton1Click:Connect(function()
					Picker.Position = UDim2.new(0, Box.AbsolutePosition.X - 190, 0, Box.AbsolutePosition.Y)
					Picker.Visible = not Picker.Visible
				end)
				
				Update()
			end

			function Sector:CreateKeybind(name, default, callback)
				local Keybind = Instance.new("Frame")
				Keybind.Name = name .. "Keybind"
				Keybind.Size = UDim2.new(1, 0, 0, 20)
				Keybind.BackgroundTransparency = 1
				Keybind.Parent = Content

				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, -60, 1, 0)
				Label.BackgroundTransparency = 1
				Label.Text = name:lower()
				Label.TextColor3 = Color3.fromRGB(180, 180, 180)
				Label.Font = Enum.Font.Code
				Label.TextSize = 12
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Keybind

				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(0, 50, 0, 15)
				Button.Position = UDim2.new(1, -50, 0.5, -7)
				Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Button.Text = default and default.Name or "none"
				Button.TextColor3 = Color3.fromRGB(200, 200, 200)
				Button.Font = Enum.Font.Code
				Button.TextSize = 10
				Button.Parent = Keybind

				Button.MouseEnter:Connect(function() Library.CanDrag = false end)
				Button.MouseLeave:Connect(function() Library.CanDrag = true end)

				local ButtonStroke = Instance.new("UIStroke")
				ButtonStroke.Color = Color3.fromRGB(50, 50, 50)
				ButtonStroke.Thickness = 1
				ButtonStroke.Parent = Button

				local Binding = false
				Button.MouseButton1Click:Connect(function()
					Binding = true
					Button.Text = "..."
				end)

				UserInputService.InputBegan:Connect(function(input)
					if Binding and input.UserInputType == Enum.UserInputType.Keyboard then
						Binding = false
						Button.Text = input.KeyCode.Name:lower()
						callback(input.KeyCode)
					elseif Binding and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2) then
						Binding = false
						Button.Text = "none"
						callback(nil)
					end
				end)
			end

			return Sector
		end

		Window.Tabs[name] = { Button = TabButton, Frame = TabFrame }

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
