-- ================================================================= --
--  BOBON HUB v12.0 FINAL - FULL AUTO KAITUN                        --
--  Auto Farm Quest | Auto Items | Auto Fruit | Always Visible UI   --
-- ================================================================= --

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

print("[BobonHub v12.0] Loading...")

-- ══════════════════════════════════════════════════════════════════
--                            SERVICES
-- ══════════════════════════════════════════════════════════════════
local Players        = game:GetService("Players")
local RS             = game:GetService("ReplicatedStorage")
local RunService     = game:GetService("RunService")
local VU             = game:GetService("VirtualUser")
local TS             = game:GetService("TweenService")
local TeleportSvc    = game:GetService("TeleportService")
local CoreGui        = game:GetService("CoreGui")

local LP      = Players.LocalPlayer
local Remotes = RS:WaitForChild("Remotes", 10)
local CommF_  = Remotes and Remotes:WaitForChild("CommF_", 10)

if not CommF_ then
    warn("[BobonHub] CommF_ not found!")
    return
end

-- ══════════════════════════════════════════════════════════════════
--                         GLOBAL SETTINGS
-- ══════════════════════════════════════════════════════════════════
_G.Settings = {
    TweenSpeed           = 300,
    FarmHeight           = 22,
    HitboxSize           = 50,
    AttackDelay          = 0.08,
    RandomFruitInterval  = 120,
    FastTravelDistance   = 1000,
}

_G.State = {
    CurrentTween     = nil,
    CurrentTarget    = nil,
    KillCount        = 0,
    StartTime        = os.time(),
    LastQuest        = 0,
    LastRandomFruit  = 0,
    IsTweening       = false,
    IsFastTraveling  = false,
    TeleportTarget   = nil,
}

_G.BobonStatus = "Starting..."

-- ══════════════════════════════════════════════════════════════════
--           UI - ALWAYS VISIBLE + FADE-IN ANIMATION
-- ══════════════════════════════════════════════════════════════════

if CoreGui:FindFirstChild("BobonHubUI") then
    CoreGui.BobonHubUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "BobonHubUI"
ScreenGui.Parent          = CoreGui
ScreenGui.ResetOnSpawn    = false
ScreenGui.DisplayOrder    = 10000
ScreenGui.IgnoreGuiInset  = true
ScreenGui.Enabled         = true

local Overlay = Instance.new("Frame")
Overlay.Name                 = "Overlay"
Overlay.Parent               = ScreenGui
Overlay.Size                 = UDim2.new(1, 0, 1, 0)
Overlay.Position             = UDim2.new(0, 0, 0, 0)
Overlay.BackgroundColor3     = Color3.fromRGB(8, 12, 25)
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel      = 0
Overlay.ZIndex               = 1

local Container = Instance.new("Frame")
Container.Name               = "Container"
Container.Parent             = ScreenGui
Container.AnchorPoint        = Vector2.new(0.5, 0.5)
Container.Position           = UDim2.new(0.5, 0, 0.5, 0)
Container.Size               = UDim2.new(0, 520, 0, 300)
Container.BackgroundTransparency = 1
Container.BorderSizePixel    = 0
Container.ZIndex             = 2

local function CreateLabel(name, text, size, color, yOffset, bold)
    local label = Instance.new("TextLabel")
    label.Name                = name
    label.Parent              = Container
    label.AnchorPoint         = Vector2.new(0.5, 0)
    label.Position            = UDim2.new(0.5, 0, 0, yOffset)
    label.Size                = UDim2.new(1, 0, 0, size + 18)
    label.BackgroundTransparency = 1
    label.Text                = text
    label.TextColor3          = color
    label.TextSize            = size
    label.Font                = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    label.TextXAlignment      = Enum.TextXAlignment.Center
    label.TextYAlignment      = Enum.TextYAlignment.Center
    label.TextTransparency    = 1
    label.TextStrokeTransparency = 0.7
    label.TextStrokeColor3    = Color3.fromRGB(0, 0, 0)
    label.ZIndex              = 3
    return label
end

local TitleLabel    = CreateLabel("Title",    "Bobon Hub",          34, Color3.fromRGB(80, 200, 255),    5,   true)
local SubtitleLabel = CreateLabel("Subtitle", "Blox Fruit Kaitun",  17, Color3.fromRGB(160, 190, 220),   55,  false)
local StatusLabel   = CreateLabel("Status",   "Status: Loading...", 15, Color3.fromRGB(100, 255, 140),   105, false)
local TimeLabel     = CreateLabel("Time",     "Time: 00:00:00",     14, Color3.fromRGB(190, 205, 230),   145, false)

