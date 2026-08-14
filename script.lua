-- ================================================================= --
--         KAITUN BLOX FRUIT | FIX FULL by Axiom                    --
--         Auto Farm + Auto Quest + Auto Teleport                   --
-- ================================================================= --

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

print("[Kaitun] Loading...")

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local TP = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local Remotes = RS:WaitForChild("Remotes", 10)
local CommF_ = Remotes and Remotes:WaitForChild("CommF_", 10)
if not CommF_ then return end

-- ================================================================= --
--                      🚀 TÍNH NĂNG CHÍNH 🚀
-- ================================================================= --
-- ✅ Auto Farm theo Level (1-2800) | ✅ Auto Nhận Quest
-- ✅ Auto Teleport về NPC | ✅ Auto Chọn Team Pirates
-- ✅ Auto Bật Haki (1 lần duy nhất - không bật tắt)
-- ✅ Auto Nâng Stat | ✅ Auto Noclip + Anti AFK
-- ✅ Auto Unlock Sea 2 & 3 | ✅ Auto Saber + Pole
-- ✅ Đếm Kill | ✅ UI hiển thị Beli, Frag, Time
-- ================================================================= --

-- ================================================================= --
--                          STATE
-- ================================================================= --
_G.Kaitun = {
    Status = "Starting...",
    Kills = 0,
    StartTime = os.time(),
    IsTraveling = false,
    TeamSet = false,
}

-- ================================================================= --
--                          UI
-- ================================================================= --
if CoreGui:FindFirstChild("KaitunUI") then CoreGui.KaitunUI:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name = "KaitunUI"
SG.Parent = CoreGui
SG.ResetOnSpawn = false

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 350, 0, 200)
Main.Position = UDim2.new(0.5, -175, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Kaitun Blox Fruit"
Title.TextColor3 = Color3.fromRGB(100, 210, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold

local StatusL = Instance.new("TextLabel", Main)
StatusL.Size = UDim2.new(1, 0, 0, 25)
StatusL.Position = UDim2.new(0, 0, 0, 45)
StatusL.BackgroundTransparency = 1
StatusL.Text = "Status: Starting..."
StatusL.TextColor3 = Color3.fromRGB(85, 255, 130)
StatusL.TextSize = 15
StatusL.Font = Enum.Font.GothamMedium

local TimeL = Instance.new("TextLabel", Main)
TimeL.Size = UDim2.new(1, 0, 0, 25)
TimeL.Position = UDim2.new(0, 0, 0, 70)
TimeL.BackgroundTransparency = 1
TimeL.Text = "Time: 00:00:00"
TimeL.TextColor3 = Color3.fromRGB(200, 200, 210)
TimeL.TextSize = 14
TimeL.Font = Enum.Font.Gotham

local KillL = Instance.new("TextLabel", Main)
KillL.Size = UDim2.new(1, 0, 0, 25)
KillL.Position = UDim2.new(0, 0, 0, 95)
KillL.BackgroundTransparency = 1
KillL.Text = "Kills: 0"
KillL.TextColor3 = Color3.fromRGB(255, 150, 150)
KillL.TextSize = 14
KillL.Font = Enum.Font.Gotham

local BeliL = Instance.new("TextLabel", Main)
BeliL.Size = UDim2.new(0.5, 0, 0, 25)
BeliL.Position = UDim2.new(0, 10, 0, 125)
BeliL.BackgroundTransparency = 1
BeliL.Text = "Beli: 0"
BeliL.TextColor3 = Color3.fromRGB(255, 195, 60)
BeliL.TextSize = 14
BeliL.Font = Enum.Font.Gotham
BeliL.TextXAlignment = Enum.TextXAlignment.Left

local FragL = Instance.new("TextLabel", Main)
FragL.Size = UDim2.new(0.5, 0, 0, 25)
FragL.Position = UDim2.new(0.5, 0, 0, 125)
FragL.BackgroundTransparency = 1
FragL.Text = "Frag: 0"
FragL.TextColor3 = Color3.fromRGB(90, 175, 255)
FragL.TextSize = 14
FragL.Font = Enum.Font.Gotham
FragL.TextXAlignment = Enum.TextXAlignment.Right

local function Fmt(n)
    local s = tostring(math.floor(n or 0))
    return s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local e = os.time() - _G.Kaitun.StartTime
            TimeL.Text = ("Time: %02d:%02d:%02d"):format(
                math.floor(e/3600), math.floor(e%3600/60), e%60
            )
            StatusL.Text = "Status: " .. (_G.Kaitun.Status or "Idle")
            KillL.Text = "Kills: " .. Fmt(_G.Kaitun.Kills)
            local d = LP:FindFirstChild("Data")
            if d then
                local beli = d:FindFirstChild("Beli")
                local frag = d:FindFirstChild("Fragments")
                if beli then BeliL.Text = "Beli: " .. Fmt(beli.Value) end
                if frag then FragL.Text = "Frag: " .. Fmt(frag.Value) end
            end
        end)
    end
end)
-- ================================================================= --
--                          HELPERS
-- ================================================================= --
local function Char() return LP.Character end
local function HRP() local c = Char(); return c and c:FindFirstChild("HumanoidRootPart") end
local function Hum() local c = Char(); return c and c:FindFirstChild("Humanoid") end
local function Level() local d = LP:FindFirstChild("Data"); return d and d:FindFirstChild("Level") and d.Level.Value or 1 end
local function Beli() local d = LP:FindFirstChild("Data"); return d and d:FindFirstChild("Beli") and d.Beli.Value or 0 end

