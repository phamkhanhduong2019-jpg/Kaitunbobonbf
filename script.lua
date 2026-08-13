--[[
    UI Banana Stats Checker - Image Toggle Button
    Copy and replace all old code in your script.lua
]]

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BananaStatsUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Màu sắc chủ đạo
local Colors = {
    Main = Color3.fromRGB(10, 15, 28),
    Border = Color3.fromRGB(255, 185, 50),
    Title = Color3.fromRGB(255, 185, 50),
    Text = Color3.fromRGB(220, 220, 220)
}

-- Hàm tạo viền
local function addStroke(object, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Colors.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = object
    return stroke
end

-- === 2. NÚT BẬT/TẮT HÌNH ẢNH (CON CHUỐI) ===
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 60, 0, 60) -- Kích thước nút nhỏ gọn
ToggleButton.Position = UDim2.new(0.03, 0, 0.5, -30) -- Nằm giữa bên trái màn hình
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Nút có nền trắng như hình bạn gửi
ToggleButton.BackgroundTransparency = 0
ToggleButton.Parent = ScreenGui

-- Tạo viền đen mỏng quanh khung trắng cho giống hình
local strokeBtn = Instance.new("UIStroke")
strokeBtn.Color = Color3.fromRGB(0, 0, 0)
strokeBtn.Thickness = 1
strokeBtn.Parent = ToggleButton

-- Thêm hình ảnh (Icon Chuối có sẵn của Roblox - Bạn có thể đổi ID này)
local Icon = Instance.new("ImageLabel")
Icon.Size = UDim2.new(0.9, 0, 0.9, 0)
Icon.Position = UDim2.new(0.05, 0, 0.05, 0)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://7078685236" -- ĐÂY LÀ ICON CHUỐI TẠM (Bạn có thể đổi sang ID ảnh chuối thật nếu có)
Icon.ImageColor3 = Color3.fromRGB(255, 255, 0) -- Tô màu vàng cho con chuối
Icon.Parent = ToggleButton
addStroke(Icon, Color3.fromRGB(100, 100, 100), 0.5) -- Viền nhạt cho ảnh

-- === 3. BẢNG CHÍNH (Ẩn mặc định) ===
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 460, 0, 320)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -160)
MainFrame.BackgroundColor3 = Colors.Main
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- Mặc định ẩn, bấm nút chuối mới hiện
MainFrame.Parent = ScreenGui
addStroke(MainFrame, Colors.Border, 1.5)
local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = MainFrame

-- Sự kiện bấm nút chuối để mở menu
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- (Phần kéo thả nút)
local dragging, dragInput, dragStart, startPos
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y))
    end
end)

-- === 4. NỘI DUNG BẢNG (GIỮ NGUYÊN) ===
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35); Title.Position = UDim2.new(0, 0, 0, 5); Title.BackgroundTransparency = 1; Title.Text = "Banana Stats Checker"; Title.TextColor3 = Colors.Title; Title.TextScaled = true; Title.Font = Enum.Font.GothamBold; Title.Parent = MainFrame

local Div1 = Instance.new("Frame")
Div1.Size = UDim2.new(0.9, 0, 0, 1); Div1.Position = UDim2.new(0.05, 0, 0, 45); Div1.BackgroundColor3 = Colors.Border; Div1.BackgroundTransparency = 0.7; Div1.BorderSizePixel = 0; Div1.Parent = MainFrame

-- Layout 2 cột
local LayoutFrame = Instance.new("Frame")
LayoutFrame.Size = UDim2.new(0.95, 0, 0.7, 0); LayoutFrame.Position = UDim2.new(0.025, 0, 0, 55); LayoutFrame.BackgroundTransparency = 1; LayoutFrame.Parent = MainFrame

-- Cột Trái: Stats
local LeftCol = Instance.new("Frame")
LeftCol.Size = UDim2.new(0.5, -5, 1, 0); LeftCol.BackgroundTransparency = 1; LeftCol.Parent = LayoutFrame

local LTitle = Instance.new("TextLabel")
LTitle.Size = UDim2.new(1, 0, 0, 25); LTitle.BackgroundTransparency = 1; LTitle.Text = "Account Stats"; LTitle.TextColor3 = Colors.Title; LTitle.TextXAlignment = Enum.TextXAlignment.Left; LTitle.TextScaled = true; LTitle.Font = Enum.Font.GothamBold; LTitle.Parent = LeftCol

local LList = Instance.new("UIListLayout"); LList.SortOrder = Enum.SortOrder.LayoutOrder; LList.Padding = UDim.new(0, 2); LList.Parent = LeftCol

