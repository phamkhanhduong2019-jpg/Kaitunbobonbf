-- ================================================================= --
--                    BOBON HUB - KAITUN FULL SOURCE                 --
--             Cập nhật Level Max 2800 & Tự Động Farm 100%             --
-- ================================================================= --

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")

-- Anti-AFK tự động tránh bị Kick
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- -----------------------------------------------------------------
-- 1. BẢNG DỮ LIỆU QUEST VÀ CẤP ĐỘ (LEVEL 1 -> MAX 2800)
-- -----------------------------------------------------------------
local QuestDatabase = {
    -- SEA 1 (Lv 1 - 699)
    {MinLvl = 1, MaxLvl = 14, Quest = "BanditQuest1", Monster = "Bandit", QuestLvl = 1, CFrame = CFrame.new(1059, 16, 1548)},
    {MinLvl = 15, MaxLvl = 29, Quest = "JungleQuest", Monster = "Monkey", QuestLvl = 1, CFrame = CFrame.new(-1598, 37, 152)},
    {MinLvl = 30, MaxLvl = 59, Quest = "JungleQuest", Monster = "Gorilla", QuestLvl = 2, CFrame = CFrame.new(-1230, 6, -486)},
    {MinLvl = 60, MaxLvl = 89, Quest = "PirateQuest", Monster = "Pirate", QuestLvl = 1, CFrame = CFrame.new(-1120, 4, 3850)},
    {MinLvl = 90, MaxLvl = 119, Quest = "DesertQuest", Monster = "Desert Bandit", QuestLvl = 1, CFrame = CFrame.new(890, 6, 4380)},
    {MinLvl = 120, MaxLvl = 149, Quest = "MiddleQuest", Monster = "Sniper", QuestLvl = 1, CFrame = CFrame.new(-1100, 4, 1500)},
    {MinLvl = 150, MaxLvl = 189, Quest = "SkyQuest", Monster = "Sky Bandit", QuestLvl = 1, CFrame = CFrame.new(-4850, 718, -2620)},
    {MinLvl = 190, MaxLvl = 274, Quest = "PrisonQuest", Monster = "Prisoner", QuestLvl = 1, CFrame = CFrame.new(530, 2, 480)},
    {MinLvl = 275, MaxLvl = 374, Quest = "ColosseumQuest", Monster = "Toga Warrior", QuestLvl = 1, CFrame = CFrame.new(-1580, 7, -2980)},
    {MinLvl = 375, MaxLvl = 449, Quest = "MagmaQuest", Monster = "Military Soldier", QuestLvl = 1, CFrame = CFrame.new(-5250, 8, 8480)},
    {MinLvl = 450, MaxLvl = 524, Quest = "FishmanQuest", Monster = "Fishman Warrior", QuestLvl = 1, CFrame = CFrame.new(61120, 18, 1560)},
    {MinLvl = 525, MaxLvl = 624, Quest = "Sky2Quest", Monster = "God's Guard", QuestLvl = 1, CFrame = CFrame.new(-7730, 5600, -1430)},
    {MinLvl = 625, MaxLvl = 699, Quest = "FountainQuest", Monster = "Cyborg", QuestLvl = 1, CFrame = CFrame.new(5260, 38, 4050)},

    -- SEA 2 (Lv 700 - 1499)
    {MinLvl = 700, MaxLvl = 724, Quest = "Area1Quest", Monster = "Raider", QuestLvl = 1, CFrame = CFrame.new(-425, 73, 1836)},
    {MinLvl = 725, MaxLvl = 774, Quest = "Area2Quest", Monster = "Mercenary", QuestLvl = 1, CFrame = CFrame.new(-860, 140, 1315)},
    {MinLvl = 775, MaxLvl = 874, Quest = "SwanQuest", Monster = "Swan Pirate", QuestLvl = 1, CFrame = CFrame.new(878, 122, 1235)},
    {MinLvl = 875, MaxLvl = 999, Quest = "ZombieQuest", Monster = "Zombie", QuestLvl = 1, CFrame = CFrame.new(-5620, 80, -720)},
    {MinLvl = 1000, MaxLvl = 1124, Quest = "SnowMountainQuest", Monster = "Snow Trooper", QuestLvl = 1, CFrame = CFrame.new(600, 400, -5300)},
    {MinLvl = 1125, MaxLvl = 1249, Quest = "IceSideQuest", Monster = "Arctic Warrior", QuestLvl = 1, CFrame = CFrame.new(6100, 28, -6200)},
    {MinLvl = 1250, MaxLvl = 1349, Quest = "ShipQuest1", Monster = "Ship Deckhand", QuestLvl = 1, CFrame = CFrame.new(1030, 125, 32900)},
    {MinLvl = 1350, MaxLvl = 1424, Quest = "FrostQuest", Monster = "Snow Lurker", QuestLvl = 1, CFrame = CFrame.new(5560, 28, -6800)},
    {MinLvl = 1425, MaxLvl = 1499, Quest = "WaterTigerQuest", Monster = "Water Fighter", QuestLvl = 1, CFrame = CFrame.new(2880, 6, -9200)},

    -- SEA 3 (Lv 1500 - 2800 MAX)
    {MinLvl = 1500, MaxLvl = 1574, Quest = "PiratePortQuest", Monster = "Pirate Millionaire", QuestLvl = 1, CFrame = CFrame.new(-290, 44, 5580)},
    {MinLvl = 1575, MaxLvl = 1699, Quest = "AmazonQuest", Monster = "Female Islander", QuestLvl = 1, CFrame = CFrame.new(5830, 50, -300)},
    {MinLvl = 1700, MaxLvl = 1824, Quest = "MarineTreeQuest", Monster = "Marine Commodore", QuestLvl = 1, CFrame = CFrame.new(2180, 28, -6740)},
    {MinLvl = 1825, MaxLvl = 1974, Quest = "DeepForestIsland1Quest", Monster = "Forest Pirate", QuestLvl = 1, CFrame = CFrame.new(-13230, 330, -7630)},
    {MinLvl = 1975, MaxLvl = 2074, Quest = "HauntedQuest1", Monster = "Reborn Skeleton", QuestLvl = 1, CFrame = CFrame.new(-9480, 140, 5530)},
    {MinLvl = 2075, MaxLvl = 2224, Quest = "NutsIslandQuest", Monster = "Peanut Scout", QuestLvl = 1, CFrame = CFrame.new(-2100, 38, -10190)},
    {MinLvl = 2225, MaxLvl = 2449, Quest = "IceCreamIslandQuest", Monster = "Ice Cream Chef", QuestLvl = 1, CFrame = CFrame.new(700, 50, -11000)},
    {MinLvl = 2450, MaxLvl = 2524, Quest = "CandyQuest1", Monster = "Isle Outlaw", QuestLvl = 1, CFrame = CFrame.new(-2110, 38, -12140)},
    {MinLvl = 2525, MaxLvl = 2624, Quest = "TikiQuest1", Monster = "Isle Champion", QuestLvl = 1, CFrame = CFrame.new(-16200, 10, 450)},
    {MinLvl = 2625, MaxLvl = 2724, Quest = "TikiQuest2", Monster = "Sun-kissed Warrior", QuestLvl = 1, CFrame = CFrame.new(-16500, 50, 800)},
    {MinLvl = 2725, MaxLvl = 2800, Quest = "TikiQuest3", Monster = "Islands Guard", QuestLvl = 1, CFrame = CFrame.new(-17000, 90, 1200)}
}

