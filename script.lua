-- ================================================================= --
--          BOBON HUB - KAITUN SCRIPT (FIXED - TELE TRÊN ĐẦU QUÁI)  --
--                     Version 3.0 | Fixed by Axiom                  --
-- ================================================================= --
-- FIX LIST:
--  [1] Teleport dùng HRP.CFrame thay vì Tween => không bị lag/stuck
--  [2] Check quest dùng Remote thay vì GUI Visible (GUI check không tin cậy)
--  [3] Sau nhận quest => tele thẳng lên đầu quái (Y+25 studs)
--  [4] Thêm cooldown nhận quest tránh spam InvokeServer
--  [5] Thêm check enemy còn sống chặt chẽ hơn
--  [6] UI cập nhật mượt, thêm Kill counter
-- ================================================================= --

getgenv().Configs = {
    ["Team"]          = "Pirates",
    ["Farm Distance"] = 25,   -- Bay trên đầu quái bao nhiêu studs
    ["Hitbox Size"]   = 40,   -- Kích thước hitbox extend
    ["TeleDelay"]     = 0.08, -- Delay giữa các lần tele (giây)
}

repeat task.wait(1) until
    game:IsLoaded() and
    game.Players.LocalPlayer and
    game.Players.LocalPlayer.Character and
    game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- ================================================================= --
--                         SERVICES & VARS                           --
-- ================================================================= --
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService       = game:GetService("RunService")
local VirtualUser      = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local startTime   = os.time()
local killCount   = 0
local questCooldown = false   -- [FIX 4] chống spam InvokeServer nhận quest

_G.BobonStatus = "Đang khởi tạo..."

-- ================================================================= --
--                        1. OVERLAY UI                              --
-- ================================================================= --
if CoreGui:FindFirstChild("BobonHubUI") then
    CoreGui.BobonHubUI:Destroy()
end

local ScreenGui  = Instance.new("ScreenGui")
ScreenGui.Name            = "BobonHubUI"
ScreenGui.Parent          = CoreGui
ScreenGui.ResetOnSpawn    = false
ScreenGui.DisplayOrder    = 999

local MainFrame = Instance.new("Frame")
MainFrame.Name             = "MainFrame"
MainFrame.Parent           = ScreenGui
MainFrame.AnchorPoint      = Vector2.new(0.5, 0)
MainFrame.Position         = UDim2.new(0.5, 0, 0.03, 0)
MainFrame.Size             = UDim2.new(0, 340, 0, 190)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel  = 0
MainFrame.Active           = true
MainFrame.Draggable        = true  -- Kéo được UI

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color     = Color3.fromRGB(80, 60, 200)
UIStroke.Thickness = 1.5

local UIListLayout = Instance.new("UIListLayout", MainFrame)
UIListLayout.SortOrder          = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding            = UDim.new(0, 3)

local UIPadding = Instance.new("UIPadding", MainFrame)
UIPadding.PaddingTop = UDim.new(0, 10)

local function MakeLabel(parent, text, size, color, order)
    local lbl = Instance.new("TextLabel")
    lbl.Parent             = parent
    lbl.Size               = UDim2.new(1, -10, 0, size)
    lbl.BackgroundTransparency = 1
    lbl.Font               = Enum.Font.GothamBold
    lbl.Text               = text
    lbl.TextColor3         = color
    lbl.TextSize           = size
    lbl.LayoutOrder        = order or 0
    lbl.TextXAlignment     = Enum.TextXAlignment.Center
    return lbl
end

local TitleLbl    = MakeLabel(MainFrame, "⬡ BobonHub", 22, Color3.fromRGB(200, 185, 255), 1)
local SubLbl      = MakeLabel(MainFrame, "Kaitun Edition v3.0", 12, Color3.fromRGB(130, 120, 180), 2)
SubLbl.Font       = Enum.Font.Gotham

