-- ================================================================= --
--        BOBON HUB - KAITUN v4.1 | FIXED BY AXIOM                  --
-- ================================================================= --
-- CHANGELOG v4.1:
--   [FIX] Quest loop stuck - sửa lại flow teleport + attack
--   [FIX] Enemy detection với fallback cho cả Enemies và ReplicatedStorage
--   [+] Hỗ trợ đầy đủ Sea 1, Sea 2, Sea 3 (đến lv 2800)
--   [+] Bỏ UI overlay - chỉ log status vào console
--   [+] TP logic cải thiện: tele tới spawn area trước, đợi quái spawn
--   [+] Kill counter chính xác với HealthChanged event
-- ================================================================= --

getgenv().BobonConfigs = {
    TeamName      = "Pirates",
    FarmHeight    = 25,
    HitboxSize    = 50,
    AttackDelay   = 0.08,
    TeleportSpeed = 1,
}

-- ── WAIT GAME LOAD ──────────────────────────────────────────────────
repeat task.wait(0.5) until
    game:IsLoaded()
    and game.Players.LocalPlayer
    and game.Players.LocalPlayer.Character
    and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- ── SERVICES ────────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService       = game:GetService("RunService")
local VirtualUser      = game:GetService("VirtualUser")
local TweenService     = game:GetService("TweenService")

local LP        = Players.LocalPlayer
local CommF_    = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local startTime = os.time()
local killCount = 0

_G.BobonStatus = "Khởi động..."

-- ================================================================= --
--                     CORE FUNCTIONS                                --
-- ================================================================= --

-- Anti AFK
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.3)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Noclip
RunService.Stepped:Connect(function()
    pcall(function()
        local c = LP.Character
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end)
end)

-- Teleport with tween
local function TP(cf, speed)
    pcall(function()
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local dist = (hrp.Position - cf.Position).Magnitude
        if dist < 10 then
            hrp.CFrame = cf
            return
        end

        local spd = speed or getgenv().BobonConfigs.TeleportSpeed
        local ti = TweenInfo.new(dist / 350 * spd, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, ti, {CFrame = cf})
        tween:Play()
    end)
end

-- Instant TP (no tween)
local function TPInstant(cf)
    pcall(function()
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = cf
        end
    end)
end

-- Melee weapons
local MeleeList = {
    "Combat","Black Leg","Electro","Fishman Karate","Dragon Claw",
    "Superhuman","Death Step","Sharkman Karate","Electric Claw",
    "Dragon Talon","Godhuman","Sanguine Art"
}

local function EquipMelee()
    pcall(function()
        local c = LP.Character
        if not c or not c:FindFirstChild("Humanoid") then return end

        -- Check đã cầm melee chưa
        for _, t in ipairs(c:GetChildren()) do
            if t:IsA("Tool") then
                for _, n in ipairs(MeleeList) do
                    if t.Name == n then return end
                end
            end
        end

        -- Equip từ backpack
        for _, t in ipairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") then
                for _, n in ipairs(MeleeList) do
                    if t.Name == n then
                        c.Humanoid:EquipTool(t)
                        return
                    end
                end
            end
        end
    end)
end

-- Tìm quái (với fallback tới ReplicatedStorage nếu ko thấy trong workspace)
local function FindEnemy(mobName)
    -- Tìm trong workspace.Enemies
    local folder = workspace:FindFirstChild("Enemies")
    if folder then
        for _, v in ipairs(folder:GetChildren()) do
            if v.Name == mobName
                and v:FindFirstChild("Humanoid")
                and v.Humanoid.Health > 0
                and v:FindFirstChild("HumanoidRootPart")
            then
                return v
            end
        end
    end

    -- Fallback: check ReplicatedStorage (một số mob ẩn ở đây)
    local rs = ReplicatedStorage:FindFirstChild("Enemies")
    if rs then
        for _, v in ipairs(rs:GetChildren()) do
            if v.Name == mobName then
                return v
            end
        end
    end

    return nil
end