local function GetSea()
    local id = game.PlaceId
    if id == 2753915549 then return 1 end
    if id == 4442272183 then return 2 end
    if id == 7449423635 then return 3 end
    return 1
end

local function HasItem(name)
    return LP.Backpack:FindFirstChild(name) or (Char() and Char():FindFirstChild(name))
end

local function HasQuest()
    local ok, r = pcall(function()
        return LP.PlayerGui.Main.Quest.Visible
    end)
    return ok and r
end

local function Attack()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton1(Vector2.new())
    end)
end

local MeleeList = {
    "Godhuman", "Superhuman", "Death Step", "Electric Claw",
    "Dragon Talon", "Sharkman Karate", "Dragon Claw",
    "Fishman Karate", "Black Leg", "Electro", "Combat", "Sanguine Art"
}

local function EquipMelee()
    local c = Char()
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, n in ipairs(MeleeList) do
        if c:FindFirstChild(n) then return end
    end
    for _, n in ipairs(MeleeList) do
        local tool = LP.Backpack:FindFirstChild(n)
        if tool then
            hum:EquipTool(tool)
            return
        end
    end
end

local function FindMob(name)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    local best, bestDist = nil, math.huge
    local hrp = HRP()
    for _, v in ipairs(folder:GetChildren()) do
        if v.Name == name and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            if hrp then
                local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < bestDist then best, bestDist = v, d end
            else
                return v
            end
        end
    end
    return best
end

local function FindBoss(name)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    for _, v in ipairs(folder:GetChildren()) do
        if v.Name == name and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            return v
        end
    end
    return nil
end

-- ================================================================= --
--                  TELEPORT (FIX RỚT BIỂN - SAFE RESPAWN)
-- ================================================================= --
local SPAM_SECS = 6.0 -- Tăng thời gian spam lên 6s cho chắc
local SPAM_TICK = 0.02 -- Spam nhanh hơn (50 lần/giây)

-- Hàm bay thẳng (không chết)
local function ForceTeleport(cf)
    local hrp = HRP()
    if not hrp then return end
    
    -- Set vị trí lên cao hơn một chút để tránh kẹt đất
    local safeCF = cf + Vector3.new(0, 5, 0)
    
    pcall(function()
        hrp.CFrame = safeCF
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end)
    
    -- Spam giữ vị trí
    task.spawn(function()
        for i = 1, 20 do
            pcall(function()
                if hrp and hrp.Parent then
                    hrp.CFrame = safeCF
                    hrp.Velocity = Vector3.zero
                end
            end)
            task.wait(0.03)
        end
    end)
end

