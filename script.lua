-- ================================================================= --
--               BOBON HUB - ULTIMATE FIX TELE & HAKI                --
-- ================================================================= --

getgenv().Configs = {
    ["Auto Collect Berry"] = true,
    ["Team"] = "Pirates",
}

repeat task.wait(1) until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

-- 1. TỰ ĐỘNG CHỌN PHE (ĐỜI KHỎI BỊ LỖI TELE SPAWN)
task.spawn(function()
    pcall(function()
        if LocalPlayer.Team == nil or LocalPlayer.Team.Name == "" then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", getgenv().Configs["Team"] or "Pirates")
            task.wait(2)
        end
    end)
end)

-- 2. CHỐNG AFK & NOCLIP
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

-- 3. HÀM TWEEN CHỐNG BỊ TELE NGƯỢC
local currentTween = nil
local function FastTween(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    if hrp and humanoid and humanoid.Health > 0 then
        local distance = (targetCFrame.Position - hrp.Position).Magnitude
        
        -- Reset gia tốc để không bị Rubberband (kéo ngược)
        hrp.Velocity = Vector3.new(0, 0, 0)
        
        if distance > 15 then
            local speed = 250 -- Giảm tốc độ xuống 250 để lọt qua Anti-Cheat
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

-- 4. BẬT HAKI RIÊNG BẬC CAO (CHẮC CHẮN KHÔNG SPAM BẬT/TẮT)
task.spawn(function()
    while task.wait(8) do -- 8 Giây mới kiểm tra 1 lần
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                -- Bật Buso (Haki Vũ Trang)
                if not char:FindFirstChild("HasBuso") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                    task.wait(1)
                end
                
                -- Bật Ken (Haki Quan Sát)
                if not char:FindFirstChild("Vision") then
                    ReplicatedStorage.Remotes.CommE:FireServer("Ken", true)
                end
            end
        end)
    end
end)

-- 5. HÀM TRANG BỊ MELEE (ÉP CẦM VÕ CHUẨN XÁC)
local function ForceEquipMelee()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    
    -- Kiểm tra xem tay đã cầm chưa
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool:FindFirstChild("Combat") or tool:FindFirstChild("Melee")) then
            return -- Đã cầm sẵn võ trên tay
        end
    end

    -- Tìm trong Balo để cầm ra
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            -- Kiểm tra tất cả các loại Võ trong game
            if tool.ToolTip == "Melee" 
               or tool:FindFirstChild("Combat") 
               or tool:FindFirstChild("Melee") 
               or tool.Name == "Combat" 
               or tool.Name == "Superhuman" 
               or tool.Name == "Godhuman" 
               or tool.Name == "Dragon Talon" 
               or tool.Name == "Electric Claw" 
               or tool.Name == "Death Step" 
               or tool.Name == "Sharkman Karate" 
               or tool.Name == "Sanguine Art"
               or tool.Name == "Black Leg"
               or tool.Name == "Electro"
               or tool.Name == "Fishman Karate"
               or tool.Name == "Dragon Claw" then
               
                char.Humanoid:EquipTool(tool)
                break
            end
        end
    end
end

