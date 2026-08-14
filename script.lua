-- Blox Fruits Status Menu - ĐÚNG THEO ẢNH MẪU
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MenuVisible = true

-- COLORS
local COLOR_BG = Color3.fromRGB(8, 15, 22)
local COLOR_BORDER = Color3.fromRGB(218, 165, 32)
local COLOR_TITLE = Color3.fromRGB(218, 165, 32)
local COLOR_TEXT = Color3.fromRGB(255, 255, 255)

-- Toggle Button (NHỎ)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 0.35, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 220, 150)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

-- Discord Link
local DiscordLink = Instance.new("TextLabel")
DiscordLink.Size = UDim2.new(0, 200, 0, 20)
DiscordLink.Position = UDim2.new(0.5, -100, 0.03, 0)
DiscordLink.BackgroundTransparency = 1
DiscordLink.Text = "discord.gg/chuoihub"
DiscordLink.TextColor3 = COLOR_TITLE
DiscordLink.TextSize = 13
DiscordLink.Font = Enum.Font.GothamBold
DiscordLink.Visible = true
DiscordLink.Parent = ScreenGui

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(0, 370, 0, 55)
StatusBar.Position = UDim2.new(0.5, -185, 0.07, 0)
StatusBar.BackgroundColor3 = COLOR_BG
StatusBar.BackgroundTransparency = 0.2
StatusBar.BorderSizePixel = 0
StatusBar.Visible = true
StatusBar.Parent = ScreenGui

local StatusBarCorner = Instance.new("UICorner")
StatusBarCorner.CornerRadius = UDim.new(0, 5)
StatusBarCorner.Parent = StatusBar

local StatusBarStroke = Instance.new("UIStroke")
StatusBarStroke.Color = COLOR_BORDER
StatusBarStroke.Thickness = 2
StatusBarStroke.Parent = StatusBar

local StatusFarm = Instance.new("TextLabel")
StatusFarm.Size = UDim2.new(1, -10, 0, 25)
StatusFarm.Position = UDim2.new(0, 5, 0, 3)
StatusFarm.BackgroundTransparency = 1
StatusFarm.Text = "Status Farm : Take Quest"
StatusFarm.TextColor3 = COLOR_TITLE
StatusFarm.TextSize = 14
StatusFarm.Font = Enum.Font.GothamBold
StatusFarm.TextXAlignment = Enum.TextXAlignment.Center
StatusFarm.Parent = StatusBar

local StatusItem = Instance.new("TextLabel")
StatusItem.Size = UDim2.new(1, -10, 0, 25)
StatusItem.Position = UDim2.new(0, 5, 0, 28)
StatusItem.BackgroundTransparency = 1
StatusItem.Text = "Status Item : None"
StatusItem.TextColor3 = COLOR_TITLE
StatusItem.TextSize = 14
StatusItem.Font = Enum.Font.GothamBold
StatusItem.TextXAlignment = Enum.TextXAlignment.Center
StatusItem.Parent = StatusBar

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 240)
MainFrame.Position = UDim2.new(0.5, -225, 0.45, -120)
MainFrame.BackgroundColor3 = COLOR_BG
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COLOR_BORDER
MainStroke.Thickness = 3
MainStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "Banana Stats Checker"
Title.TextColor3 = COLOR_TITLE
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Gạch ngang trên
local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(0.88, 0, 0, 2)
TopLine.Position = UDim2.new(0.06, 0, 0, 42)
TopLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopLine.BorderSizePixel = 0
TopLine.Parent = MainFrame

-- Account Stats (TRÁI)
local AccountStatsTitle = Instance.new("TextLabel")
AccountStatsTitle.Size = UDim2.new(0.48, 0, 0, 25)
AccountStatsTitle.Position = UDim2.new(0.04, 0, 0, 50)
AccountStatsTitle.BackgroundTransparency = 1
AccountStatsTitle.Text = "Account Stats"
AccountStatsTitle.TextColor3 = COLOR_TITLE
AccountStatsTitle.TextSize = 15
AccountStatsTitle.Font = Enum.Font.GothamBold
AccountStatsTitle.TextXAlignment = Enum.TextXAlignment.Left
AccountStatsTitle.Parent = MainFrame

local LevelLabel = Instance.new("TextLabel")
LevelLabel.Size = UDim2.new(0.48, 0, 0, 20)
LevelLabel.Position = UDim2.new(0.04, 0, 0, 80)
LevelLabel.BackgroundTransparency = 1
LevelLabel.Text = "Level: 2800"
LevelLabel.TextColor3 = COLOR_TEXT
LevelLabel.TextSize = 13
LevelLabel.Font = Enum.Font.GothamBold
LevelLabel.TextXAlignment = Enum.TextXAlignment.Left
LevelLabel.Parent = MainFrame

