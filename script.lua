-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- VARIABLES
local isMenuOpen = false
local dragging = false
local dragInput, dragStart, startPos

-- TẠO GIAO DIỆN CHÍNH (SCREENGUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BananaStatsUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- 1. NÚT TRÒN (AVATAR BUTTON)
local AvatarBtn = Instance.new("ImageButton")
AvatarBtn.Name = "AvatarButton"
AvatarBtn.BackgroundTransparency = 1
AvatarBtn.Size = UDim2.new(0, 60, 0, 60)
AvatarBtn.Position = UDim2.new(0, 50, 0, 200) -- Vị trí ban đầu
AvatarBtn.Image = "rbxassetid://10734891663" -- ID ảnh chuối (hoặc thay bằng ảnh khác)
AvatarBtn.Parent = ScreenGui

-- Viền tròn cho nút
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) -- Tròn hoàn toàn
UICorner.Parent = AvatarBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = AvatarBtn

-- 2. BẢNG STATUS NHỎ (TRÊN CÙNG)
local TopStatusFrame = Instance.new("Frame")
TopStatusFrame.Name = "TopStatus"
TopStatusFrame.Size = UDim2.new(0, 300, 0, 60)
TopStatusFrame.Position = UDim2.new(0.5, -150, 0, 20)
TopStatusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopStatusFrame.BackgroundTransparency = 0.2
TopStatusFrame.BorderSizePixel = 0
TopStatusFrame.Visible = false -- Mặc định ẩn
TopStatusFrame.Parent = ScreenGui

local TopCorner = Instance.new("UICorner", TopStatusFrame)
TopCorner.CornerRadius = UDim.new(0, 8)
local TopStroke = Instance.new("UIStroke", TopStatusFrame)
TopStroke.Color = Color3.fromRGB(255, 165, 0) -- Màu cam/vàng
TopStroke.Thickness = 2

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0.5, 0)
StatusLabel.Position = UDim2.new(0, 0, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status Farm : None"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 14
StatusLabel.Parent = TopStatusFrame

local ItemLabel = Instance.new("TextLabel")
ItemLabel.Size = UDim2.new(1, 0, 0.5, 0)
ItemLabel.Position = UDim2.new(0, 0, 0.5, 0)
ItemLabel.BackgroundTransparency = 1
ItemLabel.Text = "Status Item : None"
ItemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemLabel.Font = Enum.Font.Gotham
ItemLabel.TextSize = 14
ItemLabel.Parent = TopStatusFrame

-- 3. BẢNG STATS CHÍNH (GIỮA)
local MainStatsFrame = Instance.new("Frame")
MainStatsFrame.Name = "MainStats"
MainStatsFrame.Size = UDim2.new(0, 350, 0, 250)
MainStatsFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainStatsFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 35)
MainStatsFrame.BackgroundTransparency = 0.1
MainStatsFrame.BorderSizePixel = 0
MainStatsFrame.Visible = false -- Mặc định ẩn
MainStatsFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainStatsFrame)
MainCorner.CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainStatsFrame)
MainStroke.Color = Color3.fromRGB(255, 165, 0)
MainStroke.Thickness = 2

-- Tiêu đề
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Banana Stats Checker"
TitleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Parent = MainStatsFrame

-- Các thông số
local statsData = {
    {Name = "Level", Value = "Loading..."},
    {Name = "Race", Value = "Loading..."},
    {Name = "Beli", Value = "Loading..."},
    {Name = "Frag", Value = "Loading..."}
}

local yOffset = 40
for i, data in pairs(statsData) do
    local label = Instance.new("TextLabel")
    label.Name = data.Name .. "Label"
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, yOffset)
    label.BackgroundTransparency = 1
    label.Text = data.Name .. ": " .. data.Value
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = MainStatsFrame
    yOffset = yOffset + 30
end

-- HÀM LẤY THÔNG TIN GAME (BLOX FRUITS)
-- Lưu ý: Cách lấy thông tin có thể thay đổi tùy bản cập nhật của game
local function GetPlayerStats()
    local stats = {}
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    
    if leaderstats then
        -- Lấy Level
        local lvl = leaderstats:FindFirstChild("Level")
        stats.Level = lvl and lvl.Value or "N/A"
        
        -- Lấy Beli
        local beli = leaderstats:FindFirstChild("Beli") or leaderstats:FindFirstChild("Money")
        stats.Beli = beli and beli.Value or "N/A"
        
        -- Lấy Fragments
        local frag = leaderstats:FindFirstChild("Fragments")
        stats.Frag = frag and frag.Value or "N/A"
    end
    
    -- Lấy Race (Thường nằm trong Data hoặc GUI, đây là cách ước lượng)
    -- Trong Blox Fruits mới, Race thường check qua Remote hoặc biến cụ thể
    -- Ở đây mình để tạm là Human nếu không tìm thấy
    stats.Race = "Human (Check GUI)" 
    
    return stats
end

local function GetWeaponMastery()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        -- Thường mastery nằm trong attribute hoặc folder bên trong tool
        local mastery = tool:FindFirstChild("Level") or tool:GetAttribute("Mastery")
        if mastery then
            return tool.Name .. " [Mastery: " .. tostring(mastery.Value or mastery) .. "]"
        end
        return tool.Name .. " [Mastery: 0]"
    end
    return "None"
end

local function GetFarmStatus()
    -- Kiểm tra xem có đang auto farm không (thường check qua biến global của script khác hoặc check target)
    -- Vì không biết bạn dùng script farm gì, mình sẽ check xem nhân vật có đang đánh nhau không
    -- Hoặc đơn giản là hiển thị "Idle" / "Fighting"
    return "Killing Mob (Demo)" 
end

-- CẬP NHẬT THÔNG TIN LIÊN TỤC
spawn(function()
    while wait(1) do
        if isMenuOpen then
            local stats = GetPlayerStats()
            
            -- Update Main Stats
            if MainStatsFrame:FindFirstChild("LevelLabel") then
                MainStatsFrame.LevelLabel.Text = "Level: " .. tostring(stats.Level)
                MainStatsFrame.RaceLabel.Text = "Race: " .. tostring(stats.Race)
                MainStatsFrame.BeliLabel.Text = "Beli: " .. tostring(stats.Beli)
                MainStatsFrame.FragLabel.Text = "Frag: " .. tostring(stats.Frag)
            end
            
            -- Update Top Status
            ItemLabel.Text = "Status Item : " .. GetWeaponMastery()
            StatusLabel.Text = "Status Farm : " .. GetFarmStatus()
        end
    end
end)

-- XỬ LÝ SỰ KIỆN NÚT TRÒN (DRAG & DROP + CLICK)
AvatarBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = AvatarBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

AvatarBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        AvatarBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Xử lý Click (phân biệt giữa kéo và click)
local clickTime = 0
AvatarBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        clickTime = tick()
    end
end)

AvatarBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if tick() - clickTime < 0.2 then -- Nếu nhấn nhanh hơn 0.2s thì là click
            isMenuOpen = not isMenuOpen
            MainStatsFrame.Visible = isMenuOpen
            TopStatusFrame.Visible = isMenuOpen
            
            -- Hiệu ứng hiện ra
            if isMenuOpen then
                MainStatsFrame.Size = UDim2.new(0, 0, 0, 0)
                TweenService:Create(MainStatsFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 250)}):Play()
            end
        end
    end
end)

print("Banana Stats UI Loaded! Click the banana icon to open.")
