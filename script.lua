-- Blox Fruits Status Menu - Full Clone
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
local MenuVisible = true -- BẬT SẴN

-- Toggle Button (Icon tròn - DRAGGABLE)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleBtn"
ToggleButton.Size = UDim2.new(0, 80, 0, 80)
ToggleButton.Position = UDim2.new(0, 10, 0.35, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BorderSizePixel = 0
ToggleButton.Image = "rbxassetid://18134683241" -- Icon chuối
ToggleButton.Parent = ScreenGui

local ToggleBtnCorner = Instance.new("UICorner")
ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
ToggleBtnCorner.Parent = ToggleButton

local ToggleBtnStroke = Instance.new("UIStroke")
ToggleBtnStroke.Color = Color3.fromRGB(100, 100, 100)
ToggleBtnStroke.Thickness = 3
ToggleBtnStroke.Parent = ToggleButton

-- Status Bar (Top)
local StatusBar = Instance.new("Frame")
StatusBar.Name = "StatusBar"
StatusBar.Size = UDim2.new(0, 380, 0, 55)
StatusBar.Position = UDim2.new(0.5, -190, 0.05, 0)
StatusBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusBar.BorderSizePixel = 0
StatusBar.Visible = true -- BẬT SẴN
StatusBar.Parent = ScreenGui

local StatusBarCorner = Instance.new("UICorner")
StatusBarCorner.CornerRadius = UDim.new(0, 6)
StatusBarCorner.Parent = StatusBar

local StatusBarStroke = Instance.new("UIStroke")
StatusBarStroke.Color = Color3.fromRGB(255, 200, 0)
StatusBarStroke.Thickness = 2
StatusBarStroke.Parent = StatusBar

local StatusFarm = Instance.new("TextLabel")
StatusFarm.Size = UDim2.new(1, -20, 0, 25)
StatusFarm.Position = UDim2.new(0, 10, 0, 5)
StatusFarm.BackgroundTransparency = 1
StatusFarm.Text = "Status Farm : Take Quest"
StatusFarm.TextColor3 = Color3.fromRGB(255, 200, 0)
StatusFarm.TextSize = 15
StatusFarm.Font = Enum.Font.GothamBold
StatusFarm.TextXAlignment = Enum.TextXAlignment.Left
StatusFarm.Parent = StatusBar

local StatusItem = Instance.new("TextLabel")
StatusItem.Size = UDim2.new(1, -20, 0, 25)
StatusItem.Position = UDim2.new(0, 10, 0, 28)
StatusItem.BackgroundTransparency = 1
StatusItem.Text = "Status Item : None"
StatusItem.TextColor3 = Color3.fromRGB(255, 200, 0)
StatusItem.TextSize = 15
StatusItem.Font = Enum.Font.GothamBold
StatusItem.TextXAlignment = Enum.TextXAlignment.Left
StatusItem.Parent = StatusBar

-- Discord Link (Top)
local DiscordLink = Instance.new("TextButton")
DiscordLink.Size = UDim2.new(0, 200, 0, 30)
DiscordLink.Position = UDim2.new(0.5, -100, 0.02, 0)
DiscordLink.BackgroundTransparency = 1
DiscordLink.Text = "discord.gg/chuoihub"
DiscordLink.TextColor3 = Color3.fromRGB(255, 200, 0)
DiscordLink.TextSize = 14
DiscordLink.Font = Enum.Font.GothamBold
DiscordLink.Visible = true -- BẬT SẴN
DiscordLink.Parent = ScreenGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 430, 0, 270)
MainFrame.Position = UDim2.new(0.5, -215, 0.5, -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true -- BẬT SẴN
MainFrame.Parent = ScreenGui

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 8)
MainFrameCorner.Parent = MainFrame

local MainFrameStroke = Instance.new("UIStroke")
MainFrameStroke.Color = Color3.fromRGB(255, 200, 0)
MainFrameStroke.Thickness = 3
MainFrameStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Banana Stats Checker"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(0.88, 0, 0, 2)
TitleLine.Position = UDim2.new(0.06, 0, 0, 42)
TitleLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleLine.BorderSizePixel = 0
TitleLine.Parent = MainFrame

-- Account Stats (Left)
local AccountStatsTitle = Instance.new("TextLabel")
AccountStatsTitle.Size = UDim2.new(0.45, 0, 0, 30)
AccountStatsTitle.Position = UDim2.new(0.05, 0, 0, 50)
AccountStatsTitle.BackgroundTransparency = 1
AccountStatsTitle.Text = "Account Stats"
AccountStatsTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
AccountStatsTitle.TextSize = 17
AccountStatsTitle.Font = Enum.Font.GothamBold
AccountStatsTitle.TextXAlignment = Enum.TextXAlignment.Left
AccountStatsTitle.Parent = MainFrame

local LevelLabel = Instance.new("TextLabel")
LevelLabel.Size = UDim2.new(0.45, 0, 0, 25)
LevelLabel.Position = UDim2.new(0.05, 0, 0, 85)
LevelLabel.BackgroundTransparency = 1
LevelLabel.Text = "Level: 2800"
LevelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LevelLabel.TextSize = 15
LevelLabel.Font = Enum.Font.GothamBold
LevelLabel.TextXAlignment = Enum.TextXAlignment.Left
LevelLabel.Parent = MainFrame

