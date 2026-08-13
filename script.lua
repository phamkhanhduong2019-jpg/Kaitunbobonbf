-- ================================================================= --
--  BOBON HUB v10.0 FINAL - AUTO RANDOM FRUIT + AUTO STORE FRUIT   --
-- ================================================================= --
-- FEATURES:
--   [✓] Auto Farm Quest (Sea 1/2/3 → 2800)
--   [✓] Auto Random Fruit (Sea 2+ mỗi 2 phút)
--   [✓] Auto Store Fruit vào inventory (skip nếu đã có)
--   [✓] Auto All Quest Items (Saber, Second/Third Sea, etc.)
--   [✓] Auto Buy All Swords/Melee
--   [✓] Auto Stats (70% Melee, 30% Defense)
--   [✓] UI Vxeze Style
-- ================================================================= --

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- ══════════════════════════════════════════════════════════════════
--                            SERVICES
-- ══════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local TS = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local Remotes = RS:WaitForChild("Remotes")
local CommF_ = Remotes:WaitForChild("CommF_")

-- ══════════════════════════════════════════════════════════════════
--                         SETTINGS & STATE
-- ══════════════════════════════════════════════════════════════════
_G.Settings = {
    TweenSpeed = 300,
    FarmHeight = 22,
    HitboxSize = 50,
    AttackDelay = 0.08,
    RandomFruitInterval = 120, -- Mỗi 2 phút random 1 lần (Sea 2+)
}

_G.State = {
    CurrentTween = nil,
    CurrentTarget = nil,
    KillCount = 0,
    StartTime = os.time(),
    LastQuest = 0,
    LastRandomFruit = 0,
}

_G.BobonStatus = "Starting..."

-- ══════════════════════════════════════════════════════════════════
--                              UI
-- ══════════════════════════════════════════════════════════════════

if CoreGui:FindFirstChild("BobonHubUI") then
    CoreGui.BobonHubUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BobonHubUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true

local Overlay = Instance.new("Frame")
Overlay.Name = "Overlay"
Overlay.Parent = ScreenGui
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.Position = UDim2.new(0, 0, 0, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0
Overlay.ZIndex = 1

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Parent = ScreenGui
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.Size = UDim2.new(0, 500, 0, 280)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ZIndex = 2

local function CreateLabel(name, text, size, color, yOffset, bold)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Parent = Container
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.Position = UDim2.new(0.5, 0, 0, yOffset)
    label.Size = UDim2.new(1, 0, 0, size + 15)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextSize = size
    label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextTransparency = 1
    label.TextStrokeTransparency = 0.8
    label.ZIndex = 3
    return label
end

local TitleLabel = CreateLabel("Title", "Bobon Hub", 32, Color3.fromRGB(100, 220, 255), 10, true)
local SubtitleLabel = CreateLabel("Subtitle", "Blox Fruit Kaitun", 18, Color3.fromRGB(180, 200, 220), 60, false)
local StatusLabel = CreateLabel("Status", "Status: Starting...", 16, Color3.fromRGB(120, 255, 150), 110, false)
local TimeLabel = CreateLabel("Time", "Time: 00:00:00", 15, Color3.fromRGB(200, 210, 230), 150, false)

local EarnedFrame = Instance.new("Frame")
EarnedFrame.Name = "EarnedFrame"
EarnedFrame.Parent = Container
EarnedFrame.AnchorPoint = Vector2.new(0.5, 0)
EarnedFrame.Position = UDim2.new(0.5, 0, 0, 190)
EarnedFrame.Size = UDim2.new(1, 0, 0, 30)
EarnedFrame.BackgroundTransparency = 1
EarnedFrame.ZIndex = 3

local BeliLabel = Instance.new("TextLabel")
BeliLabel.Name = "Beli"
BeliLabel.Parent = EarnedFrame
BeliLabel.Position = UDim2.new(0, 0, 0, 0)
BeliLabel.Size = UDim2.new(0.5, -5, 1, 0)
BeliLabel.BackgroundTransparency = 1
BeliLabel.Text = "Beli: 0"
BeliLabel.TextColor3 = Color3.fromRGB(255, 180, 80)
BeliLabel.TextSize = 15
BeliLabel.Font = Enum.Font.Gotham
BeliLabel.TextXAlignment = Enum.TextXAlignment.Right
BeliLabel.TextTransparency = 1
BeliLabel.TextStrokeTransparency = 0.8
BeliLabel.ZIndex = 3

local FragLabel = Instance.new("TextLabel")
FragLabel.Name = "Frag"
FragLabel.Parent = EarnedFrame
FragLabel.Position = UDim2.new(0.5, 5, 0, 0)
FragLabel.Size = UDim2.new(0.5, -5, 1, 0)
FragLabel.BackgroundTransparency = 1
FragLabel.Text = "Frag: 0"
FragLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
FragLabel.TextSize = 15
FragLabel.Font = Enum.Font.Gotham
FragLabel.TextXAlignment = Enum.TextXAlignment.Left
FragLabel.TextTransparency = 1
FragLabel.TextStrokeTransparency = 0.8
FragLabel.ZIndex = 3

local function FadeIn(object, duration, targetTransparency)
    local tween = TS:Create(
        object,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = targetTransparency,
            TextTransparency = targetTransparency
        }
    )
    tween:Play()
