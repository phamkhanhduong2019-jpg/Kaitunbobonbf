repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

print("[BobonHub] Loading...")

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local LP = Players.LocalPlayer
local CommF_ = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("CommF_")

if not CommF_ then
    for i,v in pairs(RS:GetDescendants()) do
        if v.Name == "CommF_" then
            CommF_ = v
            break
        end
    end
end

_G.State = {
    StartTime = os.time(),
    KillCount = 0,
    Farming = false,
    CurrentTarget = nil,
}

_G.Settings = {
    TweenSpeed = 350,
    FarmHeight = 25,
}

local function GetLevel()
    local data = LP:FindFirstChild("Data")
    if data and data:FindFirstChild("Level") then
        return data.Level.Value
    end
    return 1
end

local function GetSea()
    local id = game.PlaceId
    if id == 2753915549 then return 1 end
    if id == 4442272183 then return 2 end
    if id == 7449423635 then return 3 end
    return 1
end

local function HasItem(name)
    return LP.Backpack:FindFirstChild(name) or (LP.Character and LP.Character:FindFirstChild(name))
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
    if c then
        return c:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function GetHum()
    local c = GetChar()
    if c then
        return c:FindFirstChild("Humanoid")
    end
    return nil
end

local function EquipTool(name)
    pcall(function()
        local c = GetChar()
        if not c then return end
        local tool = LP.Backpack:FindFirstChild(name)
        if tool then
            c.Humanoid:EquipTool(tool)
        end
    end)
end

local MeleeList = {"Godhuman","Superhuman","Death Step","Electric Claw","Dragon Talon","Sharkman Karate","Dragon Claw","Fishman Karate","Black Leg","Electro","Combat"}

local function EquipMelee()
    for _,name in ipairs(MeleeList) do
        if HasItem(name) then
            EquipTool(name)
            return true
        end
    end
    return false
end

local function Attack()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton1(Vector2.new())
    end)
end

local function Tween(cf)
    local hrp = GetHRP()
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    if dist < 12 then
        hrp.CFrame = cf
        return
    end
    local dur = math.min(dist / _G.Settings.TweenSpeed, 5)
    local t = TS:Create(hrp, TweenInfo.new(dur, Enum.EasingStyle.Linear), {CFrame = cf})
    t:Play()
    return t
end

local function FindMob(name)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local hrp = GetHRP()
    local best, bestDist = nil, math.huge
    for _, mob in pairs(enemies:GetChildren()) do
        if mob.Name == name and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
            if hrp then
                local d = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < bestDist then
                    best = mob
                    bestDist = d
                end
            else
                return mob
            end
        end
    end
    return best
end

