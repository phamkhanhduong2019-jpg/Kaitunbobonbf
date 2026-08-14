Đây là bản **hoàn chỉnh** của Bobon Hub v13. Copy toàn bộ và paste vào executor:

```lua
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

-- Nền mờ toàn màn hình
local Dim = Instance.new("Frame", SG)
Dim.Size                   = UDim2.new(1,0,1,0)
Dim.BackgroundColor3       = Color3.fromRGB(0,0,0)
Dim.BackgroundTransparency = 1
Dim.BorderSizePixel        = 0
Dim.ZIndex                 = 1

-- Container giữa màn hình
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
--     RESPAWN-BASED TRAVEL (thay Tween — không rớt biển)
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
           