end

task.spawn(function()
    task.wait(0.1)
    FadeIn(Overlay, 0.8, 0.4)
    task.wait(0.3)
    FadeIn(TitleLabel, 0.6, 0)
    task.wait(0.15)
    FadeIn(SubtitleLabel, 0.6, 0)
    task.wait(0.15)
    FadeIn(StatusLabel, 0.6, 0)
    task.wait(0.15)
    FadeIn(TimeLabel, 0.6, 0)
    task.wait(0.15)
    FadeIn(BeliLabel, 0.6, 0)
    FadeIn(FragLabel, 0.6, 0)
end)

local function FormatNumber(num)
    local str = tostring(math.floor(num))
    return str:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local elapsed = os.time() - _G.State.StartTime
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = elapsed % 60
            TimeLabel.Text = string.format("Time: %02d:%02d:%02d", hours, minutes, seconds)

            StatusLabel.Text = "Status: " .. (_G.BobonStatus or "Idle")

            local data = LP:FindFirstChild("Data")
            if data then
                local beli = data:FindFirstChild("Beli") and data.Beli.Value or 0
                local frag = data:FindFirstChild("Fragments") and data.Fragments.Value or 0

                BeliLabel.Text = "Beli: " .. FormatNumber(beli)
                FragLabel.Text = "Frag: " .. FormatNumber(frag)
            end
        end)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--                         CORE UTILITIES
-- ══════════════════════════════════════════════════════════════════

local function GetLevel()
    return LP.Data:FindFirstChild("Level") and LP.Data.Level.Value or 1
end

local function GetSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then return 1 end
    if placeId == 4442272183 then return 2 end
    if placeId == 7449423635 then return 3 end
    return 1
end

local function GetBeli()
    return LP.Data:FindFirstChild("Beli") and LP.Data.Beli.Value or 0
end

local function HasItem(itemName)
    return LP.Backpack:FindFirstChild(itemName) or LP.Character:FindFirstChild(itemName)
end

local function Tween(cf)
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = LP.Character.HumanoidRootPart
    local dist = (hrp.Position - cf.Position).Magnitude

    if dist < 15 then
        hrp.CFrame = cf
        return
    end

    if _G.State.CurrentTween then
        _G.State.CurrentTween:Cancel()
    end

    local duration = dist / _G.Settings.TweenSpeed
    local tween = TS:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = cf})

    _G.State.CurrentTween = tween
    tween:Play()

    return tween
end

local function StopTween()
    if _G.State.CurrentTween then
        _G.State.CurrentTween:Cancel()
        _G.State.CurrentTween = nil
    end
end

local function HasQuest()
    local ok, res = pcall(function()
        return LP.PlayerGui.Main.Quest.Visible
    end)
    return ok and res
end

local function EquipTool(toolName)
    pcall(function()
        if LP.Character:FindFirstChild(toolName) then return end
        local tool = LP.Backpack:FindFirstChild(toolName)
        if tool then
            LP.Character.Humanoid:EquipTool(tool)
            task.wait(0.3)
        end
    end)
end

