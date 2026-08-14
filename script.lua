-- ================================================================= --
--         BOBON HUB v13.0 | KAITUN BLOX FRUIT                      --
--         UI: Vxeze Style | Respawn TP | Full Fix by Axiom          --
-- ================================================================= --

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("Data")

print("[BobonHub v13] Loading...")

-- ══════════════════════════════════════════════════════════════════
--                          SERVICES
-- ══════════════════════════════════════════════════════════════════
local Players      = game:GetService("Players")
local RS           = game:GetService("ReplicatedStorage")
local RunService   = game:GetService("RunService")
local VU           = game:GetService("VirtualUser")
local TS           = game:GetService("TweenService")
local TeleportSvc  = game:GetService("TeleportService")
local CoreGui      = game:GetService("CoreGui")

local LP      = Players.LocalPlayer
local Remotes = RS:WaitForChild("Remotes", 10)
local CommF_  = Remotes and Remotes:WaitForChild("CommF_", 10)
if not CommF_ then warn("[BobonHub] CommF_ not found!") return end

-- ══════════════════════════════════════════════════════════════════
--                       GLOBAL STATE
-- ══════════════════════════════════════════════════════════════════
_G.BobonStatus = "Starting..."
_G.State = {
    CurrentTarget   = nil,
    KillCount       = 0,
    StartTime       = os.time(),
    LastQuest       = 0,
    LastRandomFruit = 0,
    IsTraveling     = false,
    SpamTarget      = nil,
    SpamDeadline    = 0,
}
_G.Settings = {
    FarmHeight          = 22,
    HitboxSize          = 50,
    RandomFruitInterval = 120,
}
-- ══════════════════════════════════════════════════════════════════
--             UI — VXEZE HUB STYLE (thuần text, nền mờ)
-- ══════════════════════════════════════════════════════════════════
if CoreGui:FindFirstChild("BobonHubUI") then
    CoreGui.BobonHubUI:Destroy()
end

local SG = Instance.new("ScreenGui")
SG.Name           = "BobonHubUI"
SG.Parent         = CoreGui
SG.ResetOnSpawn   = false
SG.DisplayOrder   = 10000
SG.IgnoreGuiInset = true

local Dim = Instance.new("Frame", SG)
Dim.Size                   = UDim2.new(1,0,1,0)
Dim.BackgroundColor3       = Color3.fromRGB(0,0,0)
Dim.BackgroundTransparency = 1
Dim.BorderSizePixel        = 0
Dim.ZIndex                 = 1

local Con = Instance.new("Frame", SG)
Con.AnchorPoint        = Vector2.new(0.5, 0.5)
Con.Position           = UDim2.new(0.5, 0, 0.5, 0)
Con.Size               = UDim2.new(0, 500, 0, 270)
Con.BackgroundTransparency = 1
Con.BorderSizePixel    = 0
Con.ZIndex             = 2

local ULL = Instance.new("UIListLayout", Con)
ULL.SortOrder           = Enum.SortOrder.LayoutOrder
ULL.HorizontalAlignment = Enum.HorizontalAlignment.Center
ULL.VerticalAlignment   = Enum.VerticalAlignment.Center
ULL.Padding             = UDim.new(0, 3)

local function MkLabel(txt, sz, col, bold, order)
    local lb = Instance.new("TextLabel", Con)
    lb.Size                  = UDim2.new(1, 0, 0, sz + 12)
    lb.BackgroundTransparency= 1
    lb.Text                  = txt
    lb.TextColor3            = col
    lb.TextSize              = sz
    lb.Font                  = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
    lb.TextXAlignment        = Enum.TextXAlignment.Center
    lb.TextYAlignment        = Enum.TextYAlignment.Center
    lb.TextTransparency      = 1
    lb.TextStrokeTransparency= 0.6
    lb.TextStrokeColor3      = Color3.fromRGB(0,0,0)
    lb.LayoutOrder           = order
    lb.ZIndex                = 3
    return lb
end

local function MkDiv(order)
    local f = Instance.new("Frame", Con)
    f.Size               = UDim2.new(0.40, 0, 0, 1)
    f.BackgroundColor3   = Color3.fromRGB(255,255,255)
    f.BackgroundTransparency = 0.72
    f.BorderSizePixel    = 0
    f.LayoutOrder        = order
    f.ZIndex             = 3
    return f
end