local RaceLabel = Instance.new("TextLabel")
RaceLabel.Size = UDim2.new(0.48, 0, 0, 20)
RaceLabel.Position = UDim2.new(0.04, 0, 0, 105)
RaceLabel.BackgroundTransparency = 1
RaceLabel.Text = "Race: Ghoul"
RaceLabel.TextColor3 = COLOR_TEXT
RaceLabel.TextSize = 13
RaceLabel.Font = Enum.Font.GothamBold
RaceLabel.TextXAlignment = Enum.TextXAlignment.Left
RaceLabel.Parent = MainFrame

local BeliLabel = Instance.new("TextLabel")
BeliLabel.Size = UDim2.new(0.48, 0, 0, 20)
BeliLabel.Position = UDim2.new(0.04, 0, 0, 130)
BeliLabel.BackgroundTransparency = 1
BeliLabel.Text = "Beli: 7,880,375"
BeliLabel.TextColor3 = COLOR_TEXT
BeliLabel.TextSize = 13
BeliLabel.Font = Enum.Font.GothamBold
BeliLabel.TextXAlignment = Enum.TextXAlignment.Left
BeliLabel.Parent = MainFrame

local FragLabel = Instance.new("TextLabel")
FragLabel.Size = UDim2.new(0.48, 0, 0, 20)
FragLabel.Position = UDim2.new(0.04, 0, 0, 155)
FragLabel.BackgroundTransparency = 1
FragLabel.Text = "Frag: 5,228"
FragLabel.TextColor3 = COLOR_TEXT
FragLabel.TextSize = 13
FragLabel.Font = Enum.Font.GothamBold
FragLabel.TextXAlignment = Enum.TextXAlignment.Left
FragLabel.Parent = MainFrame

-- Account Items (PHẢI)
local AccountItemsTitle = Instance.new("TextLabel")
AccountItemsTitle.Size = UDim2.new(0.48, 0, 0, 25)
AccountItemsTitle.Position = UDim2.new(0.52, 0, 0, 50)
AccountItemsTitle.BackgroundTransparency = 1
AccountItemsTitle.Text = "Account Items"
AccountItemsTitle.TextColor3 = COLOR_TITLE
AccountItemsTitle.TextSize = 15
AccountItemsTitle.Font = Enum.Font.GothamBold
AccountItemsTitle.TextXAlignment = Enum.TextXAlignment.Left
AccountItemsTitle.Parent = MainFrame

-- Gạch ngang dưới
local BottomLine = Instance.new("Frame")
BottomLine.Size = UDim2.new(0.88, 0, 0, 2)
BottomLine.Position = UDim2.new(0.06, 0, 0, 185)
BottomLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BottomLine.BorderSizePixel = 0
BottomLine.Parent = MainFrame

local ItemLabel1 = Instance.new("TextLabel")
ItemLabel1.Size = UDim2.new(0.44, 0, 0, 20)
ItemLabel1.Position = UDim2.new(0.52, 0, 0, 195)
ItemLabel1.BackgroundTransparency = 1
ItemLabel1.Text = "Label"
ItemLabel1.TextColor3 = COLOR_TEXT
ItemLabel1.TextSize = 13
ItemLabel1.Font = Enum.Font.GothamBold
ItemLabel1.TextXAlignment = Enum.TextXAlignment.Left
ItemLabel1.Parent = MainFrame

local ItemLabel2 = Instance.new("TextLabel")
ItemLabel2.Size = UDim2.new(0.44, 0, 0, 20)
ItemLabel2.Position = UDim2.new(0.52, 0, 0, 215)
ItemLabel2.BackgroundTransparency = 1
ItemLabel2.Text = "Label"
ItemLabel2.TextColor3 = COLOR_TEXT
ItemLabel2.TextSize = 13
ItemLabel2.Font = Enum.Font.GothamBold
ItemLabel2.TextXAlignment = Enum.TextXAlignment.Left
ItemLabel2.Parent = MainFrame

-- Draggable Toggle
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
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle
ToggleButton.MouseButton1Click:Connect(function()
    if not draggingToggle then
        MenuVisible = not MenuVisible
        MainFrame.Visible = MenuVisible
        StatusBar.Visible = MenuVisible
        DiscordLink.Visible = MenuVisible
        ToggleButton.Text = MenuVisible and "ON" or "OFF"
    end
end)

-- Update Stats
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

print("✅ Fixed - Đúng layout ảnh mẫu!")
