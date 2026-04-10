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

    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 480)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.Parent = ScreenGui

    -- Internal borders
    local b1 = Instance.new("Frame", MainFrame) b1.Size = UDim2.new(1,2,1,2) b1.Position = UDim2.new(0,-1,0,-1) b1.BackgroundColor3 = Color3.fromRGB(40,40,40) b1.ZIndex = 0 b1.BorderSizePixel = 0
    local b2 = Instance.new("Frame", MainFrame) b2.Size = UDim2.new(1,4,1,4) b2.Position = UDim2.new(0,-2,0,-2) b2.BackgroundColor3 = Color3.fromRGB(0,0,0) b2.ZIndex = -1 b2.BorderSizePixel = 0
    local b3 = Instance.new("Frame", MainFrame) b3.Size = UDim2.new(1,6,1,6) b3.Position = UDim2.new(0,-3,0,-3) b3.BackgroundColor3 = Color3.fromRGB(50,50,50) b3.ZIndex = -2 b3.BorderSizePixel = 0

    local InnerFrame = Instance.new("Frame", MainFrame)
    InnerFrame.Size = UDim2.new(1,-10,1,-10) InnerFrame.Position = UDim2.new(0,5,0,5) InnerFrame.BackgroundColor3 = Color3.fromRGB(18,18,18) InnerFrame.BorderSizePixel = 0
    Instance.new("UIStroke", InnerFrame).Color = Color3.fromRGB(35,35,35)

    local StatusLabel = Instance.new("TextLabel", MainFrame)
    StatusLabel.Size = UDim2.new(1,-15,0,20) StatusLabel.Position = UDim2.new(0,10,1,-25) StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = os.date("%b %d %Y") .. " | " .. LocalPlayer.Name:lower()
    StatusLabel.TextColor3 = Color3.fromRGB(120,120,120) StatusLabel.TextSize = 12 StatusLabel.Font = Enum.Font.Code StatusLabel.TextXAlignment = Enum.TextXAlignment.Right

    local SidebarArea = Instance.new("Frame", InnerFrame)
    SidebarArea.Size = UDim2.new(0,140,1,-45) SidebarArea.Position = UDim2.new(0,10,0,10) SidebarArea.BackgroundTransparency = 1
    Instance.new("UIStroke", SidebarArea).Color = Color3.fromRGB(35,35,35)

    local TabContainer = Instance.new("ScrollingFrame", SidebarArea)
    TabContainer.Size = UDim2.new(1,-10,1,-10) TabContainer.Position = UDim2.new(0,5,0,5) TabContainer.BackgroundTransparency = 1 TabContainer.BorderSizePixel = 0 TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0,5)

    local ContentArea = Instance.new("Frame", InnerFrame)
    ContentArea.Size = UDim2.new(1,-165,1,-10) ContentArea.Position = UDim2.new(0,155,0,10) ContentArea.BackgroundTransparency = 1

    -- Dragging
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = MainFrame.Position
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
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1,0,0,30) TabBtn.BackgroundTransparency = 1 TabBtn.Text = ""
        local TabLabel = Instance.new("TextLabel", TabBtn)
        TabLabel.Size = UDim2.new(1,0,1,0) TabLabel.BackgroundTransparency = 1 TabLabel.Text = name:upper() TabLabel.TextColor3 = Color3.fromRGB(180,180,180) TabLabel.TextSize = 14 TabLabel.Font = Enum.Font.GothamBold TabLabel.TextXAlignment = Enum.TextXAlignment.Left

        local Page = Instance.new("Frame", ContentArea)
        Page.Size = UDim2.new(1,0,1,0) Page.BackgroundTransparency = 1 Page.Visible = false
        local Tab = {Page = Page, Label = TabLabel}

        local LeftCol = Instance.new("ScrollingFrame", Page) LeftCol.Size = UDim2.new(0.5,-5,1,0) LeftCol.BackgroundTransparency = 1 LeftCol.BorderSizePixel = 0 LeftCol.ScrollBarThickness = 0 Instance.new("UIListLayout", LeftCol).Padding = UDim.new(0,15)
        local RightCol = Instance.new("ScrollingFrame", Page) RightCol.Size = UDim2.new(0.5,-5,1,0) RightCol.Position = UDim2.new(0.5,5,0,0) RightCol.BackgroundTransparency = 1 RightCol.BorderSizePixel = 0 RightCol.ScrollBarThickness = 0 Instance.new("UIListLayout", RightCol).Padding = UDim.new(0,15)

        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then Window.CurrentTab.Page.Visible = false Window.CurrentTab.Label.TextColor3 = Color3.fromRGB(180,180,180) end
            Page.Visible = true TabLabel.TextColor3 = Color3.fromRGB(255,60,60) Window.CurrentTab = Tab
        end)

        if not Window.CurrentTab then Page.Visible = true TabLabel.TextColor3 = Color3.fromRGB(255,60,60) Window.CurrentTab = Tab end

        function Tab:AddGroupbox(title, side)
            local Column = (side:lower() == "left") and LeftCol or RightCol
            local Group = Instance.new("Frame", Column) Group.Size = UDim2.new(1,0,0,30) Group.BackgroundColor3 = Color3.fromRGB(22,22,22) Group.BorderSizePixel = 0 Instance.new("UIStroke", Group).Color = Color3.fromRGB(35,35,35)
            local GTitle = Instance.new("TextLabel", Group) GTitle.Position = UDim2.new(0,10,0,-8) GTitle.BackgroundColor3 = Color3.fromRGB(18,18,18) GTitle.Text = " " .. title:upper() .. " " GTitle.TextColor3 = Color3.fromRGB(255,60,60) GTitle.TextSize = 12 GTitle.Font = Enum.Font.GothamBold GTitle.Size = UDim2.new(0,GTitle.TextBounds.X+6,0,15)
            local Container = Instance.new("Frame", Group) Container.Size = UDim2.new(1,-20,1,-20) Container.Position = UDim2.new(0,10,0,15) Container.BackgroundTransparency = 1
            local List = Instance.new("UIListLayout", Container) List.Padding = UDim.new(0,5)
            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Group.Size = UDim2.new(1,0,0,List.AbsoluteContentSize.Y+30) end)

            local Groupbox = {}
            function Groupbox:AddToggle(text, default, callback)
                local TB = Instance.new("TextButton", Container) TB.Size = UDim2.new(1,0,0,20) TB.BackgroundTransparency = 1 TB.Text = ""
                local CB = Instance.new("Frame", TB) CB.Size = UDim2.new(0,10,0,10) CB.Position = UDim2.new(0,0,0.5,0) CB.AnchorPoint = Vector2.new(0,0.5) CB.BackgroundColor3 = default and Color3.fromRGB(255,60,60) or Color3.fromRGB(40,40,40) CB.BorderSizePixel = 0
                local L = Instance.new("TextLabel", TB) L.Size = UDim2.new(1,-15,1,0) L.Position = UDim2.new(0,15,0,0) L.BackgroundTransparency = 1 L.Text = text:lower() L.TextColor3 = Color3.fromRGB(180,180,180) L.TextSize = 12 L.Font = Enum.Font.Code L.TextXAlignment = Enum.TextXAlignment.Left
                local active = default
                TB.MouseButton1Click:Connect(function() active = not active CB.BackgroundColor3 = active and Color3.fromRGB(255,60,60) or Color3.fromRGB(40,40,40) callback(active) end)
            end

            function Groupbox:AddSlider(text, min, max, default, callback)
                local SF = Instance.new("Frame", Container) SF.Size = UDim2.new(1,0,0,30) SF.BackgroundTransparency = 1
                local L = Instance.new("TextLabel", SF) L.Size = UDim2.new(1,0,0,15) L.BackgroundTransparency = 1 L.Text = text:lower() L.TextColor3 = Color3.fromRGB(180,180,180) L.TextSize = 12 L.Font = Enum.Font.Code L.TextXAlignment = Enum.TextXAlignment.Left
                local Bar = Instance.new("TextButton", SF) Bar.Size = UDim2.new(1,0,0,4) Bar.Position = UDim2.new(0,0,1,-5) Bar.BackgroundColor3 = Color3.fromRGB(40,40,40) Bar.BorderSizePixel = 0 Bar.Text = ""
                local F = Instance.new("Frame", Bar) F.Size = UDim2.new((default-min)/(max-min), 0, 1, 0) F.BackgroundColor3 = Color3.fromRGB(255,60,60) F.BorderSizePixel = 0
                local drg = false
                local function Upd() local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1) F.Size = UDim2.new(p,0,1,0) callback(math.floor(min + (max - min) * p)) end
                Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drg = true Upd() end end)
                UserInputService.InputChanged:Connect(function(i) if drg and i.UserInputType == Enum.UserInputType.MouseMovement then Upd() end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drg = false end end)
            end

            function Groupbox:AddDropdown(text, options, callback)
                local DropFrame = Instance.new("Frame", Container)
                DropFrame.Size = UDim2.new(1,0,0,35) DropFrame.BackgroundTransparency = 1

                local Label = Instance.new("TextLabel", DropFrame)
                Label.Size = UDim2.new(1,0,0,15) Label.BackgroundTransparency = 1 Label.Text = text:lower() Label.TextColor3 = Color3.fromRGB(180,180,180) Label.TextSize = 12 Label.Font = Enum.Font.Code Label.TextXAlignment = Enum.TextXAlignment.Left

                local MainBtn = Instance.new("TextButton", DropFrame)
                MainBtn.Size = UDim2.new(1,0,0,18) MainBtn.Position = UDim2.new(0,0,1,-18) MainBtn.BackgroundColor3 = Color3.fromRGB(25,25,25) MainBtn.BorderSizePixel = 0 MainBtn.Text = options[1] or "None" MainBtn.TextColor3 = Color3.fromRGB(200,200,200) MainBtn.TextSize = 12 MainBtn.Font = Enum.Font.Code MainBtn.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("UIStroke", MainBtn).Color = Color3.fromRGB(40,40,40)
                local Padding = Instance.new("UIPadding", MainBtn) Padding.PaddingLeft = UDim.new(0,5)

                local OptionsList = Instance.new("ScrollingFrame", MainFrame) -- Global list
                OptionsList.Size = UDim2.new(0, MainBtn.AbsoluteSize.X, 0, math.min(#options * 20, 100)) OptionsList.Position = UDim2.new(0, MainBtn.AbsolutePosition.X, 0, MainBtn.AbsolutePosition.Y + 18) OptionsList.BackgroundColor3 = Color3.fromRGB(25,25,25) OptionsList.BorderSizePixel = 0 OptionsList.Visible = false OptionsList.ZIndex = 5 OptionsList.ScrollBarThickness = 0
                Instance.new("UIStroke", OptionsList).Color = Color3.fromRGB(40,40,40)
                local OptListLay = Instance.new("UIListLayout", OptionsList)

                MainBtn.MouseButton1Click:Connect(function()
                    OptionsList.Visible = not OptionsList.Visible
                    OptionsList.Position = UDim2.new(0, MainBtn.AbsolutePosition.X, 0, MainBtn.AbsolutePosition.Y + 18)
                    OptionsList.Size = UDim2.new(0, MainBtn.AbsoluteSize.X, 0, math.min(#options * 20, 100))
                end)

                for _, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton", OptionsList)
                    OptBtn.Size = UDim2.new(1,0,0,20) OptBtn.BackgroundColor3 = Color3.fromRGB(25,25,25) OptBtn.BorderSizePixel = 0 OptBtn.Text = opt OptBtn.TextColor3 = Color3.fromRGB(150,150,150) OptBtn.TextSize = 12 OptBtn.Font = Enum.Font.Code OptBtn.ZIndex = 6
                    OptBtn.MouseButton1Click:Connect(function()
                        MainBtn.Text = opt callback(opt) OptionsList.Visible = false
                    end)
                    OptBtn.MouseEnter:Connect(function() OptBtn.TextColor3 = Color3.fromRGB(255,60,60) end)
                    OptBtn.MouseLeave:Connect(function() OptBtn.TextColor3 = Color3.fromRGB(150,150,150) end)
                end
            end
            return Groupbox
        end
        return Tab
    end
    return Window
end

return Library
