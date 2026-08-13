-- ================================================================= --
--         BOBON HUB - BRING MOB & DISTANCE FARM (NO FAST ATTACK)    --
-- ================================================================= --

getgenv().Configs = {
    ["Auto Collect Berry"] = true,
    ["Team"] = "Pirates",
    ["Farm Distance"] = 10, -- Khoảng cách đứng xa đánh quái (Safety Range)
}

repeat task.wait(1) until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

-- 1. DANH SÁCH VÕ (MELEE) FULL
local AllMelees = {
    "Combat", "Black Leg", "Electro", "Fishman Karate", "Dragon Claw",
    "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw",
    "Dragon Talon", "Godhuman", "Sanguine Art"
}

-- 2. TỰ ĐỘNG CHỌN PHE
task.spawn(function()
    pcall(function()
        if LocalPlayer.Team == nil or LocalPlayer.Team.Name == "" then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", getgenv().Configs["Team"] or "Pirates")
            task.wait(2)
        end
    end)
end)

-- 3. CHỐNG AFK & NOCLIP
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 4. SMART TWEEN ENGINE (KHÔNG TELE LẠI CHỖ CŨ)
local currentTween = nil
local lastTargetPos = Vector3.new(0,0,0)

local function FastTween(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    if hrp and humanoid and humanoid.Health > 0 then
        local distance = (targetCFrame.Position - hrp.Position).Magnitude
        
        if (targetCFrame.Position - lastTargetPos).Magnitude < 3 and currentTween then
            return
        end
        lastTargetPos = targetCFrame.Position

        hrp.Velocity = Vector3.new(0, 0, 0)
        
        if distance > 10 then
            local speed = 220
            local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
            
            if currentTween then currentTween:Cancel() end
            currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
            currentTween:Play()
        else
            if currentTween then currentTween:Cancel() end
            hrp.CFrame = targetCFrame
        end
    end
end

-- 5. AUTO HAKI VŨ TRANG & QUAN SÁT (8 SEC/LẦN)
task.spawn(function()
    while task.wait(8) do
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                if not char:FindFirstChild("HasBuso") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                    task.wait(0.5)
                end
                if not char:FindFirstChild("Vision") then
                    ReplicatedStorage.Remotes.CommE:FireServer("Ken", true)
                end
            end
        end)
    end
end)

-- 6. TỰ ĐỘNG CẦM MELEE THEO TÊN
local function ForceEquipMelee()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end

    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _, meleeName in ipairs(AllMelees) do
                if tool.Name == meleeName then
                    return
                end
            end
        end
    end

    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            for _, meleeName in ipairs(AllMelees) do
                if tool.Name == meleeName then
                    char.Humanoid:EquipTool(tool)
                    return
                end
            end
        end
    end
end

