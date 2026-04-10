local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local library = {}

function library:CreateWindow(title)
	local window = {
		Tabs = {},
		ActiveTab = nil
	}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "CustomMenu"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
	MainFrame.Size = UDim2.new(0, 500, 0, 350)

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.fromRGB(40, 40, 40)
	UIStroke.Thickness = 1
	UIStroke.Parent = MainFrame

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Parent = MainFrame
	Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	Sidebar.BorderSizePixel = 0
	Sidebar.Position = UDim2.new(0, 0, 0, 0)
	Sidebar.Size = UDim2.new(0, 100, 1, 0)

	local SidebarLabel = Instance.new("TextLabel")
	SidebarLabel.Name = "SidebarLabel"
	SidebarLabel.Parent = Sidebar
	SidebarLabel.BackgroundTransparency = 1
	SidebarLabel.Position = UDim2.new(0, 10, 0, 10)
	SidebarLabel.Size = UDim2.new(1, -20, 0, 20)
	SidebarLabel.Font = Enum.Font.SourceSans
	SidebarLabel.Text = title or ""
	SidebarLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	SidebarLabel.TextSize = 14
	SidebarLabel.TextXAlignment = Enum.TextXAlignment.Left

	local TabList = Instance.new("ScrollingFrame")
	TabList.Name = "TabList"
	TabList.Parent = Sidebar
	TabList.BackgroundTransparency = 1
	TabList.Position = UDim2.new(0, 10, 0, 40)
	TabList.Size = UDim2.new(1, -15, 1, -50)
	TabList.ScrollBarThickness = 0
	TabList.CanvasSize = UDim2.new(0, 0, 0, 0)

	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.Parent = TabList
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim3.new(0, 5)

	-- Divider
	local Divider = Instance.new("Frame")
	Divider.Name = "Divider"
	Divider.Parent = MainFrame
	Divider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Divider.BorderSizePixel = 0
	Divider.Position = UDim2.new(0, 100, 0, 10)
	Divider.Size = UDim2.new(0, 1, 1, -20)

	-- Container Area
	local ContainerArea = Instance.new("Frame")
	ContainerArea.Name = "ContainerArea"
	ContainerArea.Parent = MainFrame
	ContainerArea.BackgroundTransparency = 1
	ContainerArea.Position = UDim2.new(0, 110, 0, 10)
	ContainerArea.Size = UDim2.new(1, -120, 1, -20)

	-- Dragging logic
	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	MainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	MainFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	function window:AddTab(name)
		local tab = {
			Name = name,
			Frame = nil,
			Button = nil
		}

		-- Tab Container
		local TabFrame = Instance.new("ScrollingFrame")
		TabFrame.Name = name .. "Tab"
		TabFrame.Parent = ContainerArea
		TabFrame.BackgroundTransparency = 1
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.Visible = false
		TabFrame.ScrollBarThickness = 2
		TabFrame.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 40)
		TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		
		local TabFrameLayout = Instance.new("UIListLayout")
		TabFrameLayout.Parent = TabFrame
		TabFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabFrameLayout.Padding = UDim2.new(0, 10)

		tab.Frame = TabFrame

		-- Tab Button
		local TabButton = Instance.new("TextButton")
		TabButton.Name = name .. "Button"
		TabButton.Parent = TabList
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(1, 0, 0, 20)
		TabButton.Font = Enum.Font.SourceSans
		TabButton.Text = name:lower()
		TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		TabButton.TextSize = 14
		TabButton.TextXAlignment = Enum.TextXAlignment.Left

		tab.Button = TabButton

		TabButton.MouseButton1Click:Connect(function()
			for _, t in pairs(window.Tabs) do
				t.Frame.Visible = false
				t.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
			end
			TabFrame.Visible = true
			TabButton.TextColor3 = Color3.fromRGB(200, 0, 0)
			window.ActiveTab = tab
		end)

		table.insert(window.Tabs, tab)

		if #window.Tabs == 1 then
			TabFrame.Visible = true
			TabButton.TextColor3 = Color3.fromRGB(200, 0, 0)
			window.ActiveTab = tab
		end

		return tab
	end

	return window
end

return library