-- Check quest đang active
local function HasQuest()
    local ok1, r1 = pcall(function()
        local qData = LP:FindFirstChild("PlayerGui")
            and LP.PlayerGui:FindFirstChild("Main")
            and LP.PlayerGui.Main:FindFirstChild("Quest")
        return qData and qData.Visible == true
    end)
    if ok1 and r1 then return true end

    local ok2, r2 = pcall(function()
        return LP.Data.QuestData.Name.Value ~= ""
    end)
    return ok2 and r2
end

-- Auto stat
task.spawn(function()
    while task.wait(3) do
        pcall(function()
            local d = LP:FindFirstChild("Data")
            if d and d:FindFirstChild("Points") and d.Points.Value > 0 then
                local pts = d.Points.Value
                CommF_:InvokeServer("AddPoint", "Melee", math.floor(pts * 0.6))
                CommF_:InvokeServer("AddPoint", "Defense", math.floor(pts * 0.4))
            end
        end)
    end
end)

-- Hitbox extender
task.spawn(function()
    while task.wait(1) do
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

-- ================================================================= --
--                   QUEST DATABASE (SEA 1 + 2 + 3)                  --
-- ================================================================= --
local QuestDB = {
    -- SEA 1 (1-700)
    {Min=1,    Max=9,    Q="BanditQuest1",           M="Bandit",              QL=1, QC=CFrame.new(1059.37,16.55,1549.90),      MC=CFrame.new(1145,17,1634)},
    {Min=10,   Max=14,   Q="BanditQuest1",           M="Bandit",              QL=1, QC=CFrame.new(1059.37,16.55,1549.90),      MC=CFrame.new(1145,17,1634)},
    {Min=15,   Max=29,   Q="JungleQuest",            M="Monkey",              QL=1, QC=CFrame.new(-1598.08,37.00,152.88),      MC=CFrame.new(-1448,50,24)},
    {Min=30,   Max=39,   Q="BuggyQuest1",            M="Pirate",              QL=1, QC=CFrame.new(-1141.07,4.10,3831.50),      MC=CFrame.new(-1103,14,3836)},
    {Min=40,   Max=59,   Q="BuggyQuest1",            M="Brute",               QL=2, QC=CFrame.new(-1141.07,4.10,3831.50),      MC=CFrame.new(-1140,15,4314)},
    {Min=60,   Max=74,   Q="DesertQuest",            M="Desert Bandit",       QL=1, QC=CFrame.new(894.49,6.44,4392.13),        MC=CFrame.new(932,6,4488)},
    {Min=75,   Max=89,   Q="DesertQuest",            M="Desert Officer",      QL=2, QC=CFrame.new(894.49,6.44,4392.13),        MC=CFrame.new(1608,7,4371)},
    {Min=90,   Max=99,   Q="SnowQuest",              M="Snow Bandit",         QL=1, QC=CFrame.new(1389.74,87.27,-1298.90),     MC=CFrame.new(1317,87,-1318)},
    {Min=100,  Max=119,  Q="SnowQuest",              M="Snowman",             QL=2, QC=CFrame.new(1389.74,87.27,-1298.90),     MC=CFrame.new(1198,87,-1370)},
    {Min=120,  Max=149,  Q="MarineQuest2",           M="Chief Petty Officer", QL=1, QC=CFrame.new(-5039.58,28.65,4325.45),     MC=CFrame.new(-4881,22,4273)},
    {Min=150,  Max=174,  Q="MarineQuest2",           M="Sky Bandit",          QL=2, QC=CFrame.new(-5039.58,28.65,4325.45),     MC=CFrame.new(-4953,295,3951)},
    {Min=175,  Max=189,  Q="PrisonerQuest",          M="Prisoner",            QL=1, QC=CFrame.new(5308.93,0.20,474.95),        MC=CFrame.new(5411,0,485)},
    {Min=190,  Max=209,  Q="PrisonerQuest",          M="Dangerous Prisoner",  QL=2, QC=CFrame.new(5308.93,0.20,474.95),        MC=CFrame.new(5654,0,755)},
    {Min=210,  Max=249,  Q="ColosseumQuest",         M="Toga Warrior",        QL=1, QC=CFrame.new(-1580.04,7.39,-2986.47),    MC=CFrame.new(-1824,7,-2743)},
    {Min=250,  Max=274,  Q="ColosseumQuest",         M="Gladiator",           QL=2, QC=CFrame.new(-1580.04,7.39,-2986.47),    MC=CFrame.new(-1292,7,-3229)},
    {Min=275,  Max=299,  Q="MagmaQuest",             M="Military Soldier",    QL=1, QC=CFrame.new(-5313.37,10.95,8515.29),     MC=CFrame.new(-5408,11,8450)},
    {Min=300,  Max=324,  Q="MagmaQuest",             M="Military Spy",        QL=2, QC=CFrame.new(-5313.37,10.95,8515.29),     MC=CFrame.new(-5802,86,8255)},
    {Min=325,  Max=374,  Q="FishmanQuest",           M="Fishman Warrior",     QL=1, QC=CFrame.new(61122.65,18.50,1569.38),     MC=CFrame.new(60946,18,1504)},
    {Min=375,  Max=399,  Q="FishmanQuest",           M="Fishman Commando",    QL=2, QC=CFrame.new(61122.65,18.50,1569.38),     MC=CFrame.new(61798,18,1489)},
    {Min=400,  Max=449,  Q="SkyExp1Quest",           M="God's Guard",         QL=1, QC=CFrame.new(-4721.88,845.30,-1912.69),   MC=CFrame.new(-4628,845,-1932)},
    {Min=450,  Max=474,  Q="SkyExp1Quest",           M="Shanda",              QL=2, QC=CFrame.new(-7859.09,5544.19,381.47),    MC=CFrame.new(-7685,5567,387)},
    {Min=475,  Max=524,  Q="SkyExp2Quest",           M="Royal Squad",         QL=1, QC=CFrame.new(-7906.81,5634.60,-1411.99),  MC=CFrame.new(-7564,5608,-1442)},
    {Min=525,  Max=549,  Q="SkyExp2Quest",           M="Royal Soldier",       QL=2, QC=CFrame.new(-7906.81,5634.60,-1411.99),  MC=CFrame.new(-7836,5606,-1810)},
    {Min=550,  Max=624,  Q="FountainQuest",          M="Galley Pirate",       QL=1, QC=CFrame.new(5259.81,37.72,4050.45),      MC=CFrame.new(5551,42,3946)},
    {Min=625,  Max=649,  Q="FountainQuest",          M="Galley Captain",      QL=2, QC=CFrame.new(5259.81,37.72,4050.45),      MC=CFrame.new(5441,42,5656)},
    {Min=650,  Max=699,  Q="ZombieQuest",            M="Zombie",              QL=1, QC=CFrame.new(-5497.06,48.51,-794.59),     MC=CFrame.new(-5739,49,-795)},

    -- SEA 2 (700-1500)
    {Min=700,  Max=724,  Q="Area1Quest",             M="Raider",              QL=1, QC=CFrame.new(-429.54,73.00,1836.54),      MC=CFrame.new(-746,40,2507)},
    {Min=725,  Max=774,  Q="Area1Quest",             M="Mercenary",           QL=2, QC=CFrame.new(-429.54,73.00,1836.54),      MC=CFrame.new(-874,141,1312)},
    {Min=775,  Max=799,  Q="Area2Quest",             M="Swan Pirate",         QL=1, QC=CFrame.new(638.43,71.77,918.28),        MC=CFrame.new(878,122,1235)},
    {Min=800,  Max=874,  Q="Area2Quest",             M="Factory Staff",       QL=2, QC=CFrame.new(638.43,71.77,918.28),        MC=CFrame.new(295,73,-56)},
    {Min=875,  Max=899,  Q="MarineQuest3",           M="Marine Lieutenant",   QL=1, QC=CFrame.new(-2440.79,71.72,-3216.06),    MC=CFrame.new(-2842,73,-2901)},
    {Min=900,  Max=949,  Q="MarineQuest3",           M="Marine Captain",      QL=2, QC=CFrame.new(-2440.79,71.72,-3216.06),    MC=CFrame.new(-1814,73,-3208)},
    {Min=950,  Max=974,  Q="PiratePortQuest",        M="Zombie",              QL=1, QC=CFrame.new(-6567.02,6.89,-428.44),      MC=CFrame.new(-5736,126,-686)},
    {Min=975,  Max=999,  Q="PiratePortQuest",        M="Vampire",             QL=2, QC=CFrame.new(-6567.02,6.89,-428.44),      MC=CFrame.new(-6033,6,-1313)},
    {Min=1000, Max=1049, Q="SnowMountainQuest",      M="Snow Trooper",        QL=1, QC=CFrame.new(609.86,400.12,-5372.25),     MC=CFrame.new(621,401,-5329)},
    {Min=1050, Max=1099, Q="SnowMountainQuest",      M="Winter Warrior",      QL=2, QC=CFrame.new(609.86,400.12,-5372.25),     MC=CFrame.new(1295,429,-5087)},
    {Min=1100, Max=1124, Q="IceSideQuest",           M="Lab Subordinate",     QL=1, QC=CFrame.new(5827.04,15.92,-6420.17),     MC=CFrame.new(6109,16,-6178)},
    {Min=1125, Max=1174, Q="IceSideQuest",           M="Horned Warrior",      QL=2, QC=CFrame.new(5827.04,15.92,-6420.17),     MC=CFrame.new(6341,16,-6723)},
    {Min=1175, Max=1199, Q="ShipQuest1",             M="Living Zombie",       QL=1, QC=CFrame.new(1037.80,125.78,32911.10),    MC=CFrame.new(942,125,32853)},
    {Min=1200, Max=1249, Q="ShipQuest1",             M="Demonic Soul",        QL=2, QC=CFrame.new(1037.80,125.78,32911.10),    MC=CFrame.new(1082,126,33098)},
    {Min=1250, Max=1274, Q="ShipQuest2",             M="Posessed Mummy",      QL=1, QC=CFrame.new(921.22,125.78,33000.52),     MC=CFrame.new(389,41,32474)},
    {Min=1275, Max=1299, Q="ShipQuest2",             M="Peanut Scout",        QL=2, QC=CFrame.new(921.22,125.78,33000.52),     MC=CFrame.new(-2103,38,-10192)},
    {Min=1300, Max=1324, Q="FrostQuest",             M="Sea Soldier",         QL=1, QC=CFrame.new(5259.02,23.56,-6178.20),     MC=CFrame.new(5411,16,-6181)},
    {Min=1325, Max=1349, Q="FrostQuest",             M="Arctic Warrior",      QL=2, QC=CFrame.new(5259.02,23.56,-6178.20),     MC=CFrame.new(6041,29,-6235)},

    -- SEA 3 (1500-2800)
    {Min=1500, Max=1524, Q="PiratePortQuest",        M="Pirate Millionaire",  QL=1, QC=CFrame.new(-289.61,43.82,5579.94),      MC=CFrame.new(-435,44,5551)},
    {Min=1525, Max=1574, Q="PiratePortQuest",        M="Pistol Billionaire",  QL=2, QC=CFrame.new(-289.61,43.82,5579.94),      MC=CFrame.new(-52,44,5584)},
    {Min=1575, Max=1599, Q="AmazonQuest",            M="Dragon Crew Warrior", QL=1, QC=CFrame.new(5832.83,51.60,-1101.51),     MC=CFrame.new(6241,52,-1290)},
    {Min=1600, Max=1624, Q="AmazonQuest",            M="Dragon Crew Archer",  QL=2, QC=CFrame.new(5832.83,51.60,-1101.51),     MC=CFrame.new(6488,383,139)},
    {Min=1625, Max=1649, Q="AmazonQuest2",           M="Female Islander",     QL=1, QC=CFrame.new(5448.86,601.62,749.45),      MC=CFrame.new(5217,845,1069)},
    {Min=1650, Max=1699, Q="AmazonQuest2",           M="Giant Islander",      QL=2, QC=CFrame.new(5448.86,601.62,749.45),      MC=CFrame.new(4729,657,-55)},
    {Min=1700, Max=1724, Q="MarineTreeIsland",       M="Marine Commodore",    QL=1, QC=CFrame.new(2180.54,27.80,-6741.50),     MC=CFrame.new(2490,73,-7144)},
    {Min=1725, Max=1774, Q="MarineTreeIsland",       M="Marine Rear Admiral", QL=2, QC=CFrame.new(2180.54,27.80,-6741.50),     MC=CFrame.new(3671,401,-6982)},
    {Min=1775, Max=1799, Q="DeepForestIsland",       M="Mythological Pirate", QL=1, QC=CFrame.new(-13234.04,331.49,-7625.40),  MC=CFrame.new(-13478,470,-6985)},
    {Min=1800, Max=1849, Q="DeepForestIsland2",      M="Jungle Pirate",       QL=1, QC=CFrame.new(-12680.45,389.97,-9902.50),  MC=CFrame.new(-12107,332,-10549)},
    {Min=1850, Max=1899, Q="DeepForestIsland3",      M="Forest Pirate",       QL=1, QC=CFrame.new(-13257.73,331.49,-7923.70),  MC=CFrame.new(-13225,425,-7755)},
    {Min=1900, Max=1924, Q="PeanutIslandQuest",      M="Peanut Scout",        QL=1, QC=CFrame.new(-2104.35,38.10,-10192.60),   MC=CFrame.new(-2124,123,-10354)},
    {Min=1925, Max=1974, Q="PeanutIslandQuest",      M="Peanut President",    QL=2, QC=CFrame.new(-2104.35,38.10,-10192.60),   MC=CFrame.new(-1859,38,-10238)},
    {Min=1975, Max=1999, Q="IceCreamIslandQuest",    M="Ice Cream Chef",      QL=1, QC=CFrame.new(-820.64,65.82,-10965.10),    MC=CFrame.new(-641,210,-11077)},
    {Min=2000, Max=2024, Q="IceCreamIslandQuest",    M="Ice Cream Commander", QL=2, QC=CFrame.new(-820.64,65.82,-10965.10),    MC=CFrame.new(-558,115,-11253)},
    {Min=2025, Max=2049, Q="CakeQuest1",             M="Cookie Crafter",      QL=1, QC=CFrame.new(-2021.32,37.80,-12028.70),   MC=CFrame.new(-2365,38,-12099)},
    {Min=2050, Max=2074, Q="CakeQuest1",             M="Cake Guard",          QL=2, QC=CFrame.new(-2021.32,37.80,-12028.70),   MC=CFrame.new(-1651,38,-12308)},
    {Min=2075, Max=2099, Q="CakeQuest2",             M="Baking Staff",        QL=1, QC=CFrame.new(-1927.91,37.80,-12842.50),   MC=CFrame.new(-1980,38,-12850)},
    {Min=2100, Max=2124, Q="CakeQuest2",             M="Head Baker",          QL=2, QC=CFrame.new(-1927.91,37.80,-12842.50),   MC=CFrame.new(-2203,109,-12788)},
    {Min=2125, Max=2149, Q="ChocQuest1",             M="Cocoa Warrior",       QL=1, QC=CFrame.new(233.22,24.90,-12201.20),     MC=CFrame.new(167,73,-12238)},
    {Min=2150, Max=2199, Q="ChocQuest1",             M="Chocolate Bar Battler", QL=2, QC=CFrame.new(233.22,24.90,-12201.20),  MC=CFrame.new(618,25,-12585)},
    {Min=2200, Max=2224, Q="ChocQuest2",             M="Sweet Thief",         QL=1, QC=CFrame.new(150.50,24.90,-12774.80),     MC=CFrame.new(-102,25,-12804)},
    {Min=2225, Max=2274, Q="ChocQuest2",             M="Candy Rebel",         QL=2, QC=CFrame.new(150.50,24.90,-12774.80),     MC=CFrame.new(134,77,-12882)},
    {Min=2275, Max=2299, Q="HauntedQuest1",          M="Haunted Specter",     QL=1, QC=CFrame.new(-9479.20,141.22,5566.09),    MC=CFrame.new(-9631,142,5499)},
    {Min=2300, Max=2324, Q="HauntedQuest2",          M="Reborn Skeleton",     QL=1, QC=CFrame.new(-9516.99,172.14,6078.46),    MC=CFrame.new(-8760,142,6016)},
    {Min=2325, Max=2349, Q="HauntedQuest2",          M="Living Zombie",       QL=2, QC=CFrame.new(-9516.99,172.14,6078.46),    MC=CFrame.new(-10144,140,5932)},
    {Min=2350, Max=2374, Q="HauntedQuest3",          M="Demonic Soul",        QL=1, QC=CFrame.new(-9481.14,172.13,6078.88),    MC=CFrame.new(-9712,204,6193)},
    {Min=2375, Max=2399, Q="HauntedQuest3",          M="Posessed Mummy",      QL=2, QC=CFrame.new(-9481.14,172.13,6078.88),    MC=CFrame.new(-9583,6,6233)},
    {Min=2400, Max=2424, Q="NutsIslandQuest",        M="Peanut Scout",        QL=1, QC=CFrame.new(-2104.35,38.10,-10192.60),   MC=CFrame.new(-2124,123,-10354)},
    {Min=2425, Max=2449, Q="NutsIslandQuest",        M="Peanut President",    QL=2, QC=CFrame.new(-2104.35,38.10,-10192.60),   MC=CFrame.new(-1859,38,-10238)},
    {Min=2450, Max=2474, Q="TikiOutpost1",           M="Isle Outlaw",         QL=1, QC=CFrame.new(-16547.45,55.68,1051.56),    MC=CFrame.new(-16342,58,1032)},
    {Min=2475, Max=2524, Q="TikiOutpost2",           M="Island Boy",          QL=1, QC=CFrame.new(-16542.45,55.68,1044.41),    MC=CFrame.new(-16912,58,835)},
    {Min=2525, Max=2549, Q="TikiOutpost3",           M="Sun-kissed Warrior",  QL=1, QC=CFrame.new(-16541.75,55.68,1041.34),    MC=CFrame.new(-16348,58,461)},
    {Min=2550, Max=2799, Q="TikiOutpost4",           M="Isle Champion",       QL=1, QC=CFrame.new(-16540.45,55.68,1044.41),    MC=CFrame.new(-16753,58,1043)},
    {Min=2800, Max=3000, Q="TikiOutpost4",           M="Isle Champion",       QL=1, QC=CFrame.new(-16540.45,55.68,1044.41),    MC=CFrame.new(-16753,58,1043)},
}

local function GetQuest()
    local lv = LP.Data:FindFirstChild("Level") and LP.Data.Level.Value or 1
    for _, q in ipairs(QuestDB) do
        if lv >= q.Min and lv <= q.Max then
            return q
        end
    end
    return nil
end

-- ================================================================= --
--                    KHỞI ĐỘNG: TEAM + HAKI                         --
-- ================================================================= --
task.spawn(function()
    task.wait(2)
    pcall(function()
        CommF_:InvokeServer("SetTeam", getgenv().BobonConfigs.TeamName)
        print("[BobonHub] Đã chọn phe: " .. getgenv().BobonConfigs.TeamName)
    end)
    task.wait(1)
    pcall(function()
        CommF_:InvokeServer("Ken", true)
        print("[BobonHub] Đã bật Ken Haki")
    end)
    task.wait(0.5)
    pcall(function()
        CommF_:InvokeServer("Buso", true)
        print("[BobonHub] Đã bật Armor Haki")
    end)
end)

-- Re-enable haki every 30s
task.spawn(function()
    while task.wait(30) do
        pcall(function()
            CommF_:InvokeServer("Ken", true)
            CommF_:InvokeServer("Buso", true)
        end)
    end
end)

-- ================================================================= --
--                      MAIN FARM LOOP                               --
-- ================================================================= --
local currentTarget = nil
local lastAttackTick = 0
local questCooldown = 0

-- QUEST + TARGETING LOOP
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local c = LP.Character
            if not c or not c:FindFirstChild("HumanoidRootPart") then return end
            local hrp = c.HumanoidRootPart
            local hum = c:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then return end

            local qData = GetQuest()
            if not qData then
                _G.BobonStatus = "Level không có trong database!"
                return
            end

            -- Check có quest không
            if not HasQuest() then
                -- Cooldown check
                if os.time() < questCooldown then
                    _G.BobonStatus = "Chờ cooldown quest..."
                    return
                end

                -- Tele tới NPC quest
                _G.BobonStatus = "Tele NPC quest: " .. qData.M
                TPInstant(qData.QC)
                task.wait(0.8)

                -- Nhận quest
                CommF_:InvokeServer("StartQuest", qData.Q, qData.QL)
                questCooldown = os.time() + 2
                print("[BobonHub] Đã nhận quest: " .. qData.M)
                task.wait(0.5)

                -- Tele tới spawn area của quái
                TPInstant(CFrame.new(qData.MC.Position.X, qData.MC.Position.Y + getgenv().BobonConfigs.FarmHeight, qData.MC.Position.Z))
                return
            end

            -- Đã có quest => tìm quái
            local enemy = FindEnemy(qData.M)
            if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                currentTarget = enemy
                _G.BobonStatus = "Farm: " .. qData.M .. " | Kills: " .. killCount

                -- Tele bám theo quái
                local ePos = enemy.HumanoidRootPart.Position
                local targetCF = CFrame.new(ePos.X, ePos.Y + getgenv().BobonConfigs.FarmHeight, ePos.Z)
                TPInstant(targetCF)
            else
                currentTarget = nil
                _G.BobonStatus = "Chờ " .. qData.M .. " spawn..."
                -- Tele về spawn area
                TPInstant(CFrame.new(qData.MC.Position.X, qData.MC.Position.Y + getgenv().BobonConfigs.FarmHeight, qData.MC.Position.Z))
            end
        end)
    end
