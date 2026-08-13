local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Config = {
    Title = "KAITUN BF",
    Version = "v1.4",
    Author = "by Kaibeo",

    MainColor = Color3.fromRGB(220, 25, 50),
    Background = Color3.fromRGB(7, 7, 10),
    Panel = Color3.fromRGB(14, 14, 18),
    Text = Color3.fromRGB(235, 235, 235),
    SubText = Color3.fromRGB(140, 140, 145),
    Green = Color3.fromRGB(70, 255, 145)
}

--==================================================
-- GUI
--==================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "KaitunBF"
GUI.ResetOnSpawn = false
GUI.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(720, 470)
Main.Position = UDim2.new(0.5, -360, 0.5, -235)
Main.BackgroundColor3 = Config.Background
Main.BorderSizePixel = 0
Main.Parent = GUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Config.MainColor
MainStroke.Thickness = 2
MainStroke.Transparency = 0.15
MainStroke.Parent = Main

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 72)
Header.BackgroundColor3 = Color3.fromRGB(24, 8, 12)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 18)
HeaderCorner.Parent = Header

local Icon = Instance.new("TextLabel")
Icon.Size = UDim2.fromOffset(48, 48)
Icon.Position = UDim2.fromOffset(14, 12)
Icon.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
Icon.Text = "⚔"
Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
Icon.TextSize = 25
Icon.Font = Enum.Font.GothamBold
Icon.Parent = Header

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = Icon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Config.MainColor
IconStroke.Thickness = 2
IconStroke.Parent = Icon

local Title = Instance.new("TextLabel")
Title.Size = UDim2.fromOffset(300, 27)
Title.Position = UDim2.fromOffset(75, 10)
Title.BackgroundTransparency = 1
Title.Text = Config.Title
Title.TextColor3 = Config.Text
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.fromOffset(300, 22)
Version.Position = UDim2.fromOffset(75, 37)
Version.BackgroundTransparency = 1
Version.Text = Config.Author .. " • " .. Config.Version
Version.TextColor3 = Config.SubText
Version.TextSize = 13
Version.Font = Enum.Font.Gotham
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Header

-- Close
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(42, 42)
Close.Position = UDim2.new(1, -53, 0, 15)
Close.BackgroundColor3 = Color3.fromRGB(35, 8, 13)
Close.Text = "×"
Close.TextColor3 = Config.MainColor
Close.TextSize = 27
Close.Font = Enum.Font.GothamBold
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    GUI:Destroy()
end)

-- Toggle
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.fromOffset(62, 32)
Toggle.Position = UDim2.new(1, -125, 0, 20)
Toggle.BackgroundColor3 = Config.MainColor
Toggle.Text = ""
Toggle.Parent = Header

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = Toggle

local ToggleDot = Instance.new("Frame")
ToggleDot.Size = UDim2.fromOffset(26, 26)
ToggleDot.Position = UDim2.new(1, -29, 0.5, -13)
ToggleDot.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
ToggleDot.Parent = Toggle

local ToggleDotCorner = Instance.new("UICorner")
ToggleDotCorner.CornerRadius = UDim.new(1, 0)
ToggleDotCorner.Parent = ToggleDot

local Enabled = true

Toggle.MouseButton1Click:Connect(function()
    Enabled = not Enabled

    if Enabled then
        Toggle.BackgroundColor3 = Config.MainColor

        TweenService:Create(
            ToggleDot,
            TweenInfo.new(0.2),
            {Position = UDim2.new(1, -29, 0.5, -13)}
        ):Play()
    else
        Toggle.BackgroundColor3 = Color3.fromRGB(65, 65, 70)

        TweenService:Create(
            ToggleDot,
            TweenInfo.new(0.2),
            {Position = UDim2.fromOffset(3, 3)}
        ):Play()
    end
end)

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 165, 1, -88)
Sidebar.Position = UDim2.fromOffset(10, 78)
Sidebar.BackgroundColor3 = Config.Panel
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 14)
SidebarCorner.Parent = Sidebar

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -190, 1, -88)
Content.Position = UDim2.fromOffset(180, 78)
Content.BackgroundColor3 = Config.Panel
Content.BorderSizePixel = 0
Content.Parent = Main

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 14)
ContentCorner.Parent = Content

--==================================================
-- TAB SYSTEM
--==================================================

local Pages = {}
local TabButtons = {}

local function CreatePage(Name)

    local Page = Instance.new("ScrollingFrame")
    Page.Name = Name
    Page.Size = UDim2.new(1, -20, 1, -20)
    Page.Position = UDim2.fromOffset(10, 10)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 10)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(
            0,
            0,
            0,
            Layout.AbsoluteContentSize.Y + 15
        )
    end)

    Pages[Name] = Page

    return Page
end

local function CreateTab(Name, IconText)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -16, 0, 45)
    Button.BackgroundColor3 = Config.Panel
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.fromOffset(35, 45)
    IconLabel.Position = UDim2.fromOffset(5, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = IconText
    IconLabel.TextColor3 = Config.SubText
    IconLabel.TextSize = 17
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Parent = Button

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -45, 1, 0)
    Text.Position = UDim2.fromOffset(42, 0)
    Text.BackgroundTransparency = 1
    Text.Text = Name
    Text.TextColor3 = Config.SubText
    Text.TextSize = 14
    Text.Font = Enum.Font.GothamMedium
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Button

    TabButtons[Name] = {
        Button = Button,
        Icon = IconLabel,
        Text = Text
    }

    return Button
end

local HomeTab = CreateTab("Home", "⌂")
HomeTab.Position = UDim2.fromOffset(8, 12)