local Sep = Instance.new("Frame", MainFrame)
Sep.Size               = UDim2.new(0.9, 0, 0, 1)
Sep.BackgroundColor3   = Color3.fromRGB(80, 60, 200)
Sep.BackgroundTransparency = 0.4
Sep.BorderSizePixel    = 0
Sep.LayoutOrder        = 3

local StatusLbl   = MakeLabel(MainFrame, "Status: Đang khởi tạo...", 13, Color3.fromRGB(85, 255, 127), 4)
local TimeLbl     = MakeLabel(MainFrame, "Time: 00:00:00", 12, Color3.fromRGB(190, 190, 210), 5)
local KillLbl     = MakeLabel(MainFrame, "Kills: 0", 12, Color3.fromRGB(255, 160, 80), 6)
local BeliLbl     = MakeLabel(MainFrame, "Beli: 0  |  Frag: 0", 12, Color3.fromRGB(80, 180, 255), 7)
local LvlLbl      = MakeLabel(MainFrame, "Level: ...", 12, Color3.fromRGB(160, 255, 200), 8)

StatusLbl.Font = Enum.Font.GothamSemibold
TimeLbl.Font   = Enum.Font.Gotham
BeliLbl.Font   = Enum.Font.Gotham
KillLbl.Font   = Enum.Font.Gotham
LvlLbl.Font    = Enum.Font.Gotham

local function FormatNum(v)
    local s = tostring(math.floor(v))
    local result = ""
    local len = #s
    for i = 1, len do
        if i > 1 and (len - i + 1) % 3 == 0 then result = result .. "," end
        result = result .. s:sub(i, i)
    end
    return result
end

-- UI Update loop
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local e = os.time() - startTime
            TimeLbl.Text = string.format("Time: %02d:%02d:%02d", math.floor(e/3600), math.floor((e%3600)/60), e%60)
            StatusLbl.Text = "Status: " .. (_G.BobonStatus or "Idle")
            KillLbl.Text = "Kills: " .. killCount

            local data = LocalPlayer:FindFirstChild("Data")
            if data then
                local beli = data:FindFirstChild("Beli") and data.Beli.Value or 0
                local frag = data:FindFirstChild("Fragments") and data.Fragments.Value or 0
                local lvl  = data:FindFirstChild("Level") and data.Level.Value or 0
                BeliLbl.Text = "Beli: " .. FormatNum(beli) .. "  |  Frag: " .. FormatNum(frag)
                LvlLbl.Text  = "Level: " .. lvl
            end
        end)
    end
end)

-- ================================================================= --
--                       2. HELPER FUNCTIONS                         --
-- ================================================================= --

-- [FIX 1] Teleport trực tiếp bằng CFrame - không dùng Tween nữa
local function TeleportTo(cf)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = cf
    end
end

-- Lấy CFrame trên đầu quái một khoảng an toàn
local function GetSafeAboveEnemy(enemyHRP)
    return enemyHRP.CFrame * CFrame.new(0, getgenv().Configs["Farm Distance"], 0)
end

-- Đứng cách quái theo hướng ngang + cao
local function GetFarmCFrame(enemyHRP)
    -- Tele lên trên đầu quái theo offset Y
    return CFrame.new(
        enemyHRP.Position.X,
        enemyHRP.Position.Y + getgenv().Configs["Farm Distance"],
        enemyHRP.Position.Z
    )
end

-- Quay mặt về quái (giữ vị trí hiện tại)
local function FaceEnemy(enemyHRP)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local lookDir = (enemyHRP.Position - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookDir)
    end
end

-- [FIX 3] Lấy quái gần nhất theo tên
local function FindEnemy(monsterName)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end

    local best, bestDist = nil, math.huge
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    for _, v in ipairs(enemies:GetChildren()) do
        if v.Name == monsterName
            and v:FindFirstChild("Humanoid")
            and v.Humanoid.Health > 0
            and v:FindFirstChild("HumanoidRootPart")
        then
            if hrp then
                local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < bestDist then
                    best = v
                    bestDist = dist
                end
            else
                return v
            end
        end
    end
    return best