-- 6. DANH SÁCH QUEST FARM
local QuestDatabase = {
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
    {MinLvl = 700, MaxLvl = 724, Quest = "Area1Quest", Monster = "Raider", QuestLvl = 1, CFrame = CFrame.new(-425, 73, 1836)},
    {MinLvl = 725, MaxLvl = 774, Quest = "Area2Quest", Monster = "Mercenary", QuestLvl = 1, CFrame = CFrame.new(-860, 140, 1315)},
    {MinLvl = 775, MaxLvl = 874, Quest = "SwanQuest", Monster = "Swan Pirate", QuestLvl = 1, CFrame = CFrame.new(878, 122, 1235)},
    {MinLvl = 875, MaxLvl = 999, Quest = "ZombieQuest", Monster = "Zombie", QuestLvl = 1, CFrame = CFrame.new(-5620, 80, -720)},
    {MinLvl = 1000, MaxLvl = 1124, Quest = "SnowMountainQuest", Monster = "Snow Trooper", QuestLvl = 1, CFrame = CFrame.new(600, 400, -5300)},
    {MinLvl = 1125, MaxLvl = 1249, Quest = "IceSideQuest", Monster = "Arctic Warrior", QuestLvl = 1, CFrame = CFrame.new(6100, 28, -6200)},
    {MinLvl = 1250, MaxLvl = 1349, Quest = "ShipQuest1", Monster = "Ship Deckhand", QuestLvl = 1, CFrame = CFrame.new(1030, 125, 32900)},
    {MinLvl = 1350, MaxLvl = 1424, Quest = "FrostQuest", Monster = "Snow Lurker", QuestLvl = 1, CFrame = CFrame.new(5560, 28, -6800)},
    {MinLvl = 1425, MaxLvl = 1499, Quest = "WaterTigerQuest", Monster = "Water Fighter", QuestLvl = 1, CFrame = CFrame.new(2880, 6, -9200)},
    {MinLvl = 1500, MaxLvl = 1574, Quest = "PiratePortQuest", Monster = "Pirate Millionaire", QuestLvl = 1, CFrame = CFrame.new(-290, 44, 5580)},
    {MinLvl = 1575, MaxLvl = 1699, Quest = "AmazonQuest", Monster = "Female Islander", QuestLvl = 1, CFrame = CFrame.new(5830, 50, -300)},
    {MinLvl = 1700, MaxLvl = 1824, Quest = "MarineTreeQuest", Monster = "Marine Commodore", QuestLvl = 1, CFrame = CFrame.new(2180, 28, -6740)},
    {MinLvl = 1825, MaxLvl = 1974, Quest = "DeepForestIsland1Quest", Monster = "Forest Pirate", QuestLvl = 1, CFrame = CFrame.new(-13230, 330, -7630)},
    {MinLvl = 1975, MaxLvl = 2074, Quest = "HauntedQuest1", Monster = "Reborn Skeleton", QuestLvl = 1, CFrame = CFrame.new(-9480, 140, 5530)},
    {MinLvl = 2075, MaxLvl = 2224, Quest = "NutsIslandQuest", Monster = "Peanut Scout", QuestLvl = 1, CFrame = CFrame.new(-2100, 38, -10190)},
    {MinLvl = 2225, MaxLvl = 2449, Quest = "IceCreamIslandQuest", Monster = "Ice Cream Chef", QuestLvl = 1, CFrame = CFrame.new(700, 50, -11000)},
    {MinLvl = 2450, MaxLvl = 2524, Quest = "CandyQuest1", Monster = "Isle Outlaw", QuestLvl = 1, CFrame = CFrame.new(-2110, 38, -12140)},
    {MinLvl = 2525, MaxLvl = 2800, Quest = "TikiQuest1", Monster = "Isle Champion", QuestLvl = 1, CFrame = CFrame.new(-16200, 10, 450)}
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

-- 7. VÒNG LẶP AUTO FARM SẠCH
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            -- Auto Cộng Stats Melee / Defense
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
                    -- Di chuyển nhận Quest
                    FastTween(qData.CFrame)
                    if (LocalPlayer.Character.HumanoidRootPart.Position - qData.CFrame.Position).Magnitude < 15 then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", qData.Quest, qData.QuestLvl)
                    end
                else
                    -- Tìm Quái
                    local enemy = nil
                    if workspace:FindFirstChild("Enemies") then
                        for _, v in ipairs(workspace.Enemies:GetChildren()) do
                            if v.Name == qData.Monster and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                enemy = v
                                break
                            end
                        end
                    end

                    if enemy then
                        -- Tự động cầm Melee trước khi tới đánh
                        ForceEquipMelee()
                        
                        -- Tween Đứng phía trên đầu quái 7 stud (An toàn & Đánh trúng)
                        FastTween(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0))
                        
                        -- Tự đấm
                        VirtualUser:Button1Down(Vector2.new(0,0))
                    else
                        -- Bay tới bãi quái chờ spawn
                        FastTween(qData.CFrame * CFrame.new(0, 15, 0))
                    end
                end
            end
        end)
    end
end)

print("[BOBON HUB] Fixed Teleport Bug & Weapon Equip Fully Functional!")
