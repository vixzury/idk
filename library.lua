local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = {}

local function Tween(object, time, properties)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function Library:CreateWindow(name)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NyahnLib"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success, _ = pcall(function() ScreenGui.Parent = CoreGui end)
    if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(35, 35, 35)
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    -- Upper Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = name:upper()
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Sidebar (Tabs)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 140, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, 0, 0, 0)
    SidebarLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = Sidebar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabContainer

    -- Content Area
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -140, 1, -40)
    Container.Position = UDim2.new(0, 140, 0, 40)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    -- Dragging Logic
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
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

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Toggle menu visibility with RightShift
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    local Window = {
        Tabs = {},
        Items = {},
        CurrentTab = nil
    }

    function Window:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName .. "Tab"
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.Parent = TabContainer

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -10, 1, 0)
        TabLabel.Position = UDim2.new(0, 10, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabLabel.TextSize = 13
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabBtn

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName .. "Page"
        TabPage.Size = UDim2.new(1, -20, 1, -20)
        TabPage.Position = UDim2.new(0, 10, 0, 10)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 2
        TabPage.Visible = false
        TabPage.Parent = Container

        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 8)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Parent = TabPage

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
                Tween(t.Label, 0.3, {TextColor3 = Color3.fromRGB(150, 150, 150)})
            end
            TabPage.Visible = true
            Tween(TabLabel, 0.3, {TextColor3 = Color3.fromRGB(145, 117, 248)})
        end)

        local Tab = {Page = TabPage, Label = TabLabel}
        Window.Tabs[tabName] = Tab

        -- Set first tab as default
        if not Window.CurrentTab then
            Window.CurrentTab = tabName
            TabPage.Visible = true
            TabLabel.TextColor3 = Color3.fromRGB(145, 117, 248)
        end

        function Tab:AddToggle(text, default, callback)
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Name = text .. "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Text = ""
            ToggleFrame.Parent = TabPage
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 4)
            ToggleCorner.Parent = ToggleFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame
            
            local active = default
            local Switch = Instance.new("Frame")
            Switch.Size = UDim2.new(0, 30, 0, 16)
            Switch.Position = UDim2.new(1, -40, 0.5, 0)
            Switch.AnchorPoint = Vector2.new(0, 0.5)
            Switch.BackgroundColor3 = active and Color3.fromRGB(145, 117, 248) or Color3.fromRGB(40, 40, 40)
            Switch.Parent = ToggleFrame
            
            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = Switch
            
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 12, 0, 12)
            Knob.Position = UDim2.new(0, active and 16 or 2, 0.5, 0)
            Knob.AnchorPoint = Vector2.new(0, 0.5)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.Parent = Switch
            
            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1, 0)
            KnobCorner.Parent = Knob
            
            ToggleFrame.MouseButton1Click:Connect(function()
                active = not active
                Tween(Switch, 0.3, {BackgroundColor3 = active and Color3.fromRGB(145, 117, 248) or Color3.fromRGB(40, 40, 40)})
                Tween(Knob, 0.3, {Position = UDim2.new(0, active and 16 or 2, 0.5, 0)})
                callback(active)
            end)
        end

        function Tab:AddButton(text, callback)
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = text .. "Button"
            ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Text = text
            ButtonFrame.TextColor3 = Color3.fromRGB(200, 200, 200)
            ButtonFrame.TextSize = 13
            ButtonFrame.Font = Enum.Font.GothamMedium
            ButtonFrame.Parent = TabPage
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 4)
            ButtonCorner.Parent = ButtonFrame
            
            ButtonFrame.MouseButton1Click:Connect(callback)
            
            ButtonFrame.MouseEnter:Connect(function()
                Tween(ButtonFrame, 0.2, {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(255, 255, 255)})
            end)
            ButtonFrame.MouseLeave:Connect(function()
                Tween(ButtonFrame, 0.2, {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(200, 200, 200)})
            end)
        end

        function Tab:AddSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = text .. "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 45)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabPage

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 4)
            SliderCorner.Parent = SliderFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -10, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(1, -10, 0, 20)
            ValueLabel.Position = UDim2.new(0, 0, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueLabel.TextSize = 12
            ValueLabel.Font = Enum.Font.GothamMedium
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame

            local Bar = Instance.new("TextButton")
            Bar.Name = "Bar"
            Bar.Size = UDim2.new(1, -20, 0, 4)
            Bar.Position = UDim2.new(0, 10, 1, -10)
            Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Bar.BorderSizePixel = 0
            Bar.Text = ""
            Bar.Parent = SliderFrame

            local Fill = Instance.new("Frame")
            local fillSize = (default - min) / (max - min)
            Fill.Size = UDim2.new(fillSize, 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(145, 117, 248)
            Fill.BorderSizePixel = 0
            Fill.Parent = Bar

            local draggingValue = false
            local function Update()
                local mousePos = UserInputService:GetMouseLocation().X
                local barPos = Bar.AbsolutePosition.X
                local barSize = Bar.AbsoluteSize.X
                local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
                local value = math.floor(min + (max - min) * percent)
                
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                ValueLabel.Text = tostring(value)
                callback(value)
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingValue = true
                    Update()
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingValue and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update()
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingValue = false
                end
            end)
        end

        return Tab
    end

    return Window
end

return Library