local QuestDB = {
    {Min=1,Max=14,Q="BanditQuest1",M="Bandit",QL=1,QC=CFrame.new(1059,17,1550),MC=CFrame.new(1145,17,1634)},
    {Min=15,Max=29,Q="JungleQuest",M="Monkey",QL=1,QC=CFrame.new(-1598,37,153),MC=CFrame.new(-1448,50,24)},
    {Min=30,Max=59,Q="BuggyQuest1",M="Brute",QL=1,QC=CFrame.new(-1141,5,3831),MC=CFrame.new(-1145,15,4350)},
    {Min=60,Max=74,Q="DesertQuest",M="Desert Bandit",QL=1,QC=CFrame.new(894,7,4391),MC=CFrame.new(932,7,4484)},
    {Min=75,Max=89,Q="DesertQuest",M="Desert Officer",QL=2,QC=CFrame.new(894,7,4391),MC=CFrame.new(1580,11,4373)},
    {Min=90,Max=99,Q="SnowQuest",M="Snow Bandit",QL=1,QC=CFrame.new(1389,88,-1298),MC=CFrame.new(1376,87,-1396)},
    {Min=100,Max=119,Q="SnowQuest",M="Snowman",QL=2,QC=CFrame.new(1389,88,-1298),MC=CFrame.new(1201,472,-1401)},
    {Min=120,Max=149,Q="MarineQuest2",M="Chief Petty Officer",QL=1,QC=CFrame.new(-5039,29,4324),MC=CFrame.new(-4882,23,4255)},
    {Min=150,Max=174,Q="MarineQuest2",M="Sky Bandit",QL=2,QC=CFrame.new(-5039,29,4324),MC=CFrame.new(-4953,295,-2899)},
    {Min=175,Max=189,Q="PrisonerQuest",M="Prisoner",QL=1,QC=CFrame.new(5308,2,474),MC=CFrame.new(5411,96,690)},
    {Min=190,Max=209,Q="PrisonerQuest",M="Dangerous Prisoner",QL=2,QC=CFrame.new(5308,2,474),MC=CFrame.new(5654,15,866)},
    {Min=210,Max=249,Q="ColosseumQuest",M="Gladiator",QL=1,QC=CFrame.new(-1580,7,296),MC=CFrame.new(-1521,86,405)},
    {Min=250,Max=299,Q="ColosseumQuest",M="Military Soldier",QL=2,QC=CFrame.new(-1580,7,296),MC=CFrame.new(-1823,54,29)},
    {Min=300,Max=374,Q="MagmaQuest",M="Military Spy",QL=1,QC=CFrame.new(-5316,12,8515),MC=CFrame.new(-5787,76,8349)},
    {Min=375,Max=399,Q="MagmaQuest",M="Magma Admiral",QL=2,QC=CFrame.new(-5316,12,8515),MC=CFrame.new(-5530,81,8849)},
    {Min=400,Max=449,Q="FishmanQuest",M="Fishman Warrior",QL=1,QC=CFrame.new(61123,19,1569),MC=CFrame.new(60879,19,1549)},
    {Min=450,Max=474,Q="FishmanQuest",M="Fishman Commando",QL=2,QC=CFrame.new(61123,19,1569),MC=CFrame.new(61738,65,1584)},
    {Min=475,Max=524,Q="SkyExp1Quest",M="God's Guard",QL=1,QC=CFrame.new(-4722,845,-1954),MC=CFrame.new(-4698,845,-1912)},
    {Min=525,Max=549,Q="SkyExp1Quest",M="Shanda",QL=2,QC=CFrame.new(-7863,5546,-380),MC=CFrame.new(-7685,5567,-446)},
    {Min=550,Max=624,Q="SkyExp2Quest",M="Royal Squad",QL=1,QC=CFrame.new(-7906,5636,-1412),MC=CFrame.new(-7555,5637,-1420)},
    {Min=625,Max=649,Q="SkyExp2Quest",M="Royal Soldier",QL=2,QC=CFrame.new(-7906,5636,-1412),MC=CFrame.new(-7836,5645,-1699)},
    {Min=650,Max=699,Q="FountainQuest",M="Galley Pirate",QL=1,QC=CFrame.new(5259,38,4050),MC=CFrame.new(5551,78,3930)},
    {Min=700,Max=774,Q="Area1Quest",M="Raider",QL=1,QC=CFrame.new(-427,73,1837),MC=CFrame.new(-746,39,2507)},
    {Min=775,Max=849,Q="Area1Quest",M="Mercenary",QL=2,QC=CFrame.new(-427,73,1837),MC=CFrame.new(-874,141,1312)},
    {Min=850,Max=899,Q="Area2Quest",M="Swan Pirate",QL=1,QC=CFrame.new(634,73,918),MC=CFrame.new(878,122,1235)},
    {Min=900,Max=949,Q="Area2Quest",M="Marine Lieutenant",QL=2,QC=CFrame.new(634,73,918),MC=CFrame.new(-845,77,2016)},
    {Min=950,Max=999,Q="MarineQuest3",M="Marine Captain",QL=1,QC=CFrame.new(-2441,73,1891),MC=CFrame.new(-2035,73,2050)},
    {Min=1000,Max=1049,Q="MarineQuest3",M="Zombie",QL=2,QC=CFrame.new(-2441,73,1891),MC=CFrame.new(-5736,126,-653)},
    {Min=1050,Max=1099,Q="ZombieQuest",M="Vampire",QL=1,QC=CFrame.new(-5494,49,-795),MC=CFrame.new(-6033,7,-1317)},
    {Min=1100,Max=1124,Q="ZombieQuest",M="Elf",QL=2,QC=CFrame.new(-5494,49,-795),MC=CFrame.new(56,194,-1393)},
    {Min=1125,Max=1174,Q="NinjaQuest",M="Ninja Assassin",QL=1,QC=CFrame.new(-5377,39,-4826),MC=CFrame.new(-5238,84,-4634)},
    {Min=1175,Max=1199,Q="NinjaQuest",M="Ninja Hunter",QL=2,QC=CFrame.new(-5377,39,-4826),MC=CFrame.new(-5700,50,-4884)},
    {Min=1200,Max=1249,Q="IceSideQuest",M="Snow Trooper",QL=1,QC=CFrame.new(-6061,16,-4903),MC=CFrame.new(-5693,16,-4898)},
    {Min=1250,Max=1274,Q="IceSideQuest",M="Winter Warrior",QL=2,QC=CFrame.new(-6061,16,-4903),MC=CFrame.new(-5587,9,-5008)},
    {Min=1275,Max=1299,Q="ShipQuest1",M="Lab Subordinate",QL=1,QC=CFrame.new(-9505,38,4088),MC=CFrame.new(-9230,45,4294)},
    {Min=1300,Max=1324,Q="ShipQuest2",M="Horned Warrior",QL=1,QC=CFrame.new(-9481,72,6059),MC=CFrame.new(-6779,83,5928)},
    {Min=1325,Max=1349,Q="ShipQuest2",M="Magma Ninja",QL=2,QC=CFrame.new(-9481,72,6059),MC=CFrame.new(-5900,78,5800)},
    {Min=1350,Max=1374,Q="FrostQuest",M="Lava Pirate",QL=1,QC=CFrame.new(-5249,38,-4445),MC=CFrame.new(-5270,42,-4800)},
    {Min=1375,Max=1399,Q="FrostQuest",M="Ship Deckhand",QL=2,QC=CFrame.new(-5249,38,-4445),MC=CFrame.new(-8912,30,-9844)},
    {Min=1400,Max=1424,Q="ForgottenQuest",M="Ship Engineer",QL=1,QC=CFrame.new(-3053,237,-10145),MC=CFrame.new(-9300,30,-9940)},
    {Min=1425,Max=1449,Q="ForgottenQuest",M="Ship Steward",QL=2,QC=CFrame.new(-3053,237,-10145),MC=CFrame.new(-9400,15,-9350)},
    {Min=1450,Max=1474,Q="IceCastleQuest",M="Ship Officer",QL=1,QC=CFrame.new(-5539,314,-2972),MC=CFrame.new(-9658,8,-9700)},
    {Min=1475,Max=1524,Q="IceCastleQuest",M="Arctic Warrior",QL=2,QC=CFrame.new(-5539,314,-2972),MC=CFrame.new(-5990,340,-2800)},
    {Min=1525,Max=1574,Q="PiratePortQuest",M="Pirate Millionaire",QL=1,QC=CFrame.new(-290,44,5580),MC=CFrame.new(-435,191,5610)},
    {Min=1575,Max=1599,Q="PiratePortQuest",M="Pistol Billionaire",QL=2,QC=CFrame.new(-290,44,5580),MC=CFrame.new(-379,74,5873)},
    {Min=1600,Max=1624,Q="AmazonQuest",M="Dragon Crew Warrior",QL=1,QC=CFrame.new(5832,52,-1105),MC=CFrame.new(6339,52,-1213)},
    {Min=1625,Max=1649,Q="AmazonQuest",M="Dragon Crew Archer",QL=2,QC=CFrame.new(5832,52,-1105),MC=CFrame.new(6594,383,139)},
    {Min=1650,Max=1699,Q="AmazonQuest2",M="Female Islander",QL=1,QC=CFrame.new(5448,602,751),MC=CFrame.new(5792,820,863)},
    {Min=1700,Max=1724,Q="AmazonQuest2",M="Giant Islander",QL=2,QC=CFrame.new(5448,602,751),MC=CFrame.new(4530,656,-131)},
    {Min=1725,Max=1774,Q="MarineTreeIsland",M="Marine Commodore",QL=1,QC=CFrame.new(2180,29,-6737),MC=CFrame.new(2490,73,-7070)},
    {Min=1775,Max=1799,Q="MarineTreeIsland",M="Marine Rear Admiral",QL=2,QC=CFrame.new(2180,29,-6737),MC=CFrame.new(3671,402,-6982)},
    {Min=1800,Max=1849,Q="DeepForestIsland",M="Fishman Raider",QL=1,QC=CFrame.new(-13234,333,-7625),MC=CFrame.new(-10560,332,-8754)},
    {Min=1850,Max=1899,Q="DeepForestIsland",M="Fishman Captain",QL=2,QC=CFrame.new(-13234,333,-7625),MC=CFrame.new(-11465,332,-8770)},
    {Min=1900,Max=1924,Q="DeepForestIsland2",M="Forest Pirate",QL=1,QC=CFrame.new(-12684,391,-9902),MC=CFrame.new(-13225,425,-7755)},
    {Min=1925,Max=1974,Q="DeepForestIsland3",M="Jungle Pirate",QL=1,QC=CFrame.new(-12191,332,-10549),MC=CFrame.new(-12107,332,-10549)},
    {Min=1975,Max=1999,Q="PeanutIsland",M="Peanut Scout",QL=1,QC=CFrame.new(-2104,38,-10192),MC=CFrame.new(-2124,123,-10435)},
    {Min=2000,Max=2024,Q="PeanutIsland",M="Peanut President",QL=2,QC=CFrame.new(-2104,38,-10192),MC=CFrame.new(-1876,38,-10946)},
    {Min=2025,Max=2049,Q="IceCreamIsland",M="Ice Cream Chef",QL=1,QC=CFrame.new(-820,66,-10965),MC=CFrame.new(-821,44,-11253)},
    {Min=2050,Max=2074,Q="IceCreamIsland",M="Ice Cream Commander",QL=2,QC=CFrame.new(-820,66,-10965),MC=CFrame.new(-610,127,-11034)},
    {Min=2075,Max=2099,Q="CakeQuest1",M="Cookie Crafter",QL=1,QC=CFrame.new(-2022,38,-12030),MC=CFrame.new(-2365,38,-12099)},
    {Min=2100,Max=2124,Q="CakeQuest1",M="Cake Guard",QL=2,QC=CFrame.new(-2022,38,-12030),MC=CFrame.new(-1651,38,-12293)},
    {Min=2125,Max=2149,Q="CakeQuest2",M="Baking Staff",QL=1,QC=CFrame.new(-1927,38,-12843),MC=CFrame.new(-1980,38,-12763)},
    {Min=2150,Max=2199,Q="CakeQuest2",M="Head Baker",QL=2,QC=CFrame.new(-1927,38,-12843),MC=CFrame.new(-2235,53,-12858)},
    {Min=2200,Max=2224,Q="ChocQuest1",M="Cocoa Warrior",QL=1,QC=CFrame.new(233,25,-12201),MC=CFrame.new(167,26,-12238)},
    {Min=2225,Max=2249,Q="ChocQuest1",M="Chocolate Bar Battler",QL=2,QC=CFrame.new(233,25,-12201),MC=CFrame.new(507,73,-12789)},
    {Min=2250,Max=2274,Q="ChocQuest2",M="Sweet Thief",QL=1,QC=CFrame.new(151,25,-12774),MC=CFrame.new(-71,25,-12381)},
    {Min=2275,Max=2299,Q="ChocQuest2",M="Candy Rebel",QL=2,QC=CFrame.new(151,25,-12774),MC=CFrame.new(134,77,-12882)},
    {Min=2300,Max=2324,Q="CandyQuest1",M="Candy Pirate",QL=1,QC=CFrame.new(-1149,14,-14453),MC=CFrame.new(-1380,14,-14453)},
    {Min=2325,Max=2800,Q="CandyQuest1",M="Snow Demon",QL=2,QC=CFrame.new(-1149,14,-14453),MC=CFrame.new(-907,14,-14453)},
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

local function FormatNum(n)
    local s = tostring(math.floor(n or 0))
    return s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

if CoreGui:FindFirstChild("BobonHubUI") then
    CoreGui.BobonHubUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "BobonHubUI"
gui.Parent = CoreGui
gui.ResetOnSpawn = false
gui.DisplayOrder = 10000
gui.IgnoreGuiInset = true

local overlay = Instance.new("Frame")
overlay.Parent = gui
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.65
overlay.ZIndex = 1

local main = Instance.new("Frame")
main.Parent = gui
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 400, 0, 240)
main.BackgroundTransparency = 1
main.ZIndex = 2

