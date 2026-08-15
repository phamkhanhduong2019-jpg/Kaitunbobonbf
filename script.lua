-- =================================================================
--         BOBON HUB v16.3 DATA | STABLE KAITUN BLOX FRUIT
--         Long-Run Stable | Single Movement Owner | ActionToken
--         Base: v15.0 | Version: v16.3 DATA
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
--  [FIX-P12] QDB: cap nhat ten mob + quest + toa do dung cho Sea 1/2/3,
--           bao phu level 1-2800; khong dung lai bang QDB cu bi lech map.
--  [FIX-P13] Main Controller: giu priority Recovery > Sea > Items >
--           Boss > Quest > Farm. Khong tao loop movement khac.
--  [FIX-P14] Error isolation: moi subsystem pcall/xpcall rieng, loi
--           khong chet Main Controller.
--  [FIX-P15] Long-run stability: clean state sau mob chet/player chet/
--           respawn/quest xong/quest sai/travel fail/timeout/target
--           destroy. Khong leak thread/connection.
--
--  AUDIT FIXES v16.2-FIXED (A-1..A-10):
--  [A-1]  TeamController: AutoSelectTeam() — check Player.Team → chưa có
--         → chọn Pirates → verify → retry giới hạn, cooldown 5s,
--         KHÔNG spam remote. Chạy được mọi Sea.
--  [A-2]  EquipmentController: EquipMelee() — scan Character+Backpack,
--         đang cầm → không re-equip, retry cooldown (EquipCooldown),
--         verify tool trên tay, không spam EquipTool mỗi frame.
--  [A-3]  MovementManager: Acquire/Release/IsOwner — API Single Movement
--         Owner. Travel Request=Acquire, Stop/arrival=Release. Farm
--         không override khi TRAVEL giữ; travel xong → trả về Farm.
--  [A-4]  FarmPositionController: farm position PHÍA TRÊN mob (FarmHeight
--         adaptive theo size mob), gom mob: attack mob quest trong
--         MobGatherRadius quanh điểm farm để kéo aggro về cluster.
--  [A-5]  Farm state machine FState (1 loop duy nhất):
--         IDLE→CHECK_CHARACTER→CHECK_SEA→SELECT_TARGET→MOVE_TO_TARGET→
--         ATTACK→VERIFY_TARGET→NEXT_TARGET
--  [A-6]  Attack gating: alive + melee equip + target hợp lệ + Farm giữ
--         movement (owner Farm hoặc không travel) + AttackRange XZ.
--  [A-7]  FarmWatchdog merge vào watchdog DUY NHẤT: light fix trước
--         (travel không tiến → Stop + retry, lightFails đếm), Recovery
--         nặng chỉ khi light fix thất bại ≥3 lần.
--  [A-8]  DEBUG log: Settings.DEBUG=false (mặc định), DLog(tag,msg)
--         [TEAM] [EQUIP] [QUEST] [TARGET] [FARM] [MOVE] [TRAVEL]
--         [ATTACK] [RECOVERY] [STATE]. Tắt → không spam console.
--  [A-9]  Hover farm dùng FarmPositionController (đứng trên đầu mob,
--         không xuyên vào mob, không bay quá cao, clamp MinY).
--  [A-10] Không thêm loop mới: 1 Farm loop + 1 Travel loop + 1 Watchdog
--         + 1 Anti-fall net — mỗi chức năng đúng 1 loop điều khiển.
-- =================================================================


repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
-- Không chờ Character/HRP/Data ở đây: lúc mới execute, ChooseTeam có thể
-- xuất hiện trước character. Chờ các object này ở từng controller để team
-- được chọn ngay lập tức thay vì kẹt vô hạn trong bootstrap.


print("[BobonHub v16.3 DATA] Loading...")


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
if not CommF_ then warn("[BobonHub v16.3 DATA] CommF_ not found!") return end