local function MkCurrRow(order)
    local row = Instance.new("Frame", Con)
    row.Size               = UDim2.new(1, 0, 0, 30)
    row.BackgroundTransparency = 1
    row.BorderSizePixel    = 0
    row.LayoutOrder        = order
    row.ZIndex             = 3

    local function Side(txt, col, anchor, pos, align)
        local lb = Instance.new("TextLabel", row)
        lb.AnchorPoint        = anchor
        lb.Position           = pos
        lb.Size               = UDim2.new(0.47, 0, 1, 0)
        lb.BackgroundTransparency = 1
        lb.Text               = txt
        lb.TextColor3         = col
        lb.TextSize           = 15
        lb.Font               = Enum.Font.GothamBold
        lb.TextXAlignment     = align
        lb.TextYAlignment     = Enum.TextYAlignment.Center
        lb.TextTransparency   = 1
        lb.TextStrokeTransparency = 0.6
        lb.TextStrokeColor3   = Color3.fromRGB(0,0,0)
        lb.ZIndex             = 3
        return lb
    end

    local sep = Instance.new("TextLabel", row)
    sep.AnchorPoint        = Vector2.new(0.5, 0.5)
    sep.Position           = UDim2.new(0.5, 0, 0.5, 0)
    sep.Size               = UDim2.new(0, 14, 1, 0)
    sep.BackgroundTransparency = 1
    sep.Text               = "│"
    sep.TextColor3         = Color3.fromRGB(200,200,200)
    sep.TextSize           = 15
    sep.Font               = Enum.Font.Gotham
    sep.TextXAlignment     = Enum.TextXAlignment.Center
    sep.TextYAlignment     = Enum.TextYAlignment.Center
    sep.TextTransparency   = 1
    sep.TextStrokeTransparency = 0.75
    sep.ZIndex             = 3

    local beli = Side("Beli: 0",  Color3.fromRGB(255,195,60),
        Vector2.new(0,0.5), UDim2.new(0,0,0.5,0), Enum.TextXAlignment.Right)
    local frag = Side("Frag: 0",  Color3.fromRGB(90,175,255),
        Vector2.new(1,0.5), UDim2.new(1,0,0.5,0), Enum.TextXAlignment.Left)

    return row, beli, sep, frag
end

local TitleL    = MkLabel("BobonHub",           34, Color3.fromRGB(100,210,255), true,  1)
local SubL      = MkLabel("Kaitun Blox Fruit",  16, Color3.fromRGB(170,195,220), false, 2)
                  MkDiv(3)
local StatL     = MkLabel("Status: Starting...",16, Color3.fromRGB(85,255,130),  true,  4)
local TimeL     = MkLabel("Time: 00:00:00",     14, Color3.fromRGB(205,215,230), false, 5)
                  MkDiv(6)
local CurrRow, BeliL, SepL, FragL = MkCurrRow(7)
local KillL     = MkLabel("Kills: 0",           13, Color3.fromRGB(255,110,110), false, 8)

local function FadeText(lb, dur)
    TS:Create(lb, TweenInfo.new(dur, Enum.EasingStyle.Quad), {TextTransparency=0}):Play()
end

task.spawn(function()
    task.wait(0.3)
    TS:Create(Dim, TweenInfo.new(0.9, Enum.EasingStyle.Quad), {BackgroundTransparency=0.48}):Play()
    task.wait(0.5)
    local seq = {TitleL, SubL, StatL, TimeL, BeliL, SepL, FragL, KillL}
    for i, lb in ipairs(seq) do
        task.delay((i-1)*0.09, function() FadeText(lb, 0.55) end)
    end
    print("[BobonHub] UI Ready!")
end)

local function Fmt(n)
    local s = tostring(math.floor(n or 0))
    return s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,","")
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local e = os.time() - _G.State.StartTime
            TimeL.Text = ("Time: %02d:%02d:%02d"):format(
                math.floor(e/3600), math.floor(e%3600/60), e%60)
            StatL.Text = "Status: " .. (_G.BobonStatus or "Idle")
            KillL.Text = "Kills: " .. Fmt(_G.State.KillCount)
            local d = LP:FindFirstChild("Data")
            if d then
                BeliL.Text = "Beli: " .. Fmt(d:FindFirstChild("Beli") and d.Beli.Value or 0)
                FragL.Text = "Frag: " .. Fmt(d:FindFirstChild("Fragments") and d.Fragments.Value or 0)
            end
        end)
    end