-- Hàm Teleport chính (có xử lý chết)
local function TeleportTo(cf)
    if _G.Kaitun.IsTraveling then return end
    
    local hrp = HRP()
    if not hrp then return end
    
    local dist = (hrp.Position - cf.Position).Magnitude
    local isUnderwater = hrp.Position.Y < 10 -- Nếu dưới 10y là coi như ở biển
    
    -- Nếu xa > 800 hoặc đang ở biển -> Dùng Respawn
    if isUnderwater or dist > 800 then
        _G.Kaitun.IsTraveling = true
        _G.Kaitun.Status = "Respawning to Safe Zone..."
        
        -- Lưu vị trí mục tiêu vào biến global để dùng khi respawn
        _G.Kaitun.TargetCF = cf
        
        -- Tự tử
        pcall(function()
            local h = Hum()
            if h then h.Health = 0 end
        end)
        
        -- Lắng nghe sự kiện CharacterAdded
        local conn
        conn = LP.CharacterAdded:Connect(function(newChar)
            conn:Disconnect() -- Ngắt kết nối ngay để không chạy nhiều lần
            
            task.spawn(function()
                -- Đợi HumanoidRootPart xuất hiện
                local hrp2 = newChar:WaitForChild("HumanoidRootPart", 10)
                if not hrp2 then
                    _G.Kaitun.IsTraveling = false
                    return
                end
                
                -- QUAN TRỌNG: Tắt va chạm ngay lập tức
                for _, p in ipairs(newChar:GetDescendants()) do
                    if p:IsA("BasePart") then 
                        p.CanCollide = false 
                    end
                end
                
                -- Lấy vị trí mục tiêu
                local target = _G.Kaitun.TargetCF or cf
                
                -- BƯỚC 1: Set vị trí lên TRÊN TRỜI (cao hơn mục tiêu 50 stud)
                -- Để tránh bị rớt xuống biển trong lúc load
                local skyPos = target + Vector3.new(0, 50, 0)
                
                -- Spam vị trí trên trời trong 1 giây đầu
                local startTick = tick()
                while tick() - startTick < 1.0 do
                    pcall(function()
                        hrp2.CFrame = CFrame.new(skyPos.Position)
                        hrp2.Velocity = Vector3.zero
                        hrp2.RotVelocity = Vector3.zero
                    end)
                    task.wait(0.02)
                end
                
                -- BƯỚC 2: Từ từ hạ xuống vị trí mục tiêu và spam giữ
                local deadline = tick() + SPAM_SECS
                while tick() < deadline do
                    pcall(function()
                        hrp2.CFrame = target
                        hrp2.Velocity = Vector3.zero
                        hrp2.RotVelocity = Vector3.zero
                    end)
                    task.wait(SPAM_TICK)
                end
                
                -- Xong xuôi
                _G.Kaitun.IsTraveling = false
                _G.Kaitun.Status = "Ready"
                _G.Kaitun.TargetCF = nil
            end)
        end)
        
        -- Timeout an toàn
        task.delay(20, function()
            if _G.Kaitun.IsTraveling then
                pcall(function() if conn then conn:Disconnect() end end)
                _G.Kaitun.IsTraveling = false
                _G.Kaitun.Status = "Timeout - Retry"
            end
        end)
    else
        -- Gần thì bay thẳng
        ForceTeleport(cf)
    end
end
-- ================================================================= --
--                          TEAM + HAKI (FIX - 1 LẦN DUY NHẤT)
-- ================================================================= --
task.spawn(function()
    task.wait(3)
    
    -- Chọn team PIRATES
    local teamSet = false
    for i = 1, 10 do
        if LP.Team and LP.Team.Name == "Pirates" then 
            teamSet = true
            break 
        end
        pcall(function() CommF_:InvokeServer("SetTeam", "Pirates") end)
        task.wait(1)
        pcall(function() CommF_:InvokeServer("ChooseTeam", "Pirates") end)
        task.wait(1)
    end
    
    if teamSet or (LP.Team and LP.Team.Name == "Pirates") then
        _G.Kaitun.Status = "Team: Pirates ✓"
    else
        _G.Kaitun.Status = "Team: Pirates (Manual)"
    end
    
    -- Bật Haki 1 LẦN - KHÔNG LOOP
    task.wait(1)
    local hakiOn = false
    for i = 1, 3 do
        pcall(function()
            CommF_:InvokeServer("Ken", true)
            CommF_:InvokeServer("Buso", true)
            hakiOn = true
        end)
        task.wait(0.5)
        if hakiOn then break end
    end
    
    if hakiOn then
        _G.Kaitun.Status = "Haki: ON ✓"
    else
        _G.Kaitun.Status = "Haki: Check manually"
    end
    
    task.wait(0.5)
    _G.Kaitun.Status = "✅ Ready!"
    print("[Kaitun] Loaded - Haki ON, Team Pirates")
end)