-- -----------------------------------------------------------------
-- 2. TẠO GIAO DIỆN BOBON HUB (UI CREATION)
-- -----------------------------------------------------------------
if CoreGui:FindFirstChild("BobonHubUI") then
    CoreGui.BobonHubUI:Destroy()
end

local BobonUI = Instance.new("ScreenGui")
BobonUI.Name = "BobonHubUI"
BobonUI.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 360)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = BobonUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(11, 17, 22)
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 120, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "BOBON HUB"
Title.Font = Enum.Font.Code
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.Code
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function() BobonUI:Destroy() end)

-- Account Stats Header
local StatsLine = Instance.new("TextLabel")
StatsLine.Size = UDim2.new(1, -40, 0, 20)
StatsLine.Position = UDim2.new(0, 20, 0, 45)
StatsLine.Font = Enum.Font.Code
StatsLine.TextColor3 = Color3.fromRGB(200, 220, 240)
StatsLine.TextSize = 13
StatsLine.TextXAlignment = Enum.TextXAlignment.Left
StatsLine.BackgroundTransparency = 1
StatsLine.Parent = MainFrame

local function UpdateAccountStats()
    local level = LocalPlayer.Data.Level.Value
    local race = LocalPlayer.Data.Race.Value
    local beli = LocalPlayer.Data.Beli.Value
    local frag = LocalPlayer.Data.Fragments.Value
    StatsLine.Text = string.format("Level: %d          Race: %s          Beli: %s          Frag: %s", 
        level, race, string.format("%'d", beli), string.format("%'d", frag))
