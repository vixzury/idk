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

    -- Main Container (The absolute outside)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 560, 0, 420)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Internal Style Borders (Triple layer)
    local Border1 = Instance.new("Frame") -- Outer dark
    Border1.Name = "Border1"
    Border1.Size = UDim2.new(1, 2, 1, 2)
    Border1.Position = UDim2.new(0, -1, 0, -1)
    Border1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Border1.BorderSizePixel = 0
    Border1.ZIndex = 0
    Border1.Parent = MainFrame

    local Border2 = Instance.new("Frame") -- Inner thin accent (Black)
    Border2.Name = "Border2"
    Border2.Size = UDim2.new(1, 4, 1, 4)
    Border2.Position = UDim2.new(0, -2, 0, -2)
    Border2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Border2.BorderSizePixel = 0
    Border2.ZIndex = -1
    Border2.Parent = MainFrame

    local Border3 = Instance.new("Frame") -- Outermost dark
    Border3.Name = "Border3"
    Border3.Size = UDim2.new(1, 6, 1, 6)
    Border3.Position = UDim2.new(0, -3, 0, -3)
    Border3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Border3.BorderSizePixel = 0
    Border3.ZIndex = -2
    Border3.Parent = MainFrame

    -- Main Content Area (Slightly darker)
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

    -- Bottom Status Bar
    local StatusBar = Instance.new("Frame")
    StatusBar.Name = "StatusBar"
    StatusBar.Size = UDim2.new(1, -10, 0, 20)
    StatusBar.Position = UDim2.new(0, 5, 1, -25)
    StatusBar.BackgroundTransparency = 1
    StatusBar.Parent = MainFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(1, -5, 1, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = os.date("%b %d %Y") .. " | " .. LocalPlayer.Name:lower()
    StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Code -- Monospaced feel
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
    StatusLabel.Parent = StatusBar

    -- Sidebar (Tabs)
    local SidebarArea = Instance.new("Frame")
    SidebarArea.Name = "SidebarArea"
    SidebarArea.Size = UDim2.new(0, 100, 1, -40)
    SidebarArea.Position = UDim2.new(0, 10, 0, 10)
    SidebarArea.BackgroundTransparency = 1
    SidebarArea.Parent = InnerFrame

    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Color = Color3.fromRGB(35, 35, 35)
    SidebarStroke.Thickness = 1
    SidebarStroke.Parent = SidebarArea

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = SidebarArea

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabContainer

    -- Content Area (Container for Tab Pages)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -120, 1, -10)
    ContentArea.Position = UDim2.new(0, 115, 0, 10)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = InnerFrame

    -- Dragging Logic (Existing code)
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Toggle Menu Visibility (Existing code)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    local Window = {
        Main = MainFrame,
        Inner = InnerFrame,
        Tabs = {},
        CurrentTab = nil
    }

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name .. "Tab"
        TabBtn.Size = UDim2.new(1, 0, 0, 20)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.Parent = TabContainer

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, 0, 1, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name:lower()
        TabLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabLabel.TextSize = 13
        TabLabel.Font = Enum.Font.Code
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabBtn

        local Page = Instance.new("Frame")
        Page.Name = name .. "Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.Parent = ContentArea

        local Tab = {
            Page = Page,
            Label = TabLabel
        }

        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Page.Visible = false
                Window.CurrentTab.Label.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            
            Page.Visible = true
            TabLabel.TextColor3 = Color3.fromRGB(255, 60, 60) -- Classic Red accent
            Window.CurrentTab = Tab
        end)

        -- Set first tab as default
        if not Window.CurrentTab then
            Page.Visible = true
            TabLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
            Window.CurrentTab = Tab
        end

        return Tab
    end

    return Window
end

return Library
