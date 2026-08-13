-- ================================================================= --
--        BOBON HUB - KAITUN v4.0 | FULL REWRITE BY AXIOM           --
-- ================================================================= --
-- CHANGELOG v4.0:
--   [+] UI center màn hình + nền mờ overlay kiểu Vxeze Hub
--   [+] Auto chọn phe Hải Tặc khi load
--   [+] Auto bật Ken Haki (Observation) + Armor Haki
--   [+] Tách 2 loop riêng: QUEST LOOP + ATTACK LOOP (RunService)
--   [+] Attack loop dùng Heartbeat => đánh liên tục không bị stuck
--   [+] Tele bám theo quái realtime, không đứng 1 chỗ
--   [+] Kill counter chính xác dùng Humanoid.Died event
--   [+] Auto stat point
-- ================================================================= --

getgenv().BobonConfigs = {
    TeamName      = "Pirates",
    FarmHeight    = 20,     -- studs trên đầu quái
    HitboxSize    = 45,
    QuestCooldown = 3,      -- giây giữa 2 lần nhận quest
    AttackDelay   = 0.12,   -- giây giữa 2 lần click
}

-- ── WAIT GAME LOAD ──────────────────────────────────────────────────
repeat task.wait(0.5) until
    game:IsLoaded()
    and game.Players.LocalPlayer
    and game.Players.LocalPlayer.Character
    and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    and game.Players.LocalPlayer:FindFirstChild("Data")

-- ── SERVICES ────────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService       = game:GetService("RunService")
local VirtualUser      = game:GetService("VirtualUser")
local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")

local LP        = Players.LocalPlayer
local CommF     = ReplicatedStorage.Remotes.CommF_
local startTime = os.time()
local killCount = 0

_G.BobonStatus = "Đang khởi tạo..."

-- ================================================================= --
--                         1. UI OVERLAY                             --
-- ================================================================= --
if CoreGui:FindFirstChild("BobonHubV4") then
    CoreGui.BobonHubV4:Destroy()
end

local SG = Instance.new("ScreenGui")
SG.Name         = "BobonHubV4"
SG.Parent       = CoreGui
SG.ResetOnSpawn = false
SG.DisplayOrder = 9999
SG.IgnoreGuiInset = true

-- Nền mờ toàn màn hình (dimmed overlay)
local Dimmer = Instance.new("Frame")
Dimmer.Name                  = "Dimmer"
Dimmer.Parent                = SG
Dimmer.Size                  = UDim2.new(1, 0, 1, 0)
Dimmer.Position              = UDim2.new(0, 0, 0, 0)
Dimmer.BackgroundColor3      = Color3.fromRGB(0, 0, 0)
Dimmer.BackgroundTransparency = 0.45   -- mờ 55%
Dimmer.BorderSizePixel       = 0
Dimmer.ZIndex                = 1

-- Container chính ở giữa màn hình
local Box = Instance.new("Frame")
Box.Name                  = "Box"
Box.Parent                = SG
Box.AnchorPoint           = Vector2.new(0.5, 0.5)
Box.Position              = UDim2.new(0.5, 0, 0.5, 0)  -- giữa màn hình
Box.Size                  = UDim2.new(0, 360, 0, 230)
Box.BackgroundColor3      = Color3.fromRGB(10, 8, 22)
Box.BackgroundTransparency = 0.08
Box.BorderSizePixel       = 0
Box.ZIndex                = 2

Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 16)

local Stroke = Instance.new("UIStroke", Box)
Stroke.Color     = Color3.fromRGB(100, 80, 220)
Stroke.Thickness = 1.5

-- Layout
local Layout = Instance.new("UIListLayout", Box)
Layout.SortOrder           = Enum.SortOrder.LayoutOrder
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Padding             = UDim.new(0, 4)

local Pad = Instance.new("UIPadding", Box)
Pad.PaddingTop    = UDim.new(0, 14)
Pad.PaddingBottom = UDim.new(0, 10)

-- Helper tạo label
local function Lbl(txt, sz, col, bold, order)
    local l = Instance.new("TextLabel")
    l.Parent               = Box
    l.Size                 = UDim2.new(1, -20, 0, sz + 4)
    l.BackgroundTransparency = 1
    l.Font                 = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
    l.Text                 = txt
    l.TextColor3           = col
    l.TextSize             = sz
    l.TextXAlignment       = Enum.TextXAlignment.Center
    l.LayoutOrder          = order
    l.ZIndex               = 3
    return l
end