end)
-- ══════════════════════════════════════════════════════════════════
--                       HELPER FUNCTIONS
-- ══════════════════════════════════════════════════════════════════
local function Char()  return LP.Character end
local function HRP()   local c=Char(); return c and c:FindFirstChild("HumanoidRootPart") end
local function Hum()   local c=Char(); return c and c:FindFirstChild("Humanoid") end
local function Level() local d=LP:FindFirstChild("Data"); return d and d:FindFirstChild("Level") and d.Level.Value or 1 end
local function Beli()  local d=LP:FindFirstChild("Data"); return d and d:FindFirstChild("Beli") and d.Beli.Value or 0 end

local function GetSea()
    local id = game.PlaceId
    if id == 2753915549 then return 1 end
    if id == 4442272183 then return 2 end
    if id == 7449423635 then return 3 end
    return 1
end

local function HasItem(name)
    return LP.Backpack:FindFirstChild(name)
        or (Char() and Char():FindFirstChild(name))
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
    "Godhuman","Superhuman","Death Step","Electric Claw",
    "Dragon Talon","Sharkman Karate","Dragon Claw",
    "Fishman Karate","Black Leg","Electro","Combat","Sanguine Art"
}

local function EquipMelee()
    local c = Char()
    if not c or not c:FindFirstChildOfClass("Humanoid") then return end
    for _, n in ipairs(MeleeList) do
        if c:FindFirstChild(n) then return end
    end
    for _, n in ipairs(MeleeList) do
        local t = LP.Backpack:FindFirstChild(n)
        if t then
            c:FindFirstChildOfClass("Humanoid"):EquipTool(t)
            return
        end
    end
end

local function FindMob(name)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    local best, bd = nil, math.huge
    local hrp = HRP()
    for _, v in ipairs(folder:GetChildren()) do
        if v.Name == name
            and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0
            and v:FindFirstChild("HumanoidRootPart")
        then
            if hrp then
                local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < bd then best, bd = v, d end
            else return v end
        end
    end
    return best
end

local function FindBoss(name)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    for _, v in ipairs(folder:GetChildren()) do
        if v.Name == name
            and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0
            and v:FindFirstChild("HumanoidRootPart")
        then return v end
    end
    return nil
end
-- ══════════════════════════════════════════════════════════════════
--     RESPAWN-BASED TRAVEL
-- ══════════════════════════════════════════════════════════════════
local SPAM_SECS   = 4.0
local SPAM_TICK   = 0.04
local NEAR_DIST   = 400