end

-- Divider
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -40, 0, 1)
Divider.Position = UDim2.new(0, 20, 0, 75)
Divider.BackgroundColor3 = Color3.fromRGB(35, 45, 55)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- Item Grid Container
local ItemGridContainer = Instance.new("Frame")
ItemGridContainer.Size = UDim2.new(1, -40, 0, 190)
ItemGridContainer.Position = UDim2.new(0, 20, 0, 85)
ItemGridContainer.BackgroundTransparency = 1
ItemGridContainer.Parent = MainFrame

local UIGrid = Instance.new("UIGridLayout")
UIGrid.CellSize = UDim2.new(0, 180, 0, 30)
UIGrid.CellPadding = UDim2.new(0, 10, 0, 5)
UIGrid.Parent = ItemGridContainer

local ItemsList = {
    { Name = "GH Tail: 0/20", Code = "GHTail" },
    { Name = "Cursed Dual Katana", Code = "CDK" },
    { Name = "Soul Guitar", Code = "SoulGuitar" },
    { Name = "True Triple Katana", Code = "TTK" },
    { Name = "Mirror Fractal", Code = "MirrorFractal" },
    { Name = "Valkyrie Helm", Code = "Valkyrie" },
    { Name = "Shark Anchor", Code = "SharkAnchor" },
    { Name = "Dark Dagger", Code = "DarkDagger" },
    { Name = "Hallow Scythe", Code = "HallowScythe" },
    { Name = "Random Fruit", Code = "RandomFruit" },
    { Name = "Bones Roll", Code = "Bones" },
    { Name = "Yama Elite", Code = "Yama" },
}

local ItemElements = {}
for idx, itemData in ipairs(ItemsList) do
    local ItemCell = Instance.new("Frame")
    ItemCell.BackgroundTransparency = 1
    ItemCell.Parent = ItemGridContainer

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 10, 0, 10)
    StatusDot.Position = UDim2.new(0, 5, 0.5, -5)
    StatusDot.BorderSizePixel = 0
    StatusDot.BackgroundColor3 = Color3.fromRGB(230, 60, 60)
    StatusDot.Parent = ItemCell

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = StatusDot

    local ItemText = Instance.new("TextLabel")
    ItemText.Size = UDim2.new(1, -25, 1, 0)
    ItemText.Position = UDim2.new(0, 22, 0, 0)
    ItemText.Text = itemData.Name
    ItemText.Font = Enum.Font.Code
    ItemText.TextColor3 = Color3.fromRGB(190, 200, 210)
    ItemText.TextSize = 12
    ItemText.TextXAlignment = Enum.TextXAlignment.Left
    ItemText.BackgroundTransparency = 1
    ItemText.Parent = ItemCell

    ItemElements[itemData.Code] = { Dot = StatusDot, Text = ItemText }
end

-- Footer Status
local FooterFrame = Instance.new("Frame")
FooterFrame.Size = UDim2.new(1, 0, 0, 50)
FooterFrame.Position = UDim2.new(0, 0, 1, -50)
FooterFrame.BackgroundColor3 = Color3.fromRGB(10, 14, 18)
FooterFrame.Parent = MainFrame

