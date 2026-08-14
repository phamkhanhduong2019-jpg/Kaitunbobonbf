-- Blox Fruits Status Menu - EXACT COLORS
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

-- Variables
local MenuVisible = true

-- COLORS (từ ảnh)
local COLOR_BACKGROUND = Color3.fromRGB(15, 25, 35) -- Xanh đen đậm
local COLOR_BORDER = Color3.fromRGB(218, 165, 32) -- Vàng cam (goldenrod)
local COLOR_TITLE = Color3.fromRGB(218, 165, 32) -- Vàng cam
local COLOR_TEXT_WHITE = Color3.fromRGB(255, 255, 255) -- Trắng
local COLOR_LINE = Color3.fromRGB(255, 255, 255) -- Trắng

-- Toggle Button (Nhỏ hơn)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleBtn"
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 0.35, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 220, 170)
ToggleButton.BorderSizePixel = 0
ToggleButton.Image = ""
ToggleButton.Parent = ScreenGui

local ToggleBtnCorner = Instance.new("UICorner")
ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
ToggleBtnCorner.Parent = ToggleButton

local ToggleBtnStroke = Instance.new("UIStroke")
ToggleBtnStroke.Color = Color3.fromRGB(80, 80, 80)
ToggleBtnStroke.Thickness = 2
ToggleBtnStroke.Parent = ToggleButton

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Size = UDim2.new(1, 0, 1, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "OFF"
ToggleLabel.TextColor3 = Color3.fromRGB(30, 30, 30)
ToggleLabel.TextSize = 18
ToggleLabel.Font = Enum.Font.GothamBold
ToggleLabel.Parent = ToggleButton

-- Status Bar (Top)
local StatusBar = Instance.new("Frame")
StatusBar.Name = "StatusBar"
StatusBar.Size = UDim2.new(0, 380, 0, 60)
StatusBar.Position = UDim2.new(0.5, -190, 0.06, 0)
StatusBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- ĐEN THUẦN
StatusBar.BackgroundTransparency = 0.2
StatusBar.BorderSizePixel = 0
StatusBar.Visible = true
StatusBar.Parent = ScreenGui

local StatusBarCorner = Instance.new("UICorner")
StatusBarCorner.CornerRadius = UDim.new(0, 5)
StatusBarCorner.Parent = StatusBar

local StatusBarStroke = Instance.new("UIStroke")
StatusBarStroke.Color = COLOR_BORDER -- VÀNG CAM
StatusBarStroke.Thickness = 2
StatusBarStroke.Parent = StatusBar

local StatusFarm = Instance.new("TextLabel")
StatusFarm.Size = UDim2.new(1, -20, 0, 28)
StatusFarm.Position = UDim2.new(0, 10, 0, 4)
StatusFarm.BackgroundTransparency = 1
StatusFarm.Text = "Status Farm : Take Quest"
StatusFarm.TextColor3 = COLOR_TITLE -- VÀNG CAM
StatusFarm.TextSize = 16
StatusFarm.Font = Enum.Font.GothamBold
StatusFarm.TextXAlignment = Enum.TextXAlignment.Center
StatusFarm.Parent = StatusBar

local StatusItem = Instance.new("TextLabel")
StatusItem.Size = UDim2.new(1, -20, 0, 28)
StatusItem.Position = UDim2.new(0, 10, 0, 32)
StatusItem.BackgroundTransparency = 1
StatusItem.Text = "Status Item : None"
StatusItem.TextColor3 = COLOR_TITLE -- VÀNG CAM
StatusItem.TextSize = 16
StatusItem.Font = Enum.Font.GothamBold
StatusItem.TextXAlignment = Enum.TextXAlignment.Center
StatusItem.Parent = StatusBar

-- Discord Link
local DiscordLink = Instance.new("TextButton")
DiscordLink.Size = UDim2.new(0, 220, 0, 25)
DiscordLink.Position = UDim2.new(0.5, -110, 0.025, 0)
DiscordLink.BackgroundTransparency = 1
DiscordLink.Text = "discord.gg/chuoihub"
DiscordLink.TextColor3 = COLOR_TITLE -- VÀNG CAM
DiscordLink.TextSize = 15
DiscordLink.Font = Enum.Font.GothamBold
DiscordLink.Visible = true
DiscordLink.Parent = ScreenGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 220)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -110)
MainFrame.BackgroundColor3 = COLOR_BACKGROUND -- XANH ĐEN ĐẬM
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 8)
MainFrameCorner.Parent = MainFrame

