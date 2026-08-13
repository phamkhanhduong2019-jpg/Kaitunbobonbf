local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BananaUITemplate"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local function addOutline(object, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 185, 50)
    stroke.Thickness = thickness or 1
    stroke.Parent = object
    return stroke
end

-- === NÚT BẬT/TẮT UI ===
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 150, 0, 40)
ToggleButton.Position = UDim2.new(0.05, 0, 0.7, 0) -- Góc trái màn hình
ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80) -- Màu xanh lá
ToggleButton.Text = "Show UI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui
addOutline(ToggleButton)

-- === BẢNG CHÍNH (KÍCH THƯỚC NHỎ HƠN) ===
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 340) -- Nhỏ hơn (480x340 thay vì 600x400)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170) -- Căn giữa lại
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- Mặc định ẩn đi, khi bấm nút mới hiện
MainFrame.Parent = ScreenGui
addOutline(MainFrame, 2)

-- Sự kiện bấm nút bật/tắt
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleButton.Text = MainFrame.Visible and "Hide UI" or "Show UI"
end)

-- === NỘI DUNG BẢNG ===
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Banana Stats Checker"
TitleLabel.TextColor3 = Color3.fromRGB(255, 185, 50)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

local Divider1 = Instance.new("Frame")
Divider1.Size = UDim2.new(0.9, 0, 0, 1)
Divider1.Position = UDim2.new(0.05, 0, 0, 45)
Divider1.BackgroundColor3 = Color3.fromRGB(255, 185, 50)
Divider1.BackgroundTransparency = 0.3
Divider1.BorderSizePixel = 0
Divider1.Parent = MainFrame

-- Cột Trái
local LeftContainer = Instance.new("Frame")
LeftContainer.Size = UDim2.new(0.45, 0, 1, -70)
LeftContainer.Position = UDim2.new(0.05, 0, 0, 55)
LeftContainer.BackgroundTransparency = 1
LeftContainer.Parent = MainFrame

local LeftTitle = Instance.new("TextLabel")
LeftTitle.Size = UDim2.new(1, 0, 0, 25)
LeftTitle.BackgroundTransparency = 1
LeftTitle.Text = "Account Stats"
LeftTitle.TextColor3 = Color3.fromRGB(255, 210, 100)
LeftTitle.TextScaled = true
LeftTitle.Font = Enum.Font.GothamBold
LeftTitle.Parent = LeftContainer

local function createStatText(yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 22)
    label.Position = UDim2.new(0, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = "" -- ĐỂ TRỐNG
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = LeftContainer
    return label
end

local Line1 = createStatText(30)
local Line2 = createStatText(55)
local Line3 = createStatText(80)
local Line4 = createStatText(105)

-- Cột Phải
local RightContainer = Instance.new("Frame")
RightContainer.Size = UDim2.new(0.45, 0, 1, -70)
RightContainer.Position = UDim2.new(0.5, 0, 0, 55)
RightContainer.BackgroundTransparency = 1
RightContainer.Parent = MainFrame

local RightTitle = Instance.new("TextLabel")
RightTitle.Size = UDim2.new(1, 0, 0, 25)
RightTitle.BackgroundTransparency = 1
RightTitle.Text = "Account Items"
RightTitle.TextColor3 = Color3.fromRGB(255, 210, 100)
RightTitle.TextScaled = true
RightTitle.Font = Enum.Font.GothamBold
RightTitle.Parent = RightContainer

local function createItemRow(yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 22)
    container.Position = UDim2.new(0, 0, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = RightContainer

    local circle = Instance.new("ImageLabel")
    circle.Size = UDim2.new(0, 12, 0, 12)
    circle.Position = UDim2.new(0, 0, 0.5, -6)
    circle.BackgroundTransparency = 1
    circle.Image = "rbxassetid://7078685236" 
    circle.ImageColor3 = Color3.fromRGB(200, 200, 200) -- Màu trắng xám trung tính
    circle.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -18, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "" -- ĐỂ TRỐNG
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = container
end

createItemRow(30)
createItemRow(55)
createItemRow(80)
createItemRow(105)
createItemRow(130) -- Thêm dòng thứ 5 cho đỡ trống
createItemRow(155) -- Thêm dòng thứ 6 cho đỡ trống

local Divider2 = Instance.new("Frame")
Divider2.Size = UDim2.new(0.9, 0, 0, 1)
Divider2.Position = UDim2.new(0.05, 0, 1, -30)
Divider2.BackgroundColor3 = Color3.fromRGB(255, 185, 50)
Divider2.BackgroundTransparency = 0.3
Divider2.BorderSizePixel = 0
Divider2.Parent = MainFrame

-- Bảng Status nhỏ gọn
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(0, 430, 0, 75)
StatusFrame.Position = UDim2.new(0.5, -215, 1, 35)
StatusFrame.BackgroundColor3 = Color3.fromRGB(5, 10, 15)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = MainFrame
addOutline(StatusFrame, 2)

local StatusText1 = Instance.new("TextLabel")
StatusText1.Size = UDim2.new(1, 0, 0, 25)
StatusText1.Position = UDim2.new(0, 0, 0, 10)
StatusText1.BackgroundTransparency = 1
StatusText1.Text = "Status Farm : None"
StatusText1.TextColor3 = Color3.fromRGB(255, 185, 50)
StatusText1.TextScaled = true
StatusText1.Font = Enum.Font.GothamBold
StatusText1.Parent = StatusFrame

local StatusText2 = Instance.new("TextLabel")
StatusText2.Size = UDim2.new(1, 0, 0, 25)
StatusText2.Position = UDim2.new(0, 0, 0, 38)
StatusText2.BackgroundTransparency = 1
StatusText2.Text = "Status Item : None"
StatusText2.TextColor3 = Color3.fromRGB(255, 185, 50)
StatusText2.TextScaled = true
StatusText2.Font = Enum.Font.GothamBold
StatusText2.Parent = StatusFrame