-- Divider
local function Div(order)
    local f = Instance.new("Frame", Box)
    f.Size               = UDim2.new(0.85, 0, 0, 1)
    f.BackgroundColor3   = Color3.fromRGB(90, 70, 200)
    f.BackgroundTransparency = 0.5
    f.BorderSizePixel    = 0
    f.LayoutOrder        = order
    f.ZIndex             = 3
    return f
end

local TitleL  = Lbl("BobonHub",           22, Color3.fromRGB(210, 195, 255), true,  1)
local SubL    = Lbl("Blox Fruit Kaitun",  13, Color3.fromRGB(140, 130, 185), false, 2)
              Div(3)
local StatL   = Lbl("Status: Đang khởi tạo...", 14, Color3.fromRGB(85, 255, 127), true, 4)
local TimeL   = Lbl("Time: 00:00:00",     12, Color3.fromRGB(200, 200, 215), false, 5)
local KillL   = Lbl("Kills: 0",           12, Color3.fromRGB(255, 165, 80),  false, 6)
              Div(7)
local BeliL   = Lbl("Beli: 0  |  Frag: 0", 12, Color3.fromRGB(85, 180, 255), false, 8)
local LvlL    = Lbl("Level: ...",          12, Color3.fromRGB(140, 255, 190), false, 9)

StatL.Font = Enum.Font.GothamBold

-- Số format
local function Fmt(n)
    local s, k = tostring(math.floor(n)), 0
    repeat s, k = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2") until k == 0
    return s
end

-- UI realtime update
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local e = os.time() - startTime
            TimeL.Text  = ("Time: %02d:%02d:%02d"):format(math.floor(e/3600), math.floor(e%3600/60), e%60)
            StatL.Text  = "Status: " .. (_G.BobonStatus or "Idle")
            KillL.Text  = "Kills: " .. killCount

            local d = LP:FindFirstChild("Data")
            if d then
                local b = d:FindFirstChild("Beli")      and d.Beli.Value      or 0
                local f = d:FindFirstChild("Fragments") and d.Fragments.Value or 0
                local v = d:FindFirstChild("Level")     and d.Level.Value     or 0
                BeliL.Text = "Beli: " .. Fmt(b) .. "  |  Frag: " .. Fmt(f)
                LvlL.Text  = "Level: " .. v
            end
        end)
    end
end)

-- ================================================================= --
--                    2. INIT: TEAM + HAKI                           --
-- ================================================================= --
task.spawn(function()
    task.wait(2)
    -- Chọn phe Hải Tặc
    pcall(function()
        CommF_:InvokeServer("SetTeam", getgenv().BobonConfigs.TeamName)
        _G.BobonStatus = "Đã chọn phe: " .. getgenv().BobonConfigs.TeamName
    end)
    task.wait(1)

    -- Bật Ken Haki (Observation Haki)
    pcall(function()
        CommF_:InvokeServer("Ken", true)
        _G.BobonStatus = "Đã bật Ken Haki"
    end)
    task.wait(0.5)

    -- Bật Armor Haki (Buso)
    pcall(function()
        CommF_:InvokeServer("Buso", true)
        _G.BobonStatus = "Đã bật Armor Haki"
    end)
    task.wait(0.5)

    _G.BobonStatus = "Sẵn sàng farm!"
end)

-- ================================================================= --
--                    3. BACKGROUND SYSTEMS                          --
-- ================================================================= --

-- Anti AFK
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.5)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Noclip liên tục
RunService.Stepped:Connect(function()
    local c = LP.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end)

-- Hitbox extender
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local c = LP.Character
            if not c then return end
            for _, tool in ipairs(c:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, p in ipairs(tool:GetDescendants()) do
                        if p:IsA("BasePart") and p.Name == "Handle" then
                            local sz = getgenv().BobonConfigs.HitboxSize
                            p.Size = Vector3.new(sz, sz, sz)
                            p.Transparency = 1
                            p.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto stat points
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local d = LP:FindFirstChild("Data")
            if d and d:FindFirstChild("Points") and d.Points.Value > 0 then
                local pts = d.Points.Value
                CommF_:InvokeServer("AddPoint", "Melee",   math.floor(pts * 0.7))
                CommF_:InvokeServer("AddPoint", "Defense", math.floor(pts * 0.3))
            end
        end)
    end
end)

-- Melee list
local MeleeList = {
    "Combat","Black Leg","Electro","Fishman Karate","Dragon Claw",
    "Superhuman","Death Step","Sharkman Karate","Electric Claw",
    "Dragon Talon","Godhuman","Sanguine Art"
}