local MeleeList = {
    "Godhuman", "Superhuman", "Death Step", "Electric Claw", "Dragon Talon",
    "Sharkman Karate", "Dragon Claw", "Fishman Karate", "Black Leg",
    "Electro", "Combat"
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

    local best = nil
    local bestDist = math.huge

    for _, mob in pairs(enemies:GetChildren()) do
        if mob.Name == mobName
            and mob:FindFirstChild("Humanoid")
            and mob.Humanoid.Health > 0
            and mob:FindFirstChild("HumanoidRootPart")
        then
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (mob.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                if dist < bestDist then
                    best = mob
                    bestDist = dist
                end
            else
                return mob
            end
        end
    end

    return best
end

local function FindBoss(bossName)
    local bosses = workspace:FindFirstChild("Enemies")
    if not bosses then return nil end

    for _, boss in pairs(bosses:GetChildren()) do
        if boss.Name == bossName
            and boss:FindFirstChild("Humanoid")
            and boss.Humanoid.Health > 0
            and boss:FindFirstChild("HumanoidRootPart")
        then
            return boss
        end
    end

    return nil
end

local function Attack()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton1(Vector2.new())
    end)
end

-- ══════════════════════════════════════════════════════════════════
--              AUTO STORE FRUIT (Cất trái vào rương)
-- ══════════════════════════════════════════════════════════════════

-- Check xem fruit đã có trong inventory chưa
local function HasFruitInInventory(fruitName)
    local ok, result = pcall(function()
        return CommF_:InvokeServer("getInventoryFruits")
    end)

    if ok and result then
        for _, fruit in pairs(result) do
            if fruit.Name == fruitName then
                return true
            end
        end
    end

    return false
end

-- Auto store fruit từ backpack/character vào inventory
local function AutoStoreFruit()
    pcall(function()
        -- Check backpack
        for _, item in pairs(LP.Backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:find("-") then  -- Fruits có dấu - trong tên (vd: "Flame-Flame")
                local fruitName = item.Name

                -- Chỉ store nếu chưa có trong inventory
                if not HasFruitInInventory(fruitName) then
                    CommF_:InvokeServer("StoreFruit", fruitName, LP.Backpack)
                    print("[BobonHub] Stored fruit:", fruitName)
                    task.wait(0.5)
                else
                    print("[BobonHub] Fruit already in inventory, skipping:", fruitName)
                end
            end
        end

        -- Check character
        for _, item in pairs(LP.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name:find("-") then
                local fruitName = item.Name

                if not HasFruitInInventory(fruitName) then
                    CommF_:InvokeServer("StoreFruit", fruitName, LP.Character)
                    print("[BobonHub] Stored fruit:", fruitName)
                    task.wait(0.5)
                else
                    print("[BobonHub] Fruit already in inventory, skipping:", fruitName)
                end
            end
        end
    end)
end

-- ══════════════════════════════════════════════════════════════════
--          AUTO RANDOM FRUIT (Sea 2+ mỗi 2 phút)
-- ══════════════════════════════════════════════════════════════════

local RandomFruitPrices = {
    [1] = 38000,      -- Sea 1 (không tự động random)
    [2] = 100000,     -- Sea 2
    [3] = 250000,     -- Sea 3
}

local function AutoRandomFruit()
    local sea = GetSea()

    -- Chỉ auto random ở Sea 2 trở lên
    if sea < 2 then return false end

    local price = RandomFruitPrices[sea] or 100000
    local beli = GetBeli()
    local now = os.time()

    -- Check cooldown (mỗi 2 phút random 1 lần)
    if now - _G.State.LastRandomFruit < _G.Settings.RandomFruitInterval then
        return false
    end

    -- Check đủ tiền
    if beli >= price then
        _G.BobonStatus = "Auto Random Fruit..."

        pcall(function()
            -- Random fruit (không cần tele tới NPC)
            local result = CommF_:InvokeServer("Cousin", "Buy")

            if result then
                print("[BobonHub] Random Fruit success!")
                _G.State.LastRandomFruit = os.time()
                task.wait(2)

                -- Auto store fruit vừa random
                AutoStoreFruit()
            end
        end)

        return true
    end

    return false
end

-- Loop Auto Random Fruit (check mỗi 10 giây)
task.spawn(function()
    while task.wait(10) do
        pcall(function()
            AutoRandomFruit()
        end)
    end
end)

-- Loop Auto Store Fruit (check mỗi 30 giây)
task.spawn(function()
    while task.wait(30) do
        pcall(function()
            AutoStoreFruit()
        end)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--                      BACKGROUND SYSTEMS
-- ══════════════════════════════════════════════════════════════════

-- Anti AFK
LP.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton2(Vector2.new())
end)

-- Noclip
RunService.Stepped:Connect(function()
    pcall(function()
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end)
end)

-- Hitbox expander
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            for _, tool in pairs(LP.Character:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                    tool.Handle.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize)
                    tool.Handle.Transparency = 1
                    tool.Handle.CanCollide = false
                end
            end
        end)
    end
end)

-- Auto Stats: 70% Melee, 30% Defense
task.spawn(function()
    while task.wait(3) do
        pcall(function()
            local data = LP:FindFirstChild("Data")
            if not data then return end

            local points = data:FindFirstChild("Points") and data.Points.Value or 0

            if points > 0 then
                local meleePoints = math.floor(points * 0.7)
                local defensePoints = math.floor(points * 0.3)

                if meleePoints > 0 then
                    CommF_:InvokeServer("AddPoint", "Melee", meleePoints)
                end

                if defensePoints > 0 then
                    CommF_:InvokeServer("AddPoint", "Defense", defensePoints)
                end
            end
        end)
    end
end)

-- Auto Haki & Team
task.spawn(function()
    task.wait(2)
    pcall(function()
        CommF_:InvokeServer("SetTeam", "Pirates")
    end)

    task.wait(1)

    while task.wait(30) do
        pcall(function()
            CommF_:InvokeServer("Ken", true)
            CommF_:InvokeServer("Buso", true)
        end)
    end
end)

-- Kill counter
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local enemies = workspace:FindFirstChild("Enemies")
            if not enemies then return end

            for _, mob in pairs(enemies:GetChildren()) do
                local hum = mob:FindFirstChild("Humanoid")
                if hum and not hum:GetAttribute("Tracked") then
                    hum:SetAttribute("Tracked", true)
                    hum.HealthChanged:Connect(function(health)
                        if health <= 0 then
                            _G.State.KillCount = _G.State.KillCount + 1
                        end
                    end)
                end
            end
        end)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--                      AUTO QUEST ITEMS
-- ══════════════════════════════════════════════════════════════════