local EarnedFrame = Instance.new("Frame")
EarnedFrame.Name                 = "EarnedFrame"
EarnedFrame.Parent               = Container
EarnedFrame.AnchorPoint          = Vector2.new(0.5, 0)
EarnedFrame.Position             = UDim2.new(0.5, 0, 0, 190)
EarnedFrame.Size                 = UDim2.new(1, 0, 0, 34)
EarnedFrame.BackgroundTransparency = 1
EarnedFrame.ZIndex               = 3

local BeliLabel = Instance.new("TextLabel")
BeliLabel.Name              = "Beli"
BeliLabel.Parent            = EarnedFrame
BeliLabel.Position          = UDim2.new(0, 0, 0, 0)
BeliLabel.Size              = UDim2.new(0.5, -8, 1, 0)
BeliLabel.BackgroundTransparency = 1
BeliLabel.Text              = "Beli: 0"
BeliLabel.TextColor3        = Color3.fromRGB(255, 185, 60)
BeliLabel.TextSize          = 15
BeliLabel.Font              = Enum.Font.GothamBold
BeliLabel.TextXAlignment    = Enum.TextXAlignment.Right
BeliLabel.TextTransparency  = 1
BeliLabel.TextStrokeTransparency = 0.7
BeliLabel.ZIndex            = 3

local FragLabel = Instance.new("TextLabel")
FragLabel.Name              = "Frag"
FragLabel.Parent            = EarnedFrame
FragLabel.Position          = UDim2.new(0.5, 8, 0, 0)
FragLabel.Size              = UDim2.new(0.5, -8, 1, 0)
FragLabel.BackgroundTransparency = 1
FragLabel.Text              = "Frag: 0"
FragLabel.TextColor3        = Color3.fromRGB(80, 170, 255)
FragLabel.TextSize          = 15
FragLabel.Font              = Enum.Font.GothamBold
FragLabel.TextXAlignment    = Enum.TextXAlignment.Left
FragLabel.TextTransparency  = 1
FragLabel.TextStrokeTransparency = 0.7
FragLabel.ZIndex            = 3

local KillLabel = CreateLabel("Kills", "Kills: 0", 13, Color3.fromRGB(255, 120, 120), 235, false)

-- Fade-in animation
local function FadeIn(obj, duration, bgTransp, textTransp)
    local props = {}
    if bgTransp   ~= nil then props.BackgroundTransparency = bgTransp end
    if textTransp ~= nil then props.TextTransparency       = textTransp end
    local t = TS:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

task.spawn(function()
    task.wait(0.3)
    FadeIn(Overlay, 1.0, 0.55, nil)
    task.wait(0.4)
    FadeIn(TitleLabel,    0.7, nil, 0)
    task.wait(0.18)
    FadeIn(SubtitleLabel, 0.6, nil, 0)
    task.wait(0.15)
    FadeIn(StatusLabel,   0.6, nil, 0)
    task.wait(0.12)
    FadeIn(TimeLabel,     0.5, nil, 0)
    task.wait(0.12)
    FadeIn(BeliLabel,     0.5, nil, 0)
    FadeIn(FragLabel,     0.5, nil, 0)
    task.wait(0.12)
    FadeIn(KillLabel,     0.5, nil, 0)
    print("[BobonHub] UI Ready!")
end)

-- UI update loop
local function FormatNum(n)
    local s = tostring(math.floor(n or 0))
    return s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,","")
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local e = os.time() - _G.State.StartTime
            TimeLabel.Text = string.format("Time: %02d:%02d:%02d", math.floor(e/3600), math.floor((e%3600)/60), e%60)
            StatusLabel.Text = "Status: " .. (_G.BobonStatus or "Idle")
            KillLabel.Text = "Kills: " .. FormatNum(_G.State.KillCount)
            local data = LP:FindFirstChild("Data")
            if data then
                local beli = data:FindFirstChild("Beli") and data.Beli.Value or 0
                local frag = data:FindFirstChild("Fragments") and data.Fragments.Value or 0
                BeliLabel.Text = "Beli: " .. FormatNum(beli)
                FragLabel.Text = "Frag: " .. FormatNum(frag)
            end
        end)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--                         HELPER FUNCTIONS
-- ══════════════════════════════════════════════════════════════════

local function GetLevel()
    local data = LP:FindFirstChild("Data")
    return data and data:FindFirstChild("Level") and data.Level.Value or 1
end

local function GetSea()
    local id = game.PlaceId
    if id == 2753915549 then return 1 end
    if id == 4442272183 then return 2 end
    if id == 7449423635 then return 3 end
    return 1
end

local function GetBeli()
    local data = LP:FindFirstChild("Data")
    return data and data:FindFirstChild("Beli") and data.Beli.Value or 0
end

local function HasItem(name)
    return LP.Backpack:FindFirstChild(name) or LP.Character:FindFirstChild(name)
end

local function HasQuest()
    local ok, res = pcall(function()
        return LP.PlayerGui.Main.Quest.Visible
    end)
    return ok and res