local title = Instance.new("TextLabel")
title.Parent = main
title.AnchorPoint = Vector2.new(0.5, 0)
title.Position = UDim2.new(0.5, 0, 0, 5)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "BOBON HUB"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 38
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.TextStrokeTransparency = 0.3
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
title.ZIndex = 3

local sub = Instance.new("TextLabel")
sub.Parent = main
sub.AnchorPoint = Vector2.new(0.5, 0)
sub.Position = UDim2.new(0.5, 0, 0, 48)
sub.Size = UDim2.new(1, 0, 0, 22)
sub.BackgroundTransparency = 1
sub.Text = "Kaitun Blox Fruit"
sub.TextColor3 = Color3.fromRGB(180, 190, 220)
sub.TextSize = 15
sub.Font = Enum.Font.Gotham
sub.TextXAlignment = Enum.TextXAlignment.Center
sub.TextYAlignment = Enum.TextYAlignment.Center
sub.TextStrokeTransparency = 0.5
sub.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
sub.ZIndex = 3

local status = Instance.new("TextLabel")
status.Parent = main
status.AnchorPoint = Vector2.new(0.5, 0)
status.Position = UDim2.new(0.5, 0, 0, 82)
status.Size = UDim2.new(1, 0, 0, 28)
status.BackgroundTransparency = 1
status.Text = "Status: Starting..."
status.TextColor3 = Color3.fromRGB(100, 255, 150)
status.TextSize = 16
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Center
status.TextYAlignment = Enum.TextYAlignment.Center
status.TextStrokeTransparency = 0.5
status.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
status.ZIndex = 3