-- AUTO SABER
local function AutoSaber()
    if HasItem("Saber") then return false end
    if GetLevel() < 200 then return false end
    if GetSea() ~= 1 then return false end

    _G.BobonStatus = "Auto Saber Quest"

    pcall(function()
        local torches = {
            {Name = "Torch1", Pos = CFrame.new(-1610, 11, 163)},
            {Name = "Torch2", Pos = CFrame.new(1114, 4, 4350)},
            {Name = "Torch3", Pos = CFrame.new(1400, 101, -1250)},
            {Name = "Torch4", Pos = CFrame.new(-5070, 23, 4325)},
            {Name = "Torch5", Pos = CFrame.new(-1675, 7, -2985)},
        }

        for _, torch in ipairs(torches) do
            Tween(torch.Pos)
            task.wait(1)
            CommF_:InvokeServer("Torch", torch.Name)
            task.wait(0.5)
        end

        _G.BobonStatus = "Saber: Fighting Boss..."

        while not HasItem("Saber") do
            local boss = FindBoss("Saber Expert")

            if boss then
                EquipMelee()
                Tween(CFrame.new(boss.HumanoidRootPart.Position.X, boss.HumanoidRootPart.Position.Y + _G.Settings.FarmHeight, boss.HumanoidRootPart.Position.Z))
                Attack()
            else
                Tween(CFrame.new(-1405, 30, -3330))
                task.wait(3)
            end

            task.wait(0.1)
        end
    end)

    return true
end

-- AUTO POLE V1
local function AutoPoleV1()
    if HasItem("Pole (1st Form)") then return false end
    if GetLevel() < 150 then return false end
    if GetSea() ~= 1 then return false end

    _G.BobonStatus = "Auto Pole v1"

    pcall(function()
        Tween(CFrame.new(-7748, 5606, -2305))
        task.wait(1)
        CommF_:InvokeServer("BuyPoleV1")
    end)

    return true
end

-- AUTO SECOND SEA
local function AutoSecondSea()
    if GetSea() >= 2 then return false end
    if GetLevel() < 700 then return false end

    _G.BobonStatus = "Auto Second Sea Quest"

    pcall(function()
        Tween(CFrame.new(-4909, 4, 4450))
        task.wait(1)
        CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
        task.wait(0.5)

        Tween(CFrame.new(932, 13, 4482))
        task.wait(1)
        CommF_:InvokeServer("DressrosaQuestProgress", "Bartilo")
        task.wait(0.5)

        _G.BobonStatus = "Second Sea: Kill 50 Swans..."
        local kills = 0

        while kills < 50 do
            local mob = FindMob("Swan Pirate")

            if mob then
                EquipMelee()
                Tween(CFrame.new(mob.HumanoidRootPart.Position.X, mob.HumanoidRootPart.Position.Y + _G.Settings.FarmHeight, mob.HumanoidRootPart.Position.Z))
                Attack()

                if mob.Humanoid.Health <= 0 then
                    kills = kills + 1
                end
            else
                Tween(CFrame.new(878, 122, 1235))
                task.wait(2)
            end

            task.wait(0.1)
        end

        Tween(CFrame.new(932, 13, 4482))
        task.wait(1)
        CommF_:InvokeServer("DressrosaQuestProgress", "Bartilo")
        task.wait(0.5)

        Tween(CFrame.new(-12471, 374, -7551))
        task.wait(1)
        CommF_:InvokeServer("DressrosaQuestProgress", "Door")
        task.wait(1)

        TeleportService:Teleport(4442272183, LP)
    end)

    return true
end

-- AUTO THIRD SEA
local function AutoThirdSea()
    if GetSea() >= 3 then return false end
    if GetSea() < 2 then return false end
    if GetLevel() < 1500 then return false end

    _G.BobonStatus = "Auto Third Sea Quest"

    pcall(function()
        Tween(CFrame.new(-285, 306, 611))
        task.wait(1)
        CommF_:InvokeServer("ZQuestProgress", "Check")
        task.wait(0.5)

        _G.BobonStatus = "Third Sea: Fighting Don Swan..."

        while true do
            local boss = FindBoss("Don Swan")

            if boss then
                EquipMelee()
                Tween(CFrame.new(boss.HumanoidRootPart.Position.X, boss.HumanoidRootPart.Position.Y + _G.Settings.FarmHeight, boss.HumanoidRootPart.Position.Z))
                Attack()
            else
                break
            end

            task.wait(0.1)
        end

        task.wait(2)

        Tween(CFrame.new(-285, 306, 611))
        task.wait(1)
        CommF_:InvokeServer("ZQuestProgress", "Begin")
        task.wait(1)

        TeleportService:Teleport(7449423635, LP)
    end)

    return true
end

-- AUTO FIGHTING STYLES
local function AutoBuyFightingStyles()
    local level = GetLevel()
    local sea = GetSea()

    if level >= 150 and sea == 1 then
        pcall(function()
            Tween(CFrame.new(-4800, 7, 4000))
            task.wait(1)
            CommF_:InvokeServer("BuyBlackLeg")
        end)
    end

    if level >= 150 and sea == 1 then
        pcall(function()
            Tween(CFrame.new(-5400, 15, -2900))
            task.wait(1)
            CommF_:InvokeServer("BuyElectro")
        end)
    end

    if level >= 150 and sea == 1 then
        pcall(function()
            Tween(CFrame.new(61200, 18, 1500))
            task.wait(1)
            CommF_:InvokeServer("BuyFishmanKarate")
        end)
    end

    if level >= 1500 and sea >= 2 then
        pcall(function()
            Tween(CFrame.new(528, 400, -2700))
            task.wait(1)
            CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
        end)
    end

    if level >= 300 then
        pcall(function()
            Tween(CFrame.new(-5420, 7, -2800))
            task.wait(1)
            CommF_:InvokeServer("BuySuperhuman")
        end)
    end