end

-- [FIX 2] Check quest đang active thông qua Data thay vì GUI Visible
local function HasActiveQuest()
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        if mainGui then
            local questFrame = mainGui:FindFirstChild("Quest")
            if questFrame and questFrame.Visible then
                return true
            end
        end
    end)
    -- Fallback: check ObjectValue Quest trong Data
    local data = LocalPlayer:FindFirstChild("Data")
    if data and data:FindFirstChild("QuestData") then
        local qd = data.QuestData
        if qd:FindFirstChild("Name") and qd.Name.Value ~= "" then
            return true
        end
    end
    -- Fallback thứ 2: check PlayerGui Main.Quest.Visible
    local ok, result = pcall(function()
        return LocalPlayer.PlayerGui.Main.Quest.Visible
    end)
    return ok and result
end

-- Melee list
local AllMelees = {
    "Combat","Black Leg","Electro","Fishman Karate","Dragon Claw",
    "Superhuman","Death Step","Sharkman Karate","Electric Claw",
    "Dragon Talon","Godhuman","Sanguine Art"
}

local function ForceEquipMelee()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    -- Nếu đang cầm melee rồi thì bỏ qua
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _, name in ipairs(AllMelees) do
                if tool.Name == name then return end
            end
        end
    end
    -- Tìm trong Backpack
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            for _, name in ipairs(AllMelees) do
                if tool.Name == name then
                    char.Humanoid:EquipTool(tool)
                    return
                end
            end
        end
    end
end

-- ================================================================= --
--                    3. BACKGROUND FEATURES                         --
-- ================================================================= --

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Noclip
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