local time = Instance.new("TextLabel")
time.Parent = main
time.AnchorPoint = Vector2.new(0.5, 0)
time.Position = UDim2.new(0.5, 0, 0, 112)
time.Size = UDim2.new(1, 0, 0, 24)
time.BackgroundTransparency = 1
time.Text = "Time: 00:00:00"
time.TextColor3 = Color3.fromRGB(200, 210, 240)
time.TextSize = 14
time.Font = Enum.Font.Gotham
time.TextXAlignment = Enum.TextXAlignment.Center
time.TextYAlignment = Enum.TextYAlignment.Center
time.TextStrokeTransparency = 0.5
time.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
time.ZIndex = 3

local earned = Instance.new("Frame")
earned.Parent = main
earned.AnchorPoint = Vector2.new(0.5, 0)
earned.Position = UDim2.new(0.5, 0, 0, 146)
earned.Size = UDim2.new(0.9, 0, 0, 36)
earned.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
earned.BackgroundTransparency = 0.85
earned.BorderSizePixel = 1
earned.BorderColor3 = Color3.fromRGB(255, 215, 0)
earned.BorderTransparency = 0.7
earned.ZIndex = 3

local beli = Instance.new("TextLabel")
beli.Parent = earned
beli.AnchorPoint = Vector2.new(0.5, 0.5)
beli.Position = UDim2.new(0.25, 0, 0.5, 0)
beli.Size = UDim2.new(0.4, 0, 1, 0)
beli.BackgroundTransparency = 1
beli.Text = "Beli: 0"
beli.TextColor3 = Color3.fromRGB(255, 215, 0)
beli.TextSize = 15
beli.Font = Enum.Font.GothamBold
beli.TextXAlignment = Enum.TextXAlignment.Center
beli.TextYAlignment = Enum.TextYAlignment.Center
beli.ZIndex = 3

