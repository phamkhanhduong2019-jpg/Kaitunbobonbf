-- =================================================================
--         BOBON HUB v16.1 FIXED | STABLE KAITUN BLOX FRUIT
--         Long-Run Stable | Single Movement Owner | ActionToken
--         Base: v15.0 | Version: v16.1 FIXED
--
--  AUDIT FIXES v16.0-FIXED:
--  [FIX-1]  BossManager undefined -> crash main pcall -> farm khong
--           bao gio chay -> them BossManager safe stub (return false)
--  [FIX-2]  Error handling: moi subsystem wrap pcall rieng + warn
--           "[BobonHub] Module Error: <error>", main van tiep tuc
--  [FIX-3]  Attack dung khoang cach XZ (FarmHeight 22 > AttackRange 20
--           -> bot khong bao gio attack duoc truoc day)
--  [FIX-4]  TravelManager: validate target moi tick (Parent / Humanoid
--           health / duoi bien) -> mob chet/destroy tu dong clear
--           target + dung travel, khong recovery nang ne neu chi la
--           target chet (u tien clear target va resume farm)
--  [FIX-5]  Request: validate instance target truoc khi travel
--  [FIX-6]  FarmTarget: clear ngay khi chet / destroy / o duoi bien /
--           qua xa -> ve q.MC tim mob moi
--  [FIX-7]  FindNearestMob: bo qua mob o duoi bien (Y < MinY-10)
--  [FIX-8]  GetFarmPosition: nhan Vector3, clamp Y >= MinY
--  [FIX-9]  Quest sai mob: tu re-request khi toi giver (truoc day ket
--           vinh vien), khong farm mob sai quest
--  [FIX-10] Chua co quest -> khong farm, di lay quest truoc
--  [FIX-11] Travel timeout khong reset khi dang hover farm -> bo
--           recovery vo ich moi 45s
--  [FIX-12] Auto-recovery khong trigger khi Dead/Respawning
--  [FIX-13] SEA-3 CHOCOLATE LAND FIX: QDB MC sai -> bot "bay ra bien"
--           - Chocolate Bar Battler MC (507,73,-12789) -> (583,77,-12463)
--           - Sweet Thief MC (-71,25,-12381) -> (165,76,-12601)
--           (toa do that tu script farm, verify spawn mob tai khu)
--           + Travel fallback: target farm chet/mat/timeout giua duong
--           -> bay ve khu farm (q.MC) thay vi break -> KHONG drop khoi
--           khong trung giua bien
--           + Anti-fall safety net: chi khi KHONG co travel chay, neu
--           Y < MinY -> day len. Travel dang chay -> loop bo qua.
--
--  AUDIT FIXES v16.1-FIXED (FIX-P1..P15):
--  [FIX-P1] LONG-DISTANCE TRAVEL / CRUISE MODE  (FIX TRIỆT ĐỂ lỗi
--           "Lv2453 -> Chocolate Island -> bay giua bien -> dung yen")
--           - Khoang cach > CruiseThreshold(500) -> cruise mode:
--             giu do cao an toan (CruiseAltitude=60), bay ngang on dinh,
--             chi approach target Y khi con gan (ApproachThreshold=120)
--           - Timeout DONG theo khoang cach: max(TravelTimeout,
--             distance/FlySpeed + margin), cap 300s. Khong dung cu'ng 45s
--           - Stuck detection rieng: short=StuckTimeout(8),
--             cruise=CruiseStuckTimeout(20), farm hover=HoverStuckTimeout(30)
--           - Anti-fall trong travel: VUA NANG LEN VUA BAY NGANG ve target
--             (khong ket vong lap "chi di len")
--           - Khong pha token/CurrentToken/MovementOwner/IsTraveling
--  [FIX-P2] Quest verification: QuestMatches() doc TextLabel + QuestModel,
--           fallback doc dinh descendant. Khong tu dong coi la hop le khi
--           khong doc duoc text.
--  [FIX-P3] Sau RequestQuest: verify lai HasQuest + quest dung q.M.
--           Retry co gioi han (QuestRetryLimit), khong spam remote,
--           khong farm khi chua co quest, backoff neu fail lien tuc.
--  [FIX-P4] Farm target sync: clear ngay khi chet/destroy/Parent nil/
--           Health<=0/HRP mat/duoi bien/qua xa/invalid -> tim mob moi,
--           khong de travel cu' bam target cu, khong recovery nang ne.
--  [FIX-P5] Attack: chi attack khi da equip melee (EquipMelee tra ve
--           bool) + target con song + khoang cach XZ trong AttackRange,
--           giu AttackDelay, khong spam.
--  [FIX-P6] Hitbox: chi resize khi size doi, CanCollide=false an toan,
--           Handle khong ton tai -> bo qua, khong loi.
--  [FIX-P7] AutoStats: giu batch limit, Points=0 -> khong lam gi,
--           loi remote khong anh huong Farm, khong tao ActionToken.
--  [FIX-P8] ItemProgression: thay "task.wait(2)" bang TravelAndWait()
--           (travel -> verify den noi -> check alive+token -> moi remote).
--  [FIX-P9] Sea progression: verify tung step, retry gioi han, chi
--           teleport sang sea moi khi progression hoan tat + con song.
--  [FIX-P10] Recovery: guaranteed reset (xpcall) -> KHONG BAO GIO ket
--           o Mode=Recovering. Khong trigger khi Dead/Respawning, khong
--           trigger khi chi mob chet/target mat/lag ngan.
--  [FIX-P11] Travel target validation: NaN/invalid position reject ca
--           Instance va CFrame/Vector3, clamp Y an toan.
--  [FIX-P12] QDB: Lv2425-2474 = Chocolate Bar Battler dung (Lv2453
--           dung quest). Kaitun > Lv2800 chua co du lieu toa do chinh
--           xac -> GIU NGUYEN QDB (khong bi' a toa do). Ghi ro.
--  [FIX-P13] Main Controller: giu priority Recovery > Sea > Items >
--           Boss > Quest > Farm. Khong tao loop movement khac.
--  [FIX-P14] Error isolation: moi subsystem pcall/xpcall rieng, loi
--           khong chet Main Controller.
--  [FIX-P15] Long-run stability: clean state sau mob chet/player chet/
--           respawn/quest xong/quest sai/travel fail/timeout/target
--           destroy. Khong leak thread/connection.
-- =================================================================


repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("Data")


print("[BobonHub v16.1 FIXED] Loading...")


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
if not CommF_ then warn("[BobonHub v16.1 FIXED] CommF_ not found!") return end


-- ══════════════════════════════════════════════════════════════════
--                   CONFIG
-- ══════════════════════════════════════════════════════════════════
_G.Settings = {
    FarmHeight          = 22,
    FarmOffsetX         = 3,
    HitboxSize          = 50,
    FlySpeed            = 180,
    MinY                = 10,
    CloseThreshold      = 35,
    FarmArrivalThreshold= 15,
    AttackRange         = 20,
    StuckTimeout        = 8,
    HoverStuckTimeout   = 30,
    CruiseStuckTimeout  = 20,
    TargetLostTimeout   = 3,
    TravelTimeout       = 45,
    CruiseThreshold     = 500,
    CruiseAltitude      = 60,
    ApproachThreshold   = 120,
    TravelTimeoutMargin = 20,
    RandomFruitInterval = 120,
    AttackDelay         = 0.15,
    QuestDelay          = 1.5,
    QuestRetryLimit     = 3,
    RecoveryDelay       = 3,
    ActionLockTimeout   = 180,
    BossEnabled         = true,
    FruitEnabled        = true,
    AutoStats           = true,
    AutoItems           = true,
    ServerHopCooldown   = 120,
    MaxFarmDistance     = 300,
    StatBatchLimit      = 100,
}


-- ══════════════════════════════════════════════════════════════════
--              STATE MANAGER v7
--   ActionToken system chống race condition
--   State consistency checks
--   Centralized target/action management
-- ══════════════════════════════════════════════════════════════════
_G.BobonStatus = "Initializing..."


_G.State = {
    Mode             = "Idle",
    CurrentTarget    = nil,
    FarmTarget       = nil,
    KillCount        = 0,
    StartTime        = os.time(),
    LastRandomFruit  = 0,
    LastServerHop    = 0,
    LastQuestRequest = 0,
    QuestRetries     = 0,
    IsTraveling      = false,
    IsRecovering     = false,
    ActionToken      = 0,
    ActiveActionToken= 0,
    ActionOwner      = nil,
    ActionStartTime  = 0,
    MovementOwner    = nil,
    TravelID         = 0,
    LastMoveTime     = os.time(),
    LastPosition     = nil,
    LastAttackTime   = 0,
    ConsecutiveFails = 0,
    Sea              = 1,
}


function _G.State:SetMode(mode)
    self.Mode = mode
    _G.BobonStatus = mode
end


function _G.State:CanAct()
    return self.ActiveActionToken == 0
        and not self.IsRecovering
        and self.Mode ~= "Dead"
        and self.Mode ~= "Respawning"
        and self.Mode ~= "ServerHop"
end


function _G.State:CanRequestTravel()
    return not self.IsRecovering
        and self.Mode ~= "Dead"
        and self.Mode ~= "Respawning"
        and self.Mode ~= "ServerHop"
end


function _G.State:ClaimAction(owner)
    if self.ActiveActionToken ~= 0 then return 0 end
    self.ActionToken = self.ActionToken + 1
    self.ActiveActionToken = self.ActionToken
    self.ActionOwner = owner
    self.ActionStartTime = os.time()
    return self.ActiveActionToken
end


function _G.State:IsActionValid(myToken)
    return myToken > 0 and myToken == self.ActiveActionToken
end


function _G.State:ReleaseAction(myToken)
    if myToken > 0 and myToken == self.ActiveActionToken then
        self.ActiveActionToken = 0
        self.ActionOwner = nil
        self.ActionStartTime = 0
    end
end


function _G.State:ForceReleaseAction(reason)
    self.ActiveActionToken = 0
    self.ActionOwner = nil
    self.ActionStartTime = 0
end


function _G.State:ClearTargets()
    self.CurrentTarget = nil
    self.FarmTarget = nil
end


function _G.State:IsTargetValid(target)
    if not target then return false end
    if typeof(target) ~= "Instance" then return false end
    if not target.Parent then return false end
    local hum = target:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local root = target:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    -- [FIX-7] Reject target o duoi bien / vi tri bat thuong
    local ok, posY = pcall(function() return root.Position.Y end)
    if not ok or posY < _G.Settings.MinY - 10 then return false end
    return true
end


-- State consistency watchdog (Fix #22)
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            -- Fix state contradictions
            if _G.State.Mode == "Idle" and _G.State.IsTraveling and not _G.State.MovementOwner then
                _G.State.IsTraveling = false
            end
            if _G.State.Mode == "Dead" or _G.State.Mode == "Respawning" then
                if _G.State.IsTraveling then _G.State.IsTraveling = false end
                if _G.State.MovementOwner then _G.State.MovementOwner = nil end
            end
            -- Action timeout watchdog
            if _G.State.ActiveActionToken ~= 0 and _G.State.ActionStartTime > 0 then
                if os.time() - _G.State.ActionStartTime > _G.Settings.ActionLockTimeout then
                    warn("[Watchdog] Action timeout: " .. tostring(_G.State.ActionOwner))
                    _G.State:ForceReleaseAction("WatchdogTimeout")
                    _G.State:SetMode("Idle")
                end
            end
        end)
    end
end)