local function EquipMelee()
    local c = LP.Character
    if not c or not c:FindFirstChild("Humanoid") then return end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            for _, n in ipairs(MeleeList) do if t.Name == n then return end end
        end
    end
    for _, t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") then
            for _, n in ipairs(MeleeList) do
                if t.Name == n then c.Humanoid:EquipTool(t); return end
            end
        end
    end
end

-- Teleport helper
local function TP(cf)
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = cf end
end

-- Tìm quái gần nhất còn sống
local function FindEnemy(name)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    local best, bd = nil, math.huge
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    for _, v in ipairs(folder:GetChildren()) do
        if v.Name == name
            and v:FindFirstChild("Humanoid")
            and v.Humanoid.Health > 0
            and v:FindFirstChild("HumanoidRootPart")
        then
            if hrp then
                local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < bd then best, bd = v, d end
            else
                return v
            end
        end
    end
    return best
end

-- Check quest active (3 fallback)
local function HasQuest()
    -- Fallback 1: QuestData trong Data
    local ok1, r1 = pcall(function()
        return LP.Data.QuestData.Name.Value ~= ""
    end)
    if ok1 and r1 then return true end

    -- Fallback 2: PlayerGui Main Quest visible
    local ok2, r2 = pcall(function()
        return LP.PlayerGui.Main.Quest.Visible
    end)
    if ok2 and r2 then return true end

    -- Fallback 3: Check xem có Quest frame con nào visible
    local ok3, r3 = pcall(function()
        local q = LP.PlayerGui.Main:FindFirstChild("Quest")
        return q ~= nil and q.Visible
    end)
    return ok3 and r3
end