end

-- ══════════════════════════════════════════════════════════════════
--                      QUEST DATABASE
-- ══════════════════════════════════════════════════════════════════
local QuestDB = {
    -- SEA 1
    {Min=1,    Max=9,    Q="BanditQuest1",  M="Bandit",         QL=1, QC=CFrame.new(1059,17,1550),   MC=CFrame.new(1145,17,1634)},
    {Min=10,   Max=14,   Q="BanditQuest1",  M="Bandit",         QL=1, QC=CFrame.new(1059,17,1550),   MC=CFrame.new(1145,17,1634)},
    {Min=15,   Max=29,   Q="JungleQuest",   M="Monkey",         QL=1, QC=CFrame.new(-1598,37,153),   MC=CFrame.new(-1448,50,24)},
    {Min=30,   Max=39,   Q="BuggyQuest1",   M="Pirate",         QL=1, QC=CFrame.new(-1141,4,3832),   MC=CFrame.new(-1103,14,3836)},
    {Min=40,   Max=59,   Q="BuggyQuest1",   M="Brute",          QL=2, QC=CFrame.new(-1141,4,3832),   MC=CFrame.new(-1140,15,4314)},
    {Min=60,   Max=74,   Q="DesertQuest",   M="Desert Bandit",  QL=1, QC=CFrame.new(894,6,4392),     MC=CFrame.new(932,6,4488)},
    {Min=75,   Max=89,   Q="DesertQuest",   M="Desert Officer", QL=2, QC=CFrame.new(894,6,4392),     MC=CFrame.new(1608,7,4371)},
    {Min=90,   Max=99,   Q="SnowQuest",     M="Snow Bandit",    QL=1, QC=CFrame.new(1389,87,-1299),  MC=CFrame.new(1317,87,-1318)},
    {Min=100,  Max=119,  Q="SnowQuest",     M="Snowman",        QL=2, QC=CFrame.new(1389,87,-1299),  MC=CFrame.new(1198,87,-1370)},
    {Min=120,  Max=149,  Q="MarineQuest2",  M="Chief Petty Officer", QL=1, QC=CFrame.new(-5040,29,4325), MC=CFrame.new(-4881,22,4273)},
    {Min=150,  Max=174,  Q="MarineQuest2",  M="Sky Bandit",     QL=2, QC=CFrame.new(-5040,29,4325),  MC=CFrame.new(-4953,295,3951)},
    {Min=175,  Max=189,  Q="PrisonerQuest", M="Prisoner",       QL=1, QC=CFrame.new(5309,0,475),     MC=CFrame.new(5411,0,485)},
    {Min=190,  Max=209,  Q="PrisonerQuest", M="Dangerous Prisoner", QL=2, QC=CFrame.new(5309,0,475), MC=CFrame.new(5654,0,755)},
    {Min=210,  Max=249,  Q="ColosseumQuest", M="Toga Warrior",  QL=1, QC=CFrame.new(-1580,7,-2986),  MC=CFrame.new(-1824,7,-2743)},
    {Min=250,  Max=274,  Q="ColosseumQuest", M="Gladiator",     QL=2, QC=CFrame.new(-1580,7,-2986),  MC=CFrame.new(-1292,7,-3229)},
    {Min=275,  Max=299,  Q="MagmaQuest",    M="Military Soldier", QL=1, QC=CFrame.new(-5313,11,8515), MC=CFrame.new(-5408,11,8450)},
    {Min=300,  Max=324,  Q="MagmaQuest",    M="Military Spy",   QL=2, QC=CFrame.new(-5313,11,8515),  MC=CFrame.new(-5802,86,8255)},
    {Min=325,  Max=374,  Q="FishmanQuest",  M="Fishman Warrior", QL=1, QC=CFrame.new(61123,19,1569), MC=CFrame.new(60946,18,1504)},
    {Min=375,  Max=399,  Q="FishmanQuest",  M="Fishman Commando", QL=2, QC=CFrame.new(61123,19,1569), MC=CFrame.new(61798,18,1489)},
    {Min=400,  Max=449,  Q="SkyExp1Quest",  M="God's Guard",    QL=1, QC=CFrame.new(-4722,845,-1912), MC=CFrame.new(-4628,845,-1932)},
    {Min=450,  Max=474,  Q="SkyExp1Quest",  M="Shanda",         QL=2, QC=CFrame.new(-7859,5544,381),  MC=CFrame.new(-7685,5567,387)},
    {Min=475,  Max=524,  Q="SkyExp2Quest",  M="Royal Squad",    QL=1, QC=CFrame.new(-7907,5635,-1412), MC=CFrame.new(-7564,5608,-1442)},
    {Min=525,  Max=549,  Q="SkyExp2Quest",  M="Royal Soldier",  QL=2, QC=CFrame.new(-7907,5635,-1412), MC=CFrame.new(-7836,5606,-1810)},
    {Min=550,  Max=624,  Q="FountainQuest", M="Galley Pirate",  QL=1, QC=CFrame.new(5260,38,4050),   MC=CFrame.new(5551,42,3946)},
    {Min=625,  Max=649,  Q="FountainQuest", M="Galley Captain", QL=2, QC=CFrame.new(5260,38,4050),   MC=CFrame.new(5441,42,5656)},
    {Min=650,  Max=699,  Q="ZombieQuest",   M="Zombie",         QL=1, QC=CFrame.new(-5497,49,-795),   MC=CFrame.new(-5739,49,-795)},

    -- SEA 2
    {Min=700,  Max=724,  Q="Area1Quest",    M="Raider",         QL=1, QC=CFrame.new(-430,73,1837),    MC=CFrame.new(-746,40,2507)},
    {Min=725,  Max=774,  Q="Area1Quest",    M="Mercenary",      QL=2, QC=CFrame.new(-430,73,1837),    MC=CFrame.new(-874,141,1312)},
    {Min=775,  Max=799,  Q="Area2Quest",    M="Swan Pirate",    QL=1, QC=CFrame.new(638,72,918),      MC=CFrame.new(878,122,1235)},
    {Min=800,  Max=874,  Q="Area2Quest",    M="Factory Staff",  QL=2, QC=CFrame.new(638,72,918),      MC=CFrame.new(295,73,-56)},
    {Min=875,  Max=899,  Q="MarineQuest3",  M="Marine Lieutenant", QL=1, QC=CFrame.new(-2441,72,-3216), MC=CFrame.new(-2842,73,-2901)},
    {Min=900,  Max=949,  Q="MarineQuest3",  M="Marine Captain", QL=2, QC=CFrame.new(-2441,72,-3216),  MC=CFrame.new(-1814,73,-3208)},
    {Min=950,  Max=974,  Q="PiratePortQuest", M="Zombie",       QL=1, QC=CFrame.new(-6567,7,-428),    MC=CFrame.new(-5736,126,-686)},
    {Min=975,  Max=999,  Q="PiratePortQuest", M="Vampire",      QL=2, QC=CFrame.new(-6567,7,-428),    MC=CFrame.new(-6033,6,-1313)},
    {Min=1000, Max=1049, Q="SnowMountainQuest", M="Snow Trooper", QL=1, QC=CFrame.new(610,400,-5372), MC=CFrame.new(621,401,-5329)},
    {Min=1050, Max=1099, Q="SnowMountainQuest", M="Winter Warrior", QL=2, QC=CFrame.new(610,400,-5372), MC=CFrame.new(1295,429,-5087)},
    {Min=1100, Max=1124, Q="IceSideQuest",  M="Lab Subordinate", QL=1, QC=CFrame.new(5827,16,-6420), MC=CFrame.new(6109,16,-6178)},
    {Min=1125, Max=1174, Q="IceSideQuest",  M="Horned Warrior", QL=2, QC=CFrame.new(5827,16,-6420),  MC=CFrame.new(6341,16,-6723)},
    {Min=1175, Max=1199, Q="ShipQuest1",    M="Living Zombie",  QL=1, QC=CFrame.new(1038,126,32911),  MC=CFrame.new(942,125,32853)},
    {Min=1200, Max=1249, Q="ShipQuest1",    M="Demonic Soul",   QL=2, QC=CFrame.new(1038,126,32911),  MC=CFrame.new(1082,126,33098)},
    {Min=1250, Max=1274, Q="ShipQuest2",    M="Posessed Mummy", QL=1, QC=CFrame.new(921,126,33001),   MC=CFrame.new(389,41,32474)},
    {Min=1275, Max=1299, Q="ShipQuest2",    M="Peanut Scout",   QL=2, QC=CFrame.new(921,126,33001),   MC=CFrame.new(-2103,38,-10192)},
    {Min=1300, Max=1324, Q="FrostQuest",    M="Sea Soldier",    QL=1, QC=CFrame.new(5259,24,-6178),   MC=CFrame.new(5411,16,-6181)},
    {Min=1325, Max=1349, Q="FrostQuest",    M="Arctic Warrior", QL=2, QC=CFrame.new(5259,24,-6178),   MC=CFrame.new(6041,29,-6235)},
    {Min=1350, Max=1374, Q="ForgottenQuest", M="Sea Soldier",   QL=1, QC=CFrame.new(-3054,237,-10145), MC=CFrame.new(-2917,237,-10468)},
    {Min=1375, Max=1424, Q="ForgottenQuest", M="Water Fighter", QL=2, QC=CFrame.new(-3054,237,-10145), MC=CFrame.new(-3385,239,-10542)},
    {Min=1425, Max=1449, Q="IceCastleQuest", M="Snow Lurker",   QL=1, QC=CFrame.new(5566,9,-6313),    MC=CFrame.new(5604,29,-6820)},
    {Min=1450, Max=1474, Q="IceCastleQuest", M="Arctic Warrior", QL=2, QC=CFrame.new(5566,9,-6313),   MC=CFrame.new(6129,29,-6235)},
    {Min=1475, Max=1499, Q="PiratePortQuest", M="Pirate Millionaire", QL=1, QC=CFrame.new(-290,44,5580), MC=CFrame.new(-435,44,5551)},

    -- SEA 3
    {Min=1500, Max=1524, Q="PiratePortQuest", M="Pirate Millionaire", QL=1, QC=CFrame.new(-290,44,5580), MC=CFrame.new(-435,44,5551)},
    {Min=1525, Max=1574, Q="PiratePortQuest", M="Pistol Billionaire", QL=2, QC=CFrame.new(-290,44,5580), MC=CFrame.new(-52,44,5584)},
    {Min=1575, Max=1599, Q="AmazonQuest",   M="Dragon Crew Warrior", QL=1, QC=CFrame.new(5833,52,-1101), MC=CFrame.new(6241,52,-1290)},
    {Min=1600, Max=1624, Q="AmazonQuest",   M="Dragon Crew Archer", QL=2, QC=CFrame.new(5833,52,-1101), MC=CFrame.new(6488,383,139)},
    {Min=1625, Max=1649, Q="AmazonQuest2",  M="Female Islander",     QL=1, QC=CFrame.new(5449,602,749), MC=CFrame.new(5217,845,1069)},
    {Min=1650, Max=1699, Q="AmazonQuest2",  M="Giant Islander",      QL=2, QC=CFrame.new(5449,602,749), MC=CFrame.new(4729,657,-55)},
    {Min=1700, Max=1724, Q="MarineTreeIsland", M="Marine Commodore", QL=1, QC=CFrame.new(2181,28,-6742), MC=CFrame.new(2490,73,-7144)},
    {Min=1725, Max=1774, Q="MarineTreeIsland", M="Marine Rear Admiral", QL=2, QC=CFrame.new(2181,28,-6742), MC=CFrame.new(3671,401,-6982)},
    {Min=1775, Max=1799, Q="DeepForestIsland", M="Mythological Pirate", QL=1, QC=CFrame.new(-13234,332,-7625), MC=CFrame.new(-13478,470,-6985)},
    {Min=1800, Max=1849, Q="DeepForestIsland2", M="Jungle Pirate",     QL=1, QC=CFrame.new(-12680,390,-9903), MC=CFrame.new(-12107,332,-10549)},
    {Min=1850, Max=1899, Q="DeepForestIsland3", M="Forest Pirate",     QL=1, QC=CFrame.new(-13258,332,-7924), MC=CFrame.new(-13225,425,-7755)},
    {Min=1900, Max=1924, Q="PeanutIslandQuest", M="Peanut Scout",      QL=1, QC=CFrame.new(-2104,38,-10193), MC=CFrame.new(-2124,123,-10354)},
    {Min=1925, Max=1974, Q="PeanutIslandQuest", M="Peanut President",  QL=2, QC=CFrame.new(-2104,38,-10193), MC=CFrame.new(-1859,38,-10238)},
    {Min=1975, Max=1999, Q="IceCreamIslandQuest", M="Ice Cream Chef",  QL=1, QC=CFrame.new(-821,66,-10965), MC=CFrame.new(-641,210,-11077)},
    {Min=2000, Max=2024, Q="IceCreamIslandQuest", M="Ice Cream Commander", QL=2, QC=CFrame.new(-821,66,-10965), MC=CFrame.new(-558,115,-11253)},
    {Min=2025, Max=2049, Q="CakeQuest1",    M="Cookie Crafter",      QL=1, QC=CFrame.new(-2021,38,-12029), MC=CFrame.new(-2365,38,-12099)},
    {Min=2050, Max=2074, Q="CakeQuest1",    M="Cake Guard",          QL=2, QC=CFrame.new(-2021,38,-12029), MC=CFrame.new(-1651,38,-12308)},
    {Min=2075, Max=2099, Q="CakeQuest2",    M="Baking Staff",        QL=1, QC=CFrame.new(-1928,38,-12843), MC=CFrame.new(-1980,38,-12850)},
    {Min=2100, Max=2124, Q="CakeQuest2",    M="Head Baker",          QL=2, QC=CFrame.new(-1928,38,-12843), MC=CFrame.new(-2203,109,-12788)},
    {Min=2125, Max=2149, Q="ChocQuest1",    M="Cocoa Warrior",       QL=1, QC=CFrame.new(233,25,-12201), MC=CFrame.new(167,73,-12238)},
    {Min=2150, Max=2199, Q="ChocQuest1",    M="Chocolate Bar Battler", QL=2, QC=CFrame.new(233,25,-12201), MC=CFrame.new(618,25,-12585)},
    {Min=2200, Max=2224, Q="ChocQuest2",    M="Sweet Thief",         QL=1, QC=CFrame.new(151,25,-12775), MC=CFrame.new(-102,25,-12804)},
    {Min=2225, Max=2274, Q="ChocQuest2",    M="Candy Rebel",         QL=2, QC=CFrame.new(151,25,-12775), MC=CFrame.new(134,77,-12882)},
    {Min=2275, Max=2299, Q="HauntedQuest1", M="Haunted Specter",     QL=1, QC=CFrame.new(-9479,141,5566), MC=CFrame.new(-9631,142,5499)},
    {Min=2300, Max=2324, Q="HauntedQuest2", M="Reborn Skeleton",     QL=1, QC=CFrame.new(-9517,172,6078), MC=CFrame.new(-8760,142,6016)},
    {Min=2325, Max=2349, Q="HauntedQuest2", M="Living Zombie",       QL=2, QC=CFrame.new(-9517,172,6078), MC=CFrame.new(-10144,140,5932)},
    {Min=2350, Max=2374, Q="HauntedQuest3", M="Demonic Soul",        QL=1, QC=CFrame.new(-9481,172,6079), MC=CFrame.new(-9712,204,6193)},
    {Min=2375, Max=2399, Q="HauntedQuest3", M="Posessed Mummy",      QL=2, QC=CFrame.new(-9481,172,6079), MC=CFrame.new(-9583,6,6233)},
    {Min=2400, Max=2424, Q="NutsIslandQuest", M="Peanut Scout",      QL=1, QC=CFrame.new(-2104,38,-10193), MC=CFrame.new(-2124,123,-10354)},
    {Min=2425, Max=2449, Q="NutsIslandQuest", M="Peanut President",  QL=2, QC=CFrame.new(-2104,38,-10193), MC=CFrame.new(-1859,38,-10238)},
    {Min=2450, Max=2474, Q="TikiOutpost1",  M="Isle Outlaw",         QL=1, QC=CFrame.new(-16547,56,1052), MC=CFrame.new(-16342,58,1032)},
    {Min=2475, Max=2524, Q="TikiOutpost2",  M="Island Boy",          QL=1, QC=CFrame.new(-16542,56,1044), MC=CFrame.new(-16912,58,835)},
    {Min=2525, Max=2549, Q="TikiOutpost3",  M="Sun-kissed Warrior",  QL=1, QC=CFrame.new(-16542,56,1041), MC=CFrame.new(-16348,58,461)},
    {Min=2550, Max=2800, Q="TikiOutpost4",  M="Isle Champion",       QL=1, QC=CFrame.new(-16540,56,1044), MC=CFrame.new(-16753,58,1043)},
}

