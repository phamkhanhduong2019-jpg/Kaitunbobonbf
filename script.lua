-- ================================================================= --
--         BOBON HUB - TWEEN MOVEMENT & AUTO OBSERVATION HAKI        --
-- ================================================================= --

getgenv().Configs = {
    ["Auto Collect Berry"] = true,
    ["Auto Evo Race"] = false, 
    ["Auto Pull Lever"] = false, 
    ["Auto Saber"] = true,
    ["Auto Spawn Dough King"] = true,
    ["Auto Spawn rip_indra"] = true,
    ["Awaken Fruit"] = true,
    ["Buy Stuffs"] = true, 
    ["Cursed Dual Katana"] = true,
    ["Eat Fruit"] = "", 
    
    ["FPS Boost"] = {
        ["Enable"] = true,
        ["FPS Cap"] = 30,
        ["Hide Game UI"] = false, 
        ["Disable 3D Render"] = false,
    },
    
    ["Farm Boss Drops"] = {
        ["Enable"] = true,
        ["When x2 Exp Expired"] = true,
    },
    
    ["Farm Config"] = {
        ["Farm Bone Get x2 Exp"] = {
            ["Enable"] = true,
            ["Level"] = 1500,
        },
        ["First Farm At Sky"] = true,
        ["Max Level"] = 2800,
    },
    
    ["Farm Mastery"] = {
        ["Enable"] = true,
        ["Farm Mastery Weapons"] = {"Melee"},
        ["Guns To Farm"] = {},
        ["Mastery Health (%)"] = 40,
        ["Swords To Farm"] = {},
    },
    
    ["Fruit to use for auto third sea"] = {"Buddha-Buddha", "Magma-Magma"}, 
    ["Get Fruits"] = true,
    
    ["Hop"] = {
        ["Enable"] = false, 
        ["Find Fruit"] = true,
        ["Hop Elite"] = true,
        ["Hop Find Darkbeard"] = true,
        ["Hop Find Mirage"] = true,
        ["Hop Find Mirror Fractal"] = true,
        ["Hop Find Soul Reaper"] = true,
        ["Hop Find Tushita"] = true,
        ["Hop Find Valkyrie Helm"] = true,
    },
    
    ["Hop Player Near"] = true,
    ["Lock Fragment"] = 25000,
    ["Rainbow Haki"] = true,
    ["Shutdown"] = false, 
    ["Skull Guitar"] = true,
    ["Snipe Fruit"] = "Dough-Dough",
    ["Switch Melee"] = true,
    ["Team"] = "Pirates",
}

-- ================================================================= --
--                    BOBON HUB CORE ENGINE LOGIC                    --
-- ================================================================= --

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

-- 1. CHỐNG AFK & CHỌN PHE
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

pcall(function()
    if getgenv().Configs["Team"] == "Pirates" then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
    else
        ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
    end
end)

-- 2. NOCLIP (TỰ ĐỘNG ĐI XUYÊN VẬT THỂ KHI TWEEN BAY)
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 3. HỆ THỐNG DI CHUYỂN TWEEN MƯỢT (TWEEN FLY ENGINE)
local currentTween = nil
local function FastTween(targetCFrame)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        if char.Humanoid.Health <= 0 then return end
        
        local hrp = char.HumanoidRootPart
        local distance = (targetCFrame.Position - hrp.Position).Magnitude
        
        -- Ngăn nghiêng người/rơi tự do khi đang Tween
        hrp.Velocity = Vector3.new(0, 0, 0)
        
        if distance > 10 then
            local speed = 300 -- Tốc độ bay Tween an toàn chuẩn Blox Fruits
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

-- 4. AUTO BẬT HAKI VŨ KHÍ (BUSO) & HAKI QUAN SÁT (OBSERVATION / KEN)
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                -- Bật Haki Vũ Khí (Buso Haki) nếu chưa có
                if not char:FindFirstChild("HasBuso") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end
                
                -- Bật Haki Quan Sát (Observation Haki / Vision)
                if not char:FindFirstChild("Vision") then
                    ReplicatedStorage.Remotes.CommE:FireServer("Ken", true)
                end
            end
        end)
    end
end)

-- 5. AUTO EQUIP MELEE (CẦM VÕ VÀO TAY)
local function EquipMelee()
    local char = LocalPlayer.Character
    if not char then return end

    local holdingMelee = false
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") and (item.ToolTip == "Melee" or item:FindFirstChild("Combat") or item:FindFirstChild("Melee")) then
            holdingMelee = true
            break
        end
    end

    if not holdingMelee then
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool:FindFirstChild("Combat") or tool:FindFirstChild("Melee") or tool.Name == "Combat" or tool.Name == "Superhuman" or tool.Name == "Godhuman" or tool.Name == "Dragon Talon" or tool.Name == "Electric Claw" or tool.Name == "Death Step" or tool.Name == "Sharkman Karate" or tool.Name == "Sanguine Art") then
                char.Humanoid:EquipTool(tool)
                break
            end
        end
    end
end

-- 6. DỮ LIỆU QUEST FARM
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
    local myLevel = LocalPlayer.Data.Level.Value
    for _, q in ipairs(QuestDatabase) do
        if myLevel >= q.MinLvl and myLevel <= q.MaxLvl then
            return q
        end
    end
    return nil
end

-- 7. VÒNG LẶP FARM TWEEN VÀ OBAERVATION HAKI CHÍNH
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            -- Auto Stats
            local points = LocalPlayer.Data.Points.Value
            if points > 0 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", points)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", points)
            end

            -- Luôn cầm võ
            EquipMelee()

            local qData = GetQuestData()
            if qData then
                local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                local hasQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible

                if not hasQuest then
                    -- Tween đến NPC nhận Quest
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
                        -- Tween đến vị trí đỉnh đầu quái (cách 8 stud) để đánh an toàn
                        FastTween(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0))
                        VirtualUser:Button1Down(Vector2.new(0,0))
                    else
                        -- Nếu chưa thấy quái xuất hiện, Tween đến khu vực spawn quái
                        FastTween(qData.CFrame * CFrame.new(0, 15, 0))
                    end
                end
            end
        end)
    end
end)

print("[BOBON HUB] FastTween Movement & Observation Haki Fully Loaded!")