end

local function GetChar()
    return LP.Character
end

local function GetHRP()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChild("Humanoid")
end

local function Attack()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton1(Vector2.new())
    end)
end

local function EquipTool(toolName)
    pcall(function()
        local c = GetChar()
        if not c then return end
        if c:FindFirstChild(toolName) then return end
        local tool = LP.Backpack:FindFirstChild(toolName)
        if tool then
            c.Humanoid:EquipTool(tool)
            task.wait(0.2)
        end
    end)
end

local MeleeList = {
    "Godhuman", "Superhuman", "Death Step", "Electric Claw",
    "Dragon Talon", "Sharkman Karate", "Dragon Claw",
    "Fishman Karate", "Black Leg", "Electro", "Combat"
}

local function EquipMelee()
    for _, name in ipairs(MeleeList) do
        if HasItem(name) then
            EquipTool(name)
            return true
        end
    end
    return false
end

local function FindMob(mobName)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local best, bestDist = nil, math.huge
    local hrp = GetHRP()
    for _, mob in pairs(enemies:GetChildren()) do
        if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
            if hrp then
                local d = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < bestDist then best = mob; bestDist = d end
            else
                return mob
            end
        end
    end
    return best
end

local function FindBoss(bossName)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    for _, boss in pairs(enemies:GetChildren()) do
        if boss.Name == bossName and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 and boss:FindFirstChild("HumanoidRootPart") then
            return boss
        end
    end
    return nil
end

-- ══════════════════════════════════════════════════════════════════
--           FAST TRAVEL (RESET CHARACTER + RESPAWN TELE)
-- ══════════════════════════════════════════════════════════════════

local function FastTravelTo(targetCF)
    if _G.State.IsFastTraveling then return end
    _G.State.IsFastTraveling = true
    _G.State.TeleportTarget  = targetCF

    if _G.State.CurrentTween then
        _G.State.CurrentTween:Cancel()
        _G.State.CurrentTween = nil
    end

    print("[BobonHub] FastTravel → Reset character")
    _G.BobonStatus = "Fast Travel..."

    pcall(function()
        local hum = GetHum()
        if hum then hum.Health = 0 end
    end)

    local conn
    conn = LP.CharacterAdded:Connect(function(newChar)
        task.wait(0.5)
        pcall(function()
            local hrp = newChar:WaitForChild("HumanoidRootPart", 8)
            if hrp and _G.State.TeleportTarget then
                hrp.CFrame = _G.State.TeleportTarget
                print("[BobonHub] FastTravel complete!")
            end
        end)
        conn:Disconnect()
        task.wait(0.5)
        _G.State.IsFastTraveling = false
        _G.State.TeleportTarget  = nil
    end)

    task.delay(12, function()
        if _G.State.IsFastTraveling then
            pcall(function() conn:Disconnect() end)
            _G.State.IsFastTraveling = false
            _G.State.TeleportTarget  = nil
        end
    end)
end

local function Tween(cf)
    if _G.State.IsFastTraveling then
        task.wait(3)
        return
    end

    local hrp = GetHRP()
    if not hrp then return end

    local dist = (hrp.Position - cf.Position).Magnitude

    if dist > _G.Settings.FastTravelDistance then
        FastTravelTo(cf)
        return
    end

    if dist < 12 then
        hrp.CFrame = cf
        _G.State.IsTweening = false
        return
    end

    if _G.State.CurrentTween then
        _G.State.CurrentTween:Cancel()
    end

    _G.State.IsTweening = true

    local dur = dist / _G.Settings.TweenSpeed
    local t = TS:Create(hrp, TweenInfo.new(dur, Enum.EasingStyle.Linear), {CFrame = cf})

    _G.State.CurrentTween = t

    t.Completed:Connect(function()
        _G.State.IsTweening   = false
        _G.State.CurrentTween = nil
    end)

    t:Play()
    return t
end

-- ══════════════════════════════════════════════════════════════════
--                   TEAM SELECTION
-- ══════════════════════════════════════════════════════════════════

local TeamSelected = false

local function SelectTeam()
    if TeamSelected then return end

    for attempt = 1, 5 do
        if LP.Team and LP.Team.Name == "Pirates" then
            print("[BobonHub] Team = Pirates ✓")
            _G.BobonStatus = "Team: Pirates ✓"
            TeamSelected = true
            return true
        end

        pcall(function() CommF_:InvokeServer("SetTeam", "Pirates") end)
        task.wait(1.5)
        if LP.Team and LP.Team.Name == "Pirates" then TeamSelected = true; return true end

        pcall(function() CommF_:InvokeServer("ChooseTeam", "Pirates") end)
        task.wait(1.5)
        if LP.Team and LP.Team.Name == "Pirates" then TeamSelected = true; return true end

        task.wait(2)
    end