-- 7. CƠ CHẾ BRING MOB (GOM QUÁI LẠI 1 ĐIỂM DỄ ĐÁNH)
local function BringMob(monsterName, targetCFrame)
    if not workspace:FindFirstChild("Enemies") then return end
    
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        if enemy.Name == monsterName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
            -- Tắt CanCollide của quái để không đẩy nhân vật
            for _, part in ipairs(enemy:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            -- Kéo quái về vị trí gom
            local dist = (enemy.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
            if dist <= 300 then -- Chỉ gom quái trong phạm vi 300 stud
                enemy.HumanoidRootPart.CFrame = targetCFrame
                enemy.HumanoidRootPart.Size = Vector3.new(10, 10, 10) -- Mở rộng Hitbox nhẹ
                enemy.Humanoid.WalkSpeed = 0
            end
        end
    end
end

-- 8. DATABASE QUEST
local QuestDatabase = {
    {MinLvl = 1, MaxLvl = 14, Quest = "BanditQuest1", Monster = "Bandit", QuestLvl = 1, QuestCFrame = CFrame.new(1059, 16, 1548), MonsterCFrame = CFrame.new(1145, 17, 1634)},
    {MinLvl = 15, MaxLvl = 29, Quest = "JungleQuest", Monster = "Monkey", QuestLvl = 1, QuestCFrame = CFrame.new(-1598, 37, 152), MonsterCFrame = CFrame.new(-1618, 22, 142)},
    {MinLvl = 30, MaxLvl = 59, Quest = "JungleQuest", Monster = "Gorilla", QuestLvl = 2, QuestCFrame = CFrame.new(-1230, 6, -486), MonsterCFrame = CFrame.new(-1237, 6, -502)},
    {MinLvl = 60, MaxLvl = 89, Quest = "PirateQuest", Monster = "Pirate", QuestLvl = 1, QuestCFrame = CFrame.new(-1120, 4, 3850), MonsterCFrame = CFrame.new(-1200, 4, 3900)},
    {MinLvl = 90, MaxLvl = 119, Quest = "DesertQuest", Monster = "Desert Bandit", QuestLvl = 1, QuestCFrame = CFrame.new(890, 6, 4380), MonsterCFrame = CFrame.new(950, 6, 4400)},
    {MinLvl = 120, MaxLvl = 149, Quest = "MiddleQuest", Monster = "Sniper", QuestLvl = 1, QuestCFrame = CFrame.new(-1100, 4, 1500), MonsterCFrame = CFrame.new(-1150, 4, 1450)},
    {MinLvl = 150, MaxLvl = 189, Quest = "SkyQuest", Monster = "Sky Bandit", QuestLvl = 1, QuestCFrame = CFrame.new(-4850, 718, -2620), MonsterCFrame = CFrame.new(-4950, 718, -2630)},
    {MinLvl = 190, MaxLvl = 274, Quest = "PrisonQuest", Monster = "Prisoner", QuestLvl = 1, QuestCFrame = CFrame.new(530, 2, 480), MonsterCFrame = CFrame.new(480, 2, 530)},
    {MinLvl = 275, MaxLvl = 374, Quest = "ColosseumQuest", Monster = "Toga Warrior", QuestLvl = 1, QuestCFrame = CFrame.new(-1580, 7, -2980), MonsterCFrame = CFrame.new(-1640, 7, -2980)},
    {MinLvl = 375, MaxLvl = 449, Quest = "MagmaQuest", Monster = "Military Soldier", QuestLvl = 1, QuestCFrame = CFrame.new(-5250, 8, 8480), MonsterCFrame = CFrame.new(-5300, 8, 8530)},
    {MinLvl = 450, MaxLvl = 524, Quest = "FishmanQuest", Monster = "Fishman Warrior", QuestLvl = 1, QuestCFrame = CFrame.new(61120, 18, 1560), MonsterCFrame = CFrame.new(61000, 18, 1500)},
    {MinLvl = 525, MaxLvl = 624, Quest = "Sky2Quest", Monster = "God's Guard", QuestLvl = 1, QuestCFrame = CFrame.new(-7730, 5600, -1430), MonsterCFrame = CFrame.new(-7650, 5600, -1400)},
    {MinLvl = 625, MaxLvl = 699, Quest = "FountainQuest", Monster = "Cyborg", QuestLvl = 1, QuestCFrame = CFrame.new(5260, 38, 4050), MonsterCFrame = CFrame.new(5300, 38, 4000)},
    {MinLvl = 700, MaxLvl = 724, Quest = "Area1Quest", Monster = "Raider", QuestLvl = 1, QuestCFrame = CFrame.new(-425, 73, 1836), MonsterCFrame = CFrame.new(-500, 73, 1850)},
    {MinLvl = 725, MaxLvl = 774, Quest = "Area2Quest", Monster = "Mercenary", QuestLvl = 1, QuestCFrame = CFrame.new(-860, 140, 1315), MonsterCFrame = CFrame.new(-920, 140, 1350)},
    {MinLvl = 775, MaxLvl = 874, Quest = "SwanQuest", Monster = "Swan Pirate", QuestLvl = 1, QuestCFrame = CFrame.new(878, 122, 1235), MonsterCFrame = CFrame.new(930, 122, 1200)},
    {MinLvl = 875, MaxLvl = 999, Quest = "ZombieQuest", Monster = "Zombie", QuestLvl = 1, QuestCFrame = CFrame.new(-5620, 80, -720), MonsterCFrame = CFrame.new(-5650, 80, -700)},
    {MinLvl = 1000, MaxLvl = 1124, Quest = "SnowMountainQuest", Monster = "Snow Trooper", QuestLvl = 1, QuestCFrame = CFrame.new(600, 400, -5300), MonsterCFrame = CFrame.new(650, 400, -5300)},
    {MinLvl = 1125, MaxLvl = 1249, Quest = "IceSideQuest", Monster = "Arctic Warrior", QuestLvl = 1, QuestCFrame = CFrame.new(6100, 28, -6200), MonsterCFrame = CFrame.new(6150, 28, -6250)},
    {MinLvl = 1250, MaxLvl = 1349, Quest = "ShipQuest1", Monster = "Ship Deckhand", QuestLvl = 1, QuestCFrame = CFrame.new(1030, 125, 32900), MonsterCFrame = CFrame.new(1080, 125, 32950)},
    {MinLvl = 1350, MaxLvl = 1424, Quest = "FrostQuest", Monster = "Snow Lurker", QuestLvl = 1, QuestCFrame = CFrame.new(5560, 28, -6800), MonsterCFrame = CFrame.new(5600, 28, -6800)},
    {MinLvl = 1425, MaxLvl = 1499, Quest = "WaterTigerQuest", Monster = "Water Fighter", QuestLvl = 1, QuestCFrame = CFrame.new(2880, 6, -9200), MonsterCFrame = CFrame.new(2920, 6, -9250)},
    {MinLvl = 1500, MaxLvl = 1574, Quest = "PiratePortQuest", Monster = "Pirate Millionaire", QuestLvl = 1, QuestCFrame = CFrame.new(-290, 44, 5580), MonsterCFrame = CFrame.new(-350, 44, 5550)},
    {MinLvl = 1575, MaxLvl = 1699, Quest = "AmazonQuest", Monster = "Female Islander", QuestLvl = 1, QuestCFrame = CFrame.new(5830, 50, -300), MonsterCFrame = CFrame.new(5880, 50, -350)},
    {MinLvl = 1700, MaxLvl = 1824, Quest = "MarineTreeQuest", Monster = "Marine Commodore", QuestLvl = 1, QuestCFrame = CFrame.new(2180, 28, -6740), MonsterCFrame = CFrame.new(2230, 28, -6700)},
    {MinLvl = 1825, MaxLvl = 1974, Quest = "DeepForestIsland1Quest", Monster = "Forest Pirate", QuestLvl = 1, QuestCFrame = CFrame.new(-13230, 330, -7630), MonsterCFrame = CFrame.new(-13280, 330, -7600)},
    {MinLvl = 1975, MaxLvl = 2074, Quest = "HauntedQuest1", Monster = "Reborn Skeleton", QuestLvl = 1, QuestCFrame = CFrame.new(-9480, 140, 5530), MonsterCFrame = CFrame.new(-9530, 140, 5500)},
    {MinLvl = 2075, MaxLvl = 2224, Quest = "NutsIslandQuest", Monster = "Peanut Scout", QuestLvl = 1, QuestCFrame = CFrame.new(-2100, 38, -10190), MonsterCFrame = CFrame.new(-2150, 38, -10200)},
    {MinLvl = 2225, MaxLvl = 2449, Quest = "IceCreamIslandQuest", Monster = "Ice Cream Chef", QuestLvl = 1, QuestCFrame = CFrame.new(700, 50, -11000), MonsterCFrame = CFrame.new(750, 50, -11050)},
    {MinLvl = 2450, MaxLvl = 2524, Quest = "CandyQuest1", Monster = "Isle Outlaw", QuestLvl = 1, QuestCFrame = CFrame.new(-2110, 38, -12140), MonsterCFrame = CFrame.new(-2150, 38, -12100)},
    {MinLvl = 2525, MaxLvl = 2800, Quest = "TikiQuest1", Monster = "Isle Champion", QuestLvl = 1, QuestCFrame = CFrame.new(-16200, 10, 450), MonsterCFrame = CFrame.new(-16250, 10, 500)}
}

local function GetQuestData()
    local lvl = LocalPlayer.Data.Level.Value
    for _, q in ipairs(QuestDatabase) do
        if lvl >= q.MinLvl and lvl <= q.MaxLvl then
            return q
        end
    end
    return nil
end

-- 9. VÒNG LẶP FARM TỪ XA CHÍNH (SAFE DISTANCE ATTACK)
task.spawn(function()
    while task.wait(0.15) do
        pcall(function()
            -- Auto Stats
            local points = LocalPlayer.Data.Points.Value
            if points > 0 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", points)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", points)
            end

            local qData = GetQuestData()
            if qData then
                local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                local hasQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible

                if not hasQuest then
                    -- Bay đi nhận Quest
                    FastTween(qData.QuestCFrame)
                    if (LocalPlayer.Character.HumanoidRootPart.Position - qData.QuestCFrame.Position).Magnitude < 15 then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", qData.Quest, qData.QuestLvl)
                        task.wait(0.3)
                    end
                else
                    ForceEquipMelee()

                    -- Lấy con quái chính làm tâm gom
                    local mainMonster = nil
                    if workspace:FindFirstChild("Enemies") then
                        for _, v in ipairs(workspace.Enemies:GetChildren()) do
                            if v.Name == qData.Monster and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                                mainMonster = v
                                break
                            end
                        end
                    end

                    if mainMonster then
                        local mobPos = mainMonster.HumanoidRootPart.CFrame
                        
                        -- Gom tất cả quái xung quanh về vị trí con quái chính
                        BringMob(qData.Monster, mobPos)

                        -- Bay lơ lửng trên đầu quái một khoảng AN TOÀN (10 stud)
                        local safeFarmPos = mobPos * CFrame.new(0, getgenv().Configs["Farm Distance"], 0)
                        FastTween(safeFarmPos)

                        -- Đấm bình thường (Không dùng Fast Attack tránh crash/văng game)
                        VirtualUser:Button1Down(Vector2.new(0,0))
                        task.wait(0.1)
                        VirtualUser:Button1Up(Vector2.new(0,0))
                    else
                        -- Đứng chờ quái spawn ở khoảng cách cao an toàn
                        FastTween(qData.MonsterCFrame * CFrame.new(0, 15, 0))
                    end
                end
            end
        end)
    end
end)

print("[BOBON HUB] Distance Farm & Bring Mob Active (Anti-Crash/No Fast Attack)!")