local RaceLabel = Instance.new("TextLabel")
RaceLabel.Size = UDim2.new(0.45, 0, 0, 25)
RaceLabel.Position = UDim2.new(0.05, 0, 0, 115)
RaceLabel.BackgroundTransparency = 1
RaceLabel.Text = "Race: Ghoul"
RaceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RaceLabel.TextSize = 15
RaceLabel.Font = Enum.Font.GothamBold
RaceLabel.TextXAlignment = Enum.TextXAlignment.Left
RaceLabel.Parent = MainFrame

local BeliLabel = Instance.new("TextLabel")
BeliLabel.Size = UDim2.new(0.45, 0, 0, 25)
BeliLabel.Position = UDim2.new(0.05, 0, 0, 145)
BeliLabel.BackgroundTransparency = 1
BeliLabel.Text = "Beli: 7,880,375"
BeliLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BeliLabel.TextSize = 15
BeliLabel.Font = Enum.Font.GothamBold
BeliLabel.TextXAlignment = Enum.TextXAlignment.Left
BeliLabel.Parent = MainFrame

local FragLabel = Instance.new("TextLabel")
FragLabel.Size = UDim2.new(0.45, 0, 0, 25)
FragLabel.Position = UDim2.new(0.05, 0, 0, 175)
FragLabel.BackgroundTransparency = 1
FragLabel.Text = "Frag: 5,228"
FragLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FragLabel.TextSize = 15
FragLabel.Font = Enum.Font.GothamBold
FragLabel.TextXAlignment = Enum.TextXAlignment.Left
FragLabel.Parent = MainFrame

local MiddleLine = Instance.new("Frame")
MiddleLine.Size = UDim2.new(0, 2, 0.65, 0)
MiddleLine.Position = UDim2.new(0.5, 0, 0.25, 0)
MiddleLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MiddleLine.BorderSizePixel = 0
MiddleLine.Parent = MainFrame

-- Account Items (Right)
local AccountItemsTitle = Instance.new("TextLabel")
AccountItemsTitle.Size = UDim2.new(0.45, 0, 0, 30)
AccountItemsTitle.Position = UDim2.new(0.52, 0, 0, 50)
AccountItemsTitle.BackgroundTransparency = 1
AccountItemsTitle.Text = "Account Items"
AccountItemsTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
AccountItemsTitle.TextSize = 17
AccountItemsTitle.Font = Enum.Font.GothamBold
AccountItemsTitle.TextXAlignment = Enum.TextXAlignment.Left
AccountItemsTitle.Parent = MainFrame

local ItemLabel1 = Instance.new("TextLabel")
ItemLabel1.Size = UDim2.new(0.45, 0, 0, 25)
ItemLabel1.Position = UDim2.new(0.52, 0, 0, 145)
ItemLabel1.BackgroundTransparency = 1
ItemLabel1.Text = "Label"
ItemLabel1.TextColor3 = Color3.fromRGB(200, 200, 200)
ItemLabel1.TextSize = 14
ItemLabel1.Font = Enum.Font.Gotham
ItemLabel1.TextXAlignment = Enum.TextXAlignment.Left
ItemLabel1.Parent = MainFrame

local ItemLabel2 = Instance.new("TextLabel")
ItemLabel2.Size = UDim2.new(0.45, 0, 0, 25)
ItemLabel2.Position = UDim2.new(0.52, 0, 0, 175)
ItemLabel2.BackgroundTransparency = 1
ItemLabel2.Text = "Label"
ItemLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
ItemLabel2.TextSize = 14
ItemLabel2.Font = Enum.Font.Gotham
ItemLabel2.TextXAlignment = Enum.TextXAlignment.Left
ItemLabel2.Parent = MainFrame

-- Bottom Line
local BottomLine = Instance.new("Frame")
BottomLine.Size = UDim2.new(0.88, 0, 0, 2)
BottomLine.Position = UDim2.new(0.06, 0, 0, 215)
BottomLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BottomLine.BorderSizePixel = 0
BottomLine.Parent = MainFrame

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
    end
end)

-- Update Stats Function
local function UpdateStats()
    local player = LocalPlayer
    local level = player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") and player.Data.Level.Value or 2800
    LevelLabel.Text = "Level: " .. tostring(level)

    local beli = player:FindFirstChild("Data") and player.Data:FindFirstChild("Beli") and player.Data.Beli.Value or 7880375
    BeliLabel.Text = "Beli: " .. string.format("%,d", beli):gsub(",", ".")

    local race = player:FindFirstChild("Data") and player.Data:FindFirstChild("Race") and player.Data.Race.Value or "Ghoul"
    RaceLabel.Text = "Race: " .. race

    local frag = player:FindFirstChild("Data") and player.Data:FindFirstChild("Fragments") and player.Data.Fragments.Value or 5228
    FragLabel.Text = "Frag: " .. string.format("%,d", frag):gsub(",", ".")
end

spawn(function()
    while wait(1) do
        UpdateStats()
    end
end)

print("✅ Blox Fruits Status Menu Loaded - Menu is ON by default!")
