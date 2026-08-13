-- Tạo ScreenGui chứa toàn bộ giao diện
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BananaTemplate"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Hàm tạo nét viền (Stroke) màu vàng cho khung
local function addOutline(object, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 185, 50) -- Màu vàng cam
    stroke.Thickness = thickness or 1
    stroke.Parent = object
    return stroke
end

-- === BẢNG CHÍNH (MAIN FRAME) ===
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200) -- Căn giữa màn hình
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 30) -- Màu nền xanh đen
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
addOutline(MainFrame, 2)

-- Dòng tiêu đề chính (Banana Stats Checker)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Banana Stats Checker"
TitleLabel.TextColor3 = Color3.fromRGB(255, 185, 50)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Đường gạch ngang dưới tiêu đề
local Divider1 = Instance.new("Frame")
Divider1.Size = UDim2.new(0.9, 0, 0, 2)
Divider1.Position = UDim2.new(0.05, 0, 0, 55)
Divider1.BackgroundColor3 = Color3.fromRGB(255, 185, 50)
Divider1.BackgroundTransparency = 0.3
Divider1.BorderSizePixel = 0
Divider1.Parent = MainFrame

-- === CỘT TRÁI (ACCOUNT STATS) ===
local LeftContainer = Instance.new("Frame")
LeftContainer.Size = UDim2.new(0.45, 0, 1, -80)
LeftContainer.Position = UDim2.new(0.05, 0, 0, 70)
LeftContainer.BackgroundTransparency = 1
LeftContainer.Parent = MainFrame

local LeftTitle = Instance.new("TextLabel")
LeftTitle.Size = UDim2.new(1, 0, 0, 30)
LeftTitle.BackgroundTransparency = 1
LeftTitle.Text = "Account Stats"
LeftTitle.TextColor3 = Color3.fromRGB(255, 210, 100)
LeftTitle.TextScaled = true
LeftTitle.Font = Enum.Font.GothamBold
LeftTitle.Parent = LeftContainer

-- Hàm tạo dòng chữ để trống
local function createStatText(yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Position = UDim2.new(0, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = "" -- Để trống nội dung
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = LeftContainer
    return label
end

-- Tạo các dòng trống bên trái (để bạn sau này điền dữ liệu vào)
local Line1 = createStatText(40) -- Vị trí dòng Level
local Line2 = createStatText(75) -- Vị trí dòng Race
local Line3 = createStatText(110) -- Vị trí dòng Beli
local Line4 = createStatText(145) -- Vị trí dòng Frag

-- === CỘT PHẢI (ACCOUNT ITEMS) ===
local RightContainer = Instance.new("Frame")
RightContainer.Size = UDim2.new(0.45, 0, 1, -80)
RightContainer.Position = UDim2.new(0.5, 0, 0, 70)
RightContainer.BackgroundTransparency = 1
RightContainer.Parent = MainFrame

local RightTitle = Instance.new("TextLabel")
RightTitle.Size = UDim2.new(1, 0, 0, 30)
RightTitle.BackgroundTransparency = 1
RightTitle.Text = "Account Items"
RightTitle.TextColor3 = Color3.fromRGB(255, 210, 100)
RightTitle.TextScaled = true
RightTitle.Font = Enum.Font.GothamBold
RightTitle.Parent = RightContainer

-- Hàm tạo dòng item kèm theo dấu chấm tròn (Màu trắng/Xám trung tính)
local function createItemRow(yPos, text)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 25)
    container.Position = UDim2.new(0, 0, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = RightContainer

    local circle = Instance.new("ImageLabel")
    circle.Size = UDim2.new(0, 15, 0, 15)
    circle.Position = UDim2.new(0, 0, 0.5, -7.5)
    circle.BackgroundTransparency = 1
    circle.Image = "rbxassetid://7078685236" -- Hình ảnh vòng tròn
    circle.ImageColor3 = Color3.fromRGB(200, 200, 200) -- Màu trắng xám (Trung tính)
    circle.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 20, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "" -- Để trống tên Item
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = container
end

-- Tạo các dòng trống bên phải (để bạn sau này điền tên item vào)
local Item1 = createItemRow(40)
local Item2 = createItemRow(75)
local Item3 = createItemRow(110)
local Item4 = createItemRow(145)
local Item5 = createItemRow(180)
local Item6 = createItemRow(215)

-- Đường gạch ngang dưới cùng
local Divider2 = Instance.new("Frame")
Divider2.Size = UDim2.new(0.9, 0, 0, 2)
Divider2.Position = UDim2.new(0.05, 0, 1, -35)
Divider2.BackgroundColor3 = Color3.fromRGB(255, 185, 50)
Divider2.BackgroundTransparency = 0.3
Divider2.BorderSizePixel = 0
Divider2.Parent = MainFrame

-- === BẢNG PHỤ (STATUS FARM) ===
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(0, 550, 0, 90)
StatusFrame.Position = UDim2.new(0.5, -275, 1, 50) -- Nằm ngay dưới bảng chính
StatusFrame.BackgroundColor3 = Color3.fromRGB(5, 10, 15)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = MainFrame -- Gắn vào MainFrame để nó di chuyển cùng
addOutline(StatusFrame, 2)

local StatusText1 = Instance.new("TextLabel")
StatusText1.Size = UDim2.new(1, 0, 0, 30)
StatusText1.Position = UDim2.new(0, 0, 0, 15)
StatusText1.BackgroundTransparency = 1
StatusText1.Text = "Status Farm : None" -- Để mặc định là None
StatusText1.TextColor3 = Color3.fromRGB(255, 185, 50)
StatusText1.TextScaled = true
StatusText1.Font = Enum.Font.GothamBold
StatusText1.Parent = StatusFrame

local StatusText2 = Instance.new("TextLabel")
StatusText2.Size = UDim2.new(1, 0, 0, 30)
StatusText2.Position = UDim2.new(0, 0, 0, 45)
StatusText2.BackgroundTransparency = 1
StatusText2.Text = "Status Item : None" -- Để mặc định là None
StatusText2.TextColor3 = Color3.fromRGB(255, 185, 50)
StatusText2.TextScaled = true
StatusText2.Font = Enum.Font.GothamBold
StatusText2.Parent = StatusFrame