local function RespawnTravelTo(targetCF)
    if _G.State.IsTraveling then return end
    _G.State.IsTraveling = true
    _G.State.SpamTarget  = targetCF
    _G.BobonStatus       = "Di chuyển..."

    pcall(function()
        local h = Hum()
        if h then h.Health = 0 end
    end)

    local conn
    conn = LP.CharacterAdded:Connect(function(newChar)
        conn:Disconnect()
        task.spawn(function()
            local hrp = newChar:WaitForChild("HumanoidRootPart", 8)
            if not hrp then
                _G.State.IsTraveling = false
                return
            end

            for _, p in ipairs(newChar:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end

            local deadline = tick() + SPAM_SECS
            while tick() < deadline do
                pcall(function()
                    if _G.State.SpamTarget then
                        hrp.CFrame      = _G.State.SpamTarget
                        hrp.Velocity    = Vector3.zero
                        hrp.RotVelocity = Vector3.zero
                    end
                end)
                task.wait(SPAM_TICK)
            end

            _G.State.IsTraveling = false
            _G.State.SpamTarget  = nil
        end)
    end)

    task.delay(15, function()
        if _G.State.IsTraveling then
            pcall(function() conn:Disconnect() end)
            _G.State.IsTraveling = false
            _G.State.SpamTarget  = nil
        end
    end)
end

local function Travel(cf)
    if _G.State.IsTraveling then return end
    local hrp = HRP()
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    if dist <= NEAR_DIST then
        hrp.CFrame = cf
    else
        RespawnTravelTo(cf)
    end
end
-- ══════════════════════════════════════════════════════════════════
--                   TEAM + HAKI INIT
-- ══════════════════════════════════════════════════════════════════
local TeamDone = false
task.spawn(function()
    task.wait(3)
    for _ = 1, 6 do
        if LP.Team and LP.Team.Name == "Pirates" then break end
        pcall(function() CommF_:InvokeServer("SetTeam",    "Pirates") end)
        task.wait(1.5)
        pcall(function() CommF_:InvokeServer("ChooseTeam", "Pirates") end)
        task.wait(1.5)
    end
    TeamDone = true
    _G.BobonStatus = "Team: Pirates ✓"
    task.wait(0.5)
    pcall(function() CommF_:InvokeServer("Ken",  true) end)
    pcall(function() CommF_:InvokeServer("Buso", true) end)
    _G.BobonStatus = "Haki: ON ✓"
    task.wait(0.5)
    _G.BobonStatus = "Sẵn sàng!"
end)

task.spawn(function()
    while task.wait(20) do
        pcall(function()
            CommF_:InvokeServer("Ken",  true)
            CommF_:InvokeServer("Buso", true)
        end)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--                    BACKGROUND SYSTEMS
-- ══════════════════════════════════════════════════════════════════

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

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local c = Char()
            if not c then return end
            for _, tool in ipairs(c:GetChildren()) do
                if tool:IsA("Tool") then
                    local h = tool:FindFirstChild("Handle")
                    if h then
                        local sz = _G.Settings.HitboxSize
                        h.Size        = Vector3.new(sz,sz,sz)
                        h.Transparency = 1
                        h.CanCollide  = false
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(3) do
        pcall(function()
            local d = LP:FindFirstChild("Data")
            if not d then return end
            local pts = d:FindFirstChild("Points") and d.Points.Value or 0
            if pts > 0 then
                CommF_:InvokeServer("AddPoint","Melee",  math.floor(pts*0.7))
                CommF_:InvokeServer("AddPoint","Defense",math.floor(pts*0.3))
            end
        end)
    end
end)

local function HookMob(mob)
    local h = mob:FindFirstChild("Humanoid")
    if h and not h:GetAttribute("BHooked") then
        h:SetAttribute("BHooked", true)
        h.Died:Connect(function()
            _G.State.KillCount = _G.State.KillCount + 1
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
    if not workspace:FindFirstChild("Enemies") then
        workspace.ChildAdded:Connect(function(c)
            if c.Name == "Enemies" then task.wait(0.3); Watch() end
        end)
    end
end)
-- ══════════════════════════════════════════════════════════════════
--                   AUTO FRUIT (Sea 2+)
-- ══════════════════════════════════════════════════════════════════
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
    local now   = os.time()
    if now - _G.State.LastRandomFruit < _G.Settings.RandomFruitInterval then return end
    if Beli() < price then return end
    _G.BobonStatus = "Random Fruit..."
    pcall(function() CommF_:InvokeServer("Cousin","Buy") end)
    _G.State.LastRandomFruit = os.time()
    task.wait(2)
    AutoStoreFruit()
end

task.spawn(function() while task.wait(15) do pcall(AutoRandomFruit) end end)
task.spawn(function() while task.wait(30) do pcall(AutoStoreFruit)  end end)
-- ══════════════════════════════════════════════════════════════════
--                   AUTO ITEMS (Saber, Pole, Sea unlock)
-- ══════════════════════════════════════════════════════════════════
local function AutoSaber()
    if HasItem("Saber") or Level() < 200 or GetSea() ~= 1 then return false end
    _G.BobonStatus = "Quest: Saber Sword"
    local torches = {
        {N="Torch1", C=CFrame.new(-1610,11,163)},
        {N="Torch2", C=CFrame.new(1114,4,4350)},
        {N="Torch3", C=CFrame.new(1400,101,-1250)},
        {N="Torch4", C=CFrame.new(-5070,23,4325)},
        {N="Torch5", C=CFrame.new(-1675,7,-2985)},
    }
    for _, t in ipairs(torches) do
        Travel(t.C); task.wait(2.5)
        pcall(function() CommF_:InvokeServer("Torch", t.N) end)
        task.wait(0.5)
    end
    local timeout = os.time() + 300
    while not HasItem("Saber") and os.time() < timeout do
        local boss = FindBoss("Saber Expert")
        if boss then
            EquipMelee()
            Travel(CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0,22,0)))
            Attack()
        else
            Travel(CFrame.new(-1405,30,-3330)); task.wait(3)
        end
        task.wait(0.1)
    end
    return true
