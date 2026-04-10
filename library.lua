local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Themes = {
    Background = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(18, 18, 18),
    Border = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(255, 51, 51),
    Text = Color3.fromRGB(200, 200, 200),
    InactiveText = Color3.fromRGB(120, 120, 120)
}

local function Tween(obj, info, goal)
    local tween = TweenService:Create(obj, info, goal)
    tween:Play()
    return tween
end

function Library:CreateWindow(title, footer)
    local UI = Instance.new("ScreenGui")
    UI.Name = title or "Menu"
    UI.Parent = CoreGui
    UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 550, 0, 400)
    Main.Position = UDim2.new(0.5, -275, 0.5, -200)
    Main.BackgroundColor3 = Themes.Background
    Main.BorderSizePixel = 0
    Main.Parent = UI

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Themes.Border
    Stroke.Thickness = 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Main

    -- Draggable
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 130, 1, -2)
    Sidebar.Position = UDim2.new(0, 1, 0, 1)
    Sidebar.BackgroundColor3 = Themes.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, 0, 0, 0)
    SidebarLine.BackgroundColor3 = Themes.Border
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = Sidebar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -10, 1, -20)
    TabContainer.Position = UDim2.new(0, 5, 0, 10)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 8)
    TabList.Parent = TabContainer

    local Footer = Instance.new("TextLabel")
    Footer.Size = UDim2.new(0, 200, 0, 20)
    Footer.Position = UDim2.new(1, -205, 1, -20)
    Footer.BackgroundTransparency = 1
    Footer.Text = footer or "Menu Library | v1.0.0"
    Footer.TextColor3 = Themes.InactiveText
    Footer.TextXAlignment = Enum.TextXAlignment.Right
    Footer.Font = Enum.Font.RobotoMono
    Footer.TextSize = 12
    Footer.Parent = Main

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -145, 1, -40)
    Container.Position = UDim2.new(0, 140, 0, 10)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local Tabs = {}
    local FirstTab = nil

    function Tabs:AddTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 20)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = name
        TabButton.TextColor3 = Themes.InactiveText
        TabButton.Font = Enum.Font.RobotoMono
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = TabContainer

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Visible = false
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = Themes.Accent
        TabContent.Parent = Container

        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 10)
        ContentList.Parent = TabContent

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then 
                    Tween(v, TweenInfo.new(0.2), {TextColor3 = Themes.InactiveText})
                end
            end
            TabContent.Visible = true
            Tween(TabButton, TweenInfo.new(0.2), {TextColor3 = Themes.Accent})
        end)

        if not FirstTab then
            FirstTab = TabButton
            TabContent.Visible = true
            TabButton.TextColor3 = Themes.Accent
        end

        local Sections = {}

        function Sections:AddSection(name)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name .. "Section"
            SectionFrame.Size = UDim2.new(1, -10, 0, 0)
            SectionFrame.BackgroundColor3 = Themes.Sidebar
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent

            local SectionStroke = Instance.new("UIStroke")
            SectionStroke.Color = Themes.Border
            SectionStroke.Thickness = 1
            SectionStroke.Parent = SectionFrame

            local SectionList = Instance.new("UIListLayout")
            SectionList.Padding = UDim.new(0, 8)
            SectionList.Parent = SectionFrame

            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.PaddingLeft = UDim.new(0, 10)
            SectionPadding.PaddingRight = UDim.new(0, 10)
            SectionPadding.PaddingTop = UDim.new(0, 10)
            SectionPadding.PaddingBottom = UDim.new(0, 10)
            SectionPadding.Parent = SectionFrame

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, 0, 0, 15)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = name:upper()
            SectionTitle.TextColor3 = Themes.Accent
            SectionTitle.Font = Enum.Font.RobotoMono
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame

            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, -10, 0, SectionList.AbsoluteContentSize.Y + 20)
            end)

            local Elements = {}

            function Elements:AddToggle(text, default, callback)
                local Toggle = Instance.new("TextButton")
                Toggle.Size = UDim2.new(1, 0, 0, 20)
                Toggle.BackgroundTransparency = 1
                Toggle.Text = ""
                Toggle.Parent = SectionFrame

                local ToggleText = Instance.new("TextLabel")
                ToggleText.Size = UDim2.new(1, -30, 1, 0)
                ToggleText.BackgroundTransparency = 1
                ToggleText.Text = text
                ToggleText.TextColor3 = Themes.Text
                ToggleText.Font = Enum.Font.RobotoMono
                ToggleText.TextSize = 14
                ToggleText.TextXAlignment = Enum.TextXAlignment.Left
                ToggleText.Parent = Toggle

                local Box = Instance.new("Frame")
                Box.Size = UDim2.new(0, 16, 0, 16)
                Box.Position = UDim2.new(1, -16, 0.5, -8)
                Box.BackgroundColor3 = Themes.Background
                Box.BorderSizePixel = 0
                Box.Parent = Toggle

                local BoxStroke = Instance.new("UIStroke")
                BoxStroke.Color = Themes.Border
                BoxStroke.Thickness = 1
                BoxStroke.Parent = Box

                local Check = Instance.new("Frame")
                Check.Size = UDim2.new(1, -4, 1, -4)
                Check.Position = UDim2.new(0, 2, 0, 2)
                Check.BackgroundColor3 = Themes.Accent
                Check.BorderSizePixel = 0
                Check.BackgroundTransparency = default and 0 or 1
                Check.Parent = Box

                local Enabled = default or false
                Toggle.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    Tween(Check, TweenInfo.new(0.2), {BackgroundTransparency = Enabled and 0 or 1})
                    callback(Enabled)
                end)

                return {
                    Set = function(val)
                        Enabled = val
                        Check.BackgroundTransparency = Enabled and 0 or 1
                        callback(Enabled)
                    end
                }
            end

            function Elements:AddSlider(text, min, max, default, callback)
                local Slider = Instance.new("Frame")
                Slider.Size = UDim2.new(1, 0, 0, 35)
                Slider.BackgroundTransparency = 1
                Slider.Parent = SectionFrame

                local SliderText = Instance.new("TextLabel")
                SliderText.Size = UDim2.new(1, 0, 0, 15)
                SliderText.BackgroundTransparency = 1
                SliderText.Text = text
                SliderText.TextColor3 = Themes.Text
                SliderText.Font = Enum.Font.RobotoMono
                SliderText.TextSize = 14
                SliderText.TextXAlignment = Enum.TextXAlignment.Left
                SliderText.Parent = Slider

                local ValueText = Instance.new("TextLabel")
                ValueText.Size = UDim2.new(1, 0, 0, 15)
                ValueText.BackgroundTransparency = 1
                ValueText.Text = tostring(default)
                ValueText.TextColor3 = Themes.InactiveText
                ValueText.Font = Enum.Font.RobotoMono
                ValueText.TextSize = 14
                ValueText.TextXAlignment = Enum.TextXAlignment.Right
                ValueText.Parent = Slider

                local Bar = Instance.new("Frame")
                Bar.Size = UDim2.new(1, 0, 0, 4)
                Bar.Position = UDim2.new(0, 0, 0, 25)
                Bar.BackgroundColor3 = Themes.Background
                Bar.BorderSizePixel = 0
                Bar.Parent = Slider

                local BarStroke = Instance.new("UIStroke")
                BarStroke.Color = Themes.Border
                BarStroke.Thickness = 1
                BarStroke.Parent = Bar

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = Themes.Accent
                Fill.BorderSizePixel = 0
                Fill.Parent = Bar

                local dragging = false
                local function Update()
                    local mousePos = UserInputService:GetMouseLocation().X
                    local barPos = Bar.AbsolutePosition.X
                    local barWidth = Bar.AbsoluteSize.X
                    local percent = math.clamp((mousePos - barPos) / barWidth, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    
                    Fill.Size = UDim2.new(percent, 0, 1, 0)
                    ValueText.Text = tostring(value)
                    callback(value)
                end

                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        Update()
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        Update()
                    end
                end)
            end

            return Elements
        end

        return Sections
    end

    return Tabs
end

return Library