-- ══════════════════════════════════════════════════════════════════
--             UI — VXEZE STYLE (GIỮ NGUYÊN)
-- ══════════════════════════════════════════════════════════════════
if CoreGui:FindFirstChild("BobonHubUI") then CoreGui.BobonHubUI:Destroy() end


local SG = Instance.new("ScreenGui")
SG.Name = "BobonHubUI"; SG.Parent = CoreGui
SG.ResetOnSpawn = false; SG.DisplayOrder = 10000; SG.IgnoreGuiInset = true


local Dim = Instance.new("Frame", SG)
Dim.Size = UDim2.new(1,0,1,0); Dim.BackgroundColor3 = Color3.fromRGB(0,0,0)
Dim.BackgroundTransparency = 1; Dim.BorderSizePixel = 0; Dim.ZIndex = 1


local Con = Instance.new("Frame", SG)
Con.AnchorPoint = Vector2.new(0.5,0.5); Con.Position = UDim2.new(0.5,0,0.5,0)
Con.Size = UDim2.new(0,500,0,310); Con.BackgroundTransparency = 1
Con.BorderSizePixel = 0; Con.ZIndex = 2


local ULL = Instance.new("UIListLayout", Con)
ULL.SortOrder = Enum.SortOrder.LayoutOrder
ULL.HorizontalAlignment = Enum.HorizontalAlignment.Center
ULL.VerticalAlignment = Enum.VerticalAlignment.Center
ULL.Padding = UDim.new(0,3)


local function MkLabel(txt,sz,col,bold,order)
    local lb = Instance.new("TextLabel", Con)
    lb.Size = UDim2.new(1,0,0,sz+12); lb.BackgroundTransparency = 1
    lb.Text = txt; lb.TextColor3 = col; lb.TextSize = sz
    lb.Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
    lb.TextXAlignment = Enum.TextXAlignment.Center
    lb.TextYAlignment = Enum.TextYAlignment.Center
    lb.TextTransparency = 1; lb.TextStrokeTransparency = 0.6
    lb.TextStrokeColor3 = Color3.fromRGB(0,0,0); lb.LayoutOrder = order; lb.ZIndex = 3
    return lb
end


local function MkDiv(order)
    local f = Instance.new("Frame", Con)
    f.Size = UDim2.new(0.40,0,0,1); f.BackgroundColor3 = Color3.fromRGB(255,255,255)
    f.BackgroundTransparency = 0.72; f.BorderSizePixel = 0; f.LayoutOrder = order; f.ZIndex = 3
    Instance.new("UIListLayout", f).HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end


local function MkCurrRow(order)
    local row = Instance.new("Frame", Con)
    row.Size = UDim2.new(1,0,0,30); row.BackgroundTransparency = 1
    row.BorderSizePixel = 0; row.LayoutOrder = order; row.ZIndex = 3
    local function Side(txt,col,anchor,pos,align)
        local lb = Instance.new("TextLabel", row)
        lb.AnchorPoint = anchor; lb.Position = pos; lb.Size = UDim2.new(0.47,0,1,0)
        lb.BackgroundTransparency = 1; lb.Text = txt; lb.TextColor3 = col; lb.TextSize = 15
        lb.Font = Enum.Font.GothamBold; lb.TextXAlignment = align
        lb.TextYAlignment = Enum.TextYAlignment.Center; lb.TextTransparency = 1
        lb.TextStrokeTransparency = 0.6; lb.TextStrokeColor3 = Color3.fromRGB(0,0,0); lb.ZIndex = 3
        return lb
    end
    local sep = Instance.new("TextLabel", row)
    sep.AnchorPoint = Vector2.new(0.5,0.5); sep.Position = UDim2.new(0.5,0,0.5,0)
    sep.Size = UDim2.new(0,14,1,0); sep.BackgroundTransparency = 1; sep.Text = "│"
    sep.TextColor3 = Color3.fromRGB(200,200,200); sep.TextSize = 15; sep.Font = Enum.Font.Gotham
    sep.TextXAlignment = Enum.TextXAlignment.Center; sep.TextYAlignment = Enum.TextYAlignment.Center
    sep.TextTransparency = 1; sep.TextStrokeTransparency = 0.75; sep.ZIndex = 3
    local beli = Side("Beli: 0",Color3.fromRGB(255,195,60),Vector2.new(0,0.5),UDim2.new(0,0,0.5,0),Enum.TextXAlignment.Right)
    local frag = Side("Frag: 0",Color3.fromRGB(90,175,255),Vector2.new(1,0.5),UDim2.new(1,0,0.5,0),Enum.TextXAlignment.Left)
    return row, beli, sep, frag
end


local TitleL = MkLabel("BobonHub",34,Color3.fromRGB(100,210,255),true,1)
local SubL   = MkLabel("Kaitun Blox Fruit",16,Color3.fromRGB(170,195,220),false,2)
MkDiv(3)
local StatL  = MkLabel("Status: Initializing...",16,Color3.fromRGB(85,255,130),true,4)
local ModeL  = MkLabel("Mode: Idle",13,Color3.fromRGB(180,200,220),false,5)
local TimeL  = MkLabel("Time: 00:00:00",14,Color3.fromRGB(205,215,230),false,6)
MkDiv(7)
local CurrRow, BeliL, SepL, FragL = MkCurrRow(8)
local KillL  = MkLabel("Kills: 0",13,Color3.fromRGB(255,110,110),false,9)
local InfoL  = MkLabel("Sea: 1 | Lv: 1",12,Color3.fromRGB(160,180,200),false,10)


task.spawn(function()
    task.wait(0.3)
    TS:Create(Dim,TweenInfo.new(0.9,Enum.EasingStyle.Quad),{BackgroundTransparency=0.48}):Play()
    task.wait(0.5)
    for i,lb in ipairs({TitleL,SubL,StatL,ModeL,TimeL,BeliL,SepL,FragL,KillL,InfoL}) do
        task.delay((i-1)*0.08,function()
            TS:Create(lb,TweenInfo.new(0.55,Enum.EasingStyle.Quad),{TextTransparency=0}):Play()
        end)
    end
    print("[BobonHub v16.1 FIXED] UI Ready!")
end)


local function Fmt(n)
    local s = tostring(math.floor(n or 0))
    return s:reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
end


task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local e = os.time() - _G.State.StartTime
            TimeL.Text = ("Time: %02d:%02d:%02d"):format(math.floor(e/3600),math.floor(e%3600/60),e%60)
            StatL.Text = "Status: " .. (_G.BobonStatus or "Idle")
            ModeL.Text = "Mode: " .. (_G.State.Mode or "Idle")
            KillL.Text = "Kills: " .. Fmt(_G.State.KillCount)
            local d = LP:FindFirstChild("Data")
            if d then
                BeliL.Text = "Beli: " .. Fmt(d:FindFirstChild("Beli") and d.Beli.Value or 0)
                FragL.Text = "Frag: " .. Fmt(d:FindFirstChild("Fragments") and d.Fragments.Value or 0)
                local lv = d:FindFirstChild("Level") and d.Level.Value or 1
                InfoL.Text = ("Sea: %d | Lv: %s"):format(_G.State.Sea, Fmt(lv))
            end
        end)
    end
end)
-- ══════════════════════════════════════════════════════════════════
--                       HELPER FUNCTIONS
-- ══════════════════════════════════════════════════════════════════
local function Char() return LP.Character end
local function HRP() local c=Char(); return c and c:FindFirstChild("HumanoidRootPart") end
local function Hum() local c=Char(); return c and c:FindFirstChild("Humanoid") end
local function IsAlive() local h=Hum(); return h and h.Health > 0 end


local function Level()
    local d=LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Level") and d.Level.Value or 1
end


