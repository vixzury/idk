local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Theme configuration
local Theme = {
    Background = Color3.fromRGB(18, 18, 18),
    SidebarBackground = Color3.fromRGB(12, 12, 12),
    Border = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(200, 50, 50),
    Text = Color3.fromRGB(200, 200, 200),
    InactiveText = Color3.fromRGB(130, 130, 130),
    SectionBackground = Color3.fromRGB(22, 22, 22)
}

function Library:Tween(object, data, duration)
    duration = duration or 0.2
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, data)
    tween:Play()
    return tween
end

function Library:MakeDraggable(frame)
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(name)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AntigravityMenu"
    ScreenGui.Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui")) or game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Outer black outline
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local Outline2 = Instance.new("Frame")
    Outline2.Name = "Outline2"
    Outline2.Size = UDim2.new(1, -2, 1, -2)
    Outline2.Position = UDim2.new(0, 1, 0, 1)
    Outline2.BackgroundColor3 = Theme.Border -- Dark grey middle outline
    Outline2.BorderSizePixel = 0
    Outline2.Parent = MainFrame

    local Outline3 = Instance.new("Frame")
    Outline3.Name = "Outline3"
    Outline3.Size = UDim2.new(1, -2, 1, -2)
    Outline3.Position = UDim2.new(0, 1, 0, 1)
    Outline3.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Inner black outline
    Outline3.BorderSizePixel = 0
    Outline3.Parent = Outline2

    local MainBg = Instance.new("Frame")
    MainBg.Name = "MainBg"
    MainBg.Size = UDim2.new(1, -2, 1, -2)
    MainBg.Position = UDim2.new(0, 1, 0, 1)
    MainBg.BackgroundColor3 = Theme.Background
    MainBg.BorderSizePixel = 0
    MainBg.Parent = Outline3

    Library:MakeDraggable(MainFrame)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 120, 1, 0)
    Sidebar.BackgroundColor3 = Theme.SidebarBackground
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainBg

    local SidebarBorder = Instance.new("Frame")
    SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    SidebarBorder.BackgroundColor3 = Theme.Border
    SidebarBorder.BorderSizePixel = 0
    SidebarBorder.Parent = Sidebar

    -- Tab Divider (The box around the tabs)
    local TabDivider = Instance.new("Frame")
    TabDivider.Name = "TabDivider"
    TabDivider.Size = UDim2.new(1, -20, 1, -40)
    TabDivider.Position = UDim2.new(0, 10, 0, 10)
    TabDivider.BackgroundColor3 = Theme.SidebarBackground
    TabDivider.BorderColor3 = Theme.Border
    TabDivider.BorderSizePixel = 1
    TabDivider.Parent = Sidebar

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = TabDivider

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabContainer

    -- Content Area
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -130, 1, -40)
    ContentHolder.Position = UDim2.new(0, 125, 0, 10)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = MainBg

    -- Footer
    local Footer = Instance.new("Frame")
    Footer.Name = "Footer"
    Footer.Size = UDim2.new(1, -120, 0, 25)
    Footer.Position = UDim2.new(0, 120, 1, -25)
    Footer.BackgroundTransparency = 1
    Footer.Parent = MainBg

    local FooterText = Instance.new("TextLabel")
    FooterText.Size = UDim2.new(1, -10, 1, 0)
    FooterText.Position = UDim2.new(0, 0, 0, 0)
    FooterText.BackgroundTransparency = 1
    FooterText.TextXAlignment = Enum.TextXAlignment.Right
    FooterText.Font = Enum.Font.Code
    FooterText.TextSize = 13
    FooterText.TextColor3 = Theme.InactiveText
    FooterText.Parent = Footer

    local function UpdateFooter()
        local date = os.date("%b %d %Y")
        FooterText.Text = date .. " | " .. LocalPlayer.Name
    end
    UpdateFooter()

    -- Object to return
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }

    function Window:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = tabName:lower()
        TabButton.Font = Enum.Font.Code
        TabButton.TextSize = 14
        TabButton.TextColor3 = Theme.InactiveText
        TabButton.Parent = TabContainer

        local TabContent = Instance.new("Frame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentHolder

        local LeftColumn = Instance.new("ScrollingFrame")
        LeftColumn.Name = "LeftColumn"
        LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.BorderSizePixel = 0
        LeftColumn.ScrollBarThickness = 0
        LeftColumn.Parent = TabContent

        local RightColumn = Instance.new("ScrollingFrame")
        RightColumn.Name = "RightColumn"
        RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
        RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
        RightColumn.BackgroundTransparency = 1
        RightColumn.BorderSizePixel = 0
        RightColumn.ScrollBarThickness = 0
        RightColumn.Parent = TabContent

        local LList = Instance.new("UIListLayout"); LList.Padding = UDim.new(0, 10); LList.Parent = LeftColumn
        local RList = Instance.new("UIListLayout"); RList.Padding = UDim.new(0, 10); RList.Parent = RightColumn

        local function Select()
            if Window.CurrentTab then
                Window.CurrentTab.Button.TextColor3 = Theme.InactiveText
                Window.CurrentTab.Content.Visible = false
            end
            
            TabButton.TextColor3 = Theme.Accent
            TabContent.Visible = true
            Window.CurrentTab = {Button = TabButton, Content = TabContent}
        end

        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab and Window.CurrentTab.Button == TabButton then return end
            Library:Tween(TabButton, {TextColor3 = Theme.Text})
        end)

        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab and Window.CurrentTab.Button == TabButton then return end
            Library:Tween(TabButton, {TextColor3 = Theme.InactiveText})
        end)

        TabButton.MouseButton1Click:Connect(Select)

        if not Window.CurrentTab then
            Select()
        end

        local Tab = {}

        function Tab:CreateSection(sectionName, column)
            local columnFrame = (column == 2 and RightColumn) or LeftColumn
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName .. "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 30) -- Height will auto-adjust
            SectionFrame.BackgroundColor3 = Theme.SectionBackground
            SectionFrame.BorderSizePixel = 1
            SectionFrame.BorderColor3 = Theme.Border
            SectionFrame.Parent = columnFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -10, 0, 20)
            SectionTitle.Position = UDim2.new(0, 10, 0, -10)
            SectionTitle.BackgroundColor3 = Theme.Background -- Hack to make title overlap border
            SectionTitle.Text = " " .. sectionName:lower() .. " "
            SectionTitle.Font = Enum.Font.Code
            SectionTitle.TextSize = 13
            SectionTitle.TextColor3 = Theme.Text
            SectionTitle.Parent = SectionFrame
            
            -- Simple text size adjustment for the title
            local txSize = game:GetService("TextService"):GetTextSize(SectionTitle.Text, SectionTitle.TextSize, SectionTitle.Font, Vector2.new(1000, 1000))
            SectionTitle.Size = UDim2.new(0, txSize.X, 0, 20)
            
            local SectionContainer = Instance.new("Frame")
            SectionContainer.Name = "Container"
            SectionContainer.Size = UDim2.new(1, -20, 1, -15)
            SectionContainer.Position = UDim2.new(0, 10, 0, 10)
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.Parent = SectionFrame
            
            local SList = Instance.new("UIListLayout")
            SList.Padding = UDim.new(0, 5)
            SList.Parent = SectionContainer
            
            SList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, SList.AbsoluteContentSize.Y + 25)
            end)

            return {
                Container = SectionContainer
            }
        end

        return Tab
    end

    return Window
end

return Library