local function GetQuest()
    local level = GetLevel()
    for _, q in ipairs(QuestDB) do
        if level >= q.Min and level <= q.Max then
            return q
        end
    end
    return nil
end

-- ══════════════════════════════════════════════════════════════════
--                      MAIN FARM LOOP
-- ══════════════════════════════════════════════════════════════════

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local level = GetLevel()

            -- Priority 1: Auto Saber
            if level >= 200 and level < 700 and GetSea() == 1 and not HasItem("Saber") then
                if AutoSaber() then return end
            end

            -- Priority 2: Auto Pole v1
            if level >= 150 and level < 700 and GetSea() == 1 and not HasItem("Pole (1st Form)") then
                if AutoPoleV1() then return end
            end

            -- Priority 3: Auto Second Sea
            if level >= 700 and GetSea() == 1 then
                if AutoSecondSea() then return end
            end

            -- Priority 4: Auto Third Sea
            if level >= 1500 and GetSea() == 2 then
                if AutoThirdSea() then return end
            end

            -- Priority 5: Auto Fighting Styles
            if level >= 150 and level < 700 then
                AutoBuyFightingStyles()
            end

            -- Main Quest Farm
            local c = LP.Character
            if not c or not c:FindFirstChild("HumanoidRootPart") then return end

            local qData = GetQuest()
            if not qData then
                _G.BobonStatus = "Level out of range!"
                return
            end

            if not HasQuest() then
                local now = os.time()
                if now - _G.State.LastQuest < _G.Settings.QuestCooldown then
                    _G.BobonStatus = "Quest cooldown..."
                    return
                end

                _G.BobonStatus = "Taking quest: " .. qData.M
                Tween(qData.QC)
                task.wait(0.8)
                CommF_:InvokeServer("StartQuest", qData.Q, qData.QL)
                _G.State.LastQuest = os.time()
                task.wait(0.5)

                Tween(CFrame.new(qData.MC.Position.X, qData.MC.Position.Y + _G.Settings.FarmHeight, qData.MC.Position.Z))
                return
            end

            local mob = FindMob(qData.M)
            if mob then
                _G.State.CurrentTarget = mob
                _G.BobonStatus = "Farming: " .. qData.M .. " | Kills: " .. _G.State.KillCount
                Tween(CFrame.new(mob.HumanoidRootPart.Position.X, mob.HumanoidRootPart.Position.Y + _G.Settings.FarmHeight, mob.HumanoidRootPart.Position.Z))
            else
                _G.State.CurrentTarget = nil
                _G.BobonStatus = "Waiting: " .. qData.M
                Tween(CFrame.new(qData.MC.Position.X, qData.MC.Position.Y + _G.Settings.FarmHeight, qData.MC.Position.Z))
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

print("[BobonHub v10.0] Loaded! Auto Farm + Random Fruit + Store Fruit")
_G.BobonStatus = "BobonHub v10.0 Ready!"