end

-- ══════════════════════════════════════════════════════════════════
--             AUTO FRUIT (RANDOM + STORE)
-- ══════════════════════════════════════════════════════════════════

local FruitPrices = {[1] = 38000, [2] = 100000, [3] = 250000}

local function HasFruitInStorage(fruitName)
    local ok, result = pcall(function()
        return CommF_:InvokeServer("getInventoryFruits")
    end)
    if ok and type(result) == "table" then
        for _, f in pairs(result) do
            if f.Name == fruitName then return true end
        end
    end
    return false
end

local function AutoStoreFruit()
    for _, item in pairs(LP.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name:find("%-") then
            if not HasFruitInStorage(item.Name) then
                pcall(function() CommF_:InvokeServer("StoreFruit", item.Name, LP.Backpack) end)
                task.wait(0.5)
            end
        end
    end
    local c = GetChar()
    if c then
        for _, item in pairs(c:GetChildren()) do
            if item:IsA("Tool") and item.Name:find("%-") then
                if not HasFruitInStorage(item.Name) then
                    pcall(function() CommF_:InvokeServer("StoreFruit", item.Name, c) end)
                    task.wait(0.5)
                end
            end
        end
    end
end

local function AutoRandomFruit()
    local sea = GetSea()
    if sea < 2 then return false end

    local price = FruitPrices[sea] or 100000
    local beli  = GetBeli()
    local now   = os.time()

    if now - _G.State.LastRandomFruit < _G.Settings.RandomFruitInterval then return false end
    if beli < price then return false end

    _G.BobonStatus = "Random Fruit..."

    local ok = pcall(function() CommF_:InvokeServer("Cousin", "Buy") end)
    if ok then
        _G.State.LastRandomFruit = os.time()
        task.wait(2)
        AutoStoreFruit()
        return true
    end
    return false
end

task.spawn(function() while task.wait(12) do pcall(AutoRandomFruit) end end)
task.spawn(function() while task.wait(30) do pcall(AutoStoreFruit) end end)

-- ══════════════════════════════════════════════════════════════════
--                     BACKGROUND SYSTEMS
-- ══════════════════════════════════════════════════════════════════

LP.Idled:Connect(function()
    pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
end)

RunService.Stepped:Connect(function()
    pcall(function()
        local c = GetChar()
        if not c then return end
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local c = GetChar()
            if not c then return end
            for _, tool in pairs(c:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                    tool.Handle.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize)
                    tool.Handle.Transparency = 1
                    tool.Handle.CanCollide = false
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(3) do
        pcall(function()
            local data = LP:FindFirstChild("Data")
            if not data then return end
            local points = data:FindFirstChild("Points") and data.Points.Value or 0
            if points > 0 then
                CommF_:InvokeServer("AddPoint", "Melee", math.floor(points * 0.7))
                CommF_:InvokeServer("AddPoint", "Defense", math.floor(points * 0.3))
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(20) do
        pcall(function()
            CommF_:InvokeServer("Ken", true)
            CommF_:InvokeServer("Buso", true)
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local enemies = workspace:FindFirstChild("Enemies")
            if not enemies then return end
            for _, mob in pairs(enemies:GetChildren()) do
                local hum = mob:FindFirstChild("Humanoid")
                if hum and not hum:GetAttribute("KillTracked") then
                    hum:SetAttribute("KillTracked", true)
                    hum.HealthChanged:Connect(function(h)
                        if h <= 0 then _G.State.KillCount = _G.State.KillCount + 1 end
                    end)
                end
            end
        end)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--                    AUTO QUEST ITEMS
-- ══════════════════════════════════════════════════════════════════

local function AutoSaber()
    if HasItem("Saber") or GetLevel() < 200 or GetSea() ~= 1 then return false end
    _G.BobonStatus = "Quest: Saber"
    local torches = {
        {Name = "Torch1", CF = CFrame.new(-1610, 11, 163)},
        {Name = "Torch2", CF = CFrame.new(1114, 4, 4350)},
        {Name = "Torch3", CF = CFrame.new(1400, 101, -1250)},
        {Name = "Torch4", CF = CFrame.new(-5070, 23, 4325)},
        {Name = "Torch5", CF = CFrame.new(-1675, 7, -2985)},
    }
    for _, torch in ipairs(torches) do
        Tween(torch.CF)
        task.wait(2.5)
        pcall(function() CommF_:InvokeServer("Torch", torch.Name) end)
        task.wait(0.5)
    end
    local timeout = os.time() + 300
    while not HasItem("Saber") and os.time() < timeout do
        local boss = FindBoss("Saber Expert")
        if boss then
            EquipMelee()
            Tween(CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0, _G.Settings.FarmHeight, 0)))
            Attack()
        else
            Tween(CFrame.new(-1405, 30, -3330))
            task.wait(3)
        end
        task.wait(0.1)
    end
    return true
end

local function AutoPoleV1()
    if HasItem("Pole (1st Form)") or GetLevel() < 150 or GetSea() ~= 1 then return false end
    _G.BobonStatus = "Quest: Pole v1"
    Tween(CFrame.new(-7748, 5606, -2305))
    task.wait(2.5)
    pcall(function() CommF_:InvokeServer("BuyPoleV1") end)
    task.wait(1)
    return true
end

local function AutoSecondSea()
    if GetSea() >= 2 or GetLevel() < 700 then return false end
    _G.BobonStatus = "Quest: 2nd Sea"
    Tween(CFrame.new(-4909, 4, 4450))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Detective") end)
    task.wait(0.5)
    Tween(CFrame.new(932, 13, 4482))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Bartilo") end)
    task.wait(0.5)
    local kills = 0
    local timeout = os.time() + 600
    while kills < 50 and os.time() < timeout do
        local mob = FindMob("Swan Pirate")
        if mob then
            EquipMelee()
            Tween(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0, _G.Settings.FarmHeight, 0)))
            Attack()
            if mob.Humanoid.Health <= 0 then kills = kills + 1 end
        else
            Tween(CFrame.new(878, 122, 1235))
            task.wait(2)
        end
        task.wait(0.1)
    end
    Tween(CFrame.new(932, 13, 4482))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Bartilo") end)
    task.wait(0.5)
    Tween(CFrame.new(-12471, 374, -7551))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Door") end)
    task.wait(1)
    TeleportSvc:Teleport(4442272183, LP)
    return true