local frag = Instance.new("TextLabel")
frag.Parent = earned
frag.AnchorPoint = Vector2.new(0.5, 0.5)
frag.Position = UDim2.new(0.75, 0, 0.5, 0)
frag.Size = UDim2.new(0.4, 0, 1, 0)
frag.BackgroundTransparency = 1
frag.Text = "Frag: 0"
frag.TextColor3 = Color3.fromRGB(100, 180, 255)
frag.TextSize = 15
frag.Font = Enum.Font.GothamBold
frag.TextXAlignment = Enum.TextXAlignment.Center
frag.TextYAlignment = Enum.TextYAlignment.Center
frag.ZIndex = 3

local div = Instance.new("Frame")
div.Parent = earned
div.AnchorPoint = Vector2.new(0.5, 0.5)
div.Position = UDim2.new(0.5, 0, 0.5, 0)
div.Size = UDim2.new(0, 1, 0.6, 0)
div.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
div.BackgroundTransparency = 0.6
div.BorderSizePixel = 0
div.ZIndex = 3

local footer = Instance.new("TextLabel")
footer.Parent = main
footer.AnchorPoint = Vector2.new(0.5, 0)
footer.Position = UDim2.new(0.5, 0, 0, 196)
footer.Size = UDim2.new(1, 0, 0, 18)
footer.BackgroundTransparency = 1
footer.Text = "v12.0 | Auto Farm + Auto Items"
footer.TextColor3 = Color3.fromRGB(150, 150, 190)
footer.TextSize = 11
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.TextYAlignment = Enum.TextYAlignment.Center
footer.TextTransparency = 0.5
footer.TextStrokeTransparency = 0.5
footer.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
footer.ZIndex = 3

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local e = os.time() - _G.State.StartTime
            time.Text = string.format("Time: %02d:%02d:%02d", math.floor(e/3600), math.floor((e%3600)/60), e%60)
            status.Text = "Status: " .. (_G.BobonStatus or "Idle")
            local data = LP:FindFirstChild("Data")
            if data then
                local b = data:FindFirstChild("Beli") and data.Beli.Value or 0
                local f = data:FindFirstChild("Fragments") and data.Fragments.Value or 0
                beli.Text = "Beli: " .. FormatNum(b)
                frag.Text = "Frag: " .. FormatNum(f)
            end
        end)
    end