-- KHÔNG CÓ LOOP RE-ENABLE HAKI - TRÁNH BẬT TẮT

-- ================================================================= --
--                          BACKGROUND
-- ================================================================= --
LP.Idled:Connect(function()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end)

RunService.Stepped:Connect(function()
    pcall(function()
        local c = Char()
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end)
end)

-- Kill counter
local function HookMob(mob)
    local h = mob:FindFirstChild("Humanoid")
    if h and not h:GetAttribute("Hooked") then
        h:SetAttribute("Hooked", true)
        h.Died:Connect(function()
            _G.Kaitun.Kills = _G.Kaitun.Kills + 1
        end)
    end
end

task.spawn(function()
    local function Watch()
        local f = workspace:FindFirstChild("Enemies")
        if not f then return end
        for _, mob in ipairs(f:GetChildren()) do HookMob(mob) end
        f.ChildAdded:Connect(function(mob) task.wait(0.1); HookMob(mob) end)
    end
    Watch()
    workspace.ChildAdded:Connect(function(c)
        if c.Name == "Enemies" then task.wait(0.5); Watch() end
    end)
end)

-- Auto stat
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            local d = LP:FindFirstChild("Data")
            if not d then return end
            local pts = d:FindFirstChild("Points") and d.Points.Value or 0
            if pts > 0 then
                CommF_:InvokeServer("AddPoint", "Melee", math.floor(pts * 0.7))
                CommF_:InvokeServer("AddPoint", "Defense", math.floor(pts * 0.3))
            end
        end)
    end
end)

-- Auto Fruit (Sea 2+)
local FruitPrices = {[1]=38000,[2]=100000,[3]=250000}

local function AutoStoreFruit()
    local function TryStore(container)
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and item.Name:find("%-") then
                pcall(function() CommF_:InvokeServer("StoreFruit", item.Name, container) end)
                task.wait(0.4)
            end
        end
    end
    TryStore(LP.Backpack)
    local c = Char()
    if c then TryStore(c) end
end

local function AutoRandomFruit()
    local sea = GetSea()
    if sea < 2 then return end
    local price = FruitPrices[sea] or 100000
    if Beli() < price then return end
    _G.Kaitun.Status = "Random Fruit..."
    pcall(function() CommF_:InvokeServer("Cousin", "Buy") end)
    task.wait(2)
    AutoStoreFruit()
end

task.spawn(function() while task.wait(15) do pcall(AutoRandomFruit) end end)
task.spawn(function() while task.wait(30) do pcall(AutoStoreFruit) end end)
-- ================================================================= --
--                    AUTO UNLOCK SEA
-- ================================================================= --
local function AutoSecondSea()
    if GetSea() >= 2 or Level() < 700 then return false end
    _G.Kaitun.Status = "Unlocking Sea 2..."
    TeleportTo(CFrame.new(-4909, 4, 4450)); task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Detective") end); task.wait(1)
    TeleportTo(CFrame.new(932, 13, 4482)); task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Bartilo") end); task.wait(1)
    local kills = 0
    while kills < 50 do
        local mob = FindMob("Swan Pirate")
        if mob then
            EquipMelee()
            TeleportTo(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0, 22, 0)))
            Attack()
            if mob.Humanoid.Health <= 0 then kills = kills + 1 end
        else
            TeleportTo(CFrame.new(878, 122, 1235)); task.wait(2)
        end
        task.wait(0.1)
    end
    TeleportTo(CFrame.new(932, 13, 4482)); task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Bartilo") end); task.wait(1)
    TeleportTo(CFrame.new(-12471, 374, -7551)); task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Door") end); task.wait(1)
    TP:Teleport(4442272183, LP)
    return true