end

local function AutoThirdSea()
    if GetSea() ~= 2 or GetLevel() < 1500 then return false end
    _G.BobonStatus = "Quest: 3rd Sea"
    Tween(CFrame.new(-285, 306, 611))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("ZQuestProgress", "Check") end)
    task.wait(0.5)
    local timeout = os.time() + 600
    while os.time() < timeout do
        local boss = FindBoss("Don Swan")
        if boss and boss.Humanoid.Health > 0 then
            EquipMelee()
            Tween(CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0, _G.Settings.FarmHeight, 0)))
            Attack()
        else
            break
        end
        task.wait(0.1)
    end
    task.wait(2)
    Tween(CFrame.new(-285, 306, 611))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("ZQuestProgress", "Begin") end)
    task.wait(1)
    TeleportSvc:Teleport(7449423635, LP)
    return true
end

-- ══════════════════════════════════════════════════════════════════
--                       QUEST DATABASE
-- ══════════════════════════════════════════════════════════════════

local QuestDB = {
    {Min=1, Max=14, Q="BanditQuest1", M="Bandit", QL=1, QC=CFrame.new(1059,17,1550), MC=CFrame.new(1145,17,1634)},
    {Min=15, Max=29, Q="JungleQuest", M="Monkey", QL=1, QC=CFrame.new(-1598,37,153), MC=CFrame.new(-1448,50,24)},
    {Min=30, Max=59, Q="BuggyQuest1", M="Brute", QL=1, QC=CFrame.new(-1141,5,3831), MC=CFrame.new(-1145,15,4350)},
    {Min=60, Max=74, Q="DesertQuest", M="Desert Bandit", QL=1, QC=CFrame.new(894,7,4391), MC=CFrame.new(932,7,4484)},
    {Min=75, Max=89, Q="DesertQuest", M="Desert Officer", QL=2, QC=CFrame.new(894,7,4391), MC=CFrame.new(1580,11,4373)},
    {Min=90, Max=99, Q="SnowQuest", M="Snow Bandit", QL=1, QC=CFrame.new(1389,88,-1298), MC=CFrame.new(1376,87,-1396)},
    {Min=100, Max=119, Q="SnowQuest", M="Snowman", QL=2, QC=CFrame.new(1389,88,-1298), MC=CFrame.new(1201,472,-1401)},
    {Min=120, Max=149, Q="MarineQuest2", M="Chief Petty Officer", QL=1, QC=CFrame.new(-5039,29,4324), MC=CFrame.new(-4882,23,4255)},
    {Min=150, Max=174, Q="MarineQuest2", M="Sky Bandit", QL=2, QC=CFrame.new(-5039,29,4324), MC=CFrame.new(-4953,295,-2899)},
    {Min=175, Max=189, Q="PrisonerQuest", M="Prisoner", QL=1, QC=CFrame.new(5308,2,474), MC=CFrame.new(5411,96,690)},
    {Min=190, Max=209, Q="PrisonerQuest", M="Dangerous Prisoner", QL=2, QC=CFrame.new(5308,2,474), MC=CFrame.new(5654,15,866)},
    {Min=210, Max=249, Q="ColosseumQuest", M="Gladiator", QL=1, QC=CFrame.new(-1580,7,296), MC=CFrame.new(-1521,86,405)},
    {Min=250, Max=299, Q="ColosseumQuest", M="Military Soldier", QL=2, QC=CFrame.new(-1580,7,296), MC=CFrame.new(-1823,54,29)},
    {Min=300, Max=374, Q="MagmaQuest", M="Military Spy", QL=1, QC=CFrame.new(-5316,12,8515), MC=CFrame.new(-5787,76,8349)},
    {Min=375, Max=399, Q="MagmaQuest", M="Magma Admiral", QL=2, QC=CFrame.new(-5316,12,8515), MC=CFrame.new(-5530,81,8849)},
    {Min=400, Max=449, Q="FishmanQuest", M="Fishman Warrior", QL=1, QC=CFrame.new(61123,19,1569), MC=CFrame.new(60879,19,1549)},
    {Min=450, Max=474, Q="FishmanQuest", M="Fishman Commando", QL=2, QC=CFrame.new(61123,19,1569), MC=CFrame.new(61738,65,1584)},
    {Min=475, Max=524, Q="SkyExp1Quest", M="God's Guard", QL=1, QC=CFrame.new(-4722,845,-1954), MC=CFrame.new(-4698,845,-1912)},
    {Min=525, Max=549, Q="SkyExp1Quest", M="Shanda", QL=2, QC=CFrame.new(-7863,5546,-380), MC=CFrame.new(-7685,5567,-446)},
    {Min=550, Max=624, Q="SkyExp2Quest", M="Royal Squad", QL=1, QC=CFrame.new(-7906,5636,-1412), MC=CFrame.new(-7555,5637,-1420)},
    {Min=625, Max=649, Q="SkyExp2Quest", M="Royal Soldier", QL=2, QC=CFrame.new(-7906,5636,-1412), MC=CFrame.new(-7836,5645,-1699)},
    {Min=650, Max=699, Q="FountainQuest", M="Galley Pirate", QL=1, QC=CFrame.new(5259,38,4050), MC=CFrame.new(5551,78,3930)},
    {Min=700, Max=774, Q="Area1Quest", M="Raider", QL=1, QC=CFrame.new(-427,73,1837), MC=CFrame.new(-746,39,2507)},
    {Min=775, Max=849, Q="Area1Quest", M="Mercenary", QL=2, QC=CFrame.new(-427,73,1837), MC=CFrame.new(-874,141,1312)},
    {Min=850, Max=899, Q="Area2Quest", M="Swan Pirate", QL=1, QC=CFrame.new(634,73,918), MC=CFrame.new(878,122,1235)},
    {Min=900, Max=949, Q="Area2Quest", M="Marine Lieutenant", QL=2, QC=CFrame.new(634,73,918), MC=CFrame.new(-845,77,2016)},
    {Min=950, Max=999, Q="MarineQuest3", M="Marine Captain", QL=1, QC=CFrame.new(-2441,73,1891), MC=CFrame.new(-2035,73,2050)},
    {Min=1000, Max=1049, Q="MarineQuest3", M="Zombie", QL=2, QC=CFrame.new(-2441,73,1891), MC=CFrame.new(-5736,126,-653)},
    {Min=1050, Max=1099, Q="ZombieQuest", M="Vampire", QL=1, QC=CFrame.new(-5494,49,-795), MC=CFrame.new(-6033,7,-1317)},
    {Min=1100, Max=1124, Q="ZombieQuest", M="Elf", QL=2, QC=CFrame.new(-5494,49,-795), MC=CFrame.new(56,194,-1393)},
    {Min=1125, Max=1174, Q="NinjaQuest", M="Ninja Assassin", QL=1, QC=CFrame.new(-5377,39,-4826), MC=CFrame.new(-5238,84,-4634)},
    {Min=1175, Max=1199, Q="NinjaQuest", M="Ninja Hunter", QL=2, QC=CFrame.new(-5377,39,-4826), MC=CFrame.new(-5700,50,-4884)},
    {Min=1200, Max=1249, Q="IceSideQuest", M="Snow Trooper", QL=1, QC=CFrame.new(-6061,16,-4903), MC=CFrame.new(-5693,16,-4898)},
    {Min=1250, Max=1274, Q="IceSideQuest", M="Winter Warrior", QL=2, QC=CFrame.new(-6061,16,-4903), MC=CFrame.new(-5587,9,-5008)},
    {Min=1275, Max=1299, Q="ShipQuest1", M="Lab Subordinate", QL=1, QC=CFrame.new(-9505,38,4088), MC=CFrame.new(-9230,45,4294)},
    {Min=1300, Max=1324, Q="ShipQuest2", M="Horned Warrior", QL=1, QC=CFrame.new(-9481,72,6059), MC=CFrame.new(-6779,83,5928)},
    {Min=1325, Max=1349, Q="ShipQuest2", M="Magma Ninja", QL=2, QC=CFrame.new(-9481,72,6059), MC=CFrame.new(-5900,78,5800)},
    {Min=1350, Max=1374, Q="FrostQuest", M="Lava Pirate", QL=1, QC=CFrame.new(-5249,38,-4445), MC=CFrame.new(-5270,42,-4800)},
    {Min=1375, Max=1399, Q="FrostQuest", M="Ship Deckhand", QL=2, QC=CFrame.new(-5249,38,-4445), MC=CFrame.new(-8912,30,-9844)},
    {Min=1400, Max=1424, Q="ForgottenQuest", M="Ship Engineer", QL=1, QC=CFrame.new(-3053,237,-10145), MC=CFrame.new(-9300,30,-9940)},
    {Min=1425, Max=1449, Q="ForgottenQuest", M="Ship Steward", QL=2, QC=CFrame.new(-3053,237,-10145), MC=CFrame.new(-9400,15,-9350)},
    {Min=1450, Max=1474, Q="IceCastleQuest", M="Ship Officer", QL=1, QC=CFrame.new(-5539,314,-2972), MC=CFrame.new(-9658,8,-9700)},
    {Min=1475, Max=1524, Q="IceCastleQuest", M="Arctic Warrior", QL=2, QC=CFrame.new(-5539,314,-2972), MC=CFrame.new(-5990,340,-2800)},
    {Min=1525, Max=1574, Q="PiratePortQuest", M="Pirate Millionaire", QL=1, QC=CFrame.new(-290,44,5580), MC=CFrame.new(-435,191,5610)},
    {Min=1575, Max=1599, Q="PiratePortQuest", M="Pistol Billionaire", QL=2, QC=CFrame.new(-290,44,5580), MC=CFrame.new(-379,74,5873)},
    {Min=1600, Max=1624, Q="AmazonQuest", M="Dragon Crew Warrior", QL=1, QC=CFrame.new(5832,52,-1105), MC=CFrame.new(6339,52,-1213)},
    {Min=1625, Max=1649, Q="AmazonQuest", M="Dragon Crew Archer", QL=2, QC=CFrame.new(5832,52,-1105), MC=CFrame.new(6594,383,139)},
    {Min=1650, Max=1699, Q="AmazonQuest2", M="Female Islander", QL=1, QC=CFrame.new(5448,602,751), MC=CFrame.new(5792,820,863)},
    {Min=1700, Max=1724, Q="AmazonQuest2", M="Giant Islander", QL=2, QC=CFrame.new(5448,602,751), MC=CFrame.new(4530,656,-131)},
    {Min=1725, Max=1774, Q="MarineTreeIsland", M="Marine Commodore", QL=1, QC=CFrame.new(2180,29,-6737), MC=CFrame.new(2490,73,-7070)},
    {Min=1775, Max=1799, Q="MarineTreeIsland", M="Marine Rear Admiral", QL=2, QC=CFrame.new(2180,29,-6737), MC=CFrame.new(3671,402,-6982)},
    {Min=1800, Max=1849, Q="DeepForestIsland", M="Fishman Raider", QL=1, QC=CFrame.new(-13234,333,-7625), MC=CFrame.new(-10560,332,-8754)},
    {Min=1850, Max=1899, Q="DeepForestIsland", M="Fishman Captain", QL=2, QC=CFrame.new(-13234,333,-7625), MC=CFrame.new(-11465,332,-8770)},
    {Min=1900, Max=1924, Q="DeepForestIsland2", M="Forest Pirate", QL=1, QC=CFrame.new(-12684,391,-9902), MC=CFrame.new(-13225,425,-7755)},
    {Min=1925, Max=1974, Q="DeepForestIsland3", M="Jungle Pirate", QL=1, QC=CFrame.new(-12191,332,-10549), MC=CFrame.new(-12107,332,-10549)},
    {Min=1975, Max=1999, Q="PeanutIsland", M="Peanut Scout", QL=1, QC=CFrame.new(-2104,38,-10192), MC=CFrame.new(-2124,123,-10435)},
    {Min=2000, Max=2024, Q="PeanutIsland", M="Peanut President", QL=2, QC=CFrame.new(-2104,38,-10192), MC=CFrame.new(-1876,38,-10946)},
    {Min=2025, Max=2049, Q="IceCreamIsland", M="Ice Cream Chef", QL=1, QC=CFrame.new(-820,66,-10965), MC=CFrame.new(-821,44,-11253)},
    {Min=2050, Max=2074, Q="IceCreamIsland", M="Ice Cream Commander", QL=2, QC=CFrame.new(-820,66,-10965), MC=CFrame.new(-610,127,-11034)},
    {Min=2075, Max=2099, Q="CakeQuest1", M="Cookie Crafter", QL=1, QC=CFrame.new(-2022,38,-12030), MC=CFrame.new(-2365,38,-12099)},
    {Min=2100, Max=2124, Q="CakeQuest1", M="Cake Guard", QL=2, QC=CFrame.new(-2022,38,-12030), MC=CFrame.new(-1651,38,-12293)},
    {Min=2125, Max=2149, Q="CakeQuest2", M="Baking Staff", QL=1, QC=CFrame.new(-1927,38,-12843), MC=CFrame.new(-1980,38,-12763)},
    {Min=2150, Max=2199, Q="CakeQuest2", M="Head Baker", QL=2, QC=CFrame.new(-1927,38,-12843), MC=CFrame.new(-2235,53,-12858)},
    {Min=2200, Max=2224, Q="ChocQuest1", M="Cocoa Warrior", QL=1, QC=CFrame.new(233,25,-12201), MC=CFrame.new(167,26,-12238)},
    {Min=2225, Max=2249, Q="ChocQuest1", M="Chocolate Bar Battler", QL=2, QC=CFrame.new(233,25,-12201), MC=CFrame.new(507,73,-12789)},
    {Min=2250, Max=2274, Q="ChocQuest2", M="Sweet Thief", QL=1, QC=CFrame.new(151,25,-12774), MC=CFrame.new(-71,25,-12381)},
    {Min=2275, Max=2299, Q="ChocQuest2", M="Candy Rebel", QL=2, QC=CFrame.new(151,25,-12774), MC=CFrame.new(134,77,-12882)},
    {Min=2300, Max=2324, Q="CandyQuest1", M="Candy Pirate", QL=1, QC=CFrame.new(-1149,14,-14453), MC=CFrame.new(-1380,14,-14453)},
    {Min=2325, Max=2800, Q="CandyQuest1", M="Snow Demon", QL=2, QC=CFrame.new(-1149,14,-14453), MC=CFrame.new(-907,14,-14453)},
}