local function Beli()
    local d=LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Beli") and d.Beli.Value or 0
end


local function Points()
    local d=LP:FindFirstChild("Data")
    return d and d:FindFirstChild("Points") and d.Points.Value or 0
end


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
        local main = LP:FindFirstChild("PlayerGui")
            and LP.PlayerGui:FindFirstChild("Main")
        local quest = main and main:FindFirstChild("Quest")
        return quest and quest.Visible or false
    end)
    return ok and r or false
end


-- [FIX-P11] Kiểm tra Vector3 hợp lệ (reject NaN / vô hạn)
local function IsValidPos(p)
    return p ~= nil and typeof(p) == "Vector3"
        and p.X == p.X and p.Y == p.Y and p.Z == p.Z
end


-- [FIX-P2] Đọc quest text với nhiều fallback (TextLabel chính + QuestModel)
-- Trả về text đọc được, hoặc nil nếu UI không đọc được.
local function GetQuestText()
    local ok, text = pcall(function()
        local main = LP:FindFirstChild("PlayerGui")
            and LP.PlayerGui:FindFirstChild("Main")
        local quest = main and main:FindFirstChild("Quest")
        if not quest then return nil end
        local container = quest:FindFirstChild("Container")
        if not container then return nil end
        -- QuestModel: tên model hiển thị = tên mob (chính xác hơn text)
        local qm = container:FindFirstChild("QuestModel")
        if qm and qm.Name and qm.Name ~= "" then
            return qm.Name
        end
        -- TextLabel chính
        local label = container:FindFirstChild("TextLabel")
        if label and label.Text and label.Text ~= "" then
            return label.Text
        end
        -- Fallback: tìm mọi TextLabel trong Container
        for _, d in ipairs(container:GetDescendants()) do
            if d:IsA("TextLabel") and d.Text and d.Text ~= "" then
                return d.Text
            end
        end
        return nil
    end)
    if not ok then return nil end
    return text
end


-- [FIX-P2] Kiểm tra quest hiện tại có đúng mob q.M hay không.
-- Trả về: true = khớp, false = sai mob, nil = không đọc được UI.
local function QuestMatches(mobName)
    local text = GetQuestText()
    if not text then return nil end
    return string.find(text, mobName) ~= nil
end


-- [FIX-P3] Request quest tại giver với retry có giới hạn, không spam remote.
-- Trả về true = "đã xử lý (đừng farm)", false = "chưa tới giver".
local function HandleQuestAtGiver(q, atGiver)
    if not atGiver then return false end
    local now = os.time()
    if now - _G.State.LastQuestRequest < _G.Settings.QuestDelay then
        _G.BobonStatus = "Quest: Chờ xác nhận " .. q.M
        return true
    end
    if _G.State.QuestRetries > _G.Settings.QuestRetryLimit then
        -- Quá số lần retry → backoff, không spam remote, không farm
        _G.BobonStatus = "Quest: Fail, chờ retry"
        if now - _G.State.LastQuestRequest >= 20 then
            _G.State.QuestRetries = 0
        end
        return true
    end
    _G.State.LastQuestRequest = now
    _G.State.QuestRetries = _G.State.QuestRetries + 1
    local okRQ = pcall(function()
        CommF_:InvokeServer("RequestQuest", q.Q, q.QL)
    end)
    if okRQ then
        _G.BobonStatus = "Quest: Đã gửi " .. q.M
    else
        warn("[BobonHub] RequestQuest error (retry " .. _G.State.QuestRetries .. ")")
        _G.BobonStatus = "Quest: Lỗi, retry " .. q.M
    end
    return true
end


local function Attack()
    if not IsAlive() then return end
    local now = tick()
    if now - _G.State.LastAttackTime < _G.Settings.AttackDelay then return end
    _G.State.LastAttackTime = now
    pcall(function() VU:CaptureController(); VU:ClickButton1(Vector2.new()) end)
end


local MeleeList = {
    "Godhuman","Superhuman","Death Step","Electric Claw",
    "Dragon Talon","Sharkman Karate","Dragon Claw",
    "Fishman Karate","Black Leg","Electro","Combat","Sanguine Art"
}


-- [FIX-P5] Equip melee, trả về true nếu đã có melee trên tay (thành công)
local function EquipMelee()
    local c = Char()
    if not c or not c:FindFirstChildOfClass("Humanoid") then return false end
    for _,n in ipairs(MeleeList) do if c:FindFirstChild(n) then return true end end
    for _,n in ipairs(MeleeList) do
        local t = LP.Backpack:FindFirstChild(n)
        if t then
            pcall(function() c:FindFirstChildOfClass("Humanoid"):EquipTool(t) end)
            return true
        end
    end
    return false
end


local function FindMob(name)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    local best,bd = nil,math.huge
    local hrp = HRP()
    for _,v in ipairs(folder:GetChildren()) do
        if v.Name==name and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0
            and v:FindFirstChild("HumanoidRootPart") then
            if hrp then
                local d=(v.HumanoidRootPart.Position-hrp.Position).Magnitude
                if d<bd then best,bd=v,d end
            else return v end
        end
    end
    return best
end


local function FindBoss(name)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    for _,v in ipairs(folder:GetChildren()) do
        if v.Name==name and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0
            and v:FindFirstChild("HumanoidRootPart") then return v end
    end
    return nil
end


local function FindNearestMob(mobName)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil, math.huge end
    local best,bd = nil,math.huge
    local hrp = HRP()
    if not hrp then return nil, math.huge end
    for _,v in ipairs(folder:GetChildren()) do
        if v.Name==mobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0
            and v:FindFirstChild("HumanoidRootPart") then
            local root = v.HumanoidRootPart
            local ok, pos = pcall(function() return root.Position end)
            if not ok then continue end
            -- [FIX-7] Bo qua mob o duoi bien / vi tri bat thuong
            if pos.Y < _G.Settings.MinY - 10 then continue end
            local d = (pos - hrp.Position).Magnitude
            if d < bd then best,bd=v,d end
        end
    end
    return best, bd
end


-- Farm position với offset tương đối mob + clamp an toàn [FIX-8]
local function GetFarmPosition(mobPos)
    if not mobPos then return nil end
    if typeof(mobPos) == "Instance" then
        local ok, p = pcall(function() return mobPos.Position end)
        if not ok then return nil end
        mobPos = p
    end
    return Vector3.new(
        mobPos.X + _G.Settings.FarmOffsetX,
        math.max(mobPos.Y + _G.Settings.FarmHeight, _G.Settings.MinY),
        mobPos.Z
    )
end


-- ══════════════════════════════════════════════════════════════════
--    TRAVEL MANAGER v7 (FIXED)
--   Single movement owner DUY NHẤT
--   Persistent coroutine + token cancellation
--   Noclip restore original CanCollide state
--   Anti-fall lift (không teleport loop)
--   FarmHeight offset applied trong target resolution
--   Stuck detection riêng cho hover vs transit
--   [FIX-4] Validate target mỗi tick: Parent / Humanoid health / dưới biển
--   [FIX-5] Validate instance target ngay tại Request()
--   [FIX-11] Farm hover reset travel timeout khi đã tới → không recovery vô ích
-- ══════════════════════════════════════════════════════════════════
local TravelManager = {}
TravelManager.ActiveThread = nil
TravelManager.CurrentToken = 0
TravelManager.TargetRef = nil
TravelManager.NoclipConn = nil
TravelManager.PhysicsBV = nil
TravelManager.PhysicsBG = nil
TravelManager.OriginalCollision = {}


function TravelManager:CleanupPhysics(char)
    if self.PhysicsBV and self.PhysicsBV.Parent then self.PhysicsBV:Destroy() end
    if self.PhysicsBG and self.PhysicsBG.Parent then self.PhysicsBG:Destroy() end
    self.PhysicsBV = nil
    self.PhysicsBG = nil
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            for _,v in ipairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyGyro")
                    or v:IsA("AlignPosition") or v:IsA("AlignOrientation")
                    or v:IsA("LinearVelocity") or v:IsA("AngularVelocity") then
                    v:Destroy()
                end
            end
        end
    end
end