end)

-- ATTACK LOOP (Heartbeat)
RunService.Heartbeat:Connect(function()
    pcall(function()
        if not currentTarget then return end

        local now = tick()
        if now - lastAttackTick < getgenv().BobonConfigs.AttackDelay then return end
        lastAttackTick = now

        local mobHum = currentTarget:FindFirstChild("Humanoid")
        local mobHRP = currentTarget:FindFirstChild("HumanoidRootPart")

        if not mobHum or not mobHRP or mobHum.Health <= 0 then
            currentTarget = nil
            return
        end

        local c = LP.Character
        if not c then return end
        local hum = c:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then return end

        EquipMelee()

        -- Click attack
        VirtualUser:Button1Down(Vector2.new(0, 0))
        task.wait(0.01)
        VirtualUser:Button1Up(Vector2.new(0, 0))
    end)
end)

-- ================================================================= --
--                        KILL COUNTER                               --
-- ================================================================= --
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local folder = workspace:FindFirstChild("Enemies")
            if not folder then return end

            for _, mob in ipairs(folder:GetChildren()) do
                local hum = mob:FindFirstChild("Humanoid")
                if hum and not hum:GetAttribute("KillTracked") then
                    hum:SetAttribute("KillTracked", true)

                    hum.HealthChanged:Connect(function(health)
                        if health <= 0 then
                            killCount = killCount + 1
                        end
                    end)
                end
            end
        end)
    end
end)

-- ================================================================= --
--                          STATUS LOG                               --
-- ================================================================= --
task.spawn(function()
    while task.wait(5) do
        local elapsed = os.time() - startTime
        local hrs = math.floor(elapsed / 3600)
        local mins = math.floor((elapsed % 3600) / 60)
        local secs = elapsed % 60

        print(string.format(
            "[BobonHub v4.1] %s | Time: %02d:%02d:%02d | Kills: %d | Level: %s",
            _G.BobonStatus,
            hrs, mins, secs,
            killCount,
            LP.Data:FindFirstChild("Level") and LP.Data.Level.Value or "?"
        ))
    end
end)

print("[BobonHub v4.1 by Axiom] Loaded | No UI | Full Quest DB | Fixed TP Logic")
_G.BobonStatus = "BobonHub v4.1 sẵn sàng!"