-- ================================================================= --
--                       4. QUEST DATABASE                           --
-- ================================================================= --
local DB = {
    {Min=1,    Max=14,   Q="BanditQuest1",          M="Bandit",             QL=1, QC=CFrame.new(1059,16,1548),      MC=CFrame.new(1145,17,1634)},
    {Min=15,   Max=29,   Q="JungleQuest",            M="Monkey",             QL=1, QC=CFrame.new(-1598,37,152),      MC=CFrame.new(-1618,22,142)},
    {Min=30,   Max=59,   Q="JungleQuest",            M="Gorilla",            QL=2, QC=CFrame.new(-1230,6,-486),      MC=CFrame.new(-1237,6,-502)},
    {Min=60,   Max=89,   Q="PirateQuest",            M="Pirate",             QL=1, QC=CFrame.new(-1120,4,3850),      MC=CFrame.new(-1200,4,3900)},
    {Min=90,   Max=119,  Q="DesertQuest",            M="Desert Bandit",      QL=1, QC=CFrame.new(890,6,4380),        MC=CFrame.new(950,6,4400)},
    {Min=120,  Max=149,  Q="MiddleQuest",            M="Sniper",             QL=1, QC=CFrame.new(-1100,4,1500),      MC=CFrame.new(-1150,4,1450)},
    {Min=150,  Max=189,  Q="SkyQuest",               M="Sky Bandit",         QL=1, QC=CFrame.new(-4850,718,-2620),   MC=CFrame.new(-4950,718,-2630)},
    {Min=190,  Max=274,  Q="PrisonQuest",            M="Prisoner",           QL=1, QC=CFrame.new(530,2,480),         MC=CFrame.new(480,2,530)},
    {Min=275,  Max=374,  Q="ColosseumQuest",         M="Toga Warrior",       QL=1, QC=CFrame.new(-1580,7,-2980),     MC=CFrame.new(-1640,7,-2980)},
    {Min=375,  Max=449,  Q="MagmaQuest",             M="Military Soldier",   QL=1, QC=CFrame.new(-5250,8,8480),      MC=CFrame.new(-5300,8,8530)},
    {Min=450,  Max=524,  Q="FishmanQuest",           M="Fishman Warrior",    QL=1, QC=CFrame.new(61120,18,1560),     MC=CFrame.new(61000,18,1500)},
    {Min=525,  Max=624,  Q="Sky2Quest",              M="God's Guard",        QL=1, QC=CFrame.new(-7730,5600,-1430),  MC=CFrame.new(-7650,5600,-1400)},
    {Min=625,  Max=699,  Q="FountainQuest",          M="Cyborg",             QL=1, QC=CFrame.new(5260,38,4050),      MC=CFrame.new(5300,38,4000)},
    {Min=700,  Max=724,  Q="Area1Quest",             M="Raider",             QL=1, QC=CFrame.new(-425,73,1836),      MC=CFrame.new(-500,73,1850)},
    {Min=725,  Max=774,  Q="Area2Quest",             M="Mercenary",          QL=1, QC=CFrame.new(-860,140,1315),     MC=CFrame.new(-920,140,1350)},
    {Min=775,  Max=874,  Q="SwanQuest",              M="Swan Pirate",        QL=1, QC=CFrame.new(878,122,1235),      MC=CFrame.new(930,122,1200)},
    {Min=875,  Max=999,  Q="ZombieQuest",            M="Zombie",             QL=1, QC=CFrame.new(-5620,80,-720),     MC=CFrame.new(-5650,80,-700)},
    {Min=1000, Max=1124, Q="SnowMountainQuest",      M="Snow Trooper",       QL=1, QC=CFrame.new(600,400,-5300),     MC=CFrame.new(650,400,-5300)},
    {Min=1125, Max=1249, Q="IceSideQuest",           M="Arctic Warrior",     QL=1, QC=CFrame.new(6100,28,-6200),     MC=CFrame.new(6150,28,-6250)},
    {Min=1250, Max=1349, Q="ShipQuest1",             M="Ship Deckhand",      QL=1, QC=CFrame.new(1030,125,32900),    MC=CFrame.new(1080,125,32950)},
    {Min=1350, Max=1424, Q="FrostQuest",             M="Snow Lurker",        QL=1, QC=CFrame.new(5560,28,-6800),     MC=CFrame.new(5600,28,-6800)},
    {Min=1425, Max=1499, Q="WaterTigerQuest",        M="Water Fighter",      QL=1, QC=CFrame.new(2880,6,-9200),      MC=CFrame.new(2920,6,-9250)},
    {Min=1500, Max=1574, Q="PiratePortQuest",        M="Pirate Millionaire", QL=1, QC=CFrame.new(-290,44,5580),      MC=CFrame.new(-350,44,5550)},
    {Min=1575, Max=1699, Q="AmazonQuest",            M="Female Islander",    QL=1, QC=CFrame.new(5830,50,-300),      MC=CFrame.new(5880,50,-350)},
    {Min=1700, Max=1824, Q="MarineTreeQuest",        M="Marine Commodore",   QL=1, QC=CFrame.new(2180,28,-6740),     MC=CFrame.new(2230,28,-6700)},
    {Min=1825, Max=1974, Q="DeepForestIsland1Quest", M="Forest Pirate",      QL=1, QC=CFrame.new(-13230,330,-7630),  MC=CFrame.new(-13280,330,-7600)},
    {Min=1975, Max=2074, Q="HauntedQuest1",          M="Reborn Skeleton",    QL=1, QC=CFrame.new(-9480,140,5530),    MC=CFrame.new(-9530,140,5500)},
    {Min=2075, Max=2224, Q="NutsIslandQuest",        M="Peanut Scout",       QL=1, QC=CFrame.new(-2100,38,-10190),   MC=CFrame.new(-2150,38,-10200)},
    {Min=2225, Max=2449, Q="IceCreamIslandQuest",    M="Ice Cream Chef",     QL=1, QC=CFrame.new(700,50,-11000),     MC=CFrame.new(750,50,-11050)},
    {Min=2450, Max=2524, Q="CandyQuest1",            M="Isle Outlaw",        QL=1, QC=CFrame.new(-2110,38,-12140),   MC=CFrame.new(-2150,38,-12100)},
    {Min=2525, Max=2800, Q="TikiQuest1",             M="Isle Champion",      QL=1, QC=CFrame.new(-16200,10,450),     MC=CFrame.new(-16250,10,500)},
}

local function GetQ()
    local d = LP:FindFirstChild("Data")
    if not d or not d:FindFirstChild("Level") then return nil end
    local lv = d.Level.Value
    for _, q in ipairs(DB) do
        if lv >= q.Min and lv <= q.Max then return q end
    end
    return nil
end