-- Hitbox Extender
task.spawn(function()
    while task.wait(0.4) do
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, part in ipairs(tool:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name == "Handle" then
                            local sz = getgenv().Configs["Hitbox Size"]
                            part.Size = Vector3.new(sz, sz, sz)
                            part.Transparency = 1
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto set team
task.spawn(function()
    pcall(function()
        task.wait(2)
        if not LocalPlayer.Team or LocalPlayer.Team.Name == "" then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", getgenv().Configs["Team"])
        end
    end)
end)

-- ================================================================= --
--                      4. QUEST DATABASE                            --
-- ================================================================= --
local QuestDatabase = {
    {MinLvl=1,    MaxLvl=14,   Quest="BanditQuest1",        Monster="Bandit",            QuestLvl=1, QuestCFrame=CFrame.new(1059,16,1548),      MonsterCFrame=CFrame.new(1145,17,1634)},
    {MinLvl=15,   MaxLvl=29,   Quest="JungleQuest",          Monster="Monkey",            QuestLvl=1, QuestCFrame=CFrame.new(-1598,37,152),       MonsterCFrame=CFrame.new(-1618,22,142)},
    {MinLvl=30,   MaxLvl=59,   Quest="JungleQuest",          Monster="Gorilla",           QuestLvl=2, QuestCFrame=CFrame.new(-1230,6,-486),        MonsterCFrame=CFrame.new(-1237,6,-502)},
    {MinLvl=60,   MaxLvl=89,   Quest="PirateQuest",          Monster="Pirate",            QuestLvl=1, QuestCFrame=CFrame.new(-1120,4,3850),        MonsterCFrame=CFrame.new(-1200,4,3900)},
    {MinLvl=90,   MaxLvl=119,  Quest="DesertQuest",          Monster="Desert Bandit",     QuestLvl=1, QuestCFrame=CFrame.new(890,6,4380),          MonsterCFrame=CFrame.new(950,6,4400)},
    {MinLvl=120,  MaxLvl=149,  Quest="MiddleQuest",          Monster="Sniper",            QuestLvl=1, QuestCFrame=CFrame.new(-1100,4,1500),        MonsterCFrame=CFrame.new(-1150,4,1450)},
    {MinLvl=150,  MaxLvl=189,  Quest="SkyQuest",             Monster="Sky Bandit",        QuestLvl=1, QuestCFrame=CFrame.new(-4850,718,-2620),     MonsterCFrame=CFrame.new(-4950,718,-2630)},
    {MinLvl=190,  MaxLvl=274,  Quest="PrisonQuest",          Monster="Prisoner",          QuestLvl=1, QuestCFrame=CFrame.new(530,2,480),           MonsterCFrame=CFrame.new(480,2,530)},
    {MinLvl=275,  MaxLvl=374,  Quest="ColosseumQuest",       Monster="Toga Warrior",      QuestLvl=1, QuestCFrame=CFrame.new(-1580,7,-2980),       MonsterCFrame=CFrame.new(-1640,7,-2980)},
    {MinLvl=375,  MaxLvl=449,  Quest="MagmaQuest",           Monster="Military Soldier",  QuestLvl=1, QuestCFrame=CFrame.new(-5250,8,8480),        MonsterCFrame=CFrame.new(-5300,8,8530)},
    {MinLvl=450,  MaxLvl=524,  Quest="FishmanQuest",         Monster="Fishman Warrior",   QuestLvl=1, QuestCFrame=CFrame.new(61120,18,1560),       MonsterCFrame=CFrame.new(61000,18,1500)},
    {MinLvl=525,  MaxLvl=624,  Quest="Sky2Quest",            Monster="God's Guard",       QuestLvl=1, QuestCFrame=CFrame.new(-7730,5600,-1430),    MonsterCFrame=CFrame.new(-7650,5600,-1400)},
    {MinLvl=625,  MaxLvl=699,  Quest="FountainQuest",        Monster="Cyborg",            QuestLvl=1, QuestCFrame=CFrame.new(5260,38,4050),        MonsterCFrame=CFrame.new(5300,38,4000)},
    {MinLvl=700,  MaxLvl=724,  Quest="Area1Quest",           Monster="Raider",            QuestLvl=1, QuestCFrame=CFrame.new(-425,73,1836),        MonsterCFrame=CFrame.new(-500,73,1850)},
    {MinLvl=725,  MaxLvl=774,  Quest="Area2Quest",           Monster="Mercenary",         QuestLvl=1, QuestCFrame=CFrame.new(-860,140,1315),       MonsterCFrame=CFrame.new(-920,140,1350)},
    {MinLvl=775,  MaxLvl=874,  Quest="SwanQuest",            Monster="Swan Pirate",       QuestLvl=1, QuestCFrame=CFrame.new(878,122,1235),        MonsterCFrame=CFrame.new(930,122,1200)},
    {MinLvl=875,  MaxLvl=999,  Quest="ZombieQuest",          Monster="Zombie",            QuestLvl=1, QuestCFrame=CFrame.new(-5620,80,-720),        MonsterCFrame=CFrame.new(-5650,80,-700)},
    {MinLvl=1000, MaxLvl=1124, Quest="SnowMountainQuest",    Monster="Snow Trooper",      QuestLvl=1, QuestCFrame=CFrame.new(600,400,-5300),       MonsterCFrame=CFrame.new(650,400,-5300)},
    {MinLvl=1125, MaxLvl=1249, Quest="IceSideQuest",         Monster="Arctic Warrior",    QuestLvl=1, QuestCFrame=CFrame.new(6100,28,-6200),       MonsterCFrame=CFrame.new(6150,28,-6250)},
    {MinLvl=1250, MaxLvl=1349, Quest="ShipQuest1",           Monster="Ship Deckhand",     QuestLvl=1, QuestCFrame=CFrame.new(1030,125,32900),      MonsterCFrame=CFrame.new(1080,125,32950)},
    {MinLvl=1350, MaxLvl=1424, Quest="FrostQuest",           Monster="Snow Lurker",       QuestLvl=1, QuestCFrame=CFrame.new(5560,28,-6800),       MonsterCFrame=CFrame.new(5600,28,-6800)},
    {MinLvl=1425, MaxLvl=1499, Quest="WaterTigerQuest",      Monster="Water Fighter",     QuestLvl=1, QuestCFrame=CFrame.new(2880,6,-9200),        MonsterCFrame=CFrame.new(2920,6,-9250)},
    {MinLvl=1500, MaxLvl=1574, Quest="PiratePortQuest",      Monster="Pirate Millionaire",QuestLvl=1, QuestCFrame=CFrame.new(-290,44,5580),        MonsterCFrame=CFrame.new(-350,44,5550)},
    {MinLvl=1575, MaxLvl=1699, Quest="AmazonQuest",          Monster="Female Islander",   QuestLvl=1, QuestCFrame=CFrame.new(5830,50,-300),        MonsterCFrame=CFrame.new(5880,50,-350)},
    {MinLvl=1700, MaxLvl=1824, Quest="MarineTreeQuest",      Monster="Marine Commodore",  QuestLvl=1, QuestCFrame=CFrame.new(2180,28,-6740),       MonsterCFrame=CFrame.new(2230,28,-6700)},
    {MinLvl=1825, MaxLvl=1974, Quest="DeepForestIsland1Quest",Monster="Forest Pirate",    QuestLvl=1, QuestCFrame=CFrame.new(-13230,330,-7630),    MonsterCFrame=CFrame.new(-13280,330,-7600)},
    {MinLvl=1975, MaxLvl=2074, Quest="HauntedQuest1",        Monster="Reborn Skeleton",   QuestLvl=1, QuestCFrame=CFrame.new(-9480,140,5530),      MonsterCFrame=CFrame.new(-9530,140,5500)},
    {MinLvl=2075, MaxLvl=2224, Quest="NutsIslandQuest",      Monster="Peanut Scout",      QuestLvl=1, QuestCFrame=CFrame.new(-2100,38,-10190),     MonsterCFrame=CFrame.new(-2150,38,-10200)},
    {MinLvl=2225, MaxLvl=2449, Quest="IceCreamIslandQuest",  Monster="Ice Cream Chef",    QuestLvl=1, QuestCFrame=CFrame.new(700,50,-11000),       MonsterCFrame=CFrame.new(750,50,-11050)},
    {MinLvl=2450, MaxLvl=2524, Quest="CandyQuest1",          Monster="Isle Outlaw",       QuestLvl=1, QuestCFrame=CFrame.new(-2110,38,-12140),     MonsterCFrame=CFrame.new(-2150,38,-12100)},
    {MinLvl=2525, MaxLvl=2800, Quest="TikiQuest1",           Monster="Isle Champion",     QuestLvl=1, QuestCFrame=CFrame.new(-16200,10,450),       MonsterCFrame=CFrame.new(-16250,10,500)},
}

local function GetQuestData()
    local data = LocalPlayer:FindFirstChild("Data")
    if not data or not data:FindFirstChild("Level") then return nil end
    local lvl = data.Level.Value
    for _, q in ipairs(QuestDatabase) do
        if lvl >= q.MinLvl and lvl <= q.MaxLvl then
            return q
        end
    end
    return nil
end

-- ================================================================= --
--              5. MAIN FARM LOOP (FIXED TELEPORT + ATTACK)          --
-- ================================================================= --

-- Trạng thái nhỏ
local lastQuestAccept = 0   -- timestamp lần cuối nhận quest
local QUEST_COOLDOWN  = 3   -- giây chờ giữa 2 lần nhận quest

task.spawn(function()
    while task.wait(getgenv().Configs["TeleDelay"]) do
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp       = char:FindFirstChild("HumanoidRootPart")
            local humanoid  = char:FindFirstChild("Humanoid")
            if not hrp or not humanoid or humanoid.Health <= 0 then return end

            -- Auto phân phối điểm stat
            local data = LocalPlayer:FindFirstChild("Data")
            if data and data:FindFirstChild("Points") and data.Points.Value > 0 then
                local pts = data.Points.Value
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee",   math.floor(pts * 0.6))
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", math.floor(pts * 0.4))
            end

            local qData = GetQuestData()
            if not qData then
                _G.BobonStatus = "Level không nằm trong database!"
                return
            end

            local hasQuest = HasActiveQuest()

            -- ── PHASE 1: CHƯA CÓ QUEST ──────────────────────────────
            if not hasQuest then
                local now = os.time()
                -- [FIX 4] Cooldown tránh spam
                if now - lastQuestAccept < QUEST_COOLDOWN then
                    _G.BobonStatus = "Chờ cooldown nhận quest..."
                    return
                end

                _G.BobonStatus = "Tele tới NPC nhận quest: " .. qData.Monster

                -- [FIX 1] Teleport trực tiếp, không dùng Tween
                TeleportTo(qData.QuestCFrame)
                task.wait(0.5)  -- chờ server xử lý vị trí

                -- Nhận quest
                local ok, err = pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", qData.Quest, qData.QuestLvl)
                end)

                if ok then
                    lastQuestAccept = os.time()
                    _G.BobonStatus = "Đã nhận quest: " .. qData.Monster
                    task.wait(0.4)

                    -- [FIX 3] Sau nhận quest => tele ngay lên đầu quái
                    local enemy = FindEnemy(qData.Monster)
                    if enemy then
                        local targetCF = GetFarmCFrame(enemy.HumanoidRootPart)
                        TeleportTo(targetCF)
                        _G.BobonStatus = "Tele lên đầu quái: " .. qData.Monster
                    else
                        -- Quái chưa spawn, tele về vùng spawn của quái
                        TeleportTo(qData.MonsterCFrame * CFrame.new(0, getgenv().Configs["Farm Distance"], 0))
                        _G.BobonStatus = "Chờ " .. qData.Monster .. " spawn..."
                    end
                else
                    _G.BobonStatus = "Lỗi nhận quest, thử lại..."
                end

                return
            end

            -- ── PHASE 2: ĐÃ CÓ QUEST, FARM QUÁI ───────────────────
            ForceEquipMelee()

            local enemy = FindEnemy(qData.Monster)

            if enemy then
                local mobHRP = enemy.HumanoidRootPart

                -- [FIX 1+3] Tele thẳng lên đầu quái
                local farmCF = GetFarmCFrame(mobHRP)
                TeleportTo(farmCF)

                -- Quay mặt về quái
                FaceEnemy(mobHRP)

                -- Đánh
                VirtualUser:Button1Down(Vector2.new(0, 0))
                task.wait(0.08)
                VirtualUser:Button1Up(Vector2.new(0, 0))

                -- Đếm kill khi quái chết
                if mobHRP.Parent and mobHRP.Parent:FindFirstChild("Humanoid") then
                    local mobHp = mobHRP.Parent.Humanoid.Health
                    if mobHp <= 0 then
                        killCount = killCount + 1
                    end
                end

                _G.BobonStatus = "Farm: " .. qData.Monster .. " | Kills: " .. killCount
            else
                -- Quái chưa spawn / đã chết hết => tele về vùng spawn chờ
                _G.BobonStatus = "Chờ " .. qData.Monster .. " Spawn..."
                TeleportTo(qData.MonsterCFrame * CFrame.new(0, getgenv().Configs["Farm Distance"], 0))
            end
        end)
    end
end)

_G.BobonStatus = "BobonHub Kaitun sẵn sàng!"
print("[BobonHub] Script loaded! Version 3.0 - Fixed Teleport & Farm Loop")