end

local function AutoPoleV1()
    if HasItem("Pole (1st Form)") or Level() < 150 or GetSea() ~= 1 then return false end
    _G.BobonStatus = "Quest: Pole v1"
    Travel(CFrame.new(-7748,5606,-2305)); task.wait(2.5)
    pcall(function() CommF_:InvokeServer("BuyPoleV1") end)
    task.wait(1)
    return true
end

local function AutoSecondSea()
    if GetSea() >= 2 or Level() < 700 then return false end
    _G.BobonStatus = "Quest: Unlock 2nd Sea"
    Travel(CFrame.new(-4909,4,4450)); task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress","Detective") end)
    task.wait(0.5)
    Travel(CFrame.new(932,13,4482)); task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress","Bartilo") end)
    task.wait(0.5)
    local kills, timeout = 0, os.time()+600
    while kills < 50 and os.time() < timeout do
        local mob = FindMob("Swan Pirate")
        if mob then
            EquipMelee()
            Travel(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0,22,0)))
            Attack()
            if mob.Humanoid.Health <= 0 then kills = kills + 1 end
        else
            Travel(CFrame.new(878,122,1235)); task.wait(2)
        end
        task.wait(0.1)
    end
    Travel(CFrame.new(932,13,4482)); task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress","Bartilo") end)
    task.wait(0.5)
    Travel(CFrame.new(-12471,374,-7551)); task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress","Door") end)
    task.wait(1)
    TeleportSvc:Teleport(4442272183, LP)
    return true
end

local function AutoThirdSea()
    if GetSea() ~= 2 or Level() < 1500 then return false end
    _G.BobonStatus = "Quest: Unlock 3rd Sea"
    Travel(CFrame.new(-285,306,611)); task.wait(2)
    pcall(function() CommF_:InvokeServer("ZQuestProgress","Check") end)
    task.wait(0.5)
    local timeout = os.time()+600
    while os.time() < timeout do
        local boss = FindBoss("Don Swan")
        if boss and boss.Humanoid.Health > 0 then
            EquipMelee()
            Travel(CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0,22,0)))
            Attack()
        else break end
        task.wait(0.1)
    end
    task.wait(2)
    Travel(CFrame.new(-285,306,611)); task.wait(2)
    pcall(function() CommF_:InvokeServer("ZQuestProgress","Begin") end)
    task.wait(1)
    TeleportSvc:Teleport(7449423635, LP)
    return true
end
-- ══════════════════════════════════════════════════════════════════
--                      QUEST DATABASE (lv 1–2800)
-- ══════════════════════════════════════════════════════════════════
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

-- ══════════════════════════════════════════════════════════════════
--    LOOP FARM CHÍNH
-- ══════════════════════════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if _G.State.IsTraveling then return end

            local lv = Level()

            -- Auto items
            if lv >= 200 and lv < 700 and GetSea()==1 and not HasItem("Saber") then
                if AutoSaber() then return end
            end
            if lv >= 150 and lv < 700 and GetSea()==1 and not HasItem("Pole (1st Form)") then
                if AutoPoleV1() then return end
            end
            if lv >= 700 and GetSea()==1 then
                if AutoSecondSea() then return end
            end
            if lv >= 1500 and GetSea()==2 then
                if AutoThirdSea() then return end
            end

            -- Lấy quest phù hợp
            local q = GetQ()
            if not q then
                _G.BobonStatus = "Chưa có quest cho level " .. lv
                return
            end

            -- Nhận quest nếu chưa có
            if not HasQuest() then
                _G.BobonStatus = "Nhận quest: " .. q.Q
                Travel(q.QC)
                task.wait(2)
                pcall(function()
                    CommF_:InvokeServer("StartQuest", q.Q, q.QL)
                end)
                task.wait(0.5)
                return
            end

            -- Tìm mob
            local mob = FindMob(q.M)
            if not mob then
                _G.BobonStatus = "Tìm " .. q.M
                Travel(q.MC)
                return
            end

            -- Đánh
            _G.BobonStatus = "Đánh " .. q.M
            EquipMelee()
            Travel(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0, _G.Settings.FarmHeight, 0)))
            Attack()
        end)
    end
end)

print("[BobonHub v13] Loaded successfully!")
_G.BobonStatus = "Đã sẵn sàng!"