-- ================================================================= --
--          5. LOOP 1: QUEST LOOP (nhận quest, tele tới quái)        --
-- ================================================================= --
local lastQuestTime = 0
local currentEnemy  = nil   -- quái đang bị target (shared với attack loop)

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local c = LP.Character
            if not c or not c:FindFirstChild("HumanoidRootPart") then return end
            local hrp = c.HumanoidRootPart
            local hum = c:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then return end

            local qd = GetQ()
            if not qd then
                _G.BobonStatus = "Level ngoài database!"
                return
            end

            local hasQ = HasQuest()

            -- ── CHƯA CÓ QUEST: tele NPC nhận quest ─────────────────
            if not hasQ then
                currentEnemy = nil   -- reset target

                local now = os.time()
                if now - lastQuestTime < getgenv().BobonConfigs.QuestCooldown then
                    _G.BobonStatus = "Chờ cooldown nhận quest..."
                    return
                end

                _G.BobonStatus = "Tele NPC → Nhận quest: " .. qd.M
                TP(qd.QC)
                task.wait(0.6)

                CommF_:InvokeServer("StartQuest", qd.Q, qd.QL)
                lastQuestTime = os.time()
                task.wait(0.4)

                -- Sau khi nhận quest => tele thẳng lên đầu quái
                local e = FindEnemy(qd.M)
                if e then
                    local eHRP = e.HumanoidRootPart
                    TP(CFrame.new(eHRP.Position + Vector3.new(0, getgenv().BobonConfigs.FarmHeight, 0)))
                    currentEnemy = e
                    _G.BobonStatus = "Đã nhận quest, tele lên đầu: " .. qd.M
                else
                    TP(CFrame.new(qd.MC.Position + Vector3.new(0, getgenv().BobonConfigs.FarmHeight, 0)))
                    _G.BobonStatus = "Chờ " .. qd.M .. " spawn..."
                end
                return
            end

            -- ── ĐÃ CÓ QUEST: cập nhật target quái ──────────────────
            local e = FindEnemy(qd.M)
            if e then
                currentEnemy = e
                _G.BobonStatus = "Farming: " .. qd.M .. " | Kills: " .. killCount
            else
                currentEnemy = nil
                _G.BobonStatus = "Chờ " .. qd.M .. " spawn..."
                -- Tele về vùng spawn chờ
                TP(CFrame.new(qd.MC.Position + Vector3.new(0, getgenv().BobonConfigs.FarmHeight, 0)))
            end
        end)
    end
end)

-- ================================================================= --
--     6. LOOP 2: ATTACK LOOP (RunService.Heartbeat - đánh liên tục) --
-- ================================================================= --
local lastAttack = 0

RunService.Heartbeat:Connect(function()
    pcall(function()
        local now = tick()
        if now - lastAttack < getgenv().BobonConfigs.AttackDelay then return end
        lastAttack = now

        if not currentEnemy then return end

        -- Kiểm tra quái còn sống
        local mobHum = currentEnemy:FindFirstChild("Humanoid")
        local mobHRP = currentEnemy:FindFirstChild("HumanoidRootPart")
        if not mobHum or not mobHRP or mobHum.Health <= 0 then
            currentEnemy = nil
            return
        end

        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChild("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        EquipMelee()

        -- Tele bám theo quái liên tục (trên đầu quái)
        local targetPos = mobHRP.Position + Vector3.new(0, getgenv().BobonConfigs.FarmHeight, 0)
        hrp.CFrame = CFrame.new(targetPos, mobHRP.Position)

        -- Đánh
        VirtualUser:Button1Down(Vector2.new(0, 0))
        VirtualUser:Button1Up(Vector2.new(0, 0))
    end)
end)

-- ================================================================= --
--         7. KILL COUNTER: dùng Humanoid.Died event                 --
-- ================================================================= --
-- Theo dõi quái mới spawn và gắn event Died
local function WatchEnemies()
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return end

    local function HookDied(mob)
        local hum = mob:FindFirstChild("Humanoid")
        if hum then
            hum.Died:Connect(function()
                killCount = killCount + 1
            end)
        end
    end

    -- Hook tất cả quái hiện có
    for _, mob in ipairs(folder:GetChildren()) do
        HookDied(mob)
    end

    -- Hook quái mới spawn
    folder.ChildAdded:Connect(function(mob)
        task.wait(0.1)
        HookDied(mob)
    end)
end

task.spawn(WatchEnemies)

-- Re-bật haki mỗi 30 giây (phòng tắt)
task.spawn(function()
    while task.wait(30) do
        pcall(function()
            CommF_:InvokeServer("Ken",  true)
            CommF_:InvokeServer("Buso", true)
        end)
    end
end)

_G.BobonStatus = "BobonHub v4.0 sẵn sàng!"
print("[BobonHub v4.0] Loaded | Team: Pirates | Haki: ON | Farm: ACTIVE")
