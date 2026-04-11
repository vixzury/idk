local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = game:GetService("Players").LocalPlayer

local Library = {
	ToggleKey = Enum.KeyCode.RightShift,
	CanDrag = true,
	Accent = Color3.fromRGB(220, 25, 25),
	Dark = Color3.fromRGB(12, 12, 12),
	OpenPopups = {}
}

function Library:ClosePopups()
	for _, v in pairs(Library.OpenPopups) do
		v.Visible = false
	end
	Library.OpenPopups = {}
end

local function MakeDraggable(dragframe, mainobject)
	local dragging, dragInput, dragStart, startPos
	dragframe.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and Library.CanDrag then
			Library:ClosePopups()
			dragging = true
			dragStart = input.Position
			startPos = mainobject.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			mainobject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

function Library:CreateWindow(name)
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name:find("Supremacy") then v:Destroy() end
    end

	local GUI = Instance.new("ScreenGui")
	GUI.Name = "Supremacy_Final_" .. math.random(1, 1000)
	GUI.ResetOnSpawn = false
	GUI.Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or CoreGui)

	local MainOutline = Instance.new("Frame")
	MainOutline.Name = "MainOutline"
	MainOutline.Size = UDim2.fromOffset(700, 600)
	MainOutline.Position = UDim2.new(0.5, -350, 0.5, -300)
	MainOutline.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MainOutline.BorderSizePixel = 0
	MainOutline.Parent = GUI

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Library.ToggleKey or input.KeyCode == Enum.KeyCode.Insert then
			MainOutline.Visible = not MainOutline.Visible
		end
	end)

	local MainInline = Instance.new("Frame")
	MainInline.Size = UDim2.new(1, -2, 1, -2)
	MainInline.Position = UDim2.fromOffset(1, 1)
	MainInline.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	MainInline.BorderSizePixel = 0
	MainInline.Parent = MainOutline

	local MainInner = Instance.new("Frame")
	MainInner.Size = UDim2.new(1, -2, 1, -2)
	MainInner.Position = UDim2.fromOffset(1, 1)
	MainInner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MainInner.BorderSizePixel = 0
	MainInner.Parent = MainInline

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Size = UDim2.new(1, -2, 1, -2)
	Main.Position = UDim2.fromOffset(1, 1)
	Main.BackgroundColor3 = Library.Dark
	Main.BorderSizePixel = 0
	Main.Parent = MainInner

	MakeDraggable(Main, MainOutline)

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 110, 1, -40)
	Sidebar.Position = UDim2.fromOffset(15, 20)
	Sidebar.BackgroundColor3 = Library.Dark
	Sidebar.BackgroundTransparency = 1
	Sidebar.Parent = Main
	local SidebarOutline = Instance.new("UIStroke")
	SidebarOutline.Color = Color3.fromRGB(50, 50, 50)
	SidebarOutline.Parent = Sidebar
	local SidebarLayout = Instance.new("UIListLayout")
	SidebarLayout.Padding = UDim.new(0, 5)
	SidebarLayout.Parent = Sidebar
	local SidebarPadding = Instance.new("UIPadding")
	SidebarPadding.PaddingTop = UDim.new(0, 10)
	SidebarPadding.PaddingLeft = UDim.new(0, 10)
	SidebarPadding.Parent = Sidebar

	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.Size = UDim2.new(1, -155, 1, -40)
	Container.Position = UDim2.fromOffset(140, 20)
	Container.BackgroundColor3 = Library.Dark
	Container.BackgroundTransparency = 1
	Container.Parent = Main
    local ContainerOutline = Instance.new("UIStroke")
	ContainerOutline.Color = Color3.fromRGB(50, 50, 50)
	ContainerOutline.Parent = Container

	local Footer = Instance.new("TextLabel")
	Footer.Size = UDim2.fromOffset(300, 20)
	Footer.Position = UDim2.new(1, -10, 1, -5)
	Footer.AnchorPoint = Vector2.new(1, 1)
	Footer.BackgroundTransparency = 1
	Footer.Text = os.date("%b %d %Y") .. " | " .. LocalPlayer.Name:lower()
	Footer.TextColor3 = Color3.fromRGB(120, 120, 120)
	Footer.Font = Enum.Font.Code
	Footer.TextSize = 13
	Footer.TextXAlignment = Enum.TextXAlignment.Right
	Footer.Parent = Container

	local Overlay = Instance.new("Frame")
	Overlay.Name = "Overlay"
	Overlay.Size = UDim2.new(1, 0, 1, 0)
	Overlay.BackgroundTransparency = 1
	Overlay.ZIndex = 500
	Overlay.Parent = GUI

	local Window = { Tabs = {} }

	function Window:CreateTab(name)
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1, 0, 0, 20)
		TabButton.BackgroundTransparency = 1
		TabButton.Text = name:lower()
		TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		TabButton.Font = Enum.Font.Code
		TabButton.TextSize = 14
		TabButton.TextXAlignment = Enum.TextXAlignment.Left
		TabButton.Parent = Sidebar

		local TabFrame = Instance.new("ScrollingFrame")
		TabFrame.Size = UDim2.new(1, -20, 1, -45)
		TabFrame.Position = UDim2.fromOffset(10, 10)
		TabFrame.BackgroundTransparency = 1
		TabFrame.BorderSizePixel = 0
		TabFrame.Visible = false
		TabFrame.ScrollBarThickness = 0
		TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		TabFrame.Parent = Container

		local LeftColumn = Instance.new("Frame")
		LeftColumn.Size = UDim2.new(0.5, -10, 1, 0)
		LeftColumn.BackgroundTransparency = 1
		LeftColumn.Parent = TabFrame
		local LeftLayout = Instance.new("UIListLayout")
		LeftLayout.Padding = UDim.new(0, 25)
		LeftLayout.Parent = LeftColumn

		local RightColumn = Instance.new("Frame")
		RightColumn.Size = UDim2.new(0.5, -10, 1, 0)
		RightColumn.Position = UDim2.new(0.5, 10, 0, 0)
		RightColumn.BackgroundTransparency = 1
		RightColumn.Parent = TabFrame
		local RightLayout = Instance.new("UIListLayout")
		RightLayout.Padding = UDim.new(0, 25)
		RightLayout.Parent = RightColumn

		local Tab = {}

		function Tab:CreateSector(name, side)
			local SectorFrame = Instance.new("Frame")
			SectorFrame.Size = UDim2.new(1, 0, 0, 25)
			SectorFrame.BackgroundTransparency = 1
			SectorFrame.Parent = (side:lower() == "left" and LeftColumn or RightColumn)

			local Notch = Instance.new("Frame")
			Notch.Size = UDim2.new(0, 0, 0, 2)
			Notch.Position = UDim2.fromOffset(10, -1)
			Notch.BackgroundColor3 = Library.Dark
			Notch.BorderSizePixel = 0
			Notch.ZIndex = 2
			Notch.Parent = SectorFrame

			local Title = Instance.new("TextLabel")
			Title.AutomaticSize = Enum.AutomaticSize.X
			Title.BackgroundTransparency = 1
			Title.Text = "  " .. name:lower() .. "  "
			Title.TextColor3 = Color3.fromRGB(210, 210, 210)
			Title.Font = Enum.Font.Code
			Title.TextSize = 13
			Title.Parent = Notch
			Title:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				Notch.Size = UDim2.fromOffset(Title.AbsoluteSize.X, 2)
			end)

			local Content = Instance.new("Frame")
			Content.Size = UDim2.new(1, -20, 1, -20)
			Content.Position = UDim2.fromOffset(10, 12)
			Content.BackgroundTransparency = 1
			Content.Parent = SectorFrame
			local ContentLayout = Instance.new("UIListLayout")
			ContentLayout.Padding = UDim.new(0, 10)
			ContentLayout.Parent = Content
			ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				SectorFrame.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 25)
			end)

			local Sector = {}

			function Sector:CreateToggle(name, default, callback)
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
				Toggle.MouseButton1Click:Connect(function()
					enabled = not enabled
					Inner.Visible = enabled
					if callback then callback(enabled) end
				end)
			end

			function Sector:CreateCombo(name, list, default, callback)
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
				Button.Text = "  " .. (default or "none")
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
				for _, v in pairs(list) do
					local Item = Instance.new("TextButton")
					Item.Size = UDim2.new(1, 0, 0, 18)
					Item.BackgroundTransparency = 1
					Item.Text = "  " .. v:lower()
					Item.TextColor3 = (Selected == v) and Library.Accent or Color3.fromRGB(180, 180, 180)
					Item.Font = Enum.Font.Code
					Item.TextSize = 12
					Item.TextXAlignment = Enum.TextXAlignment.Left
					Item.ZIndex = 1201
					Item.Parent = ListFrame
					Item.MouseButton1Click:Connect(function()
						Selected = v
						Button.Text = "  " .. v:lower()
						ListFrame.Visible = false
						if callback then callback(v) end
						for _, it in pairs(ListFrame:GetChildren()) do
							if it:IsA("TextButton") then it.TextColor3 = (it.Text:find(v:lower()) and Library.Accent or Color3.fromRGB(180, 180, 180)) end
						end
					end)
				end
				Button.MouseButton1Click:Connect(function()
					if ListFrame.Visible then ListFrame.Visible = false else
						Library:ClosePopups()
						ListFrame.Position = UDim2.fromOffset(Button.AbsolutePosition.X, Button.AbsolutePosition.Y + Button.AbsoluteSize.Y + 1)
						ListFrame.Size = UDim2.fromOffset(Button.AbsoluteSize.X, #list * 18)
						ListFrame.Visible = true
						table.insert(Library.OpenPopups, ListFrame)
					end
				end)
			end

			function Sector:CreateKeybind(name, default, callback)
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

				local function setMode(m)
					currentMode = m
					ModeFrame.Visible = false
					if callback then callback({Key = currentKey, Mode = currentMode}) end
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
						elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
							currentKey = input.UserInputType
							listening = false
						end
						if not listening then
							BindButton.Text = "[" .. (currentKey and currentKey.Name:gsub("MouseButton", "MB") or "NONE") .. "]"
							if callback then callback({Key = currentKey, Mode = currentMode}) end
						end
					end
				end)
			end

			function Sector:CreateDropdown(name, list, default, callback)
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
				local function UpdateLabel()
					if #Selected == 0 then Button.Text = "  none" else Button.Text = "  " .. table.concat(Selected, ", ") end
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
						if callback then callback(Selected) end
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
			end

			function Sector:CreateColorpicker(name, default, callback)
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
			end

			function Sector:CreateSlider(name, min, max, default, unit, callback)
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

				local dragging = false
				local function Update(input)
					local delta = math.clamp((input.Position.X - Tray.AbsolutePosition.X) / Tray.AbsoluteSize.X, 0, 1)
					local val = math.floor(min + (max - min) * delta)
					Bar.Size = UDim2.new(delta, 0, 1, 0)
					ValueLabel.Text = tostring(val) .. (unit or "")
					if callback then callback(val) end
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
