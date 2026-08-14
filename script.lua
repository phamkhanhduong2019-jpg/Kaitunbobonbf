-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- CONFIGURATION (CHỈNH SỬA MÀU SẮC/BỐ CỤC TẠI ĐÂY CHO GIỐNG ẢNH MẪU)
local CONFIG = {
    ThemeColor = Color3.fromRGB(20, 20, 30),      -- Màu nền bảng
    AccentColor = Color3.fromRGB(255, 165, 0),    -- Màu viền/chữ nổi bật
    TextColor = Color3.fromRGB(255, 255, 255),     -- Màu chữ thường
    DiscordText = "Discord: discord.gg/bloxfruit", -- Dòng Discord hiển thị
    IconID = "rbxassetid://12885379885"            -- ID ảnh nút tròn (Banana Cat)
}

-- VARIABLES
local isMenuOpen = false
local dragging = false
local dragInput, dragStart, startPos

-- CLEANUP OLD UI
if PlayerGui:FindFirstChild("CustomStatsUI_V2") then
    PlayerGui.CustomStatsUI_V2:Destroy()
end

-- CREATE SCREENGUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomStatsUI_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-----------------------------------------
-- 1. NÚT TRÒN (AVATAR TOGGLE + DRAG)
-----------------------------------------
local AvatarBtn = Instance.new("ImageButton")
AvatarBtn.Name = "ToggleBtn"
AvatarBtn.Size = UDim2.new(0, 55, 0, 55)
AvatarBtn.Position = UDim2.new(0, 20, 0.5, -27)
AvatarBtn.Image = CONFIG.IconID
AvatarBtn.BackgroundTransparency = 1
AvatarBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner", AvatarBtn)
BtnCorner.CornerRadius = UDim.new(1, 0)
local BtnStroke = Instance.new("UIStroke", AvatarBtn)
BtnStroke.Color = CONFIG.AccentColor
BtnStroke.Thickness = 2

-----------------------------------------
-- 2. BẢNG STATUS NHỎ (TRÊN CÙNG - LIVE)
-----------------------------------------
local TopBar = Instance.new("Frame")
TopBar.Name = "TopStatusBar"
TopBar.Size = UDim2.new(0, 320, 0, 70)
TopBar.Position = UDim2.new(0.5, -160, 0, 15)
TopBar.BackgroundColor3 = CONFIG.ThemeColor
TopBar.BackgroundTransparency = 0.15
TopBar.BorderSizePixel = 0
TopBar.Visible = false
TopBar.Parent = ScreenGui

Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
local TopStroke = Instance.new("UIStroke", TopBar)
TopStroke.Color = CONFIG.AccentColor
TopStroke.Thickness = 1.5

-- Label Farm Status
local FarmLabel = Instance.new("TextLabel")
FarmLabel.Size = UDim2.new(1, -10, 0, 20)
FarmLabel.Position = UDim2.new(0, 5, 0, 5)
FarmLabel.BackgroundTransparency = 1
FarmLabel.TextXAlignment = Enum.TextXAlignment.Left
FarmLabel.Font = Enum.Font.GothamBold
FarmLabel.TextSize = 13
FarmLabel.TextColor3 = CONFIG.AccentColor
FarmLabel.Text = "Status Farm: Scanning..."
FarmLabel.Parent = TopBar

-- Label Item/Mastery
local ItemLabel = Instance.new("TextLabel")
ItemLabel.Size = UDim2.new(1, -10, 0, 20)
ItemLabel.Position = UDim2.new(0, 5, 0, 25)
ItemLabel.BackgroundTransparency = 1
ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
ItemLabel.Font = Enum.Font.Gotham
ItemLabel.TextSize = 12
ItemLabel.TextColor3 = CONFIG.TextColor
ItemLabel.Text = "Status Item: None"
ItemLabel.Parent = TopBar

-- Dòng Discord
local DiscordLabel = Instance.new("TextLabel")
DiscordLabel.Size = UDim2.new(1, -10, 0, 18)
DiscordLabel.Position = UDim2.new(0, 5, 0, 48)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left
DiscordLabel.Font = Enum.Font.GothamItalic
DiscordLabel.TextSize = 10
DiscordLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
DiscordLabel.Text = CONFIG.DiscordText
DiscordLabel.Parent = TopBar