function TravelManager:EnableNoclip(char)
    if self.NoclipConn then self.NoclipConn:Disconnect() end
    self.OriginalCollision = {}
    if char then
        for _,part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                self.OriginalCollision[part] = part.CanCollide
            end
        end
    end
    self.NoclipConn = RunService.Stepped:Connect(function()
        if char and char:FindFirstChild("Humanoid") then
            for _,part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end


function TravelManager:DisableNoclip()
    if self.NoclipConn then
        self.NoclipConn:Disconnect()
        self.NoclipConn = nil
    end
    for part, canCollide in pairs(self.OriginalCollision) do
        if part and part.Parent then
            pcall(function() part.CanCollide = canCollide end)
        end
    end
    self.OriginalCollision = {}
end


function TravelManager:Stop(reason)
    self.CurrentToken = self.CurrentToken + 1
    self.TargetRef = nil
    _G.State.IsTraveling = false
    _G.State.MovementOwner = nil
    self:CleanupPhysics(Char())
    self:DisableNoclip()
end


function TravelManager:Request(targetCF, owner, options)
    options = options or {}
    owner = owner or "Unknown"


    if not _G.State:CanRequestTravel() then
        return false, "CannotTravel:" .. _G.State.Mode
    end


    -- [FIX-5] Validate instance target tại Request(): mob chết/destroy/
    -- dưới biển → reject ngay, không khởi tạo travel tới target rác
    if typeof(targetCF) == "Instance" then
        if not targetCF.Parent then return false, "InvalidTarget" end
        local hum = targetCF.Parent:FindFirstChild("Humanoid")
        if hum and hum.Health <= 0 then return false, "InvalidTarget" end
        if targetCF:IsA("BasePart") then
            local okY, posY = pcall(function() return targetCF.Position.Y end)
            if okY and posY < _G.Settings.MinY - 10 then return false, "InvalidTarget" end
        end
    elseif typeof(targetCF) == "CFrame" or typeof(targetCF) == "Vector3" then
        -- [FIX-P11] Reject NaN/invalid position ngay tại Request()
        local pos = typeof(targetCF) == "CFrame" and targetCF.Position or targetCF
        if not IsValidPos(pos) then return false, "InvalidTarget" end
    end


    -- Same owner already traveling: update ref only, NO restart
    if _G.State.IsTraveling and _G.State.MovementOwner == owner and self.ActiveThread then
        self.TargetRef = targetCF
        return true, self.CurrentToken
    end


    -- [FIX-P1] Detect long-distance travel → cruise mode + timeout động
    local startPos = HRP() and HRP().Position
    local startDist = nil
    if startPos and IsValidPos(startPos) then
        local tpos
        if typeof(targetCF) == "CFrame" then
            tpos = targetCF.Position
        elseif typeof(targetCF) == "Vector3" then
            tpos = targetCF
        elseif typeof(targetCF) == "Instance" and targetCF:IsA("BasePart") then
            local ok, p = pcall(function() return targetCF.Position end)
            tpos = ok and p or nil
        end
        if tpos and IsValidPos(tpos) then
            startDist = (startPos - tpos).Magnitude
        end
    end


    -- New travel: invalidate old via token
    self.CurrentToken = self.CurrentToken + 1
    local myToken = self.CurrentToken


    self:CleanupPhysics(Char())
    self:DisableNoclip()


    _G.State.MovementOwner = owner
    _G.State.IsTraveling = true
    _G.State.LastMoveTime = os.time()
    _G.State.LastPosition = HRP() and HRP().Position or nil
    self.TargetRef = targetCF


    self.ActiveThread = task.spawn(function()
        local char = Char()
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            self:CleanupPhysics(char)
            _G.State.IsTraveling = false
            _G.State.MovementOwner = nil
            return
        end
        local root = char.HumanoidRootPart


        self:CleanupPhysics(char)
        self:EnableNoclip(char)


        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.zero
        self.PhysicsBV = bv


        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.D = 100; bg.P = 10000
        self.PhysicsBG = bg


        local lastPos = root.Position
        local stuckTimer = 0
        local targetLostTimer = 0
        local travelStart = os.time()
        local arrivalThresh = options.arrivalThreshold or _G.Settings.CloseThreshold
        local flySpeed = options.speed or _G.Settings.FlySpeed
        local isFarmHover = (owner == "Farm")
        local fallback = options.fallback

        -- [FIX-P1] Long-distance/cruise mode + timeout động theo khoảng cách
        local longTravel = startDist ~= nil and startDist > _G.Settings.CruiseThreshold
        local travelTimeout = _G.Settings.TravelTimeout
        if longTravel and startDist then
            travelTimeout = math.max(_G.Settings.TravelTimeout,
                startDist / flySpeed + _G.Settings.TravelTimeoutMargin)
            travelTimeout = math.min(travelTimeout, 300)
        end

        -- [FIX-13] Khi target farm chết/mất giữa đường bay → về khu farm (fallback)
        -- Thay vì break (drop khỏi không trung) → đổi TargetRef sang CFrame an toàn
        local function HandleFarmInvalid(reason)
            _G.State:ClearTargets()
            if fallback then
                self.TargetRef = fallback
                fallback = nil
                travelStart = os.time()
                stuckTimer = 0
                _G.BobonStatus = "Farm: " .. reason .. ", về khu farm"
                return true
            end
            return false
        end


        while self.CurrentToken == myToken
            and char and char.Parent
            and IsAlive() do


            -- Travel timeout (động theo khoảng cách khi long travel) [FIX-P1]
            if os.time() - travelStart > travelTimeout then
                -- Farm timeout → về khu farm (fallback), không recover giữa biển [FIX-13]
                if isFarmHover and HandleFarmInvalid("Timeout") then
                    continue
                end
                warn("[Travel] Timeout by " .. owner)
                _G.State.IsRecovering = true
                break
            end


            -- Resolve target position + validate mỗi tick [FIX-4]
            local targetPos
            local targetType = typeof(self.TargetRef)
            if targetType == "Instance" then
                if not self.TargetRef.Parent then
                    -- Mob biến mất: farm → về khu farm (fallback), không drop giữa không trung [FIX-13]
                    if isFarmHover then
                        if HandleFarmInvalid("Target mất") then
                            continue
                        end
                        break
                    end
                    targetLostTimer = targetLostTimer + task.wait(0.2)
                    if targetLostTimer >= _G.Settings.TargetLostTimeout then
                        _G.State.IsRecovering = true
                        break
                    end
                    continue
                end
                local hum = self.TargetRef.Parent:FindFirstChild("Humanoid")
                if hum and hum.Health <= 0 then
                    -- Mob chết: farm → về khu farm (fallback) để tiếp tục [FIX-13]
                    if isFarmHover then
                        if HandleFarmInvalid("Target chết") then
                            continue
                        end
                        break
                    end
                    break
                end
                local okP, p = pcall(function()
                    if self.TargetRef:IsA("BasePart") then
                        return self.TargetRef.Position
                    end
                    return self.TargetRef:GetPivot().Position
                end)
                -- [FIX-P11] Reject NaN/invalid position
                if not okP or not IsValidPos(p) then
                    if isFarmHover then
                        if HandleFarmInvalid("Target lỗi") then
                            continue
                        end
                        break
                    end
                    break
                end
                targetLostTimer = 0
                if isFarmHover then
                    targetPos = GetFarmPosition(p)
                    if not targetPos then
                        if HandleFarmInvalid("Không lấy được vị trí") then
                            continue
                        end
                        break
                    end
                else
                    targetPos = p
                end
                -- Reject target dưới biển
                if targetPos.Y < _G.Settings.MinY - 10 then
                    warn("[Travel] Reject target dưới biển (Y=" .. string.format("%.1f", targetPos.Y) .. ")")
                    if isFarmHover then
                        if HandleFarmInvalid("Target dưới biển") then
                            continue
                        end
                        break
                    end
                    break
                end
            elseif targetType == "CFrame" then
                targetPos = self.TargetRef.Position
            elseif targetType == "Vector3" then
                targetPos = self.TargetRef
            else
                break
            end


            if not targetPos or not IsValidPos(targetPos) then break end


            -- Anti-fall clamp target Y (chỉ cho target cố định CFrame/Vector3)
            if targetPos.Y < _G.Settings.MinY then
                targetPos = Vector3.new(targetPos.X, _G.Settings.MinY, targetPos.Z)
            end


            local currentPos = root.Position
            if not IsValidPos(currentPos) then currentPos = lastPos end
            local dist = (currentPos - targetPos).Magnitude


            -- [FIX-P1] CRUISE MODE: bay xa qua biển → giữ độ cao an toàn,
            -- chỉ approach target Y thật khi đã gần đảo
            if longTravel and dist > _G.Settings.ApproachThreshold then
                local cruiseY = math.max(targetPos.Y, _G.Settings.CruiseAltitude)
                if currentPos.Y < cruiseY - 1 then
                    -- còn thấp → lên độ cao cruise
                    targetPos = Vector3.new(targetPos.X, cruiseY, targetPos.Z)
                elseif currentPos.Y > cruiseY + _G.Settings.CruiseAltitude then
                    -- quá cao → hạ xuống từ từ (không dive thẳng)
                    targetPos = Vector3.new(targetPos.X, math.max(currentPos.Y - 2, cruiseY), targetPos.Z)
                else
                    -- đã ở độ cao cruise → bay ngang ổn định
                    targetPos = Vector3.new(targetPos.X, currentPos.Y, targetPos.Z)
                end
                dist = (currentPos - targetPos).Magnitude
            end


            -- [FIX-P1] Anti-fall trong travel: VỪA nâng lên VỪA bay ngang về
            -- target (không kẹt vòng lặp "chỉ đi lên")
            if currentPos.Y < _G.Settings.MinY then
                local liftOffset = targetPos - currentPos
                local liftDir = liftOffset.Magnitude > 0.1 and liftOffset.Unit or Vector3.new(0, 0, 0)
                bv.Velocity = Vector3.new(liftDir.X * flySpeed, 60, liftDir.Z * flySpeed)
                bg.CFrame = CFrame.lookAt(currentPos, targetPos)
                task.wait(0.03)
                continue
            end


            -- Arrival detection
            if dist <= arrivalThresh then
                bv.Velocity = Vector3.zero
                bg.CFrame = CFrame.lookAt(currentPos, targetPos) * CFrame.Angles(0, math.pi, 0)
                if not isFarmHover then break end
                -- [FIX-11] Hover hợp lệ = activity, reset travel timeout
                travelStart = os.time()
                stuckTimer = 0
                _G.State.LastMoveTime = os.time()
                task.wait(0.03)
                continue
            end


            -- Movement with deceleration
            local direction = (targetPos - currentPos).Unit
            local speed = flySpeed
            if dist < 60 then speed = speed * math.max(dist / 60, 0.15) end


            bv.Velocity = direction * speed
            bg.CFrame = CFrame.lookAt(currentPos, targetPos)


            -- Stuck detection (riêng cho từng mode) [FIX-P1]
            local moveDelta = (currentPos - lastPos).Magnitude
            if moveDelta < 1 then
                stuckTimer = stuckTimer + task.wait(0.5)
                local stuckLimit = _G.Settings.StuckTimeout
                if isFarmHover then
                    stuckLimit = _G.Settings.HoverStuckTimeout
                elseif longTravel then
                    stuckLimit = _G.Settings.CruiseStuckTimeout
                end
                if stuckTimer >= stuckLimit then
                    _G.State.IsRecovering = true
                    warn("[Travel] Stuck by " .. owner)
                    break
                end
            else
                stuckTimer = 0
                _G.State.LastMoveTime = os.time()
                _G.State.LastPosition = currentPos
            end


            lastPos = currentPos
            task.wait(0.03)
        end


        -- Thread exited: only cleanup if still active token
        if self.CurrentToken == myToken then
            self:CleanupPhysics(char)
            self:DisableNoclip()
            _G.State.IsTraveling = false
            _G.State.MovementOwner = nil
            self.ActiveThread = nil
            self.TargetRef = nil
        end
    end)


    return true, myToken
end


-- Death/Respawn handlers
LP.CharacterRemoving:Connect(function()
    TravelManager:Stop("CharacterRemoving")
    _G.State:SetMode("Dead")
    _G.State:ClearTargets()
    _G.State:ForceReleaseAction("Death")
end)


LP.CharacterAdded:Connect(function(char)
    task.spawn(function()
        _G.State:SetMode("Respawning")
        TravelManager:Stop("Respawn")


        local hrp = char:WaitForChild("HumanoidRootPart", 10)
        local hum = char:WaitForChild("Humanoid", 10)
        if not hrp or not hum then return end


        pcall(function() LP:WaitForChild("Data", 10) end)


        _G.State.IsTraveling = false
        _G.State.IsRecovering = false
        _G.State.MovementOwner = nil
        _G.State:ForceReleaseAction("Respawn")
        _G.State:ClearTargets()
        _G.State.ConsecutiveFails = 0
        _G.State.Sea = GetSea()


        task.wait(2)
        _G.State:SetMode("Idle")
    end)
end)


-- [FIX-P8/P9] Travel + verify tới nơi trước khi gọi remote.
-- Thay cho "task.wait(2)" giả định thành công. Check alive + token
-- mỗi bước; nếu chưa tới thì chờ travel tới (TravelManager tự bay).
-- Trả về true khi đã tới + còn sống + token còn hợp lệ.
local function TravelAndWait(owner, token, cf, opts)
    opts = opts or {}
    if not _G.State:IsActionValid(token) then return false end
    if not IsAlive() then return false end
    local ok = TravelManager:Request(cf, owner)
    if not ok then return false end
    local hrp = HRP()
    local thresh = opts.arrivalThreshold or _G.Settings.CloseThreshold
    local timeout = os.time() + (opts.timeout or 60)
    while _G.State:IsActionValid(token) and IsAlive() and os.time() < timeout do
        hrp = HRP()
        if hrp and (hrp.Position - cf.Position).Magnitude <= thresh then
            break
        end
        task.wait(0.5)
    end
    task.wait(opts.settle or 1)
    return _G.State:IsActionValid(token) and IsAlive()
end
-- ══════════════════════════════════════════════════════════════════
--         [FIX-13] ANTI-FALL SAFETY NET (chỉ khi KHÔNG có travel)
--   Background loop an toàn: KHÔNG điều khiển movement bình thường.
--   Chỉ kích hoạt khi character rơi dưới MinY (sắp chết đuối) MÀ
--   không có travel nào đang chạy → đẩy lên đến khi > MinY.
--   Khi travel hoạt động → loop này bỏ qua hoàn toàn (travel tự xử lý).
--   Ngăn hoàn toàn việc "rớt xuống biển" trong khoảng trống recovery/tick.
-- ══════════════════════════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not IsAlive() then return end
            if _G.State.IsTraveling then return end
            local root = HRP()
            if not root then return end
            if root.Position.Y < _G.Settings.MinY then
                root.AssemblyLinearVelocity = Vector3.new(
                    root.AssemblyLinearVelocity.X, 45, root.AssemblyLinearVelocity.Z)
            end
        end)
    end