local MainFrameStroke = Instance.new("UIStroke")
MainFrameStroke.Color = COLOR_BORDER -- VIỀN VÀNG CAM
MainFrameStroke.Thickness = 3
MainFrameStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Banana Stats Checker"
Title.TextColor3 = COLOR_TITLE -- VÀNG CAM
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Gạch ngang trên
local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(0.9, 0, 0, 2)
TitleLine.Position = UDim2.new(0.05, 0, 0, 38)
TitleLine.BackgroundColor3 = COLOR_LINE -- TRẮNG
TitleLine.BorderSizePixel = 0
TitleLine.Parent = MainFrame

-- Account Stats (Left)
local AccountStatsTitle = Instance.new("TextLabel")
AccountStatsTitle.Size = UDim2.new(0.45, 0, 0, 25)
AccountStatsTitle.Position = UDim2.new(0.05, 0, 0, 45)
AccountStatsTitle.BackgroundTransparency = 1
AccountStatsTitle.Text = "Account Stats"
AccountStatsTitle.TextColor3 = COLOR_TITLE -- VÀNG CAM
AccountStatsTitle.TextSize = 16
AccountStatsTitle.Font = Enum.Font.GothamBold
AccountStatsTitle.TextXAlignment = Enum.TextXAlignment.Left
AccountStatsTitle.Parent = MainFrame

local LevelLabel = Instance.new("TextLabel")
LevelLabel.Size = UDim2.new(0.45, 0, 0, 22)
LevelLabel.Position = UDim2.new(0.05, 0, 0, 75)
LevelLabel.BackgroundTransparency = 1
LevelLabel.Text = "Level: 2800"
LevelLabel.TextColor3 = COLOR_TEXT_WHITE -- TRẮNG
LevelLabel.TextSize = 14
LevelLabel.Font = Enum.Font.GothamBold
LevelLabel.TextXAlignment = Enum.TextXAlignment.Left
LevelLabel.Parent = MainFrame

local RaceLabel = Instance.new("TextLabel")
RaceLabel.Size = UDim2.new(0.45, 0, 0, 22)
RaceLabel.Position = UDim2.new(0.05, 0, 0, 100)
RaceLabel.BackgroundTransparency = 1
RaceLabel.Text = "Race: Ghoul"
RaceLabel.TextColor3 = COLOR_TEXT_WHITE -- TRẮNG
RaceLabel.TextSize = 14
RaceLabel.Font = Enum.Font.GothamBold
RaceLabel.TextXAlignment = Enum.TextXAlignment.Left
RaceLabel.Parent = MainFrame

local BeliLabel = Instance.new("TextLabel")
BeliLabel.Size = UDim2.new(0.45, 0, 0, 22)
BeliLabel.Position = UDim2.new(0.05, 0, 0, 125)
BeliLabel.BackgroundTransparency = 1
BeliLabel.Text = "Beli: 7,880,375"
BeliLabel.TextColor3 = COLOR_TEXT_WHITE -- TRẮNG
BeliLabel.TextSize = 14
BeliLabel.Font = Enum.Font.GothamBold
BeliLabel.TextXAlignment = Enum.TextXAlignment.Left
BeliLabel.Parent = MainFrame

local FragLabel = Instance.new("TextLabel")
FragLabel.Size = UDim2.new(0.45, 0, 0, 22)
FragLabel.Position = UDim2.new(0.05, 0, 0, 150)
FragLabel.BackgroundTransparency = 1
FragLabel.Text = "Frag: 5,228"
FragLabel.TextColor3 = COLOR_TEXT_WHITE -- TRẮNG
FragLabel.TextSize = 14
FragLabel.Font = Enum.Font.GothamBold
FragLabel.TextXAlignment = Enum.TextXAlignment.Left
FragLabel.Parent = MainFrame