-----------------------------------------
-- 3. BẢNG STATS CHÍNH (LEVEL, BELI, FRAG)
-----------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainStatsPanel"
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.BackgroundColor3 = CONFIG.ThemeColor
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = CONFIG.AccentColor
MainStroke.Thickness = 2

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextColor3 = CONFIG.AccentColor
Title.Text = "ACCOUNT STATUS"
Title.Parent = MainFrame

-- Stats Container
local StatsList = {"Level", "Race", "Beli", "Fragments"}
local yOffset = 35
for _, statName in ipairs(StatsList) do
    local lbl = Instance.new("TextLabel")
    lbl.Name = statName
    lbl.Size = UDim2.new(1, -20, 0, 22)
    lbl.Position = UDim2.new(0, 10, 0, yOffset)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 14
    lbl.TextColor3 = CONFIG.TextColor
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = statName .. ": Loading..."
    lbl.Parent = MainFrame
    yOffset += 28
end

-----------------------------------------
-- LOGIC LẤY DỮ LIỆU THẬT (LIVE UPDATE)
-----------------------------------------
local function getNearestMob()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local root = char.HumanoidRootPart
    local nearestDist = 30 -- Tầm quét 30 studs
    local targetName = "Idle / Not Fighting"
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") and v.Health > 0 and v.Parent ~= char then
            local mobRoot = v.Parent:FindFirstChild("HumanoidRootPart")
            if mobRoot then
                local dist = (root.Position - mobRoot.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    targetName = v.Parent.Name
                end
            end
        end
    end
    return targetName
end

local function getCurrentWeapon()
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool then
        -- Blox Fruits thường lưu mastery trong Tool.Level hoặc attribute
        local mastery = tool:FindFirstChild("Level") or tool:GetAttribute("Mastery")
        local mVal = mastery and tostring(mastery.Value or mastery) or "0"
        return string.format("%s [Mastery: %s]", tool.Name, mVal)
    end
    return "No Weapon Equipped"
end

local function updateLiveStats()
    while task.wait(0.5) do -- Cập nhật mỗi 0.5s cho mượt
        if isMenuOpen then
            -- Update Farm Status
            FarmLabel.Text = "Status Farm: " .. getNearestMob()
            
            -- Update Item Status
            ItemLabel.Text = "Status Item: " .. getCurrentWeapon()
            
            -- Update Account Stats
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            if ls then
                MainFrame.Level.Text = "Level: " .. tostring(ls:FindFirstChild("Level") and ls.Level.Value or "?")
                MainFrame.Beli.Text = "Beli: " .. tostring(ls:FindFirstChild("Beli") and ls.Beli.Value or "?")
                MainFrame.Fragments.Text = "Fragments: " .. tostring(ls:FindFirstChild("Fragments") and ls.Fragments.Value or "?")
            end
            
            -- Race (thường cần remote, để placeholder nếu không lấy được)
            MainFrame.Race.Text = "Race: Check DataStore" 
        end
    end
end

task.spawn(updateLiveStats)

-----------------------------------------
-- XỬ LÝ KÉO THẢ & BẬT TẮT (MOBILE + PC)
-----------------------------------------
local clickStart = 0

AvatarBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        clickStart = tick()
        dragging = true
        dragStart = input.Position
        startPos = AvatarBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                -- Phân biệt Click vs Drag
                if tick() - clickStart < 0.2 and (input.Position - dragStart).Magnitude < 10 then
                    isMenuOpen = not isMenuOpen
                    TopBar.Visible = isMenuOpen
                    MainFrame.Visible = isMenuOpen
                    
                    -- Animation mở menu
                    if isMenuOpen then
                        MainFrame.Size = UDim2.new(0, 0, 0, 0)
                        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.BackOut), {Size = UDim2.new(0, 320, 0, 220)}):Play()
                    end
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        AvatarBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("✅ Custom Stats UI V2 Loaded! Drag the icon to move, tap to toggle.")