local function GetQuest()
    local level = GetLevel()
    for _, q in ipairs(QuestDB) do
        if level >= q.Min and level <= q.Max then return q end
    end
    return nil
end

-- ══════════════════════════════════════════════════════════════════
--                      MAIN FARM LOOP
-- ══════════════════════════════════════════════════════════════════

task.spawn(function()
    task.wait(5)
    SelectTeam()
end)

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if _G.State.IsFastTraveling then return end

            local level = GetLevel()

            if level >= 200 and level < 700 and GetSea() == 1 and not HasItem("Saber") then
                if AutoSaber() then return end
            end

            if level >= 150 and level < 700 and GetSea() == 1 and not HasItem("Pole (1st Form)") then
                if AutoPoleV1() then return end
            end

            if level >= 700 and GetSea() == 1 then
                if AutoSecondSea() then return end
            end

            if level >= 1500 and GetSea() == 2 then
                if AutoThirdSea() then return end
            end

            local c = GetChar()
            if not c or not c:FindFirstChild("HumanoidRootPart") then return end

            local qData = GetQuest()
            if not qData then
                _G.BobonStatus = "Level out of range!"
                return
            end

            if not HasQuest() then
                local now = os.time()
                if now - _G.State.LastQuest < 3 then
                    _G.BobonStatus = "Quest cooldown..."
                    return
                end

                _G.BobonStatus = "Taking quest: " .. qData.M
                Tween(qData.QC)
                task.wait(1)
                CommF_:InvokeServer("StartQuest", qData.Q, qData.QL)
                _G.State.LastQuest = os.time()
                task.wait(0.5)
                Tween(CFrame.new(qData.MC.Position.X, qData.MC.Position.Y + 22, qData.MC.Position.Z))
                return
            end

            local mob = FindMob(qData.M)
            if mob then
                _G.State.CurrentTarget = mob
                _G.BobonStatus = "Farming: " .. qData.M .. " | Kills: " .. _G.State.KillCount
                Tween(CFrame.new(mob.HumanoidRootPart.Position.X, mob.HumanoidRootPart.Position.Y + 22, mob.HumanoidRootPart.Position.Z))
            else
                _G.State.CurrentTarget = nil
                _G.BobonStatus = "Waiting: " .. qData.M
                Tween(CFrame.new(qData.MC.Position.X, qData.MC.Position.Y + 22, qData.MC.Position.Z))
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        if not _G.State.CurrentTarget then return end
        local mob = _G.State.CurrentTarget
        if not mob or not mob:FindFirstChild("Humanoid") or mob.Humanoid.Health <= 0 then
            _G.State.CurrentTarget = nil
            return
        end
        EquipMelee()
        Attack()
    end)
end)

print("[BobonHub v12.0] ✓ Ready! | Always visible menu + Auto farm + Auto items + Auto fruit")
_G.BobonStatus = "BobonHub v12.0 Ready!"