end)
-- ══════════════════════════════════════════════════════════════════
--         RECOVERY MANAGER v7 (Fix #2,#6)
--   State machine: STOP → CLEANUP → RESET → WAIT → CHECK → IDLE
--   KHÔNG tạo movement coroutine trong recovery
--   Sau recovery → Idle → Main Controller tự resume
--   Nếu character không xuất hiện → reset sạch, không kẹt vĩnh viễn
-- ══════════════════════════════════════════════════════════════════
local RecoveryManager = {}


function RecoveryManager:Handle(reason)
    if _G.State.Mode == "Recovering" then return end
    _G.State:SetMode("Recovering")
    _G.BobonStatus = "Recovery: " .. reason


    -- STEP 1: Stop all movement immediately
    TravelManager:Stop("Recovery")


    -- STEP 2: Force release any active action token
    _G.State:ForceReleaseAction("Recovery:" .. reason)


    task.spawn(function()
        -- [FIX-P10] xpcall toàn bộ → dù lỗi vẫn guaranteed reset về Idle.
        -- Không bao giờ kẹt ở Mode=Recovering (nguyên nhân "đứng yên giữa biển")
        local success, noChar = xpcall(function()
            -- STEP 3: Wait for stability
            task.wait(_G.Settings.RecoveryDelay)


            -- STEP 4: Check character alive với timeout
            local retries = 0
            while not IsAlive() and retries < 15 do
                task.wait(1)
                retries = retries + 1
            end


            -- Nếu character không xuất hiện sau timeout → báo fail, vẫn reset
            if not IsAlive() then
                _G.BobonStatus = "Recovery: Failed - no character"
                _G.State.ConsecutiveFails = _G.State.ConsecutiveFails + 1
                return true
            end


            -- STEP 5: Reset HRP velocity chống residual momentum
            pcall(function()
                local hrp = HRP()
                if hrp then
                    hrp.Velocity = Vector3.zero
                    hrp.RotVelocity = Vector3.zero
                end
            end)
            return false
        end, debug.traceback)
        if not success then
            warn("[BobonHub] Module Error: RecoveryManager: " .. tostring(noChar))
            noChar = nil
        end


        -- STEP 6: Full state reset (GUARANTEED)
        _G.State:ClearTargets()
        _G.State.MovementOwner = nil
        _G.State.IsTraveling = false
        _G.State.IsRecovering = false
        _G.State:ForceReleaseAction("RecoveryComplete")
        if not noChar then
            _G.State.ConsecutiveFails = 0
        end
        _G.State.Sea = GetSea()


        -- STEP 7: Return to Idle — Main Controller tự resume
        _G.BobonStatus = "Recovery: Complete"
        _G.State:SetMode("Idle")
    end)
end


-- Auto-trigger recovery khi TravelManager set IsRecovering
-- [FIX-12] Không trigger khi Dead/Respawning (respawn tự xử lý)
task.spawn(function()
    while task.wait(0.5) do
        if _G.State.IsRecovering
            and _G.State.Mode ~= "Recovering"
            and _G.State.Mode ~= "Dead"
            and _G.State.Mode ~= "Respawning" then
            RecoveryManager:Handle("StuckOrTimeout")
        end
    end
end)


-- ══════════════════════════════════════════════════════════════════
--          QUEST DATABASE v16.1 AUDITED (GIỮ NGUYÊN)
-- ══════════════════════════════════════════════════════════════════
local QDB = {
    {Min=1,Max=14,Q="BanditQuest1",M="Bandit",QL=1,QC=CFrame.new(1059,17,1550),MC=CFrame.new(1145,17,1634)},
    {Min=15,Max=29,Q="JungleQuest",M="Monkey",QL=1,QC=CFrame.new(-1598,37,153),MC=CFrame.new(-1448,50,24)},
    {Min=30,Max=59,Q="BuggyQuest1",M="Brute",QL=1,QC=CFrame.new(-1141,5,3831),MC=CFrame.new(-1145,15,4350)},
    {Min=60,Max=74,Q="DesertQuest",M="Desert Bandit",QL=1,QC=CFrame.new(894,7,4391),MC=CFrame.new(932,7,4484)},
    {Min=75,Max=89,Q="DesertQuest",M="Desert Officer",QL=2,QC=CFrame.new(894,7,4391),MC=CFrame.new(1580,11,4373)},
    {Min=90,Max=99,Q="SnowQuest",M="Snow Bandit",QL=1,QC=CFrame.new(1389,88,-1298),MC=CFrame.new(1376,87,-1396)},
    {Min=100,Max=119,Q="SnowQuest",M="Snowman",QL=2,QC=CFrame.new(1389,88,-1298),MC=CFrame.new(1201,472,-1401)},
    {Min=120,Max=149,Q="MarineQuest2",M="Chief Petty Officer",QL=1,QC=CFrame.new(-5039,29,4324),MC=CFrame.new(-4882,23,4255)},
    {Min=150,Max=174,Q="SkyQuest",M="Sky Bandit",QL=1,QC=CFrame.new(-4850,718,-2620),MC=CFrame.new(-4953,295,-2899)},
    {Min=175,Max=209,Q="PrisonerQuest",M="Prisoner",QL=1,QC=CFrame.new(5308,2,474),MC=CFrame.new(5411,96,690)},
    {Min=210,Max=249,Q="PrisonerQuest",M="Dangerous Prisoner",QL=2,QC=CFrame.new(5308,2,474),MC=CFrame.new(5654,15,866)},
    {Min=250,Max=299,Q="ColosseumQuest",M="Gladiator",QL=1,QC=CFrame.new(-1580,7,296),MC=CFrame.new(-1521,86,405)},
    {Min=300,Max=374,Q="MagmaQuest",M="Military Spy",QL=1,QC=CFrame.new(-5316,12,8515),MC=CFrame.new(-5787,76,8349)},
    {Min=375,Max=449,Q="FishmanQuest",M="Fishman Warrior",QL=1,QC=CFrame.new(61123,19,1569),MC=CFrame.new(60879,19,1549)},
    {Min=450,Max=524,Q="FishmanQuest",M="Fishman Commando",QL=2,QC=CFrame.new(61123,19,1569),MC=CFrame.new(61738,65,1584)},
    {Min=525,Max=624,Q="SkyExp1Quest",M="God's Guard",QL=1,QC=CFrame.new(-4722,845,-1954),MC=CFrame.new(-4698,845,-1912)},
    {Min=625,Max=699,Q="SkyExp2Quest",M="Royal Squad",QL=1,QC=CFrame.new(-7906,5636,-1412),MC=CFrame.new(-7555,5637,-1420)},
    {Min=700,Max=774,Q="Area1Quest",M="Raider",QL=1,QC=CFrame.new(-427,73,1837),MC=CFrame.new(-746,39,2507)},
    {Min=775,Max=849,Q="Area1Quest",M="Mercenary",QL=2,QC=CFrame.new(-427,73,1837),MC=CFrame.new(-874,141,1312)},
    {Min=850,Max=899,Q="Area2Quest",M="Swan Pirate",QL=1,QC=CFrame.new(634,73,918),MC=CFrame.new(878,122,1235)},
    {Min=900,Max=949,Q="Area2Quest",M="Marine Lieutenant",QL=2,QC=CFrame.new(634,73,918),MC=CFrame.new(-845,77,2016)},
    {Min=950,Max=999,Q="MarineQuest3",M="Marine Captain",QL=1,QC=CFrame.new(-2441,73,1891),MC=CFrame.new(-2035,73,2050)},
    {Min=1000,Max=1049,Q="ZombieQuest",M="Zombie",QL=1,QC=CFrame.new(-5494,49,-795),MC=CFrame.new(-5736,126,-653)},
    {Min=1050,Max=1099,Q="ZombieQuest",M="Vampire",QL=2,QC=CFrame.new(-5494,49,-795),MC=CFrame.new(-6033,7,-1317)},
    {Min=1100,Max=1174,Q="NinjaQuest",M="Ninja Assassin",QL=1,QC=CFrame.new(-5377,39,-4826),MC=CFrame.new(-5238,84,-4634)},
    {Min=1175,Max=1249,Q="IceSideQuest",M="Snow Trooper",QL=1,QC=CFrame.new(-6061,16,-4903),MC=CFrame.new(-5693,16,-4898)},
    {Min=1250,Max=1299,Q="ShipQuest1",M="Lab Subordinate",QL=1,QC=CFrame.new(-9505,38,4088),MC=CFrame.new(-9230,45,4294)},
    {Min=1300,Max=1349,Q="ShipQuest2",M="Horned Warrior",QL=1,QC=CFrame.new(-9481,72,6059),MC=CFrame.new(-6779,83,5928)},
    {Min=1350,Max=1399,Q="FrostQuest",M="Lava Pirate",QL=1,QC=CFrame.new(-5249,38,-4445),MC=CFrame.new(-5270,42,-4800)},
    {Min=1400,Max=1449,Q="ForgottenQuest",M="Ship Engineer",QL=1,QC=CFrame.new(-3053,237,-10145),MC=CFrame.new(-9300,30,-9940)},
    {Min=1450,Max=1524,Q="IceCastleQuest",M="Arctic Warrior",QL=2,QC=CFrame.new(-5539,314,-2972),MC=CFrame.new(-5990,340,-2800)},
    {Min=1525,Max=1599,Q="PiratePortQuest",M="Pirate Millionaire",QL=1,QC=CFrame.new(-290,44,5580),MC=CFrame.new(-435,191,5610)},
    {Min=1600,Max=1649,Q="AmazonQuest",M="Dragon Crew Warrior",QL=1,QC=CFrame.new(5832,52,-1105),MC=CFrame.new(6339,52,-1213)},
    {Min=1650,Max=1724,Q="AmazonQuest2",M="Female Islander",QL=1,QC=CFrame.new(5448,602,751),MC=CFrame.new(5792,820,863)},
    {Min=1725,Max=1799,Q="MarineTreeIsland",M="Marine Commodore",QL=1,QC=CFrame.new(2180,29,-6737),MC=CFrame.new(2490,73,-7070)},
    {Min=1800,Max=1874,Q="DeepForestIsland",M="Fishman Raider",QL=1,QC=CFrame.new(-13234,333,-7625),MC=CFrame.new(-10560,332,-8754)},
    {Min=1875,Max=1924,Q="DeepForestIsland",M="Fishman Captain",QL=2,QC=CFrame.new(-13234,333,-7625),MC=CFrame.new(-11465,332,-8770)},
    {Min=1925,Max=1974,Q="DeepForestIsland2",M="Forest Pirate",QL=1,QC=CFrame.new(-12684,391,-9902),MC=CFrame.new(-13225,425,-7755)},
    {Min=1975,Max=2024,Q="PeanutIsland",M="Peanut Scout",QL=1,QC=CFrame.new(-2104,38,-10192),MC=CFrame.new(-2124,123,-10435)},
    {Min=2025,Max=2074,Q="PeanutIsland",M="Peanut President",QL=2,QC=CFrame.new(-2104,38,-10192),MC=CFrame.new(-1876,38,-10946)},
    {Min=2075,Max=2124,Q="IceCreamIsland",M="Ice Cream Chef",QL=1,QC=CFrame.new(-820,66,-10965),MC=CFrame.new(-821,44,-11253)},
    {Min=2125,Max=2174,Q="IceCreamIsland",M="Ice Cream Commander",QL=2,QC=CFrame.new(-820,66,-10965),MC=CFrame.new(-610,127,-11034)},
    {Min=2175,Max=2224,Q="CakeQuest1",M="Cookie Crafter",QL=1,QC=CFrame.new(-2022,38,-12030),MC=CFrame.new(-2365,38,-12099)},
    {Min=2225,Max=2274,Q="CakeQuest1",M="Cake Guard",QL=2,QC=CFrame.new(-2022,38,-12030),MC=CFrame.new(-1651,38,-12293)},
    {Min=2275,Max=2324,Q="CakeQuest2",M="Baking Staff",QL=1,QC=CFrame.new(-1927,38,-12843),MC=CFrame.new(-1980,38,-12763)},
    {Min=2325,Max=2374,Q="CakeQuest2",M="Head Baker",QL=2,QC=CFrame.new(-1927,38,-12843),MC=CFrame.new(-2235,53,-12858)},
    {Min=2375,Max=2424,Q="ChocQuest1",M="Cocoa Warrior",QL=1,QC=CFrame.new(233,25,-12201),MC=CFrame.new(167,26,-12238)},
    {Min=2425,Max=2474,Q="ChocQuest1",M="Chocolate Bar Battler",QL=2,QC=CFrame.new(233,25,-12201),MC=CFrame.new(583,77,-12463)},
    {Min=2475,Max=2524,Q="ChocQuest2",M="Sweet Thief",QL=1,QC=CFrame.new(151,25,-12774),MC=CFrame.new(165,76,-12601)},
    {Min=2525,Max=2574,Q="ChocQuest2",M="Candy Rebel",QL=2,QC=CFrame.new(151,25,-12774),MC=CFrame.new(134,77,-12882)},
    {Min=2575,Max=2649,Q="CandyQuest1",M="Candy Pirate",QL=1,QC=CFrame.new(-1149,14,-14453),MC=CFrame.new(-1380,14,-14453)},
    {Min=2650,Max=2800,Q="CandyQuest1",M="Snow Demon",QL=2,QC=CFrame.new(-1149,14,-14453),MC=CFrame.new(-907,14,-14453)},
}


local function GetQ()
    local lv = Level()
    for _, q in ipairs(QDB) do
        if lv >= q.Min and lv <= q.Max then return q end
    end
    return nil
end
-- ══════════════════════════════════════════════════════════════════
--     AUTO ITEMS + SEA PROGRESSION v16.1 (GIỮ NGUYÊN + FIX-P8/P9)
--   ActionToken system: ClaimAction → IsActionValid → ReleaseAction
--   Mọi subsystem check token trước MỌI operation
--   ReleaseAction LUÔN được gọi trong finally block (xpcall)
--   Death/Recovery invalidate token → subsystem tự dừng
-- ══════════════════════════════════════════════════════════════════
local ItemProgression = {}


function ItemProgression:CheckSaber()
    if not _G.Settings.AutoItems then return false end
    if HasItem("Saber") or Level() < 200 or GetSea() ~= 1 then return false end
    local myToken = _G.State:ClaimAction("Saber")
    if myToken == 0 then return false end
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Item: Saber Sword"


    task.spawn(function()
        local ok, err = xpcall(function()
            local torches = {
                {N="Torch1",C=CFrame.new(-1610,11,163)},
                {N="Torch2",C=CFrame.new(1114,4,4350)},
                {N="Torch3",C=CFrame.new(1400,101,-1250)},
                {N="Torch4",C=CFrame.new(-5070,23,4325)},
                {N="Torch5",C=CFrame.new(-1675,7,-2985)},
            }
            -- [FIX-P8] Mỗi torch: travel + VERIFY tới nơi + check alive/token
            -- rồi mới gọi remote (không "task.wait(2)" giả định thành công)
            for _, t in ipairs(torches) do
                if not _G.State:IsActionValid(myToken) then return end
                if TravelAndWait("Saber", myToken, t.C, {timeout=90}) then
                    pcall(function() CommF_:InvokeServer("Torch", t.N) end)
                end
                task.wait(0.5)
            end
            local timeout = os.time() + 300
            while _G.State:IsActionValid(myToken) and not HasItem("Saber")
                and os.time() < timeout and IsAlive() do
                local boss = FindBoss("Saber Expert")
                if boss and boss:FindFirstChild("HumanoidRootPart") and boss.Humanoid.Health > 0 then
                    EquipMelee()
                    TravelManager:Request(boss.HumanoidRootPart, "Saber")
                    Attack()
                else
                    TravelManager:Request(CFrame.new(-1405,30,-3330), "Saber")
                    task.wait(3)
                end
                task.wait(0.1)
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Saber: " .. tostring(err)) end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "GettingItem" then
            _G.State:SetMode("Idle")
        end
    end)
    return true
end


function ItemProgression:CheckPoleV1()
    if not _G.Settings.AutoItems then return false end
    if HasItem("Pole (1st Form)") or Level() < 150 or GetSea() ~= 1 then return false end
    local myToken = _G.State:ClaimAction("PoleV1")
    if myToken == 0 then return false end
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Item: Pole v1"


    task.spawn(function()
        local ok, err = xpcall(function()
            if not _G.State:IsActionValid(myToken) then return end
            -- [FIX-P8] Travel + verify tới Skylands rồi mới BuyPoleV1
            if TravelAndWait("PoleV1", myToken, CFrame.new(-7748,5606,-2305), {timeout=120}) then
                pcall(function() CommF_:InvokeServer("BuyPoleV1") end)
            end
            task.wait(1)
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: PoleV1: " .. tostring(err)) end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "GettingItem" then
            _G.State:SetMode("Idle")
        end
    end)
    return true
end


function ItemProgression:CheckSecondSea()
    if GetSea() >= 2 or Level() < 700 then return false end
    local myToken = _G.State:ClaimAction("Sea2")
    if myToken == 0 then return false end
    _G.State:SetMode("UnlockingSea")
    _G.BobonStatus = "Sea: Unlock 2nd Sea"


    task.spawn(function()
        local ok, err = xpcall(function()
            if not _G.State:IsActionValid(myToken) then return end
            -- [FIX-P9] Mỗi bước: travel + verify tới nơi + check alive/token
            if TravelAndWait("Sea2", myToken, CFrame.new(-4909,4,4450), {timeout=90}) then
                pcall(function() CommF_:InvokeServer("DressrosaQuestProgress","Detective") end)
            end
            task.wait(1)


            if not _G.State:IsActionValid(myToken) then return end
            if TravelAndWait("Sea2", myToken, CFrame.new(932,13,4482), {timeout=90}) then
                pcall(function() CommF_:InvokeServer("DressrosaQuestProgress","Bartilo") end)
            end
            task.wait(1)


            -- Kill 50 Swan Pirate, đếm chính xác qua Humanoid.Died (1 lần/mob)
            local kills = 0
            local function TryCount(mob)
                local hm = mob:FindFirstChild("Humanoid")
                if hm and not hm:GetAttribute("Sea2Counted") then
                    hm:SetAttribute("Sea2Counted", true)
                    hm.Died:Connect(function()
                        kills = kills + 1
                    end)
                end
            end
            local timeout = os.time()+600
            while _G.State:IsActionValid(myToken) and kills < 50
                and os.time() < timeout and IsAlive() do
                local mob = FindMob("Swan Pirate")
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    EquipMelee()
                    TryCount(mob)
                    TravelManager:Request(mob.HumanoidRootPart, "Sea2")
                    Attack()
                else
                    TravelManager:Request(CFrame.new(878,122,1235), "Sea2")
                    task.wait(2)
                end
                task.wait(0.1)
            end


            if not _G.State:IsActionValid(myToken) then return end
            if TravelAndWait("Sea2", myToken, CFrame.new(932,13,4482), {timeout=90}) then
                pcall(function() CommF_:InvokeServer("DressrosaQuestProgress","Bartilo") end)
            end
            task.wait(1)


            if not _G.State:IsActionValid(myToken) then return end
            if TravelAndWait("Sea2", myToken, CFrame.new(-12471,374,-7551), {timeout=120}) then
                pcall(function() CommF_:InvokeServer("DressrosaQuestProgress","Door") end)
            end
            task.wait(2)


            -- [FIX-P9] Chỉ teleport sang Sea 2 khi progression hoàn tất + còn sống
            if _G.State:IsActionValid(myToken) and IsAlive() then
                TeleportSvc:Teleport(4442272183, LP)
                _G.State.LastServerHop = os.time()
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Sea2: " .. tostring(err)) end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "UnlockingSea" then
            _G.State:SetMode("Idle")
        end
    end)
    return true
end


function ItemProgression:CheckThirdSea()
    if GetSea() ~= 2 or Level() < 1500 then return false end
    local myToken = _G.State:ClaimAction("Sea3")
    if myToken == 0 then return false end
    _G.State:SetMode("UnlockingSea")
    _G.BobonStatus = "Sea: Unlock 3rd Sea"


    task.spawn(function()
        local ok, err = xpcall(function()
            if not _G.State:IsActionValid(myToken) then return end
            -- [FIX-P9] Verify từng bước trước khi gọi ZQuestProgress
            if TravelAndWait("Sea3", myToken, CFrame.new(-285,306,611), {timeout=90}) then
                pcall(function() CommF_:InvokeServer("ZQuestProgress","Check") end)
            end
            task.wait(1)


            local timeout = os.time()+600
            while _G.State:IsActionValid(myToken) and os.time() < timeout and IsAlive() do
                local boss = FindBoss("Don Swan")
                if boss and boss:FindFirstChild("HumanoidRootPart") and boss.Humanoid.Health > 0 then
                    EquipMelee()
                    TravelManager:Request(boss.HumanoidRootPart, "Sea3")
                    Attack()
                else break end
                task.wait(0.1)
            end
            task.wait(2)


            if not _G.State:IsActionValid(myToken) then return end
            if TravelAndWait("Sea3", myToken, CFrame.new(-285,306,611), {timeout=90}) then
                pcall(function() CommF_:InvokeServer("ZQuestProgress","Begin") end)
            end
            task.wait(2)


            -- [FIX-P9] Chỉ teleport sang Sea 3 khi progression hoàn tất + còn sống
            if _G.State:IsActionValid(myToken) and IsAlive() then
                TeleportSvc:Teleport(7449423635, LP)
                _G.State.LastServerHop = os.time()
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Sea3: " .. tostring(err)) end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "UnlockingSea" then
            _G.State:SetMode("Idle")
        end
    end)
    return true
end


function ItemProgression:RunChecks()
    if not _G.State:CanAct() then return false end
    if self:CheckSaber() then return true end
    if self:CheckPoleV1() then return true end
    if self:CheckSecondSea() then return true end
    if self:CheckThirdSea() then return true end
    return false
end
-- ══════════════════════════════════════════════════════════════════
--              BOSSMANAGER [FIX-1] — SAFE STUB
--   Source hiện tại chưa có boss logic hoàn chỉnh.
--   TryFightBoss() LUÔN return false (boolean) để Main Controller
--   tiếp tục Quest/Farm bình thường.
--   Không bao giờ để nil-index crash Main Controller.
-- ══════════════════════════════════════════════════════════════════
local BossManager = {}
BossManager._BossWarned = false


function BossManager:TryFightBoss()
    if not _G.Settings.BossEnabled then return false end
    if not BossManager._BossWarned then
        BossManager._BossWarned = true
        warn("[BobonHub] Module Info: BossManager chưa có boss logic, return false")
    end
    return false
end


-- ══════════════════════════════════════════════════════════════════
--    MAIN CONTROLLER v16.1 FIXED — SINGLE LOOP
--
--   Priority: Recovery > Sea > Items > Boss > Quest+Farm
--   CHỈ gọi TravelManager:Request(), KHÔNG tự ghi MovementOwner
--   [FIX-2] Mỗi subsystem wrap pcall riêng + warn Module Error,
--           lỗi 1 module không chặn Quest/Farm
--   [FIX-9] Quest sai mob → tự re-request khi tới giver
--   [FIX-10] Chưa có quest → không farm, đi nhận quest trước
--   [FIX-3] Attack dùng khoảng cách XZ (hover trên đầu mob)
--   [FIX-6] FarmTarget invalid/qua xa/dưới biển → clear + về q.MC
-- ══════════════════════════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.15) do
        -- Skip nếu subsystem đang giữ ActionToken
        if _G.State.ActiveActionToken ~= 0 then continue end
        if _G.State.Mode == "Recovering" or _G.State.Mode == "Dead"
            or _G.State.Mode == "Respawning" or _G.State.Mode == "ServerHop" then
            continue
        end
        if not IsAlive() then continue end


        local okMain, mainErr = pcall(function()
            _G.State.Sea = GetSea()


            -- PRIORITY 1: Sea Progression + Important Items
            local okMod, modResult = pcall(function()
                return ItemProgression:RunChecks()
            end)
            if not okMod then
                warn("[BobonHub] Module Error: ItemProgression: " .. tostring(modResult))
            elseif modResult then
                return
            end


            -- PRIORITY 2: Boss
            local okBoss, bossResult = pcall(function()
                return BossManager:TryFightBoss()
            end)
            if not okBoss then
                warn("[BobonHub] Module Error: BossManager: " .. tostring(bossResult))
            elseif bossResult then
                return
            end


            -- PRIORITY 3: Quest + Farm
            local lv = Level()
            local q = GetQ()


            if not q then
                _G.State:SetMode("Idle")
                _G.BobonStatus = "Max Level / No Quest"
                return
            end


            -- ═══ QUEST HANDLING (FIX-P2/P3) ═══
            local hasQuest = HasQuest()
            -- QuestMatches: true = đúng mob | false = sai mob | nil = không đọc được UI.
            -- Lưu ý: dùng `and` (không `or nil`) để giữ giá trị `false` khi quest sai mob.
            local questOk = hasQuest and QuestMatches(q.M)

            if hasQuest and questOk ~= false then
                -- Quest hợp lệ (true) hoặc nil = UI không đọc được nhưng vừa
                -- request gần đây → cho farm trong khoảng grace ngắn
                if questOk == nil then
                    local gNow = os.time()
                    if gNow - _G.State.LastQuestRequest >= _G.Settings.QuestDelay then
                        -- Không đọc được UI lâu → về giver verify lại, KHÔNG farm
                        _G.State:SetMode("GettingQuest")
                        _G.BobonStatus = "Quest: Verify lại " .. q.M
                        local atGiver = HRP() and (HRP().Position - q.QC.Position).Magnitude <= _G.Settings.CloseThreshold
                        if HandleQuestAtGiver(q, atGiver) then
                            return
                        else
                            TravelManager:Request(q.QC, "Farm")
                            return
                        end
                    end
                end
                _G.State.QuestRetries = 0
            else
                -- [FIX-10] Chưa có quest hoặc [FIX-9] quest sai mob:
                -- CHỈ đi lấy/đổi quest, KHÔNG farm
                _G.State:SetMode("GettingQuest")
                local hrp = HRP()
                local atGiver = hrp and (hrp.Position - q.QC.Position).Magnitude <= _G.Settings.CloseThreshold
                if HandleQuestAtGiver(q, atGiver) then
                    return
                else
                    _G.BobonStatus = "Quest: Đi tới " .. q.M
                    TravelManager:Request(q.QC, "Farm")
                    return
                end
            end


            -- ═══ FARM CONTROLLER ═══
            _G.State:SetMode("Farming")


            -- Validate FarmTarget, clear NGAY nếu invalid
            if not _G.State:IsTargetValid(_G.State.FarmTarget) then
                _G.State:ClearTargets()
            end


            if _G.State.FarmTarget then
                local hrp = HRP()
                local targetHRP = _G.State.FarmTarget:FindFirstChild("HumanoidRootPart")
                if not targetHRP then
                    _G.State:ClearTargets()
                elseif hrp then
                    local targetPos = targetHRP.Position
                    local dist = (hrp.Position - targetPos).Magnitude

                    -- [FIX-6] Target quá xa hoặc dưới biển → clear, về khu farm
                    if dist > _G.Settings.MaxFarmDistance + 50
                        or targetPos.Y < _G.Settings.MinY - 10 then
                        _G.State:ClearTargets()
                        _G.BobonStatus = "Farm: Target lỗi, về khu farm"
                        if _G.State:CanRequestTravel() then
                            TravelManager:Request(q.MC, "Farm")
                        end
                        return
                    end

                    -- Target còn sống → KHÔNG restart travel, chỉ update ref
                    -- [FIX-P4] Vẫn truyền fallback=q.MC để giữ an toàn mid-flight
                    if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
                        TravelManager:Request(targetHRP, "Farm", {
                            arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                            fallback = q.MC
                        })
                    else
                        if _G.State:CanRequestTravel() then
                            TravelManager:Request(targetHRP, "Farm", {
                                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                                fallback = q.MC
                            })
                        end
                    end

                    -- [FIX-3] Attack theo khoảng cách XZ (hover phía trên đầu mob)
                    -- [FIX-P5] Chỉ attack khi đã equip melee + target còn sống
                    if _G.State:IsTargetValid(_G.State.FarmTarget) then
                        local flatDist = (Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
                            - Vector3.new(targetPos.X, 0, targetPos.Z)).Magnitude
                        if flatDist <= _G.Settings.AttackRange then
                            if EquipMelee() then
                                Attack()
                            end
                        end
                    end
                end
            else
                -- Không có target → tìm mob mới
                local mob, dist = FindNearestMob(q.M)


                if mob and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    if dist > _G.Settings.MaxFarmDistance then
                        -- Mob quá xa → về khu farm, KHÔNG giữ target xa
                        _G.State:ClearTargets()
                        _G.BobonStatus = "Farm: " .. q.M .. " xa, về khu farm"
                        if _G.State:CanRequestTravel() then
                            TravelManager:Request(q.MC, "Farm")
                        end
                    else
                        _G.State.FarmTarget = mob
                        _G.State.CurrentTarget = mob
                        _G.BobonStatus = "Farm: " .. q.M
                        if _G.State:CanRequestTravel() then
                            TravelManager:Request(mob.HumanoidRootPart, "Farm", {
                                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                                fallback = q.MC
                            })
                        end
                    end
                else
                    _G.BobonStatus = "Farm: Chờ spawn " .. q.M
                    if _G.State:CanRequestTravel() then
                        TravelManager:Request(q.MC, "Farm")
                    end
                end
            end
        end)
        if not okMain then
            warn("[BobonHub] Module Error: MainController: " .. tostring(mainErr))
        end
    end
end)
-- ══════════════════════════════════════════════════════════════════
--              TEAM + HAKI INIT (Fix #14)
-- ══════════════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(3)
    for _ = 1, 6 do
        if LP.Team and LP.Team.Name == "Pirates" then break end
        pcall(function() CommF_:InvokeServer("SetTeam", "Pirates") end)
        task.wait(1.5)
        pcall(function() CommF_:InvokeServer("ChooseTeam", "Pirates") end)
        task.wait(1.5)
    end
    _G.BobonStatus = "Team: Pirates ✓"
    task.wait(0.5)
    pcall(function() CommF_:InvokeServer("Ken", true) end)
    pcall(function() CommF_:InvokeServer("Buso", true) end)
    _G.BobonStatus = "Haki: ON ✓"
    task.wait(0.5)
    _G.State:SetMode("Idle")
end)


task.spawn(function()
    while task.wait(20) do
        pcall(function()
            CommF_:InvokeServer("Ken", true)
            CommF_:InvokeServer("Buso", true)
        end)
    end
end)


-- ══════════════════════════════════════════════════════════════════
--              BACKGROUND SYSTEMS (Fix #15,#16,#17,#18)
--   TUYỆT ĐỐI KHÔNG background loop nào điều khiển movement
--   Remote calls có cooldown/batch limit, không spam
--   pcall wrap mọi remote, lỗi không ảnh hưởng main loop
-- ══════════════════════════════════════════════════════════════════


-- Anti-AFK (Fix #16)
LP.Idled:Connect(function()
    pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
end)


-- Hitbox extender an toàn (Fix #17 / FIX-P6)
-- Chỉ resize khi size thay đổi (tránh physics jitter), CanCollide=false
-- để weapon không làm character stuck. Handle không tồn tại → bỏ qua.
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local c = Char()
            if not c then return end
            for _, tool in ipairs(c:GetChildren()) do
                if tool:IsA("Tool") then
                    local h = tool:FindFirstChild("Handle")
                    if h and h:IsA("BasePart") and h.Parent then
                        if h.Size.X ~= _G.Settings.HitboxSize then
                            h.Size = Vector3.new(_G.Settings.HitboxSize,_G.Settings.HitboxSize,_G.Settings.HitboxSize)
                        end
                        h.Transparency = 1
                        if h.CanCollide then h.CanCollide = false end
                    end
                end
            end
        end)
    end
end)


-- Auto Stats batch limit (Fix #15 / FIX-P7)
-- Giữ batch limit, Points=0 → không làm gì, lỗi remote không ảnh hưởng
-- Farm. KHÔNG tạo ActionToken cho background stat.
task.spawn(function()
    while task.wait(3) do
        if not _G.Settings.AutoStats then continue end
        pcall(function()
            local d = LP:FindFirstChild("Data")
            if not d then return end
            local pts = d:FindFirstChild("Points") and d.Points.Value or 0
            if pts <= 0 then return end
            local batch = math.min(pts, _G.Settings.StatBatchLimit)
            local meleeAdd = math.floor(batch * 0.7)
            local defAdd = batch - meleeAdd
            if meleeAdd > 0 then CommF_:InvokeServer("AddPoint","Melee",meleeAdd) end
            if defAdd > 0 then CommF_:InvokeServer("AddPoint","Defense",defAdd) end
        end)
    end
end)


-- Kill Counter (Fix #18)
local function HookMob(mob)
    if not mob then return end
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
--                   FINAL INITIALIZATION
-- ══════════════════════════════════════════════════════════════════
_G.State.Sea = GetSea()
_G.State.StartTime = os.time()


print("[BobonHub v16.1 FIXED] Full Script Loaded Successfully!")
print("[BobonHub v16.1 FIXED] Architecture: Persistent Travel | ActionToken | Single Owner")
print("[BobonHub v16.1 FIXED] Core: TravelManager(v7+P1) | StateManager(v7) | RecoveryManager(v7+P10)")
print("[BobonHub v16.1 FIXED] Modules: QuestFarm(P2/P3) | BossManager | ItemProgression(P8/P9) | AutoStats")
print("[BobonHub v16.1 FIXED] Audit: 15-Point Fix (Cruise mode, dynamic timeout, quest verify)")
print("[BobonHub v16.1 FIXED] Sea: " .. _G.State.Sea .. " | Level: " .. Level())