-- ══════════════════════════════════════════════════════════════════
--                   CONFIG
-- ══════════════════════════════════════════════════════════════════
_G.Settings = {
    -- [A-8] DEBUG log: true = in [TAG] log ra console (không spam khi false)
    DEBUG               = false,
    FarmHeight          = 8,
    FarmOffsetX         = 3,
    HitboxSize          = 50,
    FlySpeed            = 180,
    MinY                = 10,
    -- Submerged Island (Sea 3) dùng tọa độ âm dưới mặt biển.
    UnderwaterMinY      = -2300,
    CloseThreshold      = 35,
    FarmArrivalThreshold= 15,
    -- [A-4] Farm position / gom mob config (điều chỉnh theo game physics)
    MobGatherRadius     = 50,
    TargetRefreshInterval = 0.2,
    PositionRefreshInterval = 0.1,
    -- [A-2] Cooldown retry equip melee (giây)
    EquipCooldown       = 0.5,
    -- [A-1] Cooldown giữa các lần chọn team (giây)
    TeamCooldown        = 5,
    -- [A-7] Watchdog: travel không tiến quá N giây → light fix
    WatchdogStuckThreshold = 25,
    -- Current FastAttack path accepts nearby enemies up to 100 studs.  A
    -- 20-stud gate made cluster farming stop attacking while hovering over
    -- the average position of several mobs, so keep the gate in sync.
    AttackRange         = 100,
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
    AutoRedeemCodes     = true,
    RedeemCodeDelay     = 0.45,
    -- Local-only bring-mob for nearby quest enemies; no extra movement loop.
    GatherMobs          = true,
    -- Optional item failure/timeout must not block level farming forever.
    ItemRetryCooldown   = 300,
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

local function IsUnderwaterY(y)
    return game.PlaceId == 7449423635
        and type(y) == "number" and y <= -100
        and y >= (_G.Settings.UnderwaterMinY or -2300)
end

local function IsAllowedWorldY(y)
    return type(y) == "number"
        and (y >= _G.Settings.MinY - 10 or IsUnderwaterY(y))
end


_G.State = {
    Mode             = "Idle",
    FState           = "IDLE",
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
    if not ok or not IsAllowedWorldY(posY) then return false end
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
    print("[BobonHub v16.3 DATA] UI Ready!")
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
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    return (backpack and backpack:FindFirstChild(name))
        or (Char() and Char():FindFirstChild(name))
end


local function HasQuest()
    local ok, r = pcall(function()
        local main = LP:FindFirstChild("PlayerGui")
            and LP.PlayerGui:FindFirstChild("Main")
        local quest = main and main:FindFirstChild("Quest")
        -- nil means the quest UI is not ready/readable yet.  Do not let the
        -- main controller mistake that transient state for a safe item window.
        if not quest then return nil end
        local function IsDynamicQuestLabel(node)
            if not node:IsA("TextLabel") or not node.Visible then return false end
            local text = tostring(node.Text or "")
            local lower = string.lower(text)
            if text == "" or lower == "quest" or lower == "quest details"
                or lower == "objectives" or lower == "objective" then
                return false
            end
            local nodeName = string.lower(node.Name)
            -- Current UI uses QuestTitle.Title.  Older builds may expose a
            -- label named Task/Objective instead, so accept those explicitly.
            if nodeName:find("title", 1, true)
                or nodeName:find("task", 1, true)
                or nodeName:find("objective", 1, true) then
                return true
            end
            -- Last fallback: quest objectives normally contain a counter or
            -- an action verb; static panel labels do not.
            return lower:find("defeat", 1, true) ~= nil
                or lower:find("kill", 1, true) ~= nil
                or lower:find("collect", 1, true) ~= nil
                or lower:find("bounty", 1, true) ~= nil
                or lower:match("%d+%s*/%s*%d+") ~= nil
        end
        -- The wrapper can stay Visible after a quest is completed.  The
        -- actual state is Quest.Container.QuestTitle.Title.Text; only treat
        -- it as active when that title contains real quest text.
        local container = quest:FindFirstChild("Container") or quest
        local title = container:FindFirstChild("QuestTitle", true)
        local titleText = title and title:FindFirstChild("Title", true)
        if titleText and titleText:IsA("TextLabel") then
            local text = tostring(titleText.Text or "")
            local lower = string.lower(text)
            if text ~= "" and lower ~= "quest" and lower ~= "quest details" then
                return true
            end
        end
        -- Fallback for builds that omit QuestTitle but expose visible labels.
        for _, node in ipairs(container:GetDescendants()) do
            if IsDynamicQuestLabel(node) then return true end
        end
        return false
    end)
    if not ok then return nil end
    return r
end


-- [FIX-P11] Kiểm tra Vector3 hợp lệ (reject NaN / vô hạn)
local function IsValidPos(p)
    return p ~= nil and typeof(p) == "Vector3"
        and p.X == p.X and p.Y == p.Y and p.Z == p.Z
end

-- Enemy models thường có hậu tố "[Lv. n]"; chuẩn hoá để FindNearestMob
-- vẫn tìm được mob ở mọi sea và không bị phụ thuộc tên hiển thị của server.
local function IsEnemyNamed(enemy, wanted)
    if not enemy or not wanted then return false end
    local function normalize(value)
        value = tostring(value):gsub("%s*%[%s*Lv%.%s*%d+%s*%]", "")
        -- Boss models are commonly named `Name [Lv. n] [Boss]` (or
        -- `[Raid Boss]`).  Keep the database names clean and strip those
        -- display-only tags before comparing.
        value = value:gsub("%s*%[%s*Raid%s+Boss%s*%]", "")
        value = value:gsub("%s*%[%s*Boss%s*%]", "")
        value = value:gsub("^%s+", ""):gsub("%s+$", "")
        return string.lower(value)
    end
    return normalize(enemy.Name) == normalize(wanted)
end


-- [A-8] DEBUG log: chỉ in khi _G.Settings.DEBUG = true, không spam console
local function DLog(tag, msg)
    if _G.Settings and _G.Settings.DEBUG then
        print("[" .. tag .. "] " .. msg)
    end
end


-- [FIX-P2] Đọc quest text với nhiều fallback (TextLabel chính + QuestModel)
-- Trả về text đọc được, hoặc nil nếu UI không đọc được.
local function GetQuestText()
    local ok, text = pcall(function()
        local main = LP:FindFirstChild("PlayerGui")
            and LP.PlayerGui:FindFirstChild("Main")
        local quest = main and main:FindFirstChild("Quest")
        if not quest then return nil end
        local container = quest:FindFirstChild("Container") or quest
        local title = container:FindFirstChild("QuestTitle", true)
        local titleText = title and title:FindFirstChild("Title", true)
        if titleText and titleText:IsA("TextLabel") then
            -- When the canonical title exists but is empty, the quest is
            -- genuinely closed; do not resurrect stale descendant labels.
            if titleText.Text == "" then return nil end
            return titleText.Text
        end
        -- Đọc text thực tế từ UI; không dùng tên object QuestModel.
        local parts = {}
        for _, d in ipairs(container:GetDescendants()) do
            if d:IsA("TextLabel") and d.Text and d.Text ~= "" then
                parts[#parts + 1] = d.Text
            end
        end
        if #parts == 0 then return nil end
        return table.concat(parts, " ")
    end)
    if not ok then return nil end
    return text
end


-- [FIX-P2] Kiểm tra quest hiện tại có đúng mob q.M hay không.
-- Trả về: true = khớp, false = sai mob, nil = không đọc được UI.
local function QuestMatches(mobName)
    local text = GetQuestText()
    if not text or not mobName then return nil end
    return string.find(string.lower(text), string.lower(mobName), 1, true) ~= nil
end


-- [FIX-P3] Request quest tại giver với retry có giới hạn, không spam remote.
-- Trả về true = "đã xử lý (đừng farm)", false = "chưa tới giver".
local function HandleQuestAtGiver(q, atGiver)
    if not atGiver then return false end
    local now = tick()
    if now - _G.State.LastQuestRequest < _G.Settings.QuestDelay then
        _G.BobonStatus = "Quest: Chờ xác nhận " .. q.M
        return true
    end
    if _G.State.QuestRetries >= _G.Settings.QuestRetryLimit then
        -- Quá số lần retry → backoff, không spam remote, không farm
        _G.BobonStatus = "Quest: Fail, chờ retry"
        if now - _G.State.LastQuestRequest >= 20 then
            _G.State.QuestRetries = 0
        end
        return true
    end
    _G.State.LastQuestRequest = now
    _G.State.QuestRetries = _G.State.QuestRetries + 1
    DLog("QUEST", "StartQuest " .. q.Q .. " level " .. q.QL)
    -- Dọn quest cũ sai mob trước khi request quest mới; nếu không server sẽ
    -- giữ quest cũ và controller tưởng rằng StartQuest bị lỗi.
    if HasQuest() then
        local currentMatch = QuestMatches(q.M)
        if currentMatch == false then
            pcall(function() CommF_:InvokeServer("AbandonQuest") end)
            task.wait(0.15)
        end
    end
    local function VerifyQuestTitle()
        local deadline = tick() + 3
        repeat
            if QuestMatches(q.M) == true then return true end
            task.wait(0.2)
        until tick() >= deadline
        return false
    end
    -- Remote chuẩn của Blox Fruits là StartQuest. RequestQuest chỉ còn là
    -- fallback cho các server/private build cũ.
    local okRQ = pcall(function()
        CommF_:InvokeServer("StartQuest", q.Q, q.QL)
    end)
    task.wait(0.35)
    local accepted = VerifyQuestTitle()
    if not accepted then
        local okFallback = pcall(function()
            CommF_:InvokeServer("RequestQuest", q.Q, q.QL)
        end)
        okRQ = okRQ or okFallback
        accepted = VerifyQuestTitle()
    end
    if okRQ and accepted then
        _G.BobonStatus = "Quest: Đã gửi " .. q.M
        DLog("QUEST", "Đã gửi: " .. q.M)
    else
        warn("[BobonHub] RequestQuest error (retry " .. _G.State.QuestRetries .. ")")
        _G.BobonStatus = "Quest: Lỗi, retry " .. q.M
        DLog("QUEST", "Lỗi remote (retry " .. _G.State.QuestRetries .. ")")
    end
    return true
end

-- Redeem the current XP-boost starter codes once per execution.  Codes are
-- intentionally isolated from the farm/action token: an expired/rotated code
-- must never pause quest farming, and the server itself decides validity.
local CodeManager = {
    Redeemed = {},
    Codes = {
        "EASTEREXP", "StrawHatMaine", "TantaiGaming", "Bluxxy",
        "SUB2GAMERROBOT_EXP1", "StarcodeHEO", "LIGHTNINGABUSE",
        "Sub2CaptainMaui", "Sub2Fer999", "Enyu_is_Pro", "MagicBUS",
        "JCWK", "Axiore", "KittGaming", "Sub2Daigrock",
        "Sub2NoobMaster123", "Sub2OfficialNoobie", "TheGreatAce",
        -- Utility/reset starter codes are harmless to try alongside XP codes.
        "fudd10", "fudd10_V2", "Chandler", "BIGNEWS", "KITT_RESET",
        "Sub2UncleKizaru", "SUB2GAMERROBOT_RESET1",
    },
}

function CodeManager:Redeem(code)
    if self.Redeemed[code] or not code then return false end
    local ok, result = false, nil
    local redeem = Remotes and Remotes:FindFirstChild("Redeem")
    if redeem and redeem:IsA("RemoteFunction") then
        ok, result = pcall(function() return redeem:InvokeServer(code) end)
    else
        -- Compatibility fallback used by older/private builds.
        ok, result = pcall(function() return CommF_:InvokeServer("Redeem", code) end)
    end
    self.Redeemed[code] = true
    DLog("CODE", code .. " -> " .. tostring(result))
    return ok
end

function CodeManager:RedeemAll()
    if not _G.Settings.AutoRedeemCodes then return end
    for _, code in ipairs(self.Codes) do
        self:Redeem(code)
        task.wait(_G.Settings.RedeemCodeDelay or 0.45)
    end
end

task.spawn(function()
    task.wait(2)
    pcall(function() CodeManager:RedeemAll() end)
end)


local function FastRegisterHit(preferred)
    local net = RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Net")
    local registerAttack = net and net:FindFirstChild("RE/RegisterAttack")
    local registerHit = net and net:FindFirstChild("RE/RegisterHit")
    local me = HRP()
    if not me or not registerAttack or not registerHit then return false end
    local hitList = {}
    local firstPart = nil
    local folder = workspace:FindFirstChild("Enemies")
    if folder then
        for _, enemy in ipairs(folder:GetChildren()) do
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            local head = enemy:FindFirstChild("Head") or root
            if hum and hum.Health > 0 and root and head
                and (root.Position - me.Position).Magnitude <= 100 then
                hitList[#hitList + 1] = {enemy, head}
                if not firstPart and (not preferred or enemy == preferred) then
                    firstPart = head
                end
            end
        end
    end
    if #hitList == 0 then return false end
    firstPart = firstPart or hitList[1][2]
    return pcall(function()
        registerAttack:FireServer(0)
        registerHit:FireServer(firstPart, hitList)
    end)
end

-- Guns use their own LeftClickRemote in current builds.  RegisterHit is for
-- blades/melee; sending it with a gun can silently do nothing, so mirror the
-- current client path and fire a direction for every nearby enemy.
local function FireGunHits(tool, preferred)
    if not tool or not tool:FindFirstChild("LeftClickRemote") then return false end
    local me = HRP()
    local folder = workspace:FindFirstChild("Enemies")
    if not me or not folder then return false end
    local enemies = {}
    local function add(enemy)
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and root
            and (root.Position - me.Position).Magnitude <= 100 then
            enemies[#enemies + 1] = enemy
        end
    end
    if preferred and preferred.Parent then add(preferred) end
    for _, enemy in ipairs(folder:GetChildren()) do
        if enemy ~= preferred then add(enemy) end
    end
    local sent = false
    for _, enemy in ipairs(enemies) do
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if root then
            local direction = (root.Position - me.Position)
            if direction.Magnitude > 0.01 then
                pcall(function()
                    tool.LeftClickRemote:FireServer(direction.Unit, 1)
                end)
                sent = true
            end
        end
    end
    return sent
end

local function Attack(preferredTarget)
    if not IsAlive() then return end
    local now = tick()
    if now - _G.State.LastAttackTime < _G.Settings.AttackDelay then return end
    _G.State.LastAttackTime = now
    pcall(function()
        local c = Char()
        local tool = c and c:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
        -- Update combat path: RegisterAttack/RegisterHit xử lý M1 ở các
        -- client hiện tại ổn định hơn VirtualUser đơn lẻ, đồng thời đánh
        -- được nhiều mob trong cụm ở cả ba Sea.
        if tool and tool:FindFirstChild("LeftClickRemote") then
            FireGunHits(tool, preferredTarget)
        else
            FastRegisterHit(preferredTarget)
        end
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize
        local clickPos = viewport and Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
            or Vector2.new(640, 360)
        VU:CaptureController()
        -- Giữ M1 theo đúng input flow của game; (0,0) thường không được
        -- Roblox coi là click gameplay nên trước đây tool không đánh.
        VU:Button1Down(clickPos)
        VU:Button1Up(clickPos)
        VU:ClickButton1(clickPos)
    end)
end

local function PrepareCombatTarget(target)
    if not target then return end
    local root = target:IsA("BasePart") and target or target:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart") then return end
    pcall(function()
        -- Local hitbox only; avoids relying on a one-frame exact contact while
        -- hovering above enemies and matches the combat flow used by common
        -- Blox Fruits farming sources.
        local size = _G.Settings.HitboxSize
        if size and root.Size.X < size then
            root.Size = Vector3.new(size, size, size)
        end
        root.CanCollide = false
    end)
end


local MeleeList = {
    "Godhuman","Superhuman","Death Step","Electric Claw",
    "Dragon Talon","Sharkman Karate","Dragon Claw",
    "Fishman Karate","Water Kung Fu","Dark Step","Black Leg",
    "Electro","Combat","Sanguine Art"
}


-- [A-2] EQUIPMENT CONTROLLER — melee equip có cooldown + verify
-- [FIX-P5] EquipMelee() trả về true nếu đã có melee trên tay
local EquipmentController = {}
EquipmentController.LastEquip = 0
EquipmentController.LastResult = "none"
EquipmentController.PendingName = nil

local function IsMeleeTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    for _, name in ipairs(MeleeList) do
        if tool.Name == name then return true end
    end
    local ok, tip = pcall(function() return tool.ToolTip end)
    return ok and type(tip) == "string" and string.find(string.lower(tip), "melee", 1, true) ~= nil
end


function EquipmentController:EquipMelee()
    local c = Char()
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if not c or not hum then
        self.LastResult = "noChar"
        return false
    end

    -- Verify pending equip trước khi thử equip lần tiếp theo.
    for _, tool in ipairs(c:GetChildren()) do
        if IsMeleeTool(tool) then
            self.PendingName = tool.Name
            self.LastResult = "holding"
            return true
        end
    end

    -- Cooldown chỉ chặn lệnh EquipTool mới; không chặn việc verify tool.
    local now = tick()
    if now - self.LastEquip < _G.Settings.EquipCooldown then
        self.LastResult = "cooldown"
        return false
    end
    self.LastEquip = now

    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if not backpack then
        self.LastResult = "noBackpack"
        return false
    end
    for _, tool in ipairs(backpack:GetChildren()) do
        if IsMeleeTool(tool) then
            self.PendingName = tool.Name
            local ok = pcall(function() hum:EquipTool(tool) end)
            self.LastResult = ok and "equipping" or "equipError"
            DLog("EQUIP", "Equip request: " .. tool.Name)
            return false
        end
    end
    self.LastResult = "noMelee"
    DLog("EQUIP", "No melee in backpack")
    return false
end


function EquipmentController:GetLastResult()
    return self.LastResult
end


-- Wrapper giữ nguyên API cũ cho ItemProgression (Saber/Sea2/Sea3)
local function EquipMelee()
    return EquipmentController:EquipMelee()
end

-- Weapon fallback: Kaitun luôn ưu tiên melee, sau đó sword rồi gun.
-- Một số style trong Backpack không có ToolTip ổn định, vì vậy dùng cả
-- danh sách tên và nhóm ToolType/ToolTip để nhận diện mà không phụ thuộc UI.
local SwordList = {
    "Cutlass","Katana","Dual Katana","Triple Katana","Iron Mace",
    "Shark Saw","Soul Cane","Bisento","Saber","Pole (1st Form)",
    "Rengoku","Midnight Blade","Yama","Tushita","Buddy Sword",
    "Canvander","Twin Hooks","Spikey Trident","Cursed Dual Katana",
    "Dark Dagger","Hallow Scythe","Shark Anchor","Dragonheart",
}
local GunList = {
    "Slingshot","Musket","Flintlock","Refined Flintlock","Cannon",
    "Kabucha","Venom Bow","Acidum Rifle","Bizarre Rifle","Soul Guitar",
}

local function ToolNameIn(list, tool)
    if not tool or not tool:IsA("Tool") then return false end
    for _, name in ipairs(list) do
        if tool.Name == name then return true end
    end
    return false
end

local function IsSwordTool(tool)
    if ToolNameIn(SwordList, tool) then return true end
    local ok, tip = pcall(function() return tool and tool.ToolTip end)
    tip = ok and type(tip) == "string" and string.lower(tip) or ""
    return string.find(tip, "sword", 1, true) ~= nil
        or string.find(tip, "blade", 1, true) ~= nil
end

local function IsGunTool(tool)
    if ToolNameIn(GunList, tool) then return true end
    local ok, tip = pcall(function() return tool and tool.ToolTip end)
    tip = ok and type(tip) == "string" and string.lower(tip) or ""
    return string.find(tip, "gun", 1, true) ~= nil
        or string.find(tip, "rifle", 1, true) ~= nil
        or string.find(tip, "bow", 1, true) ~= nil
end

local WeaponController = {
    LastEquip = 0,
    LastResult = "none",
}

function WeaponController:IsCombatTool(tool)
    return IsMeleeTool(tool) or IsSwordTool(tool) or IsGunTool(tool)
end

function WeaponController:EquipPreferred()
    local c = Char()
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if not c or not hum then self.LastResult = "noChar"; return false end
    local held = c:FindFirstChildOfClass("Tool")
    if held and self:IsCombatTool(held) then
        self.LastResult = "holding:" .. held.Name
        return true
    end
    local now = tick()
    if now - self.LastEquip < 0.35 then
        self.LastResult = "cooldown"
        return false
    end
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if not backpack then self.LastResult = "noBackpack"; return false end
    local candidate
    -- melee trước để damage/knockback ổn định; nếu không có thì sword/gun.
    for _, tool in ipairs(backpack:GetChildren()) do
        if IsMeleeTool(tool) then candidate = tool; break end
    end
    if not candidate then
        for _, tool in ipairs(backpack:GetChildren()) do
            if IsSwordTool(tool) then candidate = tool; break end
        end
    end
    if not candidate then
        for _, tool in ipairs(backpack:GetChildren()) do
            if IsGunTool(tool) then candidate = tool; break end
        end
    end
    if not candidate then
        -- Combat mặc định của game không nhất thiết là Tool trong Backpack;
        -- vẫn cho phép M1/VirtualUser đánh bằng fists thay vì đứng im.
        self.LastResult = "defaultCombat"
        return true
    end
    self.LastEquip = now
    local ok = pcall(function() hum:EquipTool(candidate) end)
    self.LastResult = ok and "equipping:" .. candidate.Name or "equipError"
    return false
end

local function EquipCombatTool()
    return WeaponController:EquipPreferred()
end


local function FindMob(name)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    local best,bd = nil,math.huge
    local hrp = HRP()
    for _,v in ipairs(folder:GetChildren()) do
        if IsEnemyNamed(v, name) and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0
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
        if IsEnemyNamed(v, name) and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0
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
        if IsEnemyNamed(v, mobName) and v:FindFirstChild("Humanoid") and v.Humanoid.Health>0
            and v:FindFirstChild("HumanoidRootPart") then
            local root = v.HumanoidRootPart
            local ok, pos = pcall(function() return root.Position end)
            if not ok then continue end
            -- [FIX-7] Bo qua mob o duoi bien / vi tri bat thuong
            if not IsAllowedWorldY(pos.Y) then continue end
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
        local ok, p = pcall(function()
            if mobPos:IsA("BasePart") then
                return mobPos.Position
            end
            return mobPos:GetPivot().Position
        end)
        if not ok then return nil end
        mobPos = p
    end
    if not IsValidPos(mobPos) then return nil end
    return Vector3.new(
        mobPos.X + _G.Settings.FarmOffsetX,
        math.max(mobPos.Y + _G.Settings.FarmHeight,
            IsUnderwaterY(mobPos.Y) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY),
        mobPos.Z
    )
end


-- ══════════════════════════════════════════════════════════════════
--   [A-1] TEAM CONTROLLER — AutoSelectTeam()
--   CHECK TEAM → TEAM NIL? → SELECT TEAM → WAIT → VERIFY TEAM
--   Check Player.Team, chưa có → chọn Pirates, verify lại sau 3s,
--   retry giới hạn (MaxRetries), cooldown TeamCooldown(5s) giữa các
--   lần gửi → KHÔNG spam remote. Chạy được ở mọi Sea.
-- ══════════════════════════════════════════════════════════════════
local TeamController = {}
TeamController.LastCheck = 0
TeamController.Retries = 0
TeamController.MaxRetries = 6
TeamController.RetryWindow = 30

local function ClickPiratesChoice()
    local gui = LP:FindFirstChild("PlayerGui")
    if not gui then return false end
    local choose = gui:FindFirstChild("ChooseTeam", true)
    -- UIController của bản game mới xử lý chọn team qua closure thay vì
    -- GuiButton.Activate. Dùng API executor nếu có, nhưng luôn bọc pcall để
    -- bản chạy không có getgc vẫn tiếp tục bằng remote/button fallback.
    local controller = gui:FindFirstChild("UIController", true)
    if choose and choose.Visible and controller
        and type(getgc) == "function"
        and type(getconstants) == "function" and type(getfenv) == "function" then
        local ok = pcall(function()
            for _, fn in ipairs(getgc(true)) do
                if type(fn) == "function" and getfenv(fn).script == controller then
                    local constants = getconstants(fn)
                    if type(constants) == "table" and #constants == 1
                        and constants[1] == "Pirates" then
                        fn("Pirates")
                        return
                    end
                end
            end
        end)
        if ok and LP.Team then return true end
    end
    local pirates = choose and choose:FindFirstChild("Pirates", true)
    local button = pirates and (pirates:IsA("GuiButton") and pirates
        or pirates:FindFirstChildWhichIsA("GuiButton", true))
    -- Một số bản UI đổi Name của button nhưng vẫn giữ Text="Pirates".
    if not button then
        for _, node in ipairs(gui:GetDescendants()) do
            if node:IsA("GuiButton") then
                local ok, txt = pcall(function() return node.Text end)
                if ok and type(txt) == "string"
                    and string.lower(txt):find("pirates", 1, true) then
                    button = node
                    break
                end
            end
        end
    end
    if not button then return false end
    local ok = pcall(function() button.Visible = true; button:Activate() end)
    return ok
end


-- Trả về true khi player ĐÃ có team. Chưa có → gửi lệnh chọn (có
-- cooldown), chưa verify xong → false (main loop gọi lại, không chặn farm).
function TeamController:AutoSelectTeam()
    if LP.Team and LP.Team.Name == "Pirates" then
        self.Retries = 0
        return true
    end
    local now = tick()
    if now - self.LastCheck < _G.Settings.TeamCooldown then return false end
    if now - self.LastCheck > self.RetryWindow then self.Retries = 0 end
    if self.Retries >= self.MaxRetries then
        return false
    end
    self.LastCheck = now
    self.Retries = self.Retries + 1
    DLog("TEAM", "Chưa có team → chọn Pirates (retry " .. self.Retries .. ")")
    -- Ưu tiên nút UI khi ChooseTeam đang mở; một số server không nhận
    -- SetTeam cho tới khi client Activate button trước.
    ClickPiratesChoice()
    local ok, result = pcall(function()
        return CommF_:InvokeServer("SetTeam", "Pirates")
    end)
    if not ok then
        warn("[BobonHub] SetTeam error: " .. tostring(result))
    end
    if not LP.Team then ClickPiratesChoice() end
    -- VERIFY TEAM, không spam thêm remote.
    task.delay(0.75, function()
        if LP.Team then
            self.Retries = 0
            DLog("TEAM", "Verified team: " .. LP.Team.Name)
        end
    end)
    return LP.Team ~= nil
end


-- ══════════════════════════════════════════════════════════════════
--   [A-3] MOVEMENT MANAGER — Single Movement Owner API
--   Chỉ MỘT owner điều khiển movement tại một thời điểm:
--   TRAVEL | FARM | RECOVERY
--   Travel Request → Acquire(owner); Stop/arrival → Release(owner).
--   Farm không override khi TRAVEL đang giữ; travel xong → Farm tiếp.
-- ══════════════════════════════════════════════════════════════════
local MovementManager = {}


function MovementManager:Acquire(owner)
    if _G.State.MovementOwner and _G.State.MovementOwner ~= owner then
        return false
    end
    _G.State.MovementOwner = owner
    return true
end


function MovementManager:Release(owner)
    if not owner or _G.State.MovementOwner == owner then
        _G.State.MovementOwner = nil
    end
end


function MovementManager:IsOwner(owner)
    return _G.State.MovementOwner == owner
end


-- ══════════════════════════════════════════════════════════════════
--   [A-4] FARM POSITION CONTROLLER
--   Farm position: X/Z gần tâm mob, Y phía TRÊN mob (FarmHeight,
--   adaptive theo size mob — mob to thì cao hơn). Không xuyên vào mob,
--   không bay quá cao, clamp MinY (không xuống dưới map).
--   Gom mob: mob quest trong MobGatherRadius quanh điểm farm được
--   đưa về một cluster cục bộ quanh target; mob ở xa không bị chạm tới.
-- ══════════════════════════════════════════════════════════════════
local FarmPositionController = {}


function FarmPositionController:GetFarmPos(mob)
    if not mob then return nil end
    local root = mob:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local ok, pos = pcall(function() return root.Position end)
    if not ok or not IsValidPos(pos) then return nil end
    local extra = 0
    local sizeY = root.Size and root.Size.Y or 0
    if sizeY > 6 then extra = math.min(sizeY - 6, 10) end
    return Vector3.new(
        pos.X + _G.Settings.FarmOffsetX,
        math.max(pos.Y + _G.Settings.FarmHeight + extra,
            IsUnderwaterY(pos.Y) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY),
        pos.Z
    )
end

-- Tâm cụm mob: giữ vị trí ở giữa nhóm thay vì bám một mob đơn lẻ.
-- Cách này hoạt động giống nhau ở cả ba sea và không teleport mob.
function FarmPositionController:GetClusterFarmPos(primary)
    if not primary then return nil end
    local root = primary:FindFirstChild("HumanoidRootPart")
    if not root then return self:GetFarmPos(primary) end
    local ok, origin = pcall(function() return root.Position end)
    if not ok or not IsValidPos(origin) then return self:GetFarmPos(primary) end

    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return self:GetFarmPos(primary) end
    local center = Vector3.zero
    local count = 0
    local wantedName = primary.Name:gsub("%s*%[%s*Lv%.%s*%d+%s*%]$", "")
    for _, mob in ipairs(folder:GetChildren()) do
        local hum = mob:FindFirstChild("Humanoid")
        local mobRoot = mob:FindFirstChild("HumanoidRootPart")
        if IsEnemyNamed(mob, wantedName) and hum and hum.Health > 0 and mobRoot then
            local valid, pos = pcall(function() return mobRoot.Position end)
            if valid and IsValidPos(pos)
                and IsAllowedWorldY(pos.Y)
                and (pos - origin).Magnitude <= _G.Settings.MobGatherRadius then
                center = center + pos
                count = count + 1
            end
        end
    end
    if count == 0 then return self:GetFarmPos(primary) end
    local avg = center / count
    return Vector3.new(
        avg.X + _G.Settings.FarmOffsetX,
        math.max(avg.Y + _G.Settings.FarmHeight,
            IsUnderwaterY(avg.Y) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY),
        avg.Z
    )
end


-- Gom mob: trả về true nếu có mob quest khác trong MobGatherRadius
-- quanh điểm farm (tín hiệu để attack kéo cluster về một khu vực)
function FarmPositionController:HasNearbyMobs(mobName, center)
    local folder = workspace:FindFirstChild("Enemies")
    if not folder or not center then return false end
    for _, v in ipairs(folder:GetChildren()) do
        if IsEnemyNamed(v, mobName) and v:FindFirstChild("Humanoid")
            and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local p = v.HumanoidRootPart.Position
            if IsAllowedWorldY(p.Y)
                and (p - center).Magnitude <= _G.Settings.MobGatherRadius then
                return true
            end
        end
    end
    return false
end

-- Soft local bring-mob: keep only quest mobs already near the selected target
-- in a small cluster.  It does not touch distant enemies or the server map;
-- the existing FastAttack hit list then damages the whole visible group.
function FarmPositionController:GatherMobCluster(mobName, primary)
    if not primary or not mobName then return 0 end
    local primaryRoot = primary:FindFirstChild("HumanoidRootPart")
    local folder = workspace:FindFirstChild("Enemies")
    if not primaryRoot or not folder then return 0 end
    local okOrigin, origin = pcall(function() return primaryRoot.Position end)
    if not okOrigin or not IsValidPos(origin) then return 0 end
    local moved, slot = 0, 0
    for _, mob in ipairs(folder:GetChildren()) do
        local hum = mob:FindFirstChildOfClass("Humanoid")
        local root = mob:FindFirstChild("HumanoidRootPart")
        if mob ~= primary and IsEnemyNamed(mob, mobName) and hum and hum.Health > 0 and root then
            local okPos, mobPos = pcall(function() return root.Position end)
            local offset = okPos and (mobPos - origin) or nil
            if okPos and IsValidPos(mobPos) and IsAllowedWorldY(mobPos.Y)
                and offset.Magnitude <= _G.Settings.MobGatherRadius then
                slot = slot + 1
                local angle = slot * 2.4
                local destination = origin + Vector3.new(math.cos(angle) * 6, 0, math.sin(angle) * 6)
                pcall(function()
                    -- Do not rewrite an already clustered mob every frame;
                    -- this avoids physics jitter while still pulling strays.
                    if offset.Magnitude > 8 then
                        root.CFrame = CFrame.new(destination, origin)
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                        moved = moved + 1
                    end
                    root.CanCollide = false
                end)
            end
        end
    end
    return moved
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
TravelManager.LastEntranceRequest = 0

-- Dùng entrance remote cho các đảo cách nhau quá xa; nếu không, BodyVelocity
-- phải bay xuyên toàn map và dễ lệch/đứng giữa biển ở các điểm chuyển sea.
function TravelManager:MaybeRequestEntrance(targetPos)
    if not IsValidPos(targetPos) then return end
    local now = tick()
    if now - self.LastEntranceRequest < 5 then return end
    local entrance
    if targetPos.Y < -1000 and targetPos.X > 8000 and targetPos.Z > 8000 then
        -- Update 27 Submerged Island: use the live Net remote when present.
        -- If the island is not unlocked, the call safely fails and normal
        -- validation prevents a blind teleport to an invalid fallback.
        local net = RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Net")
        local speak = net and net:FindFirstChild("RF/SubmarineWorkerSpeak")
        local ok = false
        if speak then
            ok = pcall(function() speak:InvokeServer("TravelToSubmergedIsland") end)
        end
        self.LastEntranceRequest = now
        if not ok then DLog("TRAVEL", "Submerged entrance unavailable") end
        return
    elseif targetPos.X > 50000 then
        entrance = Vector3.new(61163.85, 11.68, 1819.78) -- Upper Sky/Fishman
    elseif targetPos.Z > 30000 then
        entrance = Vector3.new(923.21, 126.98, 32852.83) -- Cursed Ship
    elseif targetPos.Y > 5000 and targetPos.X < -7000 then
        entrance = Vector3.new(-7894.62, 5547.14, -380.29) -- Skylands
    elseif targetPos.Y > 700 and targetPos.X < -4000 and targetPos.Z < -1500 then
        entrance = Vector3.new(-4607.82, 872.54, -1667.56) -- Upper Sky
    elseif targetPos.X > 5000 and targetPos.Z < -5000 then
        entrance = Vector3.new(-6508.56, 5000.03, -132.84) -- Ice Castle
    end
    if not entrance then return end
    local ok, err = pcall(function()
        CommF_:InvokeServer("requestEntrance", entrance)
    end)
    self.LastEntranceRequest = now
    if not ok then
        DLog("TRAVEL", "requestEntrance failed: " .. tostring(err))
    end
end


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
    self.ActiveThread = nil
    self.TargetRef = nil
    _G.State.IsTraveling = false
    -- [A-3] Release movement owner qua MovementManager API
    MovementManager:Release()
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
    local targetType = typeof(targetCF)
    if targetType ~= "Instance" and targetType ~= "CFrame" and targetType ~= "Vector3" then
        return false, "InvalidTarget"
    end

    if targetType == "Instance" then
        if not targetCF.Parent then return false, "InvalidTarget" end
        local model = targetCF:IsA("Model") and targetCF
            or targetCF:FindFirstAncestorOfClass("Model")
        local hum = model and model:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then return false, "InvalidTarget" end
        local okPos, pos = pcall(function()
            if targetCF:IsA("BasePart") then return targetCF.Position end
            if targetCF:IsA("Model") then return targetCF:GetPivot().Position end
            return nil
        end)
        if not okPos or (pos and not IsValidPos(pos)) then return false, "InvalidTarget" end
        if pos and not IsAllowedWorldY(pos.Y) then return false, "InvalidTarget" end
    elseif targetType == "CFrame" or targetType == "Vector3" then
        -- [FIX-P11] Reject NaN/invalid position ngay tại Request()
        local pos = typeof(targetCF) == "CFrame" and targetCF.Position or targetCF
        if not IsValidPos(pos) then return false, "InvalidTarget" end
    end


    -- A different owner must never invalidate the active travel token.
    if _G.State.IsTraveling and _G.State.MovementOwner ~= owner then
        return false, "MovementBusy"
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
        if targetType == "CFrame" then
            tpos = targetCF.Position
        elseif targetType == "Vector3" then
            tpos = targetCF
        elseif targetType == "Instance" and targetCF:IsA("BasePart") then
            local ok, p = pcall(function() return targetCF.Position end)
            tpos = ok and p or nil
        end
        if tpos and IsValidPos(tpos) then
            startDist = (startPos - tpos).Magnitude
            if owner == "Farm" and startDist > 10000 then
                self:MaybeRequestEntrance(tpos)
                local refreshed = HRP()
                if refreshed and IsValidPos(refreshed.Position) then
                    startPos = refreshed.Position
                    startDist = (startPos - tpos).Magnitude
                end
            end
        end
    end


    -- Acquire before invalidating any token. This prevents a failed request
    -- from killing the currently active owner and leaving State stuck.
    if not MovementManager:Acquire(owner) then
        return false, "MovementBusy"
    end

    -- New travel: invalidate old via token
    self.CurrentToken = self.CurrentToken + 1
    local myToken = self.CurrentToken


    self:CleanupPhysics(Char())
    self:DisableNoclip()


    _G.State.IsTraveling = true
    _G.State.LastMoveTime = os.time()
    _G.State.LastPosition = HRP() and HRP().Position or nil
    self.TargetRef = targetCF
    DLog("TRAVEL", "Request by " .. owner .. ", dist="
        .. (startDist and string.format("%.0f", startDist) or "?"))


    self.ActiveThread = task.spawn(function()
        -- Travel runs in its own coroutine; isolate unexpected physics/API
        -- errors so IsTraveling can never remain stuck forever.
        local char = Char()
        local threadOk, threadErr = xpcall(function()
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
        local cruiseLogged = false
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
                DLog("TRAVEL", "Timeout by " .. owner)
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
                    -- [A-9] Vị trí farm phía TRÊN đầu mob (adaptive theo size)
                    targetPos = FarmPositionController:GetClusterFarmPos(self.TargetRef.Parent)
                    if not targetPos then
                        targetPos = GetFarmPosition(p)
                    end
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
                if not IsAllowedWorldY(targetPos.Y) then
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
            if targetPos.Y < _G.Settings.MinY and not IsUnderwaterY(targetPos.Y) then
                targetPos = Vector3.new(targetPos.X, _G.Settings.MinY, targetPos.Z)
            end


            local currentPos = root.Position
            if not IsValidPos(currentPos) then currentPos = lastPos end
            local dist = (currentPos - targetPos).Magnitude


            -- [FIX-P1] CRUISE MODE: bay xa qua biển → giữ độ cao an toàn,
            -- chỉ approach target Y thật khi đã gần đảo
            if longTravel and dist > _G.Settings.ApproachThreshold then
                if not cruiseLogged then
                    cruiseLogged = true
                    DLog("TRAVEL", "Cruise mode active → " .. tostring(targetPos))
                end
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
            if currentPos.Y < _G.Settings.MinY and not IsUnderwaterY(targetPos.Y) then
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
                    DLog("TRAVEL", "Stuck by " .. owner)
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
        end, debug.traceback)
        if not threadOk then
            warn("[BobonHub] Module Error: TravelManager: " .. tostring(threadErr))
            if self.CurrentToken == myToken then
                _G.State.IsRecovering = true
            end
        end


        -- Thread exited: only cleanup if still active token
        if self.CurrentToken == myToken then
            pcall(function()
                self:CleanupPhysics(char)
                self:DisableNoclip()
            end)
            _G.State.IsTraveling = false
            _G.State.MovementOwner = nil
            self.ActiveThread = nil
            self.TargetRef = nil
        end
    end)


    return true, myToken
end


-- Haki is enabled once for each character lifetime.  Re-sending `Buso`
-- repeatedly can act like a toggle on some builds, so never run it from a
-- heartbeat/watchdog; reset and re-enable only after CharacterAdded.
local HakiController = {
    Character = nil,
    Enabled = false,
}

function HakiController:Reset()
    self.Character = nil
    self.Enabled = false
end

function HakiController:EnableForCharacter()
    local character = Char()
    if not character or not IsAlive() then return false end
    if self.Character == character and self.Enabled then return true end
    self.Character = character
    self.Enabled = false
    local okBuso = pcall(function() CommF_:InvokeServer("Buso", true) end)
    pcall(function() CommF_:InvokeServer("Ken", true) end)
    self.Enabled = okBuso
    return okBuso
end


-- Death/Respawn handlers
LP.CharacterRemoving:Connect(function()
    HakiController:Reset()
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

        task.wait(0.5)
        HakiController:EnableForCharacter()


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
    local ok = TravelManager:Request(cf, owner, opts)
    if not ok then return false end
    local function ResolvePosition(target)
        local targetType = typeof(target)
        if targetType == "CFrame" then return target.Position end
        if targetType == "Vector3" then return target end
        if targetType == "Instance" then
            local success, position = pcall(function()
                if target:IsA("BasePart") then return target.Position end
                if target:IsA("Model") then return target:GetPivot().Position end
            end)
            if success then return position end
        end
        return nil
    end
    local destination = ResolvePosition(cf)
    if not IsValidPos(destination) then return false end
    local hrp = HRP()
    local thresh = opts.arrivalThreshold or _G.Settings.CloseThreshold
    local timeout = os.time() + (opts.timeout or 60)
    local arrived = false
    while _G.State:IsActionValid(token) and IsAlive() and os.time() < timeout do
        hrp = HRP()
        if hrp and (hrp.Position - destination).Magnitude <= thresh then
            arrived = true
            break
        end
        task.wait(0.5)
    end
    if not arrived then return false end
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
    DLog("RECOVERY", "Handle: " .. reason)


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


-- [A-7] FARMWATCHDOG — watchdog DUY NHẤT cho recovery + farm
-- Light fix TRƯỚC (travel không tiến → Stop + để main loop retry,
-- đếm lightFails), chỉ Recovery nặng khi light fix không giải quyết
-- được sau ≥3 lần. Không trigger khi Dead/Respawning (respawn tự xử lý).
task.spawn(function()
    local lightFails = 0
    while task.wait(5) do
        pcall(function()
            -- Trigger recovery nặng từ TravelManager (stuck/timeout/crash)
            if _G.State.IsRecovering
                and _G.State.Mode ~= "Recovering"
                and _G.State.Mode ~= "Dead"
                and _G.State.Mode ~= "Respawning" then
                RecoveryManager:Handle("StuckOrTimeout")
                return
            end
            -- Chỉ watchdog light khi đang Farm + còn sống
            if _G.State.Mode ~= "Farming" then return end
            if not IsAlive() then return end
            -- LIGHT 1: travel đang chạy nhưng không tiến → Stop, để main
            -- loop request lại (không recovery nặng ngay)
            if _G.State.IsTraveling and _G.State.MovementOwner then
                if os.time() - _G.State.LastMoveTime > _G.Settings.WatchdogStuckThreshold then
                    lightFails = lightFails + 1
                    DLog("RECOVERY", "Travel không tiến (" .. lightFails .. " lần) → Stop + retry")
                    _G.BobonStatus = "Watchdog: Travel không tiến, retry"
                    TravelManager:Stop("WatchdogStuck")
                    if lightFails >= 3 then
                        lightFails = 0
                        RecoveryManager:Handle("WatchdogStuck")
                    end
                end
            end
            -- LIGHT 2: melee mất → re-equip (EquipmentController có cooldown,
            -- không spam)
            local eq = EquipmentController:EquipMelee()
            if eq and EquipmentController:GetLastResult() == "equipped" then
                DLog("RECOVERY", "Light fix: re-equip melee")
            end
            -- LIGHT 3: target chết/mất → main loop tự clear + chọn mới
            -- (không cần làm gì thêm ở đây, tránh duplicate logic)
        end)
    end
end)


-- ══════════════════════════════════════════════════════════════════
--          QUEST DATABASE v16.3 (SEA 1/2/3 COORDINATES)
-- ══════════════════════════════════════════════════════════════════
local QDB = {
    {Min=1,Max=9,Q="BanditQuest1",M="Bandit",QL=1,QC=CFrame.new(1059.37,15.45,1550.42),MC=CFrame.new(1045.96,27.00,1560.82)},
    {Min=10,Max=14,Q="JungleQuest",M="Monkey",QL=1,QC=CFrame.new(-1598.09,35.55,153.38),MC=CFrame.new(-1448.52,67.85,11.47)},
    {Min=15,Max=29,Q="JungleQuest",M="Gorilla",QL=2,QC=CFrame.new(-1598.09,35.55,153.38),MC=CFrame.new(-1129.88,40.46,-525.42)},
    {Min=30,Max=39,Q="BuggyQuest1",M="Pirate",QL=1,QC=CFrame.new(-1141.07,4.10,3831.55),MC=CFrame.new(-1103.51,13.75,3896.09)},
    {Min=40,Max=59,Q="BuggyQuest1",M="Brute",QL=2,QC=CFrame.new(-1141.07,4.10,3831.55),MC=CFrame.new(-1140.08,14.81,4322.92)},
    {Min=60,Max=74,Q="DesertQuest",M="Desert Bandit",QL=1,QC=CFrame.new(894.49,5.14,4392.43),MC=CFrame.new(924.80,6.45,4481.59)},
    {Min=75,Max=89,Q="DesertQuest",M="Desert Officer",QL=2,QC=CFrame.new(894.49,5.14,4392.43),MC=CFrame.new(1608.28,8.61,4371.01)},
    {Min=90,Max=99,Q="SnowQuest",M="Snow Bandit",QL=1,QC=CFrame.new(1389.74,88.15,-1298.91),MC=CFrame.new(1354.35,87.27,-1393.95)},
    {Min=100,Max=119,Q="SnowQuest",M="Snowman",QL=2,QC=CFrame.new(1389.74,88.15,-1298.91),MC=CFrame.new(1201.64,144.58,-1550.07)},
    {Min=120,Max=149,Q="MarineQuest2",M="Chief Petty Officer",QL=1,QC=CFrame.new(-5039.59,27.35,4324.68),MC=CFrame.new(-4881.23,22.65,4273.75)},
    {Min=150,Max=174,Q="SkyQuest",M="Sky Bandit",QL=1,QC=CFrame.new(-4839.53,716.37,-2619.44),MC=CFrame.new(-4953.21,295.74,-2899.23)},
    {Min=175,Max=189,Q="SkyQuest",M="Dark Master",QL=2,QC=CFrame.new(-4839.53,716.37,-2619.44),MC=CFrame.new(-5259.84,391.40,-2229.04)},
    {Min=190,Max=209,Q="PrisonerQuest",M="Prisoner",QL=1,QC=CFrame.new(5308.93,1.66,475.12),MC=CFrame.new(5098.97,-0.32,474.24)},
    {Min=210,Max=249,Q="PrisonerQuest",M="Dangerous Prisoner",QL=2,QC=CFrame.new(5308.93,1.66,475.12),MC=CFrame.new(5654.56,15.63,866.30)},
    {Min=250,Max=274,Q="ColosseumQuest",M="Toga Warrior",QL=1,QC=CFrame.new(-1580.05,6.35,-2986.48),MC=CFrame.new(-1820.21,51.68,-2740.67)},
    {Min=275,Max=299,Q="ColosseumQuest",M="Gladiator",QL=2,QC=CFrame.new(-1580.05,6.35,-2986.48),MC=CFrame.new(-1292.84,56.38,-3339.03)},
    {Min=300,Max=324,Q="MagmaQuest",M="Military Soldier",QL=1,QC=CFrame.new(-5313.37,10.95,8515.29),MC=CFrame.new(-5411.16,11.08,8454.29)},
    {Min=325,Max=374,Q="MagmaQuest",M="Military Spy",QL=2,QC=CFrame.new(-5313.37,10.95,8515.29),MC=CFrame.new(-5802.87,86.26,8828.86)},
    {Min=375,Max=399,Q="FishmanQuest",M="Fishman Warrior",QL=1,QC=CFrame.new(61122.65,18.50,1569.40),MC=CFrame.new(60878.30,18.48,1543.76)},
    {Min=400,Max=449,Q="FishmanQuest",M="Fishman Commando",QL=2,QC=CFrame.new(61122.65,18.50,1569.40),MC=CFrame.new(61922.63,18.48,1493.93)},
    {Min=450,Max=474,Q="SkyExp1Quest",M="God's Guard",QL=1,QC=CFrame.new(-4721.89,843.87,-1949.97),MC=CFrame.new(-4710.04,845.28,-1927.31)},
    {Min=475,Max=524,Q="SkyExp1Quest",M="Shanda",QL=2,QC=CFrame.new(-7859.10,5544.19,-381.48),MC=CFrame.new(-7678.49,5566.40,-497.22)},
    {Min=525,Max=549,Q="SkyExp2Quest",M="Royal Squad",QL=1,QC=CFrame.new(-7906.82,5634.66,-1411.99),MC=CFrame.new(-7624.25,5658.13,-1467.35)},
    {Min=550,Max=624,Q="SkyExp2Quest",M="Royal Soldier",QL=2,QC=CFrame.new(-7906.82,5634.66,-1411.99),MC=CFrame.new(-7836.75,5645.66,-1790.62)},
    {Min=625,Max=649,Q="FountainQuest",M="Galley Pirate",QL=1,QC=CFrame.new(5259.82,37.35,4050.03),MC=CFrame.new(5551.02,78.90,3930.41)},
    {Min=650,Max=699,Q="FountainQuest",M="Galley Captain",QL=2,QC=CFrame.new(5259.82,37.35,4050.03),MC=CFrame.new(5441.95,42.50,4950.09)},

    {Min=700,Max=724,Q="Area1Quest",M="Raider",QL=1,QC=CFrame.new(-429.54,71.77,1836.18),MC=CFrame.new(-728.33,52.78,2345.77)},
    {Min=725,Max=774,Q="Area1Quest",M="Mercenary",QL=2,QC=CFrame.new(-429.54,71.77,1836.18),MC=CFrame.new(-1004.32,80.16,1424.62)},
    {Min=775,Max=799,Q="Area2Quest",M="Swan Pirate",QL=1,QC=CFrame.new(638.44,71.77,918.28),MC=CFrame.new(1068.66,137.61,1322.11)},
    {Min=800,Max=874,Q="Area2Quest",M="Factory Staff",QL=2,QC=CFrame.new(632.70,73.11,918.67),MC=CFrame.new(73.08,81.86,-27.47)},
    {Min=875,Max=899,Q="MarineQuest3",M="Marine Lieutenant",QL=1,QC=CFrame.new(-2440.80,71.71,-3216.07),MC=CFrame.new(-2821.37,75.90,-3070.09)},
    {Min=900,Max=949,Q="MarineQuest3",M="Marine Captain",QL=2,QC=CFrame.new(-2440.80,71.71,-3216.07),MC=CFrame.new(-1861.23,80.18,-3254.70)},
    {Min=950,Max=974,Q="ZombieQuest",M="Zombie",QL=1,QC=CFrame.new(-5497.06,47.59,-795.24),MC=CFrame.new(-5657.78,78.97,-928.69)},
    {Min=975,Max=999,Q="ZombieQuest",M="Vampire",QL=2,QC=CFrame.new(-5497.06,47.59,-795.24),MC=CFrame.new(-6037.67,32.18,-1340.66)},
    {Min=1000,Max=1049,Q="SnowMountainQuest",M="Snow Trooper",QL=1,QC=CFrame.new(609.86,400.12,-5372.26),MC=CFrame.new(549.15,427.39,-5563.70)},
    {Min=1050,Max=1099,Q="SnowMountainQuest",M="Winter Warrior",QL=2,QC=CFrame.new(609.86,400.12,-5372.26),MC=CFrame.new(1142.75,475.64,-5199.42)},
    {Min=1100,Max=1124,Q="IceSideQuest",M="Lab Subordinate",QL=1,QC=CFrame.new(-6064.07,15.24,-4902.98),MC=CFrame.new(-5707.47,15.95,-4513.39)},
    {Min=1125,Max=1174,Q="IceSideQuest",M="Horned Warrior",QL=2,QC=CFrame.new(-6064.07,15.24,-4902.98),MC=CFrame.new(-6341.37,15.95,-5723.16)},
    {Min=1175,Max=1199,Q="FireSideQuest",M="Magma Ninja",QL=1,QC=CFrame.new(-5428.03,15.06,-5299.43),MC=CFrame.new(-5449.67,76.66,-5808.20)},
    {Min=1200,Max=1249,Q="FireSideQuest",M="Lava Pirate",QL=2,QC=CFrame.new(-5428.03,15.06,-5299.43),MC=CFrame.new(-5213.33,49.74,-4701.45)},
    {Min=1250,Max=1274,Q="ShipQuest1",M="Ship Deckhand",QL=1,QC=CFrame.new(1037.80,125.09,32911.60),MC=CFrame.new(1212.01,150.79,33059.25)},
    {Min=1275,Max=1299,Q="ShipQuest1",M="Ship Engineer",QL=2,QC=CFrame.new(1037.80,125.09,32911.60),MC=CFrame.new(919.48,43.54,32779.97)},
    {Min=1300,Max=1324,Q="ShipQuest2",M="Ship Steward",QL=1,QC=CFrame.new(968.81,125.09,33244.13),MC=CFrame.new(919.44,129.56,33436.04)},
    {Min=1325,Max=1349,Q="ShipQuest2",M="Ship Officer",QL=2,QC=CFrame.new(968.81,125.09,33244.13),MC=CFrame.new(1036.02,181.44,33315.73)},
    {Min=1350,Max=1374,Q="FrostQuest",M="Arctic Warrior",QL=1,QC=CFrame.new(5667.66,26.80,-6486.09),MC=CFrame.new(5966.25,62.97,-6179.38)},
    {Min=1375,Max=1424,Q="FrostQuest",M="Snow Lurker",QL=2,QC=CFrame.new(5667.66,26.80,-6486.09),MC=CFrame.new(5407.07,69.19,-6880.88)},
    {Min=1425,Max=1449,Q="ForgottenQuest",M="Sea Soldier",QL=1,QC=CFrame.new(-3054.44,235.54,-10142.82),MC=CFrame.new(-3028.22,64.67,-9775.43)},
    {Min=1450,Max=1499,Q="ForgottenQuest",M="Water Fighter",QL=2,QC=CFrame.new(-3054.44,235.54,-10142.82),MC=CFrame.new(-3352.90,285.02,-10534.84)},

    {Min=1500,Max=1524,Q="PiratePortQuest",M="Pirate Millionaire",QL=1,QC=CFrame.new(-450.10,107.68,5950.73),MC=CFrame.new(-246.00,47.31,5584.10)},
    {Min=1525,Max=1574,Q="PiratePortQuest",M="Pistol Billionaire",QL=2,QC=CFrame.new(-450.10,107.68,5950.73),MC=CFrame.new(-54.81,83.77,5947.84)},
    {Min=1575,Max=1599,Q="DragonCrewQuest",M="Dragon Crew Warrior",QL=1,QC=CFrame.new(6750.49,127.45,-711.03),MC=CFrame.new(6709.76,52.34,-1139.03)},
    {Min=1600,Max=1624,Q="DragonCrewQuest",M="Dragon Crew Archer",QL=2,QC=CFrame.new(6750.49,127.45,-711.03),MC=CFrame.new(6668.76,481.38,329.12)},
    {Min=1625,Max=1649,Q="VenomCrewQuest",M="Hydra Enforcer",QL=1,QC=CFrame.new(5206.40,1004.10,748.35),MC=CFrame.new(4547.12,1003.10,334.19)},
    {Min=1650,Max=1699,Q="VenomCrewQuest",M="Venomous Assailant",QL=2,QC=CFrame.new(5206.40,1004.10,748.35),MC=CFrame.new(4674.93,1134.83,996.31)},
    {Min=1700,Max=1724,Q="MarineTreeIsland",M="Marine Commodore",QL=1,QC=CFrame.new(2481.09,74.27,-6779.64),MC=CFrame.new(2577.25,75.61,-7739.87)},
    {Min=1725,Max=1774,Q="MarineTreeIsland",M="Marine Rear Admiral",QL=2,QC=CFrame.new(2481.09,74.27,-6779.64),MC=CFrame.new(3761.81,123.91,-6823.52)},
    {Min=1775,Max=1799,Q="DeepForestIsland3",M="Fishman Raider",QL=1,QC=CFrame.new(-10581.66,330.87,-8761.19),MC=CFrame.new(-10407.53,331.76,-8368.52)},
    {Min=1800,Max=1824,Q="DeepForestIsland3",M="Fishman Captain",QL=2,QC=CFrame.new(-10581.66,330.87,-8761.19),MC=CFrame.new(-10994.70,352.38,-9002.11)},
    {Min=1825,Max=1849,Q="DeepForestIsland",M="Forest Pirate",QL=1,QC=CFrame.new(-13234.04,331.49,-7625.40),MC=CFrame.new(-13274.48,332.38,-7769.58)},
    {Min=1850,Max=1899,Q="DeepForestIsland",M="Mythological Pirate",QL=2,QC=CFrame.new(-13234.04,331.49,-7625.40),MC=CFrame.new(-13680.61,501.08,-6991.19)},
    {Min=1900,Max=1924,Q="DeepForestIsland2",M="Jungle Pirate",QL=1,QC=CFrame.new(-12680.38,389.97,-9902.02),MC=CFrame.new(-12256.16,331.74,-10485.84)},
    {Min=1925,Max=1974,Q="DeepForestIsland2",M="Musketeer Pirate",QL=2,QC=CFrame.new(-12680.38,389.97,-9902.02),MC=CFrame.new(-13457.90,391.55,-9859.18)},
    {Min=1975,Max=1999,Q="HauntedQuest1",M="Reborn Skeleton",QL=1,QC=CFrame.new(-9479.22,141.22,5566.09),MC=CFrame.new(-8763.72,165.72,6159.86)},
    {Min=2000,Max=2024,Q="HauntedQuest1",M="Living Zombie",QL=2,QC=CFrame.new(-9479.22,141.22,5566.09),MC=CFrame.new(-10144.13,138.63,5838.09)},
    {Min=2025,Max=2049,Q="HauntedQuest2",M="Demonic Soul",QL=1,QC=CFrame.new(-9516.99,172.02,6078.47),MC=CFrame.new(-9505.87,172.10,6158.99)},
    -- The in-game typo is intentionally `Posessed Mummy` (one s).
    {Min=2050,Max=2074,Q="HauntedQuest2",M="Posessed Mummy",QL=2,QC=CFrame.new(-9516.99,172.02,6078.47),MC=CFrame.new(-9582.02,6.25,6205.48)},
    {Min=2075,Max=2099,Q="NutsIslandQuest",M="Peanut Scout",QL=1,QC=CFrame.new(-2104.39,38.10,-10194.22),MC=CFrame.new(-2143.24,47.72,-10029.99)},
    {Min=2100,Max=2124,Q="NutsIslandQuest",M="Peanut President",QL=2,QC=CFrame.new(-2104.39,38.10,-10194.22),MC=CFrame.new(-1859.35,38.10,-10422.43)},
    {Min=2125,Max=2149,Q="IceCreamIslandQuest",M="Ice Cream Chef",QL=1,QC=CFrame.new(-820.65,65.82,-10965.80),MC=CFrame.new(-872.25,65.82,-10919.96)},
    {Min=2150,Max=2199,Q="IceCreamIslandQuest",M="Ice Cream Commander",QL=2,QC=CFrame.new(-820.65,65.82,-10965.80),MC=CFrame.new(-558.06,112.05,-11290.77)},
    {Min=2200,Max=2224,Q="CakeQuest1",M="Cookie Crafter",QL=1,QC=CFrame.new(-2021.32,37.80,-12028.73),MC=CFrame.new(-2374.14,37.80,-12125.31)},
    {Min=2225,Max=2249,Q="CakeQuest1",M="Cake Guard",QL=2,QC=CFrame.new(-2021.32,37.80,-12028.73),MC=CFrame.new(-1598.31,43.77,-12244.58)},
    {Min=2250,Max=2274,Q="CakeQuest2",M="Baking Staff",QL=1,QC=CFrame.new(-1927.92,37.80,-12842.54),MC=CFrame.new(-1887.81,77.62,-12998.35)},
    {Min=2275,Max=2299,Q="CakeQuest2",M="Head Baker",QL=2,QC=CFrame.new(-1927.92,37.80,-12842.54),MC=CFrame.new(-2216.19,82.88,-12869.29)},
    {Min=2300,Max=2324,Q="ChocQuest1",M="Cocoa Warrior",QL=1,QC=CFrame.new(233.23,29.88,-12201.23),MC=CFrame.new(-21.55,80.57,-12352.39)},
    {Min=2325,Max=2349,Q="ChocQuest1",M="Chocolate Bar Battler",QL=2,QC=CFrame.new(233.23,29.88,-12201.23),MC=CFrame.new(582.59,77.19,-12463.16)},
    {Min=2350,Max=2374,Q="ChocQuest2",M="Sweet Thief",QL=1,QC=CFrame.new(150.51,30.69,-12774.50),MC=CFrame.new(165.19,76.06,-12600.84)},
    {Min=2375,Max=2399,Q="ChocQuest2",M="Candy Rebel",QL=2,QC=CFrame.new(150.51,30.69,-12774.50),MC=CFrame.new(134.87,77.25,-12876.55)},
    {Min=2400,Max=2424,Q="CandyQuest1",M="Candy Pirate",QL=1,QC=CFrame.new(-1150.04,20.38,-14446.33),MC=CFrame.new(-1310.50,26.02,-14562.40)},
    {Min=2425,Max=2449,Q="CandyQuest1",M="Snow Demon",QL=2,QC=CFrame.new(-1150.04,20.38,-14446.33),MC=CFrame.new(-880.20,71.25,-14538.61)},
    {Min=2450,Max=2474,Q="TikiQuest1",M="Isle Outlaw",QL=1,QC=CFrame.new(-16547.75,61.14,-173.41),MC=CFrame.new(-16442.81,116.14,-264.46)},
    {Min=2475,Max=2524,Q="TikiQuest1",M="Island Boy",QL=2,QC=CFrame.new(-16547.75,61.14,-173.41),MC=CFrame.new(-16901.26,84.07,-192.89)},
    {Min=2525,Max=2549,Q="TikiQuest2",M="Isle Champion",QL=2,QC=CFrame.new(-16539.08,55.69,1051.57),MC=CFrame.new(-16641.68,235.78,1031.28)},
    {Min=2550,Max=2574,Q="TikiQuest3",M="Serpent Hunter",QL=1,QC=CFrame.new(-16665.19,104.60,1579.69),MC=CFrame.new(-16521.06,106.09,1488.78)},
    {Min=2575,Max=2599,Q="TikiQuest3",M="Skull Slayer",QL=2,QC=CFrame.new(-16665.19,104.60,1579.69),MC=CFrame.new(-16855.04,122.46,1478.15)},
    -- Update 27.0+ Submerged Island (tọa độ âm là chủ ý, không clamp lên mặt biển).
    {Min=2600,Max=2624,Q="SubmergedQuest1",M="Reef Bandit",QL=1,QC=CFrame.new(10778.875,-2087.724,9265.184),MC=CFrame.new(11019.132,-2146.068,9342.392)},
    {Min=2625,Max=2649,Q="SubmergedQuest1",M="Coral Pirate",QL=2,QC=CFrame.new(10778.875,-2087.724,9265.184),MC=CFrame.new(10808.601,-2030.361,9364.233)},
    {Min=2650,Max=2674,Q="SubmergedQuest2",M="Sea Chanter",QL=1,QC=CFrame.new(10880.686,-2086.200,10032.624),MC=CFrame.new(10671.272,-2057.592,10047.258)},
    {Min=2675,Max=2699,Q="SubmergedQuest2",M="Ocean Prophet",QL=2,QC=CFrame.new(10880.686,-2086.200,10032.624),MC=CFrame.new(11008.520,-2007.728,10223.079)},
    {Min=2700,Max=2724,Q="SubmergedQuest3",M="High Disciple",QL=1,QC=CFrame.new(9640.088,-1992.445,9613.652),MC=CFrame.new(9750.416,-1966.939,9753.360)},
    {Min=2725,Max=2800,Q="SubmergedQuest3",M="Grand Devotee",QL=2,QC=CFrame.new(9640.088,-1992.445,9613.652),MC=CFrame.new(9611.705,-1993.471,9882.688)},
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
ItemProgression.NextOptional = {
    Saber = 0,
    PoleV1 = 0,
}

function ItemProgression:OptionalReady(name)
    return tick() >= (self.NextOptional[name] or 0)
end

function ItemProgression:DelayOptional(name)
    self.NextOptional[name] = tick() + (_G.Settings.ItemRetryCooldown or 300)
end

-- Catalog item progression. Những mục có puzzle/điều kiện server phức tạp
-- được đánh dấu Manual để controller không gọi remote đoán mò làm mất tài nguyên.
-- BossDrop sẽ tự được BossManager săn khi boss xuất hiện trong Enemies.
local ItemCatalog = {
    {Name="Saber",Sea=1,MinLevel=200,Method="Puzzle+Boss",Auto="CheckSaber"},
    {Name="Pole (1st Form)",Sea=1,MinLevel=150,Method="Thunder God drop/purchase",Auto="CheckPoleV1"},
    {Name="Rengoku",Sea=2,MinLevel=1100,Method="Hidden Key + Awakened Ice Admiral",Auto="BossDrop"},
    {Name="Midnight Blade",Sea=2,MinLevel=1000,Method="Cursed Ship dealer",Auto="Manual"},
    {Name="Buddy Sword",Sea=3,MinLevel=2000,Method="Cake Queen drop",Auto="BossDrop"},
    {Name="Yama",Sea=3,MinLevel=1500,Method="Elite Hunter bounty quest",Auto="Manual"},
    {Name="Tushita",Sea=3,MinLevel=1500,Method="rip_indra puzzle + boss",Auto="Manual"},
    {Name="Cursed Dual Katana",Sea=3,MinLevel=2200,Method="Scroll quests",Auto="Manual"},
    {Name="Kabucha",Sea=2,MinLevel=700,Method="Sick Scientist + fragments",Auto="Manual"},
    {Name="Acidum Rifle",Sea=2,MinLevel=700,Method="Factory materials",Auto="Manual"},
    {Name="Soul Guitar",Sea=3,MinLevel=2300,Method="Soul Guitar puzzle",Auto="Manual"},
    {Name="Godhuman",Sea=3,MinLevel=1500,Method="mastery + materials",Auto="Manual"},
    {Name="Sanguine Art",Sea=3,MinLevel=2400,Method="Sanguine teacher + materials",Auto="Manual"},
}

function ItemProgression:GetMissingCatalog()
    local missing = {}
    for _, item in ipairs(ItemCatalog) do
        if Level() >= item.MinLevel and not HasItem(item.Name) then
            missing[#missing + 1] = item
        end
    end
    return missing
end


function ItemProgression:CheckSaber()
    if not _G.Settings.AutoItems then return false end
    if HasItem("Saber") or Level() < 200 or GetSea() ~= 1 then return false end
    if not self:OptionalReady("Saber") then return false end
    local myToken = _G.State:ClaimAction("Saber")
    if myToken == 0 then return false end
    self:DelayOptional("Saber")
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
                    PrepareCombatTarget(boss)
                    EquipMelee()
                    TravelManager:Request(boss.HumanoidRootPart, "Saber")
                    Attack(boss)
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
    if not self:OptionalReady("PoleV1") then return false end
    local myToken = _G.State:ClaimAction("PoleV1")
    if myToken == 0 then return false end
    self:DelayOptional("PoleV1")
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
                    PrepareCombatTarget(mob)
                    EquipMelee()
                    TryCount(mob)
                    TravelManager:Request(mob.HumanoidRootPart, "Sea2")
                    Attack(mob)
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
                    PrepareCombatTarget(boss)
                    EquipMelee()
                    TravelManager:Request(boss.HumanoidRootPart, "Sea3")
                    Attack(boss)
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


-- Progression is deliberately a *farm-window* operation.  A valid quest is
-- never interrupted by an optional item or boss; Sea 2/3 and item checks run
-- only after the current quest is finished (or before the first quest).
-- `allowSea` also accepts a wrong quest so the level-700/1500 sea gate cannot
-- accidentally send the player to a next-sea quest before unlocking it.
function ItemProgression:RunChecks(allowSea, allowOptional)
    if not allowSea or not _G.State:CanAct() then return false end
    -- Sea changes are mandatory gates, so they run before optional items.
    if self:CheckSecondSea() then return true end
    if self:CheckThirdSea() then return true end
    if not allowOptional then return false end
    if self:CheckSaber() then return true end
    if self:CheckPoleV1() then return true end
    return false
end
-- ══════════════════════════════════════════════════════════════════
--              BOSSMANAGER v16.3 — DATA-DRIVEN
--   Boss không dùng tọa độ cứng để tránh bay ra biển khi map thay đổi.
--   Bộ điều khiển chỉ nhận boss đang thật sự tồn tại trong workspace.Enemies,
--   lọc theo Sea/level, rồi dùng cùng TravelManager + ActionToken với Farm.
--   Vì vậy boss chết/despawn giữa đường sẽ tự nhả movement và quay lại farm.
-- ══════════════════════════════════════════════════════════════════
local BossManager = {
    Active = false,
    ActiveName = nil,
    LastKill = 0,
    LastScan = 0,
}

-- Tên được chuẩn hoá bởi IsEnemyNamed() nên vẫn khớp hậu tố [Lv. ...].
-- MinLevel chỉ là ngưỡng an toàn; việc boss có spawn hay không luôn kiểm tra
-- bằng instance sống trong Enemies trước khi di chuyển.
local BossDatabase = {
    -- Sea 1
    {N="Gorilla King",Sea=1,MinLevel=20}, {N="Bobby",Sea=1,MinLevel=55},
    {N="The Saw",Sea=1,MinLevel=100}, {N="Mob Leader",Sea=1,MinLevel=120},
    {N="Vice Admiral",Sea=1,MinLevel=130}, {N="Saber Expert",Sea=1,MinLevel=200},
    {N="Warden",Sea=1,MinLevel=220}, {N="Chief Warden",Sea=1,MinLevel=230},
    {N="Magma Admiral",Sea=1,MinLevel=350}, {N="Fishman Lord",Sea=1,MinLevel=425},
    {N="Wysper",Sea=1,MinLevel=500}, {N="Thunder God",Sea=1,MinLevel=575},
    {N="Cyborg",Sea=1,MinLevel=675}, {N="Ice Admiral",Sea=1,MinLevel=700},
    {N="Greybeard",Sea=1,MinLevel=750},
    -- Sea 2
    {N="Diamond",Sea=2,MinLevel=750}, {N="Jeremy",Sea=2,MinLevel=850},
    {N="Fajita",Sea=2,MinLevel=925}, {N="Don Swan",Sea=2,MinLevel=1000},
    {N="Smoke Admiral",Sea=2,MinLevel=1150},
    {N="Awakened Ice Admiral",Sea=2,MinLevel=1400},
    {N="Tide Keeper",Sea=2,MinLevel=1475}, {N="Darkbeard",Sea=2,MinLevel=1000},
    {N="Order",Sea=2,MinLevel=1250}, {N="Cursed Captain",Sea=2,MinLevel=1325},
    -- Sea 3
    {N="Stone",Sea=3,MinLevel=1550}, {N="Island Empress",Sea=3,MinLevel=1675},
    {N="Kilo Admiral",Sea=3,MinLevel=1750}, {N="Captain Elephant",Sea=3,MinLevel=1875},
    {N="Longma",Sea=3,MinLevel=2000},
    {N="Cursed Skeleton Boss",Sea=3,MinLevel=2050}, {N="Cake Queen",Sea=3,MinLevel=2175},
    {N="Soul Reaper",Sea=3,MinLevel=2000}, {N="Cake Prince",Sea=3,MinLevel=2200},
    {N="Dough King",Sea=3,MinLevel=2300},
    {N="Tyrant of the Skies",Sea=3,MinLevel=2600},
    {N="rip_indra",Sea=3,MinLevel=1500},
}

function BossManager:FindLiveBoss()
    local folder = workspace:FindFirstChild("Enemies")
    local root = HRP()
    if not folder or not root then return nil end
    local sea, level = GetSea(), Level()
    local best, bestDist, bestEntry = nil, math.huge, nil
    for _, mob in ipairs(folder:GetChildren()) do
        local hum = mob:FindFirstChildOfClass("Humanoid")
        local mobRoot = mob:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and mobRoot then
            for _, entry in ipairs(BossDatabase) do
                if entry.Sea == sea and level >= entry.MinLevel
                    and IsEnemyNamed(mob, entry.N) then
                    local p = mobRoot.Position
                    if IsValidPos(p) and IsAllowedWorldY(p.Y) then
                        local d = (p - root.Position).Magnitude
                        if d < bestDist then
                            best, bestDist, bestEntry = mob, d, entry
                        end
                    end
                    break
                end
            end
        end
    end
    return best, bestEntry
end

function BossManager:_Finish(token, reason)
    if TravelManager and _G.State.IsTraveling and _G.State.MovementOwner == "Boss" then
        TravelManager:Stop("Boss:" .. tostring(reason))
    end
    _G.State:ReleaseAction(token)
    self.Active = false
    self.ActiveName = nil
    if _G.State.Mode == "Bossing" then _G.State:SetMode("Idle") end
end

function BossManager:_RunBoss(boss, entry, token)
    local ok, err = xpcall(function()
        self.ActiveName = entry.N
        _G.State:SetMode("Bossing")
        _G.BobonStatus = "Boss: " .. entry.N
        local deadline = tick() + 180
        while _G.State:IsActionValid(token) and IsAlive() and tick() < deadline do
            local hum = boss and boss:FindFirstChildOfClass("Humanoid")
            local targetRoot = boss and boss:FindFirstChild("HumanoidRootPart")
            if not boss or not boss.Parent or not hum or hum.Health <= 0 or not targetRoot then
                self.LastKill = tick()
                break
            end
            if not IsValidPos(targetRoot.Position) or not IsAllowedWorldY(targetRoot.Position.Y) then
                break
            end
            PrepareCombatTarget(targetRoot)
            TravelManager:Request(targetRoot, "Boss", {
                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                fallback = nil,
            })
            local me = HRP()
            if me then
                local a = Vector3.new(me.Position.X, 0, me.Position.Z)
                local b = Vector3.new(targetRoot.Position.X, 0, targetRoot.Position.Z)
                if (a - b).Magnitude <= _G.Settings.AttackRange then
                    if EquipCombatTool() then Attack(boss) end
                end
            end
            task.wait(0.12)
        end
    end, debug.traceback)
    if not ok then warn("[BobonHub] Module Error: Boss " .. tostring(err)) end
    self:_Finish(token, ok and "complete" or "error")
end

function BossManager:TryFightBoss()
    if not _G.Settings.BossEnabled or self.Active or not _G.State:CanAct() then return false end
    local boss, entry = self:FindLiveBoss()
    if not boss or not entry then return false end
    local token = _G.State:ClaimAction("Boss")
    if token == 0 then return false end
    if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
        TravelManager:Stop("BossPriority")
    end
    self.Active = true
    task.spawn(function() self:_RunBoss(boss, entry, token) end)
    return true
end


-- ══════════════════════════════════════════════════════════════════
--    MAIN CONTROLLER v16.2 FIXED — SINGLE LOOP
--
--   Priority: Recovery > Team > Valid Quest+Farm > Sea gate > Items > Boss
--   CHỈ gọi TravelManager:Request(), KHÔNG tự ghi MovementOwner
--   [FIX-2] Mỗi subsystem wrap pcall riêng + warn Module Error,
--           lỗi 1 module không chặn Quest/Farm
--   [FIX-9] Quest sai mob → tự re-request khi tới giver
--   [FIX-10] Chưa có quest → không farm, đi nhận quest trước
--   [FIX-3] Attack dùng khoảng cách XZ (hover trên đầu mob)
--   [FIX-6] FarmTarget invalid/qua xa/dưới biển → clear + về q.MC
--   [A-5] Farm state machine FState chạy trong loop DUY NHẤT này
-- ══════════════════════════════════════════════════════════════════
local lastAttackLog = 0
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

            -- Repair a stale travel flag before quest/farm logic.  A travel
            -- coroutine can finish between ticks; never let that leave the
            -- farm loop believing movement is still owned forever.
            if _G.State.IsTraveling and not TravelManager.ActiveThread then
                TravelManager:Stop("StaleTravel")
            elseif _G.State.IsTraveling and not _G.State.MovementOwner then
                TravelManager:Stop("MissingMovementOwner")
            end

            -- Team phải được xác nhận trước mọi remote/item/boss; nếu chưa có
            -- team thì không được bắt đầu một travel dang dở.
            if not TeamController:AutoSelectTeam() then
                _G.BobonStatus = "Team: Đang xác nhận Pirates"
                return
            end


            -- FARM-FIRST GATE: inspect the current level/quest before any
            -- optional progression.  A valid quest always wins, so item and
            -- boss routines cannot pull the player away mid-farm.
            local lv = Level()
            local q = GetQ()


            if not q then
                _G.State:SetMode("Idle")
                _G.BobonStatus = "Max Level / No Quest"
                return
            end


            -- ═══ QUEST HANDLING (FIX-P2/P3) ═══
            local questState = HasQuest() -- true / false / nil (UI not ready)
            local questMatch = QuestMatches(q.M)
            local hasQuest = questState == true or questMatch == true
            -- QuestMatches: true = đúng mob | false = sai mob | nil = không đọc được UI.
            -- Lưu ý: dùng `and` (không `or nil`) để giữ giá trị `false` khi quest sai mob.
            local questOk = hasQuest and questMatch

            -- No quest means a safe window: finish mandatory Sea progression,
            -- then claim level-appropriate items before requesting the next
            -- farming quest.  Wrong/unknown quest stays on quest repair first.
            -- Only a confirmed `false` UI state opens optional item/boss work;
            -- an unreadable quest UI must keep the controller on quest repair.
            local itemWindow = questState == false and questMatch ~= true
            local seaWindow = itemWindow or questMatch == false
            local okMod, modResult = pcall(function()
                return ItemProgression:RunChecks(seaWindow, itemWindow)
            end)
            if not okMod then
                warn("[BobonHub] Module Error: ItemProgression: " .. tostring(modResult))
            elseif modResult then
                return
            end

            -- Boss drops are optional Kaitun work; only scan/fight while no
            -- quest is active, never during normal level farming.
            if itemWindow then
                local okBoss, bossResult = pcall(function()
                    return BossManager:TryFightBoss()
                end)
                if not okBoss then
                    warn("[BobonHub] Module Error: BossManager: " .. tostring(bossResult))
                elseif bossResult then
                    return
                end
            end


            -- QUEST + FARM (primary progression from level 1 to max)

            if hasQuest and questOk ~= false then
                -- Quest hợp lệ (true) hoặc nil = UI không đọc được nhưng vừa
                -- request gần đây → cho farm trong khoảng grace ngắn
                if questOk == nil then
                    local gNow = tick()
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
                DLog("QUEST", "Chưa có quest / sai mob → đi giver " .. q.M)
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


            -- ═══ FARM CONTROLLER — state machine (1 loop duy nhất) [A-5] ═══
            -- FState: IDLE→CHECK_CHARACTER→CHECK_SEA→SELECT_TARGET→
            -- MOVE_TO_TARGET→ATTACK→VERIFY_TARGET→NEXT_TARGET
            _G.State:SetMode("Farming")

            -- CHECK_CHARACTER
            _G.State.FState = "CHECK_CHARACTER"
            DLog("FARM", "State = CHECK_CHARACTER")
            if not IsAlive() then return end

            -- CHECK_SEA + TEAM (cooldown, không spam, không chặn farm lâu)
            _G.State.FState = "CHECK_SEA"
            DLog("FARM", "State = CHECK_SEA")
            _G.State.Sea = GetSea()
            if not TeamController:AutoSelectTeam() then
                _G.BobonStatus = "Team: Đang chọn Pirates"
                return
            end

            -- VERIFY_TARGET: clear NGAY nếu invalid → NEXT_TARGET
            _G.State.FState = "VERIFY_TARGET"
            if not _G.State:IsTargetValid(_G.State.FarmTarget) then
                _G.State:ClearTargets()
                _G.State.FState = "NEXT_TARGET"
                DLog("TARGET", "Target cũ invalid → chọn mới")
            end


            if _G.State.FarmTarget then
                local hrp = HRP()
                local targetHRP = _G.State.FarmTarget:FindFirstChild("HumanoidRootPart")
                if not targetHRP then
                    _G.State:ClearTargets()
                elseif hrp then
                    local targetPos = targetHRP.Position
                    local dist = (hrp.Position - targetPos).Magnitude
                    PrepareCombatTarget(_G.State.FarmTarget)

                    -- MOVE_TO_TARGET
                    _G.State.FState = "MOVE_TO_TARGET"

                    -- [FIX-6] Target quá xa hoặc dưới biển → clear, về khu farm
                    if dist > _G.Settings.MaxFarmDistance + 50
                        or not IsAllowedWorldY(targetPos.Y) then
                        _G.State:ClearTargets()
                        _G.State.FState = "NEXT_TARGET"
                        _G.BobonStatus = "Farm: Target lỗi, về khu farm"
                        DLog("TARGET", "Target lỗi (xa/dưới biển) → về khu farm")
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

                    -- ATTACK [A-6]: chỉ khi target sống + melee đã equip + trong
                    -- AttackRange (XZ) + Farm đang giữ movement (owner Farm
                    -- hoặc không travel — travel xong trả về Farm)
                    if _G.State:IsTargetValid(_G.State.FarmTarget) then
                        local flatDist = (Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
                            - Vector3.new(targetPos.X, 0, targetPos.Z)).Magnitude
                        local farmHolds = not _G.State.IsTraveling
                            or _G.State.MovementOwner == "Farm"
                        if flatDist <= _G.Settings.AttackRange and farmHolds then
                            _G.State.FState = "ATTACK"
                            if EquipCombatTool() then
                                Attack(_G.State.FarmTarget)
                                if os.time() - lastAttackLog >= 5 then
                                    lastAttackLog = os.time()
                                    DLog("ATTACK", "Target: " .. _G.State.FarmTarget.Name)
                                end
                            end
                        end
                    end

                    -- GOM MOB [A-4]: gom mềm các mob quest ở gần vào cluster
                    -- cục bộ rồi để FastAttack xử lý cả nhóm; không tạo loop
                    -- movement riêng và không đụng mob ở xa.
                    if _G.Settings.GatherMobs
                        and (not _G.State.IsTraveling or _G.State.MovementOwner == "Farm") then
                        FarmPositionController:GatherMobCluster(q.M, _G.State.FarmTarget)
                    end
                    local farmPos = FarmPositionController:GetClusterFarmPos(_G.State.FarmTarget)
                    if farmPos and FarmPositionController:HasNearbyMobs(q.M, farmPos)
                        and (not _G.State.IsTraveling or _G.State.MovementOwner == "Farm") then
                        if EquipCombatTool() then
                            Attack(_G.State.FarmTarget)
                        end
                    end
                end
            else
                -- SELECT_TARGET [A-5]: mob theo quest/level/sea hiện tại,
                -- chọn mob GẦN player nhất (không chọn ngẫu nhiên cả map)
                _G.State.FState = "SELECT_TARGET"
                DLog("FARM", "State = SELECT_TARGET")
                local mob, dist = FindNearestMob(q.M)


                if mob and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    PrepareCombatTarget(mob)
                    if dist > _G.Settings.MaxFarmDistance then
                        -- Mob quá xa → về khu farm, KHÔNG giữ target xa
                        _G.State:ClearTargets()
                        _G.BobonStatus = "Farm: " .. q.M .. " xa, về khu farm"
                        DLog("TARGET", q.M .. " quá xa (" .. string.format("%.0f", dist) .. ") → về khu farm")
                        if _G.State:CanRequestTravel() then
                            TravelManager:Request(q.MC, "Farm")
                        end
                    else
                        _G.State.FarmTarget = mob
                        _G.State.CurrentTarget = mob
                        _G.State.FState = "MOVE_TO_TARGET"
                        _G.BobonStatus = "Farm: " .. q.M
                        DLog("TARGET", "Found: " .. q.M .. " @" .. string.format("%.0f", dist) .. " studs")
                        if _G.State:CanRequestTravel() then
                            TravelManager:Request(mob.HumanoidRootPart, "Farm", {
                                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                                fallback = q.MC
                            })
                        end
                    end
                else
                    _G.BobonStatus = "Farm: Chờ spawn " .. q.M
                    DLog("TARGET", "Chờ spawn " .. q.M)
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
--              TEAM + HAKI INIT (Fix #14 / [A-1] TeamController)
-- ══════════════════════════════════════════════════════════════════
task.spawn(function()
    -- Chạy ngay sau bootstrap; không đợi character vì ChooseTeam thường
    -- được tạo trước HumanoidRootPart.
    for _ = 1, 30 do
        if TeamController:AutoSelectTeam() then break end
        task.wait(0.25)
    end
    if LP.Team then
        _G.BobonStatus = "Team: " .. LP.Team.Name .. " ✓"
        DLog("TEAM", "Verified team: " .. LP.Team.Name)
    end
    task.wait(0.5)
    if HakiController:EnableForCharacter() then
        _G.BobonStatus = "Haki: ON ✓"
    else
        _G.BobonStatus = "Haki: Chờ character"
    end
    task.wait(0.5)
    _G.State:SetMode("Idle")
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


print("[BobonHub v16.3 DATA] Full Script Loaded Successfully!")
print("[BobonHub v16.3 DATA] Architecture: Persistent Travel | ActionToken | Single Owner")
print("[BobonHub v16.3 DATA] Core: TravelManager(v7+P1) | StateManager(v7) | RecoveryManager(v7+P10)")
print("[BobonHub v16.3 DATA] Modules: QuestFarm(P2/P3) | TeamController(A1) | WeaponController(A2)")
print("[BobonHub v16.3 DATA] Modules: BossManager | MovementManager(A3) | FarmPositionController(A4)")
print("[BobonHub v16.3 DATA] Data: Sea1/2/3 QDB 1-2800 | Submerged | Boss/item catalog")
print("[BobonHub v16.3 DATA] Sea: " .. _G.State.Sea .. " | Level: " .. Level())