local FarmTab = CreateTab("Farm", "⚔")
FarmTab.Position = UDim2.fromOffset(8, 64)

local QuestTab = CreateTab("Quest", "!")
QuestTab.Position = UDim2.fromOffset(8, 116)

local TeleportTab = CreateTab("Teleport", "↗")
TeleportTab.Position = UDim2.fromOffset(8, 168)

local SettingsTab = CreateTab("Settings", "⚙")
SettingsTab.Position = UDim2.fromOffset(8, 220)

local HomePage = CreatePage("Home")
local FarmPage = CreatePage("Farm")
local QuestPage = CreatePage("Quest")
local TeleportPage = CreatePage("Teleport")
local SettingsPage = CreatePage("Settings")

--==================================================
-- BUTTONS
--==================================================

local function Section(Page, Text)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 28)
    Label.BackgroundTransparency = 1
    Label.Text = Text
    Label.TextColor3 = Config.Text
    Label.TextSize = 17
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Page

    return Label
end

local function Button(Page, Text, Callback)

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -5, 0, 45)
    B.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    B.Text = Text
    B.TextColor3 = Config.Text
    B.TextSize = 14
    B.Font = Enum.Font.GothamMedium
    B.AutoButtonColor = false
    B.Parent = Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = B

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(38, 38, 45)
    Stroke.Thickness = 1
    Stroke.Parent = B

    B.MouseEnter:Connect(function()
        TweenService:Create(
            B,
            TweenInfo.new(0.15),
            {BackgroundColor3 = Color3.fromRGB(35, 12, 18)}
        ):Play()
    end)

    B.MouseLeave:Connect(function()
        TweenService:Create(
            B,
            TweenInfo.new(0.15),
            {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}
        ):Play()
    end)

    B.MouseButton1Click:Connect(function()
        if Callback then
            Callback()
        end
    end)

    return B
end

--==================================================
-- HOME
--==================================================

Section(HomePage, "Dashboard")

Button(HomePage, "👤  User : " .. Player.Name, function()
    print("User:", Player.Name)
end)

Button(HomePage, "🌐  Status : Online", function()
    print("Status: Online")
end)

Button(HomePage, "⚡  Script Status : Ready", function()
    print("Script ready")
end)

Section(HomePage, "Information")

Button(HomePage, "ℹ  Kaitun BF " .. Config.Version, function()
    print(Config.Title, Config.Version)
end)

--==================================================
-- FARM
--==================================================

Section(FarmPage, "Farm Settings")

Button(FarmPage, "⚔  Auto Farm", function()
    print("Auto Farm button")
end)

Button(FarmPage, "🎯  Auto Quest", function()
    print("Auto Quest button")
end)

Button(FarmPage, "💰  Auto Collect", function()
    print("Auto Collect button")
end)

Button(FarmPage, "📦  Auto Store", function()
    print("Auto Store button")
end)

--==================================================
-- QUEST
--==================================================

Section(QuestPage, "Quest")

Button(QuestPage, "📜  Start Quest", function()
    print("Start Quest")
end)

Button(QuestPage, "🔄  Auto Quest", function()
    print("Auto Quest")
end)

Button(QuestPage, "❌  Stop Quest", function()
    print("Stop Quest")
end)

--==================================================
-- TELEPORT
--==================================================

Section(TeleportPage, "Locations")

Button(TeleportPage, "🏝  First Sea", function()
    print("First Sea")
end)

Button(TeleportPage, "🌊  Second Sea", function()
    print("Second Sea")
end)

Button(TeleportPage, "🌋  Third Sea", function()
    print("Third Sea")
end)

--==================================================
-- SETTINGS
--==================================================

Section(SettingsPage, "Interface")

Button(SettingsPage, "🎨  UI Theme", function()
    print("Theme settings")
end)

Button(SettingsPage, "🔔  Notifications", function()
    print("Notification settings")
end)

Button(SettingsPage, "💾  Save Settings", function()
    print("Settings saved")
end)

--==================================================
-- TAB SWITCH
--==================================================

local function ShowPage(Name)

    for PageName, Page in pairs(Pages) do
        Page.Visible = PageName == Name
    end

    for TabName, Data in pairs(TabButtons) do

        if TabName == Name then
            Data.Button.BackgroundColor3 = Color3.fromRGB(45, 10, 17)
            Data.Icon.TextColor3 = Config.MainColor
            Data.Text.TextColor3 = Config.Text
        else
            Data.Button.BackgroundColor3 = Config.Panel
            Data.Icon.TextColor3 = Config.SubText
            Data.Text.TextColor3 = Config.SubText
        end
    end
end

HomeTab.MouseButton1Click:Connect(function()
    ShowPage("Home")
end)

FarmTab.MouseButton1Click:Connect(function()
    ShowPage("Farm")
end)

QuestTab.MouseButton1Click:Connect(function()
    ShowPage("Quest")
end)

TeleportTab.MouseButton1Click:Connect(function()
    ShowPage("Teleport")
end)

SettingsTab.MouseButton1Click:Connect(function()
    ShowPage("Settings")
end)

ShowPage("Home")

--==================================================
-- DRAG
--==================================================

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

        Input.Changed:Connect(function()

            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end

        end)
    end
end)

UIS.InputChanged:Connect(function(Input)

    if Dragging and (
        Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch
    ) then

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- FPS
--==================================================

local Frames = 0
local LastFPS = tick()

RunService.RenderStepped:Connect(function()
    Frames += 1

    if tick() - LastFPS >= 1 then
        Frames = 0
        LastFPS = tick()
    end
end)

print("KAITUN BF UI loaded")