end

local function AutoThirdSea()
    if GetSea() ~= 2 or Level() < 1500 then return false end
    _G.Kaitun.Status = "Unlocking Sea 3..."
    TeleportTo(CFrame.new(-285, 306, 611)); task.wait(2)
    pcall(function() CommF_:InvokeServer("ZQuestProgress", "Check") end); task.wait(1)
    local timeout = os.time() + 300
    while os.time() < timeout do
        local boss = FindBoss("Don Swan")
        if boss and boss.Humanoid.Health > 0 then
            EquipMelee()
            TeleportTo(CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0, 22, 0)))
            Attack()
        else break end
        task.wait(0.1)
    end
    TeleportTo(CFrame.new(-285, 306, 611)); task.wait(2)
    pcall(function() CommF_:InvokeServer("ZQuestProgress", "Begin") end); task.wait(1)
    TP:Teleport(7449423635, LP)
    return true
end

-- ================================================================= --
--                    AUTO SABER + POLE
-- ================================================================= --
local function AutoSaber()
    if HasItem("Saber") or Level() < 200 or GetSea() ~= 1 then return false end
    _G.Kaitun.Status = "Getting Saber..."
    local torches = {
        {N="Torch1", C=CFrame.new(-1610, 11, 163)},
        {N="Torch2", C=CFrame.new(1114, 4, 4350)},
        {N="Torch3", C=CFrame.new(1400, 101, -1250)},
        {N="Torch4", C=CFrame.new(-5070, 23, 4325)},
        {N="Torch5", C=CFrame.new(-1675, 7, -2985)},
    }
    for _, t in ipairs(torches) do
        TeleportTo(t.C); task.wait(2)
        pcall(function() CommF_:InvokeServer("Torch", t.N) end)
        task.wait(0.5)
    end
    local timeout = os.time() + 300
    while not HasItem("Saber") and os.time() < timeout do
        local boss = FindBoss("Saber Expert")
        if boss then
            EquipMelee()
            TeleportTo(CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0, 22, 0)))
            Attack()
        else
            TeleportTo(CFrame.new(-1405, 30, -3330)); task.wait(3)
        end
        task.wait(0.1)
    end
    return true
end

local function AutoPoleV1()
    if HasItem("Pole (1st Form)") or Level() < 150 or GetSea() ~= 1 then return false end
    _G.Kaitun.Status = "Getting Pole..."
    TeleportTo(CFrame.new(-7748, 5606, -2305)); task.wait(2)
    pcall(function() CommF_:InvokeServer("BuyPoleV1") end)
    task.wait(1)
    return true