local UserText = Instance.new("TextLabel")
UserText.Size = UDim2.new(0, 200, 0, 18)
UserText.Position = UDim2.new(0, 15, 0, 5)
UserText.Text = LocalPlayer.Name .. " | Max Lvl: 2800"
UserText.Font = Enum.Font.Code
UserText.TextColor3 = Color3.fromRGB(200, 200, 200)
UserText.TextSize = 11
UserText.TextXAlignment = Enum.TextXAlignment.Left
UserText.BackgroundTransparency = 1
UserText.Parent = FooterFrame

local RightStatusText = Instance.new("TextLabel")
RightStatusText.Size = UDim2.new(0, 250, 1, 0)
RightStatusText.Position = UDim2.new(1, -260, 0, 0)
RightStatusText.Font = Enum.Font.Code
RightStatusText.TextColor3 = Color3.fromRGB(0, 190, 230)
RightStatusText.TextSize = 11
RightStatusText.TextXAlignment = Enum.TextXAlignment.Right
RightStatusText.BackgroundTransparency = 1
RightStatusText.Parent = FooterFrame

local StartTime = tick()
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local fps = math.floor(Stats.Workspace.Heartbeat:GetValue())
            local elapsed = math.floor(tick() - StartTime)
            local uptimeStr = string.format("%02d:%02d:%02d", math.floor(elapsed/3600), math.floor((elapsed%3600)/60), elapsed%60)
            RightStatusText.Text = string.format("UPTIME: %s\nFPS: %d | TIME: %s\nSTATUS: Bobon Hub Active", uptimeStr, fps, os.date("%H:%M:%S"))
        end)
    end
end)

-- -----------------------------------------------------------------
-- 3. HÀM XỬ LÝ DI CHUYỂN, BẬT SKILL VÀ TỰ CỘNG STATS
-- -----------------------------------------------------------------
local function FastTween(targetCFrame)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = targetCFrame
    end
end

local function AutoStats()
    local points = LocalPlayer.Data.Points.Value
    if points > 0 then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", points)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", points)
    end
end

local function GetCurrentQuestData()
    local myLevel = LocalPlayer.Data.Level.Value
    for _, q in ipairs(QuestDatabase) do
        if myLevel >= q.MinLvl and myLevel <= q.MaxLvl then
            return q
        end
    end
    return nil
end

local function CheckInventory(itemName)
    return LocalPlayer.Backpack:FindFirstChild(itemName) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(itemName))
end

-- -----------------------------------------------------------------
-- 4. VÒNG LẶP AUTO FARM KAITUN LÕI (CORE LOGIC)
-- -----------------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            UpdateAccountStats()
            AutoStats()

            -- Tự động Roll / Cất Trái Ác Quỷ
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if string.find(item.Name, "Fruit") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item.Name, item)
                end
            end

            -- Cập nhật trạng thái Item UI
            ItemElements["CDK"].Dot.BackgroundColor3 = CheckInventory("Cursed Dual Katana") and Color3.fromRGB(0, 230, 120) or Color3.fromRGB(230, 60, 60)
            ItemElements["SoulGuitar"].Dot.BackgroundColor3 = CheckInventory("Soul Guitar") and Color3.fromRGB(0, 230, 120) or Color3.fromRGB(230, 60, 60)
            ItemElements["Valkyrie"].Dot.BackgroundColor3 = CheckInventory("Valkyrie Helm") and Color3.fromRGB(0, 230, 120) or Color3.fromRGB(230, 60, 60)

            -- Xử lý Farm Nhiệm Vụ Level
            local qData = GetCurrentQuestData()
            if qData then
                -- Nếu chưa nhận Quest -> Nhận Quest
                if not LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") or not LocalPlayer.PlayerGui.Main.Quest.Visible then
                    FastTween(qData.CFrame)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", qData.Quest, qData.QuestLvl)
                else
                    -- Đã có Quest -> Teleport tìm quái và dùng M1 Đánh
                    local foundEnemy = false
                    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
                        if enemy.Name == qData.Monster and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            foundEnemy = true
                            FastTween(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                            VirtualUser:Button1Down(Vector2.new(0,0))
                            break
                        end
                    end
                    -- Nếu chưa thấy quái xuất hiện -> Đứng tại bãi Spawns
                    if not foundEnemy then
                        FastTween(qData.CFrame)
                    end
                end
            end
        end)
    end
end)

print("[BOBON HUB] Source Kaitun Loaded Successfully!")
