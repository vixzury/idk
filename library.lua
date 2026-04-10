local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = {}

function Library:CreateWindow(name)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RiotV2"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success, _ = pcall(function() ScreenGui.Parent = CoreGui end)
    if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Main Container (MUCH WIDER NOW)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 480) -- Increased width to 700
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Multi-layered 1px borders
    local b1 = Instance.new("Frame", MainFrame) b1.Size = UDim2.new(1, 2, 1, 2) b1.Position = UDim2.new(0,-1,0,-1) b1.BackgroundColor3 = Color3.fromRGB(40,40,40) b1.ZIndex = 0 b1.BorderSizePixel = 0
    local b2 = Instance.new("Frame", MainFrame) b2.Size = UDim2.new(1, 4, 1, 4) b2.Position = UDim2.new(0,-2,0,-2) b2.BackgroundColor3 = Color3.fromRGB(0,0,0) b2.ZIndex = -1 b2.BorderSizePixel = 0
    local b3 = Instance.new("Frame", MainFrame) b3.Size = UDim2.new(1, 6, 1, 6) b3.Position = UDim2.new(0,-3,0,-3) b3.BackgroundColor3 = Color3.fromRGB(50,50,50) b3.ZIndex = -2 b3.BorderSizePixel = 0

    local InnerFrame = Instance.new("Frame")
    InnerFrame.Name = "InnerFrame"
    InnerFrame.Size = UDim2.new(1, -10, 1, -10)
    InnerFrame.Position = UDim2.new(0, 5, 0, 5)
    InnerFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    InnerFrame.BorderSizePixel = 0
    InnerFrame.Parent = MainFrame

    local InnerStroke = Instance.new("UIStroke")
    InnerStroke.Color = Color3.fromRGB(35, 35, 35)
    InnerStroke.Thickness = 1
    InnerStroke.Parent = InnerFrame

    -- Status Bar
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -15, 0, 20)
    StatusLabel.Position = UDim2.new(0, 10, 1, -25)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = os.date("%b %d %Y") .. " | " .. LocalPlayer.Name:lower()
    StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Code
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
    StatusLabel.Parent = MainFrame

    -- Sidebar (Big Bold Tabs)
    local SidebarArea = Instance.new("Frame")
    SidebarArea.Size = UDim2.new(0, 140, 1, -45) -- Slightly wider for 700px layout
    SidebarArea.Position = UDim2.new(0, 10, 0, 10)
    SidebarArea.BackgroundTransparency = 1
    SidebarArea.Parent = InnerFrame

    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Color = Color3.fromRGB(35, 35, 35)
    SidebarStroke.Parent = SidebarArea

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = SidebarArea

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -165, 1, -10)
    ContentArea.Position = UDim2.new(0, 155, 0, 10)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = InnerFrame

    -- Dragging
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.RightShift then ScreenGui.Enabled = not ScreenGui.Enabled end
    end)

    local Window = {CurrentTab = nil}

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 42)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.Parent = TabContainer

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, 0, 1, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name:upper()
        TabLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabLabel.TextSize = 20
        TabLabel.Font = Enum.Font.GothamBold
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabBtn

        local Page = Instance.new("Frame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.Parent = ContentArea

        local LeftColumn = Instance.new("ScrollingFrame", Page)
        LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.BorderSizePixel = 0
        LeftColumn.ScrollBarThickness = 0
        Instance.new("UIListLayout", LeftColumn).Padding = UDim.new(0, 15)

        local RightColumn = Instance.new("ScrollingFrame", Page)
        RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
        RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
        RightColumn.BackgroundTransparency = 1
        RightColumn.BorderSizePixel = 0
        RightColumn.ScrollBarThickness = 0
        Instance.new("UIListLayout", RightColumn).Padding = UDim.new(0, 15)

        local Tab = {Page = Page, Label = TabLabel}

        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Page.Visible = false
                Window.CurrentTab.Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            Page.Visible = true
            TabLabel.TextColor3 = Color3.fromRGB(255, 60, 60) -- BACK TO RED
            Window.CurrentTab = Tab
        end)

        if not Window.CurrentTab then
            Page.Visible = true
            TabLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
            Window.CurrentTab = Tab
        end

        function Tab:AddGroupbox(title, side)
            local Column = (side:lower() == "left") and LeftColumn or RightColumn
            
            local GroupboxFrame = Instance.new("Frame")
            GroupboxFrame.Size = UDim2.new(1, 0, 0, 30)
            GroupboxFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            GroupboxFrame.BorderSizePixel = 0
            GroupboxFrame.Parent = Column

            Instance.new("UIStroke", GroupboxFrame).Color = Color3.fromRGB(35, 35, 35)

            local GroupTitle = Instance.new("TextLabel")
            GroupTitle.Position = UDim2.new(0, 10, 0, -8)
            GroupTitle.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            GroupTitle.Text = " " .. title:upper() .. " "
            GroupTitle.TextColor3 = Color3.fromRGB(255, 60, 60) -- RED TITLES
            GroupTitle.TextSize = 12
            GroupTitle.Font = Enum.Font.GothamBold
            GroupTitle.Size = UDim2.new(0, GroupTitle.TextBounds.X + 6, 0, 15)
            GroupTitle.Parent = GroupboxFrame

            local Container = Instance.new("Frame", GroupboxFrame)
            Container.Size = UDim2.new(1,-20,1,-20) Container.Position = UDim2.new(0,10,0,10) Container.BackgroundTransparency = 1
            local List = Instance.new("UIListLayout", Container)
            List.Padding = UDim.new(0, 5)

            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                GroupboxFrame.Size = UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y + 25)
            end)

            local Groupbox = {}
            function Groupbox:AddToggle(text, default, callback)
                local ToggleBtn = Instance.new("TextButton", Container)
                ToggleBtn.Size = UDim2.new(1,0,0,20) ToggleBtn.BackgroundTransparency = 1 ToggleBtn.Text = ""

                local Checkbox = Instance.new("Frame", ToggleBtn)
                Checkbox.Size = UDim2.new(0,10,0,10) Checkbox.Position = UDim2.new(0,0,0.5,0) Checkbox.AnchorPoint = Vector2.new(0,0.5)
                Checkbox.BackgroundColor3 = default and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(40, 40, 40) Checkbox.BorderSizePixel = 0

                local Label = Instance.new("TextLabel", ToggleBtn)
                Label.Size = UDim2.new(1,-15,1,0) Label.Position = UDim2.new(0,15,0,0) Label.BackgroundTransparency = 1
                Label.Text = text:lower() Label.TextColor3 = Color3.fromRGB(180, 180, 180) Label.TextSize = 12 Label.Font = Enum.Font.Code Label.TextXAlignment = Enum.TextXAlignment.Left

                local active = default
                ToggleBtn.MouseButton1Click:Connect(function()
                    active = not active
                    Checkbox.BackgroundColor3 = active and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(40, 40, 40)
                    callback(active)
                end)
            end

            function Groupbox:AddSlider(text, min, max, default, callback)
                local SliderFrame = Instance.new("Frame", Container)
                SliderFrame.Size = UDim2.new(1,0,0,30) SliderFrame.BackgroundTransparency = 1
                
                local Label = Instance.new("TextLabel", SliderFrame)
                Label.Size = UDim2.new(1,0,0,15) Label.BackgroundTransparency = 1 Label.Text = text:lower()
                Label.TextColor3 = Color3.fromRGB(180, 180, 180) Label.TextSize = 12 Label.Font = Enum.Font.Code Label.TextXAlignment = Enum.TextXAlignment.Left

                local Bar = Instance.new("TextButton", SliderFrame)
                Bar.Size = UDim2.new(1,0,0,4) Bar.Position = UDim2.new(0,0,1,-5) Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40) Bar.BorderSizePixel = 0 Bar.Text = ""

                local Fill = Instance.new("Frame", Bar)
                Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0) Fill.BackgroundColor3 = Color3.fromRGB(255, 60, 60) Fill.BorderSizePixel = 0

                local dragging = false
                local function Update()
                    local percent = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    Fill.Size = UDim2.new(percent,0,1,0) callback(value)
                end
                Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true Update() end end)
                UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update() end end)
                UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            end
            return Groupbox
        end
        return Tab
    end
    return Window
end

return Library