end)

task.spawn(function()
    task.wait(2)
    pcall(function()
        if LP.Team and LP.Team.Name ~= "Pirates" then
            CommF_:InvokeServer("SetTeam", "Pirates")
        end
    end)
end)

task.spawn(function()
    while task.wait(10) do
        pcall(function()
            CommF_:InvokeServer("Ken", true)
            CommF_:InvokeServer("Buso", true)
        end)
    end
end)

task.spawn(function()
    while task.wait(3) do
        pcall(function()
            local data = LP:FindFirstChild("Data")
            if data and data:FindFirstChild("Points") then
                local pts = data.Points.Value
                if pts > 0 then
                    CommF_:InvokeServer("AddPoint", "Melee", math.floor(pts * 0.7))
                    CommF_:InvokeServer("AddPoint", "Defense", math.floor(pts * 0.3))
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local c = GetChar()
            if c then
                for _, v in pairs(c:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
                for _, tool in pairs(c:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        tool.Handle.Size = Vector3.new(60, 60, 60)
                        tool.Handle.Transparency = 1
                        tool.Handle.CanCollide = false
                    end
                end
            end
        end)
    end
end)

LP.Idled:Connect(function()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in pairs(enemies:GetChildren()) do
                    local hum = mob:FindFirstChild("Humanoid")
                    if hum and not hum:GetAttribute("KillTracked") then
                        hum:SetAttribute("KillTracked", true)
                        hum.HealthChanged:Connect(function(h)
                            if h <= 0 then
                                _G.State.KillCount = _G.State.KillCount + 1
                            end
                        end)
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local level = GetLevel()
            local qData = GetQuest()
            
            if not qData then
                _G.BobonStatus = "Level out of range!"
                return
            end
            
            if not HasQuest() then
                _G.BobonStatus = "Taking quest: " .. qData.M
                Tween(qData.QC)
                task.wait(1)
                if CommF_ then
                    CommF_:InvokeServer("StartQuest", qData.Q, qData.QL)
                end
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
        if _G.State.CurrentTarget and _G.State.CurrentTarget:FindFirstChild("Humanoid") and _G.State.CurrentTarget.Humanoid.Health > 0 then
            EquipMelee()
            Attack()
        else
            _G.State.CurrentTarget = nil
        end
    end)
end)

print("[BobonHub] Ready!")
_G.BobonStatus = "BobonHub Ready!"