-- Account Items (Right)
local AccountItemsTitle = Instance.new("TextLabel")
AccountItemsTitle.Size = UDim2.new(0.45, 0, 0, 25)
AccountItemsTitle.Position = UDim2.new(0.52, 0, 0, 45)
AccountItemsTitle.BackgroundTransparency = 1
AccountItemsTitle.Text = "Account Items"
AccountItemsTitle.TextColor3 = COLOR_TITLE -- VÀNG CAM
AccountItemsTitle.TextSize = 16
AccountItemsTitle.Font = Enum.Font.GothamBold
AccountItemsTitle.TextXAlignment = Enum.TextXAlignment.Left
AccountItemsTitle.Parent = MainFrame

-- Gạch ngang dưới
local BottomLine = Instance.new("Frame")
BottomLine.Size = UDim2.new(0.9, 0, 0, 2)
BottomLine.Position = UDim2.new(0.05, 0, 0, 180)
BottomLine.BackgroundColor3 = COLOR_LINE -- TRẮNG
BottomLine.BorderSizePixel = 0
BottomLine.Parent = MainFrame

local ItemLabel1 = Instance.new("TextLabel")
ItemLabel1.Size = UDim2.new(0.45, 0, 0, 22)
ItemLabel1.Position = UDim2.new(0.52, 0, 0, 188)
ItemLabel1.BackgroundTransparency = 1
ItemLabel1.Text = "Label"
ItemLabel1.TextColor3 = COLOR_TEXT_WHITE -- TRẮNG
ItemLabel1.TextSize = 14
ItemLabel1.Font = Enum.Font.GothamBold
ItemLabel1.TextXAlignment = Enum.TextXAlignment.Right
ItemLabel1.Parent = MainFrame

-- Draggable Toggle Button
local draggingToggle, dragInputToggle, dragStartToggle, startPosToggle

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = true
        dragStartToggle = input.Position
        startPosToggle = ToggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingToggle = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputToggle = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputToggle and draggingToggle then
        local delta = input.Position - dragStartToggle
        ToggleButton.Position = UDim2.new(startPosToggle.X.Scale, startPosToggle.X.Offset + delta.X, startPosToggle.Y.Scale, startPosToggle.Y.Offset + delta.Y)
    end
end)

-- Draggable Main Frame
local dragging, dragInput, dragStart, startPos

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

-- Toggle Function
ToggleButton.MouseButton1Click:Connect(function()
    if not draggingToggle then
        MenuVisible = not MenuVisible
        MainFrame.Visible = MenuVisible
        StatusBar.Visible = MenuVisible
        DiscordLink.Visible = MenuVisible
        ToggleLabel.Text = MenuVisible and "ON" or "OFF"
    end
end)

-- Update Stats Function
local function UpdateStats()
    local player = LocalPlayer
    local level = player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") and player.Data.Level.Value or 2800
    LevelLabel.Text = "Level: " .. tostring(level)

    local beli = player:FindFirstChild("Data") and player.Data:FindFirstChild("Beli") and player.Data.Beli.Value or 7880375
    BeliLabel.Text = "Beli: " .. string.format("%,d", beli):gsub(",", ",")

    local race = player:FindFirstChild("Data") and player.Data:FindFirstChild("Race") and player.Data.Race.Value or "Ghoul"
    RaceLabel.Text = "Race: " .. race

    local frag = player:FindFirstChild("Data") and player.Data:FindFirstChild("Fragments") and player.Data.Fragments.Value or 5228
    FragLabel.Text = "Frag: " .. string.format("%,d", frag):gsub(",", ",")
end

spawn(function()
    while wait(1) do
        UpdateStats()
    end
end)

print("✅ Blox Fruits Menu - EXACT COLORS MATCHED!")