end
-- ================================================================= --
--                      QUEST DATABASE (lv 1–2800)
-- ================================================================= --
local QDB = {
    {Min=1,    Max=14,   Q="BanditQuest1",          M="Bandit",               QL=1, QC=CFrame.new(1059,17,1550),     MC=CFrame.new(1145,17,1634)},
    {Min=15,   Max=29,   Q="JungleQuest",            M="Monkey",               QL=1, QC=CFrame.new(-1598,37,153),     MC=CFrame.new(-1448,50,24)},
    {Min=30,   Max=59,   Q="BuggyQuest1",            M="Brute",                QL=1, QC=CFrame.new(-1141,5,3831),     MC=CFrame.new(-1145,15,4350)},
    {Min=60,   Max=74,   Q="DesertQuest",            M="Desert Bandit",        QL=1, QC=CFrame.new(894,7,4391),       MC=CFrame.new(932,7,4484)},
    {Min=75,   Max=89,   Q="DesertQuest",            M="Desert Officer",       QL=2, QC=CFrame.new(894,7,4391),       MC=CFrame.new(1580,11,4373)},
    {Min=90,   Max=99,   Q="SnowQuest",              M="Snow Bandit",          QL=1, QC=CFrame.new(1389,88,-1298),    MC=CFrame.new(1376,87,-1396)},
    {Min=100,  Max=119,  Q="SnowQuest",              M="Snowman",              QL=2, QC=CFrame.new(1389,88,-1298),    MC=CFrame.new(1201,472,-1401)},
    {Min=120,  Max=149,  Q="MarineQuest2",           M="Chief Petty Officer",  QL=1, QC=CFrame.new(-5039,29,4324),    MC=CFrame.new(-4882,23,4255)},
    {Min=150,  Max=174,  Q="SkyQuest",               M="Sky Bandit",           QL=1, QC=CFrame.new(-4850,718,-2620),  MC=CFrame.new(-4953,295,-2899)},
    {Min=175,  Max=209,  Q="PrisonerQuest",          M="Prisoner",             QL=1, QC=CFrame.new(5308,2,474),       MC=CFrame.new(5411,96,690)},
    {Min=210,  Max=249,  Q="PrisonerQuest",          M="Dangerous Prisoner",   QL=2, QC=CFrame.new(5308,2,474),       MC=CFrame.new(5654,15,866)},
    {Min=250,  Max=299,  Q="ColosseumQuest",         M="Gladiator",            QL=1, QC=CFrame.new(-1580,7,296),      MC=CFrame.new(-1521,86,405)},
    {Min=300,  Max=374,  Q="MagmaQuest",             M="Military Spy",         QL=1, QC=CFrame.new(-5316,12,8515),    MC=CFrame.new(-5787,76,8349)},
    {Min=375,  Max=449,  Q="FishmanQuest",           M="Fishman Warrior",      QL=1, QC=CFrame.new(61123,19,1569),    MC=CFrame.new(60879,19,1549)},
    {Min=450,  Max=524,  Q="FishmanQuest",           M="Fishman Commando",     QL=2, QC=CFrame.new(61123,19,1569),    MC=CFrame.new(61738,65,1584)},
    {Min=525,  Max=624,  Q="SkyExp1Quest",           M="God's Guard",          QL=1, QC=CFrame.new(-4722,845,-1954),  MC=CFrame.new(-4698,845,-1912)},
    {Min=625,  Max=699,  Q="SkyExp2Quest",           M="Royal Squad",          QL=1, QC=CFrame.new(-7906,5636,-1412), MC=CFrame.new(-7555,5637,-1420)},
    {Min=700,  Max=774,  Q="Area1Quest",             M="Raider",               QL=1, QC=CFrame.new(-427,73,1837),     MC=CFrame.new(-746,39,2507)},
    {Min=775,  Max=849,  Q="Area1Quest",             M="Mercenary",            QL=2, QC=CFrame.new(-427,73,1837),     MC=CFrame.new(-874,141,1312)},
    {Min=850,  Max=899,  Q="Area2Quest",             M="Swan Pirate",          QL=1, QC=CFrame.new(634,73,918),       MC=CFrame.new(878,122,1235)},
    {Min=900,  Max=949,  Q="Area2Quest",             M="Marine Lieutenant",    QL=2, QC=CFrame.new(634,73,918),       MC=CFrame.new(-845,77,2016)},
    {Min=950,  Max=999,  Q="MarineQuest3",           M="Marine Captain",       QL=1, QC=CFrame.new(-2441,73,1891),    MC=CFrame.new(-2035,73,2050)},
    {Min=1000, Max=1049, Q="ZombieQuest",            M="Zombie",               QL=1, QC=CFrame.new(-5494,49,-795),    MC=CFrame.new(-5736,126,-653)},
    {Min=1050, Max=1099, Q="ZombieQuest",            M="Vampire",              QL=2, QC=CFrame.new(-5494,49,-795),    MC=CFrame.new(-6033,7,-1317)},
    {Min=1100, Max=1174, Q="NinjaQuest",             M="Ninja Assassin",       QL=1, QC=CFrame.new(-5377,39,-4826),   MC=CFrame.new(-5238,84,-4634)},
    {Min=1175, Max=1249, Q="IceSideQuest",           M="Snow Trooper",         QL=1, QC=CFrame.new(-6061,16,-4903),   MC=CFrame.new(-5693,16,-4898)},
    {Min=1250, Max=1299, Q="ShipQuest1",             M="Lab Subordinate",      QL=1, QC=CFrame.new(-9505,38,4088),    MC=CFrame.new(-9230,45,4294)},
    {Min=1300, Max=1349, Q="ShipQuest2",             M="Horned Warrior",       QL=1, QC=CFrame.new(-9481,72,6059),    MC=CFrame.new(-6779,83,5928)},
    {Min=1350, Max=1399, Q="FrostQuest",             M="Lava Pirate",          QL=1, QC=CFrame.new(-5249,38,-4445),   MC=CFrame.new(-5270,42,-4800)},
    {Min=1400, Max=1449, Q="ForgottenQuest",         M="Ship Engineer",        QL=1, QC=CFrame.new(-3053,237,-10145), MC=CFrame.new(-9300,30,-9940)},
    {Min=1450, Max=1524, Q="IceCastleQuest",         M="Arctic Warrior",       QL=2, QC=CFrame.new(-5539,314,-2972),  MC=CFrame.new(-5990,340,-2800)},
    {Min=1525, Max=1599, Q="PiratePortQuest",        M="Pirate Millionaire",   QL=1, QC=CFrame.new(-290,44,5580),     MC=CFrame.new(-435,191,5610)},
    {Min=1600, Max=1649, Q="AmazonQuest",            M="Dragon Crew Warrior",  QL=1, QC=CFrame.new(5832,52,-1105),    MC=CFrame.new(6339,52,-1213)},
    {Min=1650, Max=1724, Q="AmazonQuest2",           M="Female Islander",      QL=1, QC=CFrame.new(5448,602,751),     MC=CFrame.new(5792,820,863)},
    {Min=1725, Max=1799, Q="MarineTreeIsland",       M="Marine Commodore",     QL=1, QC=CFrame.new(2180,29,-6737),    MC=CFrame.new(2490,73,-7070)},
    {Min=1800, Max=1874, Q="DeepForestIsland",       M="Fishman Raider",       QL=1, QC=CFrame.new(-13234,333,-7625), MC=CFrame.new(-10560,332,-8754)},
    {Min=1875, Max=1924, Q="DeepForestIsland",       M="Fishman Captain",      QL=2, QC=CFrame.new(-13234,333,-7625), MC=CFrame.new(-11465,332,-8770)},
    {Min=1925, Max=1974, Q="DeepForestIsland2",      M="Forest Pirate",        QL=1, QC=CFrame.new(-12684,391,-9902), MC=CFrame.new(-13225,425,-7755)},
    {Min=1975, Max=2024, Q="PeanutIsland",           M="Peanut Scout",         QL=1, QC=CFrame.new(-2104,38,-10192),  MC=CFrame.new(-2124,123,-10435)},
    {Min=2025, Max=2074, Q="PeanutIsland",           M="Peanut President",     QL=2, QC=CFrame.new(-2104,38,-10192),  MC=CFrame.new(-1876,38,-10946)},
    {Min=2075, Max=2124, Q="IceCreamIsland",         M="Ice Cream Chef",       QL=1, QC=CFrame.new(-820,66,-10965),   MC=CFrame.new(-821,44,-11253)},
    {Min=2125, Max=2174, Q="IceCreamIsland",         M="Ice Cream Commander",  QL=2, QC=CFrame.new(-820,66,-10965),   MC=CFrame.new(-610,127,-11034)},
    {Min=2175, Max=2224, Q="CakeQuest1",             M="Cookie Crafter",       QL=1, QC=CFrame.new(-2022,38,-12030),  MC=CFrame.new(-2365,38,-12099)},
    {Min=2225, Max=2274, Q="CakeQuest1",             M="Cake Guard",           QL=2, QC=CFrame.new(-2022,38,-12030),  MC=CFrame.new(-1651,38,-12293)},
    {Min=2275, Max=2324, Q="CakeQuest2",             M="Baking Staff",         QL=1, QC=CFrame.new(-1927,38,-12843),  MC=CFrame.new(-1980,38,-12763)},
    {Min=2325, Max=2374, Q="CakeQuest2",             M="Head Baker",           QL=2, QC=CFrame.new(-1927,38,-12843),  MC=CFrame.new(-2235,53,-12858)},
    {Min=2375, Max=2424, Q="ChocQuest1",             M="Cocoa Warrior",        QL=1, QC=CFrame.new(233,25,-12201),    MC=CFrame.new(167,26,-12238)},
    {Min=2425, Max=2474, Q="ChocQuest1",             M="Chocolate Bar Battler",QL=2, QC=CFrame.new(233,25,-12201),    MC=CFrame.new(507,73,-12789)},
    {Min=2475, Max=2524, Q="ChocQuest2",             M="Sweet Thief",          QL=1, QC=CFrame.new(151,25,-12774),    MC=CFrame.new(-71,25,-12381)},
    {Min=2525, Max=2574, Q="ChocQuest2",             M="Candy Rebel",          QL=2, QC=CFrame.new(151,25,-12774),    MC=CFrame.new(134,77,-12882)},
    {Min=2575, Max=2649, Q="CandyQuest1",            M="Candy Pirate",         QL=1, QC=CFrame.new(-1149,14,-14453),  MC=CFrame.new(-1380,14,-14453)},
    {Min=2650, Max=2800, Q="CandyQuest1",            M="Snow Demon",           QL=2, QC=CFrame.new(-1149,14,-14453),  MC=CFrame.new(-907,14,-14453)},
}

