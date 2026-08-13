-- ================================================================= --
--                    BOBON HUB - KAITUN FULL SOURCE                 --
--                Đã tích hợp đầy đủ Logic từ Config                 --
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
        ["Farm Mastery Weapons"] = {"Melee", "Sword"},
        ["Guns To Farm"] = {},
        ["Mastery Health (%)"] = 40,
        ["Swords To Farm"] = {"Cursed Dual Katana", "True Triple Katana"},
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

-- 1. HỆ THỐNG ANTI-AFK & CHỌN PHE (TEAM)
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

-- 2. HỆ THỐNG NOCLIP (ĐI XUYÊN VẬT THỂ KHI BAY)
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 3. HÀM DI CHUYỂN TWEEN FLY MƯỢT TRÁNH ANTI-CHEAT
local currentTween = nil
local function FastTween(targetCFrame)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local distance = (targetCFrame.Position - hrp.Position).Magnitude
        
        if distance > 20 then
            local speed = 320 -- Tốc độ di chuyển chuẩn
            local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
            if currentTween then currentTween:Cancel() end
            currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
            currentTween:Play()
        else
            hrp.CFrame = targetCFrame
        end
    end
end

-- 4. BẢNG DỮ LIỆU QUEST FARM LEVEL (LV 1 -> MAX 2800)
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

-- 5. CÁC TÍNH NĂNG PHỤ KÈM THEO CONFIG
-- Tự động Mua Võ / Kiếm / Haki nếu bật "Buy Stuffs"
local function AutoBuyStuffs()
    if getgenv().Configs["Buy Stuffs"] then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso") -- Bật Buso Haki
        ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki", "Geppo") -- Mua Nhảy Cao
    end
end

-- Tự động Bổ điểm Stats
local function AutoStats()
    local points = LocalPlayer.Data.Points.Value
    if points > 0 then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", points)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", points)
    end
end

-- Tự động Roll Trái Ác Quỷ & Bỏ vào Balo
local function AutoGetFruit()
    if getgenv().Configs["Get Fruits"] then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
        for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if string.find(item.Name, "Fruit") then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item.Name, item)
            end
        end
    end
end

-- 6. VÒNG LẶP CHÍNH THỰC THI (MAIN LOOP)
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            AutoStats()
            AutoBuyStuffs()
            AutoGetFruit()

            local myLevel = LocalPlayer.Data.Level.Value
            
            -- Kiểm tra ưu tiên: Farm Xương ở Lâu Đài Ma nếu bật Config & Đạt Level 1500+
            local farmBoneCfg = getgenv().Configs["Farm Config"]["Farm Bone Get x2 Exp"]
            if farmBoneCfg and farmBoneCfg["Enable"] and myLevel >= farmBoneCfg["Level"] and myLevel < 2800 then
                -- Teleport ra Haunted Castle farm xương
                FastTween(CFrame.new(-9480, 140, 5530))
                -- Tự động nhặt / đổi xương lấy x2 EXP
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
            else
                -- Farm Quest Level Bình Thường
                local qData = GetQuestData()
                if qData then
                    local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                    local hasQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible

                    if not hasQuest then
                        FastTween(qData.CFrame)
                        task.wait(0.3)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", qData.Quest, qData.QuestLvl)
                    else
                        local enemy = workspace:FindFirstChild("Enemies") and workspace.Enemies:FindFirstChild(qData.Monster)
                        if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            -- Bay đến đầu quái và spam đòn
                            FastTween(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 9, 0))
                            VirtualUser:Button1Down(Vector2.new(0,0))
                        else
                            FastTween(qData.CFrame * CFrame.new(0, 15, 0))
                        end
                    end
                end
            end
        end)
    end
end)

print("[BOBON HUB] All Sources & Logic Active Successfully!")