local function makeLeft()
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 20); t.BackgroundTransparency = 1; t.Text = ""; t.TextColor3 = Colors.Text; t.TextXAlignment = Enum.TextXAlignment.Left; t.TextScaled = true; t.Font = Enum.Font.Gotham; t.Parent = LeftCol
    return t
end
local Stat1 = makeLeft(); local Stat2 = makeLeft(); local Stat3 = makeLeft(); local Stat4 = makeLeft();

-- Cột Phải: Items
local RightCol = Instance.new("Frame")
RightCol.Size = UDim2.new(0.5, -5, 1, 0); RightCol.Position = UDim2.new(0.5, 5, 0, 0); RightCol.BackgroundTransparency = 1; RightCol.Parent = LayoutFrame

local RTitle = Instance.new("TextLabel")
RTitle.Size = UDim2.new(1, 0, 0, 25); RTitle.BackgroundTransparency = 1; RTitle.Text = "Account Items"; RTitle.TextColor3 = Colors.Title; RTitle.TextXAlignment = Enum.TextXAlignment.Left; RTitle.TextScaled = true; RTitle.Font = Enum.Font.GothamBold; RTitle.Parent = RightCol

local RList = Instance.new("UIListLayout"); RList.SortOrder = Enum.SortOrder.LayoutOrder; RList.Padding = UDim.new(0, 2); RList.Parent = RightCol

local function makeItem()
    local cont = Instance.new("Frame"); cont.Size = UDim2.new(1, 0, 0, 20); cont.BackgroundTransparency = 1; cont.Parent = RightCol
    local dot = Instance.new("ImageLabel"); dot.Size = UDim2.new(0, 12, 0, 12); dot.Position = UDim2.new(0, 0, 0.5, -6); dot.BackgroundTransparency = 1; dot.Image = "rbxassetid://7078685236"; dot.ImageColor3 = Color3.fromRGB(180, 180, 180); dot.Parent = cont
    local text = Instance.new("TextLabel"); text.Size = UDim2.new(1, -20, 1, 0); text.Position = UDim2.new(0, 20, 0, 0); text.BackgroundTransparency = 1; text.Text = ""; text.TextColor3 = Colors.Text; text.TextXAlignment = Enum.TextXAlignment.Left; text.TextScaled = true; text.Font = Enum.Font.Gotham; text.Parent = cont
    return cont, dot, text
end
local Item1, Dot1, Name1 = makeItem(); local Item2, Dot2, Name2 = makeItem(); local Item3, Dot3, Name3 = makeItem(); local Item4, Dot4, Name4 = makeItem(); local Item5, Dot5, Name5 = makeItem(); local Item6, Dot6, Name6 = makeItem();

-- Gạch dưới cùng & Status
local Div2 = Instance.new("Frame")
Div2.Size = UDim2.new(0.9, 0, 0, 1); Div2.Position = UDim2.new(0.05, 0, 1, -40); Div2.BackgroundColor3 = Colors.Border; Div2.BackgroundTransparency = 0.7; Div2.BorderSizePixel = 0; Div2.Parent = MainFrame

local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(0, 380, 0, 70); StatusFrame.Position = UDim2.new(0.5, -190, 1, -30); StatusFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); StatusFrame.BackgroundTransparency = 0.2; StatusFrame.BorderSizePixel = 0; StatusFrame.Parent = MainFrame
addStroke(StatusFrame, Colors.Border, 1.5); local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0, 4); sc.Parent = StatusFrame

local SList = Instance.new("UIListLayout"); SList.SortOrder = Enum.SortOrder.LayoutOrder; SList.Padding = UDim.new(0, 2); SList.Parent = StatusFrame

local function makeStatus(text)
    local t = Instance.new("TextLabel"); t.Size = UDim2.new(1, 0, 0, 20); t.BackgroundTransparency = 1; t.Text = text; t.TextColor3 = Colors.Border; t.TextScaled = true; t.Font = Enum.Font.GothamBold; t.Parent = StatusFrame
    return t
end
local StatusFarm = makeStatus("Status Farm : None")
local StatusItem = makeStatus("Status Item : None")

-- === HƯỚNG DẪN ĐỔI ẢNH CHUỐI THẬT ===
-- Trong code trên, dòng Icon.Image = "rbxassetid://7078685236" đang dùng ảnh tạm.
-- Nếu bạn muốn nó giống hệt cái hình bạn gửi (con chuối), bạn cần:
-- 1. Tìm ID của con chuối đó (VD: rbxassetid://1234567890)
-- 2. Thay thế số 7078685236 bằng ID thật của nó.