local function GetQ()
    local lv = Level()
    for _, q in ipairs(QDB) do
        if lv >= q.Min and lv <= q.Max then return q end
    end
    return nil
end

-- ================================================================= --
--                    MAIN FARM LOOP
-- ================================================================= --
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if _G.Kaitun.IsTraveling then return end
            
            local lv = Level()
            local sea = GetSea()
            
            -- Auto unlock sea
            if lv >= 700 and sea == 1 then
                if AutoSecondSea() then return end
            end
            if lv >= 1500 and sea == 2 then
                if AutoThirdSea() then return end
            end
            
            -- Auto items
            if lv >= 200 and lv < 700 and sea == 1 and not HasItem("Saber") then
                if AutoSaber() then return end
            end
            if lv >= 150 and lv < 700 and sea == 1 and not HasItem("Pole (1st Form)") then
                if AutoPoleV1() then return end
            end
            
            -- Get quest
            local q = GetQ()
            if not q then
                _G.Kaitun.Status = "No quest for lv " .. lv
                return
            end
            
            local hrp = HRP()
            if not hrp then return end
            
            -- Check if at NPC
            local distToNPC = (hrp.Position - q.QC.Position).Magnitude
            local isUnderwater = math.abs(hrp.Position.Y) < 8
            
            -- Nếu ở biển hoặc xa NPC > 150 -> về NPC
            if isUnderwater or distToNPC > 150 then
                _G.Kaitun.Status = "Going to NPC: " .. q.Q
                TeleportTo(q.QC)
                task.wait(1.5)
                return
            end
            
            -- Nhận quest nếu chưa có
            if not HasQuest() then
                _G.Kaitun.Status = "Getting quest: " .. q.Q
                ForceTeleport(q.QC)
                task.wait(0.3)
                pcall(function()
                    CommF_:InvokeServer("StartQuest", q.Q, q.QL)
                end)
                task.wait(0.5)
                return
            end
            
            -- Tìm mob
            local mob = FindMob(q.M)
            if not mob then
                _G.Kaitun.Status = "Finding " .. q.M
                TeleportTo(q.MC)
                return
            end
            
            -- Đánh mob
            _G.Kaitun.Status = "Farming " .. q.M
            EquipMelee()
            local targetPos = mob.HumanoidRootPart.Position + Vector3.new(0, 22, 0)
            local distToMob = (hrp.Position - mob.HumanoidRootPart.Position).Magnitude
            
            if distToMob > 80 then
                TeleportTo(CFrame.new(targetPos))
                return
            end
            
            ForceTeleport(CFrame.new(targetPos))
            Attack()
        end)
    end
end)

print("[Kaitun] Loaded successfully!")
_G.Kaitun.Status = "Ready!"
