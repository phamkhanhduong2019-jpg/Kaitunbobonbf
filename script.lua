-- =================================================================
--         BOBON HUB v16.6 LIVE | STABLE KAITUN BLOX FRUIT
--         Long-Run Stable | Single Movement Owner | ActionToken
--         Base: v15.0 | Version: v16.6 LIVE
--
--  LIVE HOTFIX VERIFIED COMBAT + ATOMIC TRAVEL:
--  [C-1] Melee/sword attack adapter: live client helper -> tokenized Net ->
--        one real client click fallback. Never fire competing input paths.
--  [C-2] A backend is READY only after two independent verified HP decreases;
--        pcall/FireServer/input success is reported as PROBE, not damage.
--  [C-3] Combat hover is explicit for every owner (Farm/Boss/Items/Sea),
--        stays above the NPC and never faces 180 degrees away on arrival.
--  [C-4] Same-owner retarget replans all travel options atomically; stuck
--        timing no longer sleeps 0.5s inside the physics loop.
--  [C-5] Bring counts only network-owned mobs; local fallback is explicitly
--        forbidden because it creates client-only "dummy" mobs. Bring never
--        changes persistent Humanoid/collision state.
--  [C-6] Skip-level combat remains disabled until fast damage is verified.
--  [C-7] Quest bring refreshes SimulationRadius, verifies network ownership
--        before and after each move, and never attacks a locally-ghosted mob.
--
--  AUDIT FIXES v16.6-LIVE (L-1..L-7):
--  [L-1] HUD responsive bằng UIListLayout + UIScale, không chồng chữ
--         trên màn hình mobile; nền kính vẫn phủ toàn màn hình.
--  [L-2] Beli xanh, Fragments tím, Status đổi màu theo Mode.
--  [L-3] Combat ưu tiên đúng ReplicatedStorage.Modules.Net và payload
--         RegisterAttack/RegisterHit hiện hành; M1 truyền camera CFrame.
--  [L-4] Attack chỉ gửi khi đã equip Tool; lỗi VirtualUser không hủy
--         RegisterHit đã gửi.
--  [L-5] Bring mob xin SimulationRadius, giới hạn 250 studs, không anchor;
--         freeze vận tốc và chỉ dịch mob khi có quyền physics khả dụng.
--  [L-6] Sửa item window unreachable; Saber dùng ProQuestProgress,
--         Pole săn Thunder God thay cho remote BuyPoleV1 không tồn tại.
--  [L-7] Sửa gate tiến trình Sea2, Bartilo và Sea3 theo live flow.
--
--  AUDIT FIXES v16.5-GLASS (G-1..G-9):
--  [G-1]  OVERLAY KÍNH MỜ: nền Dim mờ xuyên cảnh (MenuDim, mặc định
--         0.45) + BlurEffect kính mờ (MenuBlur) thay cho [D-2] nền đen
--         100%. Right Ctrl ẩn/hiện toàn bộ overlay + blur.
--  [G-2]  Tự dọn blur cũ khi re-execute; blur tự gắn lại khi
--         CurrentCamera bị thay đổi (respawn/teleport).
--  [G-3]  RecoveryManager: Velocity/RotVelocity (deprecated) →
--         AssemblyLinearVelocity/AssemblyAngularVelocity.
--  [G-4]  FULL-GLASS: bỏ hẳn card/khung menu — chữ nổi trực tiếp trên
--         nền kính mờ TOÀN màn hình, text stroke đậm hơn để đọc rõ.
--  [G-5]  ATTACK FIX: Net remote resolver đa đường dẫn (Remotes.Modules.Net
--         / Modules.Net / tìm sâu theo tên "Net"). Bản cũ chỉ nhìn
--         RS.Modules.Net nên RegisterHit không bao giờ gửi được → bot
--         đứng im không đánh. Giờ gửi RegisterHit theo từng enemy
--         (part, {part}), giới hạn 12 mob gần nhất chống spam.
--  [G-6]  FARM/GATHER FIX: quest-match KHÔNG đọc được UI (nil sau update
--         đổi cấu trúc) → vẫn farm thay vì kẹt re-request quest vô hạn;
--         gom mob không còn phụ thuộc strict quest-match, anchor nới
--         bán kính tối thiểu 30 studs, GatherInterval 0.3 → 0.15.
--  [G-7]  FAST ATTACK THEO TÊN + BRING MOB: RegisterHit đánh MỌI mob
--         trùng tên quest đang sống, KHÔNG giới hạn khoảng cách (đứng
--         đâu cũng trúng). Gom = DỊCH CHUYỂN toàn bộ mob trùng tên về
--         cụm quanh mob neo (PivotTo + anchor cục bộ chống server kéo
--         về), chỉ chạy khi đã hover trên đầu mob neo; nhả anchor khi
--         đổi target/quest/chết (ReleaseCluster).
--  [G-8]  Remote gọi qua cloneref khi executor hỗ trợ (kiểu "Fast
--         Attack Unban" công khai) để bớt bị theo dõi remote trực tiếp.
--  [G-9]  ATTACK UNBLOCK: equip tool KHÔNG còn là cổng chặn attack
--         (RegisterHit không cần tool, M1 tay không vẫn damage); camera
--         quay THẲNG vào target trước khi M1 (game bắn theo hướng
--         camera, không phải hướng thân); RegisterHit đa định dạng
--         (part,{part}) / ({parts}) / (part); skip route cũng gom mob;
--         ActionLockTimeout 180 → 60s chống đứng im dài.
--
--  AUDIT FIXES v16.4-FIXED (D-1..D-5):
--  [D-1]  DODGE CONTROLLER (NÉ CHIÊU): monitor loop duy nhất dò quái
--         gần player đang tung chiêu (animation tấn công / lao nhanh
--         về phía player) → dịch ngang 1 phát né, có cooldown chống
--         spam, không né khi bay xa (giver/island), không phá Single
--         Movement Owner (chỉ CFrame offset 1 lần, hover kéo về sau).
--  [D-2]  NỀN ĐEN FULL MÀN HÌNH: Dim phủ kín màn hình, đục hoàn toàn
--         (BackgroundTransparency = 0, đen 100%) thay vì mờ 86%.
--  [D-3]  (gộp vào D-4) Skip level không hiệu quả → quay về farm quest.
--  [D-4]  SKIP KHÔNG HIỆU QUẢ → FARM QUEST: SkipRouteController theo
--         dõi level đầu route; cùng route quá SkipRouteFallbackTimeout
--         (90s) mà level không tăng → tắt hẳn skip route, main
--         controller chạy farm quest bình thường.
--  [D-5]  KHÔNG CHỜ BOSS: route boss (Bobby/Yeti/Vice Admiral/...) mà
--         boss không có mặt NGAY → return false, quay về farm quest
--         tức thời. Chỉ route mob giữ fallback chờ spawn (mob respawn
--         nhanh). BossManager vẫn săn boss khi boss xuất hiện.
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
-- Re-execution guard. Newer sessions invalidate every persistent loop from
-- the previous run and invoke its cleanup hook before creating new state.
local PreviousUnload = rawget(_G, "BobonUnload")
if type(PreviousUnload) == "function" then pcall(PreviousUnload) end
_G.BobonUnload = nil
_G.BobonSessionID = (_G.BobonSessionID or 0) + 1
local SessionID = _G.BobonSessionID
local function SessionAlive()
    return _G.BobonSessionID == SessionID
end
-- Không chờ Character/HRP/Data ở đây: lúc mới execute, ChooseTeam có thể
-- xuất hiện trước character. Chờ các object này ở từng controller để team
-- được chọn ngay lập tức thay vì kẹt vô hạn trong bootstrap.


print("[BobonHub v16.6 LIVE] Loading...")


-- ══════════════════════════════════════════════════════════════════
--                          SERVICES
-- ══════════════════════════════════════════════════════════════════
local Players      = game:GetService("Players")
local RS           = game:GetService("ReplicatedStorage")
local RunService   = game:GetService("RunService")
local VU           = game:GetService("VirtualUser")
local VIM          = game:GetService("VirtualInputManager")
local TS           = game:GetService("TweenService")
local TeleportSvc  = game:GetService("TeleportService")
local CoreGui      = game:GetService("CoreGui")


local LP      = Players.LocalPlayer
local Remotes = RS:WaitForChild("Remotes", 10)
local CommF_  = Remotes and Remotes:WaitForChild("CommF_", 10)
if not CommF_ then warn("[BobonHub v16.6 LIVE] CommF_ not found!") return end


-- ══════════════════════════════════════════════════════════════════
--                   CONFIG
-- ══════════════════════════════════════════════════════════════════
_G.Settings = {
    -- [A-8] DEBUG log: true = in [TAG] log ra console (không spam khi false)
    DEBUG               = false,
    -- Safe hover for verified fast attack. Before fast damage is confirmed,
    -- the controller temporarily uses ClientHoverHeight for a genuine M1.
    FarmHeight          = 15,
    BossFarmHeight      = 24,
    -- Only the real-click fallback descends this low. Verified fast attack
    -- remains at FarmHeight/BossFarmHeight, safely outside ordinary NPC M1.
    ClientHoverHeight   = 5,
    FarmOffsetX         = 1.5,
    -- Retained for compatibility only; enemy roots are no longer resized.
    HitboxSize          = 0,
    FlySpeed            = 180,
    MinY                = 10,
    -- Submerged Island (Sea 3) dùng tọa độ âm dưới mặt biển.
    UnderwaterMinY      = -2300,
    CloseThreshold      = 35,
    FarmArrivalThreshold= 2.5,
    HoverConfirmRadius  = 5,
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
    FastAttackRange     = 100,
    ClientAttackRange   = 8,
    FastAttackMaxTargets= 12,
    CombatProbeTimeout  = 1.2,
    CombatProbeAttempts = 3,
    CombatBackendRetry  = 12,
    CombatFastUpgradeInterval = 90,
    CombatVerifiedMissLimit = 8,
    CombatVerifiedRetry = 0.25,
    CombatLateGrace     = 0.35,
    CombatProofsRequired= 2,
    -- A previously verified backend is re-probed after a quiet period, but
    -- ordinary island travel must not invalidate it every few seconds.
    CombatVerificationTTL= 120,
    CombatBaselineQuiet = 0.25,
    CombatRepeatProofGap= 0.9,
    CombatCausalWindow  = 0.65,
    EquipSettle         = 0.35,
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
    AttackDelay         = 0.08,
    QuestDelay          = 1.5,
    QuestRetryLimit     = 3,
    QuestRetryBackoff   = 6,
    QuestAcceptGrace    = 6,
    RecoveryDelay       = 3,
    ActionLockTimeout   = 60,   -- [G-9] đứng im tối đa 60s thì token bị force-release
    BossEnabled         = true,
    FruitEnabled        = true,
    AutoStats           = true,
    AutoItems           = true,
    AutoRedeemCodes     = true,
    RedeemCodeDelay     = 0.45,
    -- Local-only bring-mob for nearby quest enemies; no extra movement loop.
    GatherMobs          = true,
    -- Sea 1 optimized skip route (Fountain, bosses, Upper Sky/Galley).
    -- Enabled only after the combat adapter confirms real fast damage.
    SkipLevelRoute      = true,
    -- Bring matching quest mobs only inside the current island/farm area.
    -- Simulation ownership is requested before movement to avoid ghost mobs.
    GatherAllQuestMobs  = true,
    GatherMaxDistance   = 250,
    GatherSimulationRefresh = 0.75,
    GatherSpacing       = 5,
    GatherPersistTolerance = 8,
    GatherVerifiedTTL   = 0.6,
    GatherInterval      = 0.12,
    -- Optional item failure/timeout must not block level farming forever.
    ItemRetryCooldown   = 300,
    ServerHopCooldown   = 120,
    MaxFarmDistance     = 300,
    StatBatchLimit      = 100,
    -- [D-1] NÉ CHIÊU: phát hiện quái gần player tung chiêu (animation
    -- tấn công / lao nhanh về phía player) → dịch ngang né nhanh.
    -- Direct CFrame dodge conflicts with the single hover owner. Keep it off
    -- until it is represented as a TravelManager goal offset.
    DodgeAttacks        = false,
    DodgeCooldown       = 1.5,
    DodgeDistance       = 12,
    DodgeHeight         = 4,
    DodgeRadius         = 15,
    -- [D-4] Skip level không hiệu quả: cùng route quá N giây mà level
    -- không tăng → tắt skip route, quay về farm quest bình thường.
    SkipRouteFallbackTimeout = 90,
}


-- ══════════════════════════════════════════════════════════════════
--              STATE MANAGER v7
--   ActionToken system chống race condition
--   State consistency checks
--   Centralized target/action management
-- ══════════════════════════════════════════════════════════════════
_G.BobonStatus = "Initializing..."
_G.BobonDiagnostics = {
    Tool = "wait",
    Net = "wait",
    Targets = 0,
    Packet = "wait",
    Bring = "wait",
    BringCandidates = 0,
    BringOwned = 0,
    BringMoved = 0,
}

-- Submerged is a bounded region, not every negative-Y point in Third Sea.
-- Full XYZ checks prevent an ordinary ocean fall from being misclassified as
-- a valid underwater island and disabling the anti-fall rescue forever.
local SUBMERGED_REGION = {
    MinX = 8400, MaxX = 12300,
    MinZ = 8000, MaxZ = 11500,
    MinY = _G.Settings.UnderwaterMinY or -2300,
    MaxY = -100,
}

local function IsFiniteNumber(value)
    return type(value) == "number" and value == value
        and value > -math.huge and value < math.huge
end

local function IsFiniteVector3(pos)
    return typeof(pos) == "Vector3"
        and IsFiniteNumber(pos.X)
        and IsFiniteNumber(pos.Y)
        and IsFiniteNumber(pos.Z)
end

local function IsSubmergedPosition(pos)
    if game.PlaceId ~= 7449423635 or not IsFiniteVector3(pos) then return false end
    local bounds = SUBMERGED_REGION
    return pos.X >= bounds.MinX and pos.X <= bounds.MaxX
        and pos.Z >= bounds.MinZ and pos.Z <= bounds.MaxZ
        and pos.Y >= bounds.MinY and pos.Y <= bounds.MaxY
end

local function IsAllowedWorldPosition(pos)
    return IsFiniteVector3(pos)
        and (pos.Y >= _G.Settings.MinY - 10 or IsSubmergedPosition(pos))
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
    LastQuestAccepted= 0,
    QuestRetries     = 0,
    -- Canonical workspace enemy name for the quest that is actually active.
    -- Quest UI may be localized, so gathering must not infer a mob name from
    -- the visible translated text on every frame.
    ActiveQuestMob   = nil,
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

function _G.State:TouchAction(myToken)
    if self:IsActionValid(myToken) then
        self.ActionStartTime = os.time()
        return true
    end
    return false
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
    local ok, position = pcall(function() return root.Position end)
    if not ok or not IsAllowedWorldPosition(position) then return false end
    return true
end


-- State consistency watchdog (Fix #22)
task.spawn(function()
    while SessionAlive() and task.wait(5) do
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
--             UI — BOBONHUB MODERN OVERLAY
-- ══════════════════════════════════════════════════════════════════
if CoreGui:FindFirstChild("BobonHubUI") then CoreGui.BobonHubUI:Destroy() end

local UIS = game:GetService("UserInputService")

-- [G-2] Dọn blur còn sót từ lần execute trước (CoreGui / Camera / Lighting)
for _, scope in ipairs({ CoreGui, workspace.CurrentCamera, game:GetService("Lighting") }) do
    pcall(function()
        local old = scope and scope:FindFirstChild("BobonHubBlur")
        if old then old:Destroy() end
    end)
end

local SG = Instance.new("ScreenGui")
SG.Name = "BobonHubUI"; SG.Parent = CoreGui
SG.ResetOnSpawn = false; SG.DisplayOrder = 10000; SG.IgnoreGuiInset = true

-- [G-1] Cấu hình hiệu ứng kính mờ (định nghĩa lại được trong _G.Settings)
_G.Settings.MenuDim  = _G.Settings.MenuDim or 0.28    -- kính tối toàn màn hình
_G.Settings.MenuBlur = _G.Settings.MenuBlur or 16

-- [G-1] BLUR: kính mờ thật phủ lên cảnh phía sau overlay
local Blur = Instance.new("BlurEffect")
Blur.Name = "BobonHubBlur"; Blur.Size = 0; Blur.Enabled = true
Blur.Parent = workspace.CurrentCamera
-- [G-2] Camera có thể bị thay sau respawn/teleport → tự gắn lại blur
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if not SessionAlive() then return end
    pcall(function()
        if Blur and Blur.Parent then Blur.Parent = workspace.CurrentCamera end
    end)
end)

-- [G-1] NỀN KÍNH MỜ: phủ mờ xuyên cảnh thay cho [D-2] nền đen 100%.
-- Dim fade-in từ trong suốt rồi tween về MenuDim ở block phía dưới.
local Dim = Instance.new("Frame", SG)
Dim.Size = UDim2.new(1,0,1,0); Dim.BackgroundColor3 = Color3.fromRGB(8,14,26)
Dim.BackgroundTransparency = 1
Dim.BorderSizePixel = 0; Dim.ZIndex = 1
local DimGrad = Instance.new("UIGradient", Dim)
DimGrad.Rotation = 90
DimGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12,22,42)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(3,7,16)),
})


-- Full-screen HUD: no menu card. Information floats directly over the
-- full-screen frosted layer and scales on desktop/mobile resolutions.
local Con = Instance.new("Frame", SG)
Con.AnchorPoint = Vector2.new(0.5,0.5); Con.Position = UDim2.fromScale(0.5,0.5)
Con.Size = UDim2.fromScale(1,1)
Con.BackgroundTransparency = 1; Con.BorderSizePixel = 0; Con.ZIndex = 2

-- A single vertically-laid-out content column prevents labels from
-- overlapping on short mobile viewports. UIScale shrinks the whole column
-- uniformly instead of letting independent percentage positions collide.
local Content = Instance.new("Frame", Con)
Content.Name = "Content"
Content.AnchorPoint = Vector2.new(0.5,0.5)
Content.Position = UDim2.fromScale(0.5,0.5)
Content.Size = UDim2.new(0.88,0,0,350)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ZIndex = 2

local ContentConstraint = Instance.new("UISizeConstraint", Content)
ContentConstraint.MinSize = Vector2.new(280,350)
ContentConstraint.MaxSize = Vector2.new(760,350)

local ContentScale = Instance.new("UIScale", Content)
local function RefreshHudScale()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280,720)
    ContentScale.Scale = math.clamp(math.min(viewport.X / 760, viewport.Y / 470), 0.72, 1)
end
RefreshHudScale()
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if not SessionAlive() then return end
    task.defer(RefreshHudScale)
end)
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(RefreshHudScale)
end

local ContentLayout = Instance.new("UIListLayout", Content)
ContentLayout.FillDirection = Enum.FillDirection.Vertical
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0,4)

local function MkLabel(txt,sz,col,bold,height,order,align)
    local lb = Instance.new("TextLabel", Content)
    lb.Size = UDim2.new(1,0,0,height or (sz+8))
    lb.BackgroundTransparency = 1
    lb.Text = txt; lb.TextColor3 = col; lb.TextSize = sz
    lb.Font = bold and Enum.Font.GothamBlack or Enum.Font.GothamMedium
    lb.TextXAlignment = align or Enum.TextXAlignment.Center
    lb.TextYAlignment = Enum.TextYAlignment.Center
    lb.TextTransparency = 1; lb.TextStrokeTransparency = 0.45
    lb.TextStrokeColor3 = Color3.fromRGB(0,0,0); lb.ZIndex = 4
    lb.LayoutOrder = order or 1
    return lb
end


local function MkDivider(order)
    local f = Instance.new("Frame", Content)
    f.Size = UDim2.new(0.72,0,0,1)
    f.BackgroundColor3 = Color3.fromRGB(87,218,255); f.BackgroundTransparency = 0.55
    f.BorderSizePixel = 0; f.ZIndex = 3
    f.LayoutOrder = order or 1
    return f
end


local function MkCurrRow(order)
    local row = Instance.new("Frame", Content)
    row.Size = UDim2.new(0.82,0,0,34)
    row.BackgroundTransparency = 1; row.BorderSizePixel = 0; row.ZIndex = 3
    row.LayoutOrder = order or 1
    local function Side(txt,col,pos,align)
        local lb = Instance.new("TextLabel", row)
        lb.Position = pos; lb.Size = UDim2.new(0.44,0,1,0); lb.BackgroundTransparency = 1
        lb.Text = txt; lb.TextColor3 = col; lb.TextSize = 16; lb.Font = Enum.Font.GothamBold
        lb.TextXAlignment = align; lb.TextYAlignment = Enum.TextYAlignment.Center
        lb.TextTransparency = 1; lb.TextStrokeTransparency = 0.45
        lb.TextStrokeColor3 = Color3.fromRGB(0,0,0); lb.ZIndex = 4
        return lb
    end
    local sep = Instance.new("TextLabel", row)
    sep.AnchorPoint = Vector2.new(0.5,0.5); sep.Position = UDim2.new(0.5,0,0.5,0)
    sep.Size = UDim2.new(0,24,1,0); sep.BackgroundTransparency = 1; sep.Text = "•"
    sep.TextColor3 = Color3.fromRGB(130,205,235); sep.TextSize = 18; sep.Font = Enum.Font.GothamBold
    sep.TextXAlignment = Enum.TextXAlignment.Center; sep.TextYAlignment = Enum.TextYAlignment.Center
    sep.TextTransparency = 1; sep.TextStrokeTransparency = 1; sep.ZIndex = 4
    local beli = Side("Beli: 0",Color3.fromRGB(255,205,76),UDim2.new(0,0,0,0),Enum.TextXAlignment.Right)
    beli.TextColor3 = Color3.fromRGB(66,255,133)
    local frag = Side("Fragments: 0",Color3.fromRGB(190,115,255),UDim2.new(0.56,0,0,0),Enum.TextXAlignment.Left)
    return row, beli, sep, frag
end


local TitleL = MkLabel("BoBonHub",54,Color3.fromRGB(248,253,255),true,68,1)
local SubL   = MkLabel("STABLE KAITUN  •  AUTO FARM",12,Color3.fromRGB(75,222,255),true,22,2)
local StatL  = MkLabel("Status: Initializing...",18,Color3.fromRGB(62,255,220),true,32,3)
local ModeL  = MkLabel("Mode: Idle",14,Color3.fromRGB(255,214,92),false,22,4)
local TimeL  = MkLabel("Time: 00:00:00",14,Color3.fromRGB(231,240,250),false,22,5)
MkDivider(6)
local CurrRow, BeliL, SepL, FragL = MkCurrRow(7)
local KillL  = MkLabel("Kills: 0",13,Color3.fromRGB(255,105,126),false,22,8)
local InfoL  = MkLabel("Sea: 1 | Lv: 1",13,Color3.fromRGB(100,198,255),false,22,9)
local DiagL  = MkLabel("Combat: waiting  |  Bring: waiting",11,Color3.fromRGB(255,184,92),true,18,10)
DiagL.TextScaled = true
local DiagTextSize = Instance.new("UITextSizeConstraint", DiagL)
DiagTextSize.MinTextSize = 8
DiagTextSize.MaxTextSize = 11
local HintL  = MkLabel("Nút bên trái / Right Ctrl: Ẩn hiện giao diện",11,Color3.fromRGB(157,178,205),false,18,11)

-- Compact persistent toggle on the left. It stays visible while the frosted
-- overlay is hidden, unlike toggling ScreenGui.Enabled.
local ToggleButton = Instance.new("TextButton", SG)
ToggleButton.Name = "OverlayToggle"
ToggleButton.AnchorPoint = Vector2.new(0,0.5)
ToggleButton.Position = UDim2.new(0,14,0.5,0)
ToggleButton.Size = UDim2.new(0,46,0,58)
ToggleButton.BackgroundColor3 = Color3.fromRGB(8,25,44)
ToggleButton.BackgroundTransparency = 0.12
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "◀"
ToggleButton.TextColor3 = Color3.fromRGB(142,225,255)
ToggleButton.TextSize = 22
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.AutoButtonColor = false
ToggleButton.ZIndex = 20
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0,13)
local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Color = Color3.fromRGB(79,198,255)
ToggleStroke.Transparency = 0.18
ToggleStroke.Thickness = 1.5
local ToggleGradient = Instance.new("UIGradient", ToggleButton)
ToggleGradient.Rotation = 90
ToggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18,54,82)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5,18,34)),
})


-- [G-1] Fade-in: nền kính + blur hiện dần, chữ cascade như bản gốc
task.spawn(function()
    task.wait(0.15)
    TS:Create(Dim, TweenInfo.new(0.6, Enum.EasingStyle.Quad),
        {BackgroundTransparency = _G.Settings.MenuDim}):Play()
    TS:Create(Blur, TweenInfo.new(0.8, Enum.EasingStyle.Quad),
        {Size = _G.Settings.MenuBlur}):Play()
    task.wait(0.15)
    for i,lb in ipairs({TitleL,SubL,StatL,ModeL,TimeL,BeliL,SepL,FragL,KillL,InfoL,DiagL,HintL}) do
        task.delay((i-1)*0.07,function()
            TS:Create(lb,TweenInfo.new(0.55,Enum.EasingStyle.Quad),{TextTransparency=0}):Play()
        end)
    end
    print("[BobonHub v16.6 LIVE] UI Ready!")
end)

local OverlayVisible = true
local function SetOverlayVisible(visible)
    OverlayVisible = visible == true
    Dim.Visible = OverlayVisible
    Con.Visible = OverlayVisible
    ToggleButton.Text = OverlayVisible and "◀" or "B"
    pcall(function()
        if Blur and Blur.Parent then Blur.Enabled = OverlayVisible end
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    SetOverlayVisible(not OverlayVisible)
end)
ToggleButton.MouseEnter:Connect(function()
    TS:Create(ToggleButton, TweenInfo.new(0.15), {
        BackgroundTransparency = 0,
        Size = UDim2.new(0,50,0,62),
    }):Play()
end)
ToggleButton.MouseLeave:Connect(function()
    TS:Create(ToggleButton, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.12,
        Size = UDim2.new(0,46,0,58),
    }):Play()
end)

-- Right Ctrl mirrors the small left-side button.
pcall(function()
    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            SetOverlayVisible(not OverlayVisible)
        end
    end)
end)

-- [G-2] Dọn blur khi UI bị destroy (re-execute / unload)
SG.Destroying:Connect(function()
    pcall(function()
        if Blur and Blur.Parent then Blur:Destroy() end
    end)
end)

local function Fmt(n)
    local s = tostring(math.floor(n or 0))
    return s:reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
end

local StatusColors = {
    Idle         = Color3.fromRGB(190,210,232),
    Farming      = Color3.fromRGB(65,255,145),
    GettingQuest = Color3.fromRGB(255,214,92),
    GettingItem  = Color3.fromRGB(196,120,255),
    Bossing      = Color3.fromRGB(255,116,92),
    UnlockingSea = Color3.fromRGB(75,222,255),
    Recovering   = Color3.fromRGB(255,92,115),
    Dead         = Color3.fromRGB(255,92,115),
    Respawning   = Color3.fromRGB(255,183,85),
}

task.spawn(function()
    while SessionAlive() and task.wait(0.5) do
        pcall(function()
            local e = os.time() - _G.State.StartTime
            TimeL.Text = ("Time: %02d:%02d:%02d"):format(math.floor(e/3600),math.floor(e%3600/60),e%60)
            StatL.Text = "Status: " .. (_G.BobonStatus or "Idle")
            ModeL.Text = "Mode: " .. (_G.State.Mode or "Idle")
            StatL.TextColor3 = StatusColors[_G.State.Mode] or Color3.fromRGB(62,255,220)
            local diag = _G.BobonDiagnostics or {}
            DiagL.Text = ("Combat: %s / %s / targets:%s / %s / dHP:%s  |  Bring: %s c:%s o:%s m:%s")
                :format(tostring(diag.Tool or "?"), tostring(diag.Net or "?"),
                    tostring(diag.Targets or 0), tostring(diag.Packet or "?"),
                    tostring(diag.LastHPDelta or 0), tostring(diag.Bring or "?"),
                    tostring(diag.BringCandidates or 0), tostring(diag.BringOwned or 0),
                    tostring(diag.BringMoved or 0))
            DiagL.TextColor3 = tostring(diag.Packet or ""):find("CONFIRMED", 1, true)
                and Color3.fromRGB(85,255,145) or Color3.fromRGB(255,184,92)
            KillL.Text = "Kills: " .. Fmt(_G.State.KillCount)
            local d = LP:FindFirstChild("Data")
            if d then
                BeliL.Text = "Beli: " .. Fmt(d:FindFirstChild("Beli") and d.Beli.Value or 0)
                FragL.Text = "Fragments: " .. Fmt(d:FindFirstChild("Fragments") and d.Fragments.Value or 0)
                local lv = d:FindFirstChild("Level") and d.Level.Value or 1
                InfoL.Text = ("Sea: %d  |  Level: %s"):format(_G.State.Sea, Fmt(lv))
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
        -- The wrapper is the authoritative active/inactive signal in the
        -- current UI.  A hidden wrapper means the previous quest is over.
        if quest:IsA("GuiObject") and not quest.Visible then return false end
        local container = quest:FindFirstChild("Container") or quest
        local title = container:FindFirstChild("QuestTitle", true)
        local titleText = title and title:FindFirstChild("Title", true)

        -- Completed objectives can leave the title text visible for a short
        -- time.  A visible x/y counter at x >= y is an immediate completion
        -- signal, so request the next quest on this same controller tick.
        for _, node in ipairs(container:GetDescendants()) do
            if node:IsA("TextLabel") and node.Visible then
                local labelText = tostring(node.Text or "")
                local labelLower = string.lower(labelText)
                if labelLower:find("quest completed", 1, true)
                    or labelLower:find("quest complete", 1, true)
                    or labelLower:find("completed", 1, true)
                    or labelLower:find("finished", 1, true) then
                    return false
                end
                local current, total = labelText:match("(%d+)%s*/%s*(%d+)")
                if current and total and tonumber(current) >= tonumber(total) then
                    return false
                end
            end
        end

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
    return IsFiniteVector3(p)
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
            -- Include the task/counter labels too.  Some UI revisions put
            -- only a generic quest name in QuestTitle and the mob name in
            -- QuestTask, so matching the title alone can reject a valid quest.
            local parts = {titleText.Text}
            for _, d in ipairs(container:GetDescendants()) do
                if d:IsA("TextLabel") and d ~= titleText and d.Text and d.Text ~= "" then
                    parts[#parts + 1] = d.Text
                end
            end
            return table.concat(parts, " ")
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
    if not mobName then return nil end
    -- Once this session accepted (or adopted) an active quest, this canonical
    -- name is authoritative. It also makes level-boundary changes explicit:
    -- an old active quest returns false for the next QDB entry and is replaced.
    local activeMob = _G.State and _G.State.ActiveQuestMob
    if activeMob then
        return string.lower(tostring(activeMob))
            == string.lower(tostring(mobName))
    end
    local text = GetQuestText()
    if not text then return nil end
    if string.find(string.lower(text), string.lower(mobName), 1, true) then
        return true
    end
    -- Roblox can render the objective through a localization table (for
    -- example Brute -> a Vietnamese name). An untranslated miss is therefore
    -- unknown, not proof that the player holds the wrong quest.
    return nil
end


-- [FIX-P3] Request quest tại giver với retry có giới hạn, không spam remote.
-- Trả về true = "đã xử lý (đừng farm)", false = "chưa tới giver".
local function HandleQuestAtGiver(q, atGiver)
    if not atGiver then return false end
    local now = tick()
    if now - _G.State.LastQuestRequest < _G.Settings.QuestDelay then
        _G.BobonStatus = "Quest: Waiting for confirmation " .. q.M
        return true
    end
    if _G.State.QuestRetries >= _G.Settings.QuestRetryLimit then
        -- Quá số lần retry → backoff, không spam remote, không farm
        _G.BobonStatus = "Quest: Failed, waiting to retry"
        if now - _G.State.LastQuestRequest >= (_G.Settings.QuestRetryBackoff or 6) then
            _G.State.QuestRetries = 0
        end
        return true
    end
    _G.State.LastQuestRequest = now
    _G.State.QuestRetries = _G.State.QuestRetries + 1
    DLog("QUEST", "StartQuest " .. q.Q .. " level " .. q.QL)
    -- Dọn quest cũ sai mob trước khi request quest mới; nếu không server sẽ
    -- giữ quest cũ và controller tưởng rằng StartQuest bị lỗi.
    local currentMatch = QuestMatches(q.M)
    if currentMatch == false then
        _G.State.ActiveQuestMob = nil
        pcall(function() CommF_:InvokeServer("AbandonQuest") end)
        task.wait(0.15)
    end
    local function VerifyQuestTitle()
        local deadline = tick() + 3
        repeat
            -- Verify both the title and the wrapper.  A completed quest can
            -- leave stale title text behind for a few frames; that must not
            -- be mistaken for a newly accepted quest.
            -- Quest title/UI can be rearranged between game updates.  The
            -- wrapper being active is authoritative; only an explicit mob
            -- mismatch rejects the quest.  `nil` means unreadable, not wrong.
            if HasQuest() == true and QuestMatches(q.M) ~= false then return true end
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
        _G.State.QuestRetries = 0
        _G.State.LastQuestAccepted = tick()
        _G.State.ActiveQuestMob = q.M
        _G.BobonStatus = "Quest: Accepted " .. q.M
        DLog("QUEST", "Accepted: " .. q.M)
    else
        warn("[BobonHub] RequestQuest error (retry " .. _G.State.QuestRetries .. ")")
        _G.BobonStatus = "Quest: Error, retrying " .. q.M
        DLog("QUEST", "Remote error (retry " .. _G.State.QuestRetries .. ")")
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


-- Resolve the live Net folder. Combat backends are capability-detected and
-- must pass a health-delta probe before they are treated as working.
local NetFolderCache = nil
local NetWaitAttempted = false

local function ResolveNet()
    if NetFolderCache and NetFolderCache.Parent then return NetFolderCache end
    -- Current clients keep combat remotes in ReplicatedStorage.Modules.Net.
    -- Prefer that exact path; a recursive search under Remotes can select an
    -- unrelated object also named Net and make every FireServer silently fail.
    local modules = RS:FindFirstChild("Modules")
    if not modules and not NetWaitAttempted then
        NetWaitAttempted = true
        modules = RS:WaitForChild("Modules", 5)
    end
    local exactNet = modules and modules:FindFirstChild("Net")
    if exactNet then
        NetFolderCache = exactNet
        return exactNet
    end
    local roots = {}
    roots[#roots + 1] = RS
    if Remotes then roots[#roots + 1] = Remotes end
    for _, root in ipairs(roots) do
        local net = root:FindFirstChild("Net", true)
        if net then
            NetFolderCache = net
            return net
        end
    end
    return nil
end

local WeaponController
local ClientOwnsMob
local VerifiedGatherRoots = setmetatable({}, { __mode = "k" })
local GatherGeneration = 0

local function ToolCombatKind(tool)
    if not tool or not tool:IsA("Tool") then return nil end
    if tool:FindFirstChild("LeftClickRemote") then return "Gun" end
    local ok, tip = pcall(function() return tostring(tool.ToolTip or "") end)
    tip = ok and string.lower(tip) or ""
    if tip:find("melee", 1, true) then return "Melee" end
    if tip:find("sword", 1, true) or tip:find("blade", 1, true) then return "Sword" end
    if tip:find("gun", 1, true) or tip:find("rifle", 1, true)
        or tip:find("bow", 1, true) then
        return "Gun"
    end
    -- Combat is the only starter style whose tooltip can be temporarily
    -- blank while its controller initializes.
    if tool.Name == "Combat" then return "Melee" end
    -- Once the catalog controller below is initialized, it also covers named
    -- melee styles/swords whose ToolTip is temporarily blank.
    if WeaponController and type(WeaponController.IsCombatTool) == "function"
        and WeaponController:IsCombatTool(tool) then
        return tool:FindFirstChild("LeftClickRemote") and "Gun" or "CloseCombat"
    end
    return nil
end

local function IsCombatToken(value)
    return type(value) == "string" and #value == 8
        and value:match("^%x+$") ~= nil
end

local function IsClientInputBackend(name)
    return name == "CLIENT-MOUSE" or name == "CLIENT-VIM"
        or name == "CLIENT-TOOL"
end

-- Some NPC controllers attach a creator/last-hit marker. When it explicitly
-- names another player, that HP change cannot prove this controller worked.
local function DamageAttributedToOtherPlayer(model, humanoid)
    for _, scope in ipairs({ humanoid, model }) do
        if scope then
            for _, markerName in ipairs({ "creator", "Creator", "LastHitBy", "lastHitBy" }) do
                local marker = scope:FindFirstChild(markerName)
                if marker and marker:IsA("ObjectValue") and marker.Value then
                    local value = marker.Value
                    local player = value:IsA("Player") and value or nil
                    if not player and value:IsA("Model") then
                        player = Players:GetPlayerFromCharacter(value)
                    end
                    if player == LP then return false end
                    if player then
                        -- Creator tags can remain after an older attacker has
                        -- left. Treat the tag as current only while that
                        -- character is still near enough to affect this NPC.
                        local targetRoot = model and model:FindFirstChild("HumanoidRootPart")
                        local otherRoot = player.Character
                            and player.Character:FindFirstChild("HumanoidRootPart")
                        local okPositions, distance = pcall(function()
                            return (targetRoot.Position - otherRoot.Position).Magnitude
                        end)
                        if okPositions and distance <= 60 then return true end
                    end
                end
            end
        end
    end
    return false
end

local CombatController = {
    RegisterAttack = nil,
    RegisterHit = nil,
    GameGlobal = nil,
    NativeHelper = nil,
    HelperScanDone = 0,
    SessionToken = nil,
    SessionTokenSource = nil,
    FailedUntil = {},
    BackendProofs = {},
    BackendLastProof = {},
    VerifiedMisses = {},
    VerifiedBackend = nil,
    FastVerified = false,
    FastVerifiedAt = 0,
    NextFastUpgrade = 0,
    PendingBackend = nil,
    PendingTarget = nil,
    PendingHumanoid = nil,
    PendingSince = 0,
    PendingLastDispatch = 0,
    PendingSettleUntil = 0,
    PendingAttempts = 0,
    NextProbeAt = 0,
    LastConfirmedAt = 0,
    DesiredClientRange = false,
    WatchedModel = nil,
    WatchedHumanoid = nil,
    WatchedHealth = nil,
    WatchedStableSince = 0,
    HealthConnection = nil,
}

function CombatController:ResolveRemotes()
    if self.RegisterAttack and self.RegisterAttack.Parent
        and self.RegisterHit and self.RegisterHit.Parent then
        return true
    end
    local net = ResolveNet()
    self.RegisterAttack = net and net:FindFirstChild("RE/RegisterAttack") or nil
    self.RegisterHit = net and net:FindFirstChild("RE/RegisterHit") or nil
    return self.RegisterAttack ~= nil and self.RegisterHit ~= nil
end

function CombatController:GetGameGlobal()
    if type(self.GameGlobal) == "table" then return self.GameGlobal end
    if type(getrenv) == "function" then
        local ok, env = pcall(getrenv)
        if ok and type(env) == "table" and type(rawget(env, "_G")) == "table" then
            self.GameGlobal = rawget(env, "_G")
            return self.GameGlobal
        end
    end
    return nil
end

function CombatController:ResolveNativeHelper()
    if type(self.NativeHelper) == "function" then return self.NativeHelper end
    local gameGlobal = self:GetGameGlobal()
    local direct = gameGlobal and rawget(gameGlobal, "SendHitsToServer")
    if type(direct) == "function" then
        self.NativeHelper = direct
        return direct
    end
    if type(getsenv) ~= "function" then return nil end
    if tick() - (self.HelperScanDone or 0) < 5 then return nil end
    self.HelperScanDone = tick()
    for _, scope in ipairs({ LP:FindFirstChild("PlayerScripts"), Char() }) do
        if scope then
            for _, scriptObject in ipairs(scope:GetDescendants()) do
                if scriptObject:IsA("LocalScript") then
                    local ok, env = pcall(getsenv, scriptObject)
                    if ok and type(env) == "table" then
                        local helper = rawget(env, "SendHitsToServer")
                        local scopedGlobal = rawget(env, "_G")
                        if type(helper) ~= "function" and type(scopedGlobal) == "table" then
                            helper = rawget(scopedGlobal, "SendHitsToServer")
                        end
                        if type(helper) == "function" then
                            self.NativeHelper = helper
                            return helper
                        end
                    end
                end
            end
        end
    end
    return nil
end

function CombatController:ResolveSessionToken()
    if IsCombatToken(self.SessionToken) then return self.SessionToken end
    local gameGlobal = self:GetGameGlobal()
    local helper = gameGlobal and rawget(gameGlobal, "SendHitsToServer")
    local getUps = type(getupvalues) == "function" and getupvalues
        or (type(debug) == "table" and type(debug.getupvalues) == "function"
            and debug.getupvalues or nil)
    if type(helper) ~= "function" or type(getUps) ~= "function" then return nil end
    local ok, upvalues = pcall(getUps, helper)
    if not ok or type(upvalues) ~= "table" or upvalues[1] == nil then return nil end
    -- Runtime-derived adapter observed in current public clients. It is never
    -- trusted merely because it has the right shape; health delta is the gate.
    local candidate = tostring(LP.UserId):sub(2, 4)
        .. tostring(upvalues[1]):sub(11, 15)
    if IsCombatToken(candidate) then
        self.SessionToken = candidate
        self.SessionTokenSource = "runtime"
        return candidate
    end
    return nil
end

function CombatController:LegacyAllowed()
    local gameGlobal = self:GetGameGlobal()
    return gameGlobal and rawget(gameGlobal, "COMBAT_REMOTE_THREAD") == false
end

local function SelectEnemyHitPart(enemy)
    if not enemy then return nil end
    for _, name in ipairs({
        "LeftHand", "RightHand", "RightLowerLeg", "LeftLowerLeg",
        "Head", "HumanoidRootPart",
    }) do
        local part = enemy:FindFirstChild(name)
        if part and part:IsA("BasePart") then return part end
    end
    return nil
end

function CombatController:CollectTargets(preferred, mobName, maxRange)
    local me = HRP()
    local folder = workspace:FindFirstChild("Enemies")
    if not me or not folder then return {} end
    local results, seen = {}, {}
    local activeQuestMob = _G.State and _G.State.ActiveQuestMob
    local questGatherActive = _G.State.Mode == "Farming"
        and activeQuestMob ~= nil
        and mobName ~= nil
        and string.lower(tostring(activeQuestMob))
            == string.lower(tostring(mobName))
    local now = tick()
    local function add(enemy)
        if not enemy or seen[enemy] then return end
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        local part = SelectEnemyHitPart(enemy)
        local okPosition, rootPosition = pcall(function() return root.Position end)
        if hum and hum.Health > 0 and root and root.Parent and part and part.Parent
            and okPosition and IsValidPos(rootPosition)
            and (rootPosition - me.Position).Magnitude <= maxRange then
            seen[enemy] = true
            results[#results + 1] = { Model=enemy, Humanoid=hum, Root=root, Part=part }
        end
    end
    add(preferred)
    if mobName then
        for _, enemy in ipairs(folder:GetChildren()) do
            if #results >= (_G.Settings.FastAttackMaxTargets or 12) then break end
            if IsEnemyNamed(enemy, mobName) then
                local allowExtra = true
                if questGatherActive and enemy ~= preferred then
                    local root = enemy:FindFirstChild("HumanoidRootPart")
                    local verifiedAt = root and VerifiedGatherRoots[root]
                    allowExtra = verifiedAt ~= nil
                        and now - verifiedAt
                            <= (_G.Settings.GatherVerifiedTTL or 0.6)
                        and type(ClientOwnsMob) == "function"
                        and ClientOwnsMob(root) == true
                end
                if allowExtra then add(enemy) end
            end
        end
    end
    return results
end

function CombatController:ConfirmDamage(backend, delta)
    if not backend or delta <= 0 or self.PendingBackend ~= backend
        or self.PendingHumanoid ~= self.WatchedHumanoid
        or self.PendingTarget ~= self.WatchedModel then
        return
    end
    self.FailedUntil[backend] = nil
    self.VerifiedMisses[backend] = 0
    local now = tick()
    local priorProof = self.BackendLastProof[backend]
    local independentProof = not priorProof
        or priorProof.Target ~= self.WatchedModel
        or now - priorProof.Time >= (_G.Settings.CombatRepeatProofGap or 0.9)
    if independentProof then
        self.BackendProofs[backend] = (self.BackendProofs[backend] or 0) + 1
        self.BackendLastProof[backend] = {
            Target = self.WatchedModel,
            Time = now,
        }
    end
    self.VerifiedBackend = backend
    local isFastBackend = backend == "CLIENT-HELPER"
        or backend == "TOKEN-4" or backend == "LEGACY-2"
    self.FastVerified = isFastBackend
        and self.BackendProofs[backend]
            >= (_G.Settings.CombatProofsRequired or 2)
    self.FastVerifiedAt = now
    self.LastConfirmedAt = self.FastVerifiedAt
    self.DesiredClientRange = IsClientInputBackend(backend)
    if IsClientInputBackend(backend) and self.NextFastUpgrade <= 0 then
        self.NextFastUpgrade = tick()
            + (_G.Settings.CombatFastUpgradeInterval or 90)
    end
    self.PendingBackend = nil
    self.PendingTarget = nil
    self.PendingHumanoid = nil
    self.PendingSince = 0
    self.PendingLastDispatch = 0
    self.PendingSettleUntil = 0
    self.PendingAttempts = 0
    self.NextProbeAt = 0
    local diag = _G.BobonDiagnostics
    diag.Packet = "CONFIRMED"
    diag.Net = backend
    diag.LastHPDelta = delta
    DLog("ATTACK", backend .. " confirmed, HP delta=" .. tostring(delta))
end

function CombatController:WatchTarget(model, humanoid)
    if self.WatchedHumanoid == humanoid then return end
    if self.HealthConnection then self.HealthConnection:Disconnect() end
    self.HealthConnection = nil
    self.WatchedModel = model
    self.WatchedHumanoid = humanoid
    self.WatchedHealth = humanoid and humanoid.Health or nil
    self.WatchedStableSince = tick()
    self.DesiredClientRange = IsClientInputBackend(self.VerifiedBackend)
    self.PendingBackend = nil
    self.PendingTarget = nil
    self.PendingHumanoid = nil
    self.PendingSince = 0
    self.PendingLastDispatch = 0
    self.PendingSettleUntil = 0
    self.PendingAttempts = 0
    self.LastConfirmedAt = 0
    self.NextProbeAt = 0
    _G.BobonDiagnostics.LastHPDelta = 0
    _G.BobonDiagnostics.Targets = 0
    if not humanoid then return end
    self.HealthConnection = humanoid.HealthChanged:Connect(function(newHealth)
        if not SessionAlive() or self.WatchedHumanoid ~= humanoid then return end
        local oldHealth = self.WatchedHealth
        self.WatchedHealth = newHealth
        local now = tick()
        local withinProbe = self.PendingBackend ~= nil
            and self.PendingTarget == model
            and self.PendingHumanoid == humanoid
            and self.PendingAttempts > 0
            and now - self.PendingLastDispatch
                <= (_G.Settings.CombatCausalWindow or 0.65)
        -- A creator marker can update one frame behind a genuine local M1.
        -- For a real client-input click, the short causal window is stronger
        -- evidence than that stale marker; remote/helper probes stay strict.
        local attributedElsewhere = DamageAttributedToOtherPlayer(model, humanoid)
        local clientCausalProof = IsClientInputBackend(self.PendingBackend)
        if oldHealth and newHealth < oldHealth and withinProbe
            and (clientCausalProof or not attributedElsewhere) then
            self:ConfirmDamage(self.PendingBackend, oldHealth - newHealth)
        end
        if oldHealth and newHealth ~= oldHealth then
            self.WatchedStableSince = now
        end
    end)
end

function CombatController:FailBackend(backend, reason)
    if not backend then return end
    self.FailedUntil[backend] = tick() + (_G.Settings.CombatBackendRetry or 12)
    if backend == "TOKEN-4" then self.SessionToken = nil end
    if backend == "CLIENT-HELPER" then
        self.NativeHelper = nil
        self.HelperScanDone = 0
    end
    if not IsClientInputBackend(backend) and backend ~= "GUN-REMOTE" then
        self.NextFastUpgrade = tick()
            + (_G.Settings.CombatFastUpgradeInterval or 90)
    end
    if self.VerifiedBackend == backend then
        self.VerifiedBackend = nil
        self.FastVerified = false
        self.DesiredClientRange = false
    end
    self.BackendProofs[backend] = nil
    self.BackendLastProof[backend] = nil
    self.VerifiedMisses[backend] = nil
    self.PendingBackend = nil
    self.PendingTarget = nil
    self.PendingHumanoid = nil
    self.PendingSince = 0
    self.PendingLastDispatch = 0
    self.PendingSettleUntil = 0
    self.PendingAttempts = 0
    self.NextProbeAt = tick() + 0.25
    _G.BobonDiagnostics.Packet = "FAILED:" .. tostring(reason or backend)
    DLog("ATTACK", backend .. " failed health probe: " .. tostring(reason))
end

-- Range, stun and equip transitions are not evidence that a backend is bad.
-- Cancel that probe without blacklisting it, then retry after the transient
-- physical condition has cleared.
function CombatController:AbortPending(reason)
    self.PendingBackend = nil
    self.PendingTarget = nil
    self.PendingHumanoid = nil
    self.PendingSince = 0
    self.PendingLastDispatch = 0
    self.PendingSettleUntil = 0
    self.PendingAttempts = 0
    self.NextProbeAt = tick() + 0.1
    _G.BobonDiagnostics.Packet = tostring(reason or "WAIT-PHYSICAL")
end

function CombatController:CheckPending(now)
    if not self.PendingBackend then return end
    local maxAttempts = _G.Settings.CombatProbeAttempts or 3
    local timeout = _G.Settings.CombatProbeTimeout or 1.2
    if self.PendingAttempts >= maxAttempts
        and now - self.PendingLastDispatch >= timeout then
        if self.PendingSettleUntil <= 0 then
            self.PendingSettleUntil = now + (_G.Settings.CombatLateGrace or 0.35)
            _G.BobonDiagnostics.Packet = "WAIT-LATE-DAMAGE"
        elseif now >= self.PendingSettleUntil then
            local backend = self.PendingBackend
            local proven = self.VerifiedBackend == backend
                and (self.BackendProofs[backend] or 0)
                    >= (_G.Settings.CombatProofsRequired or 2)
            if proven then
                self.VerifiedMisses[backend] = (self.VerifiedMisses[backend] or 0) + 1
                if self.VerifiedMisses[backend]
                    < (_G.Settings.CombatVerifiedMissLimit or 8) then
                    self:AbortPending("RETRY-VERIFIED:" .. backend)
                    self.NextProbeAt = now + (_G.Settings.CombatVerifiedRetry or 0.25)
                    return
                end
            end
            self:FailBackend(backend, "NO-HP-DELTA")
        end
    end
end

function CombatController:BackendAvailable(name)
    if (self.FailedUntil[name] or 0) > tick() then return false end
    if name == "CLIENT-HELPER" then
        return self:ResolveRemotes() and type(self:ResolveNativeHelper()) == "function"
    elseif name == "TOKEN-4" then
        return self:ResolveRemotes() and IsCombatToken(self:ResolveSessionToken())
    elseif name == "LEGACY-2" then
        return self:ResolveRemotes() and self:LegacyAllowed()
    elseif name == "CLIENT-MOUSE" then
        return type(mouse1click) == "function"
    elseif name == "CLIENT-VIM" or name == "CLIENT-TOOL" then
        return true
    end
    return false
end

function CombatController:SelectBackend(now)
    if self.PendingBackend then
        if self.PendingAttempts >= (_G.Settings.CombatProbeAttempts or 3) then
            return nil
        end
        return self.PendingBackend
    end
    if now < self.NextProbeAt then return nil end
    if self.VerifiedBackend and self:BackendAvailable(self.VerifiedBackend) then
        if not IsClientInputBackend(self.VerifiedBackend) or now < self.NextFastUpgrade then
            return self.VerifiedBackend
        end
    end
    for _, name in ipairs({
        "CLIENT-HELPER", "TOKEN-4", "LEGACY-2",
        "CLIENT-MOUSE", "CLIENT-VIM", "CLIENT-TOOL",
    }) do
        if self:BackendAvailable(name) then return name end
    end
    return nil
end

function CombatController:IsFastReady()
    local ttl = _G.Settings.CombatVerificationTTL or 120
    return self.FastVerified and self.VerifiedBackend ~= nil
        and tick() - (self.FastVerifiedAt or 0) <= ttl
        and (self.FailedUntil[self.VerifiedBackend] or 0) <= tick()
end

function CombatController:IsDamageReady()
    local ttl = _G.Settings.CombatVerificationTTL or 120
    return self.VerifiedBackend ~= nil
        and (self.BackendProofs[self.VerifiedBackend] or 0)
            >= (_G.Settings.CombatProofsRequired or 2)
        and tick() - (self.FastVerifiedAt or 0) <= ttl
        and (self.FailedUntil[self.VerifiedBackend] or 0) <= tick()
end

function CombatController:WantsClientRange()
    return self.DesiredClientRange == true
end

function CombatController:DispatchClientClick(tool, targetRoot, backend)
    local camera = workspace.CurrentCamera
    local okTarget, targetPosition = pcall(function() return targetRoot.Position end)
    if not okTarget or not IsValidPos(targetPosition) then return false end
    if camera then
        pcall(function()
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPosition)
        end)
    end
    if backend == "CLIENT-MOUSE" and type(mouse1click) == "function" then
        return pcall(mouse1click)
    end
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local clickPos = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
    if backend == "CLIENT-VIM" then
        local ok = pcall(function()
            VIM:SendMouseButtonEvent(clickPos.X, clickPos.Y, 0, true, game, 0)
        end)
        if not ok then return false end
        task.delay(0.04, function()
            if not SessionAlive() then return end
            pcall(function()
                VIM:SendMouseButtonEvent(clickPos.X, clickPos.Y, 0, false, game, 0)
            end)
        end)
        return true
    end
    if backend == "CLIENT-TOOL" then
        local ok = pcall(function() tool:Activate() end)
        if ok then
            task.delay(0.05, function()
                if SessionAlive() and tool and tool.Parent then
                    pcall(function() tool:Deactivate() end)
                end
            end)
        end
        return ok
    end
    return false
end

function CombatController:Dispatch(backend, tool, entries, preferredRoot)
    if #entries == 0 then return false end
    if IsClientInputBackend(backend) then
        return self:DispatchClientClick(tool, preferredRoot, backend)
    elseif backend == "CLIENT-HELPER" then
        local helper = self:ResolveNativeHelper()
        local hitList = {}
        for _, entry in ipairs(entries) do
            hitList[#hitList + 1] = { entry.Model, entry.Part }
        end
        pcall(function() self.RegisterAttack:FireServer(0) end)
        local hitOk = pcall(function() helper(entries[1].Part, hitList) end)
        return hitOk
    elseif backend == "TOKEN-4" then
        local token = self:ResolveSessionToken()
        local hitOk = false
        for _, entry in ipairs(entries) do
            pcall(function() self.RegisterAttack:FireServer(0.5) end)
            local ok = pcall(function()
                self.RegisterHit:FireServer(entry.Part, {}, nil, token)
            end)
            hitOk = hitOk or ok
        end
        return hitOk
    elseif backend == "LEGACY-2" then
        local hitList = {}
        for _, entry in ipairs(entries) do
            hitList[#hitList + 1] = { entry.Model, entry.Part }
        end
        pcall(function() self.RegisterAttack:FireServer(0) end)
        local hitOk = pcall(function()
            self.RegisterHit:FireServer(entries[1].Part, hitList)
        end)
        return hitOk
    elseif backend == "GUN-REMOTE" then
        local remote = tool:FindFirstChild("LeftClickRemote")
        local playerRoot = HRP()
        if not remote or not playerRoot then return false end
        local playerPosition = playerRoot.Position
        local sent = false
        for _, entry in ipairs(entries) do
            local okRoot, enemyPosition = pcall(function() return entry.Root.Position end)
            local direction = okRoot and (enemyPosition - playerPosition) or nil
            if direction and direction.Magnitude > 0.01 then
                local ok = pcall(function() remote:FireServer(direction.Unit, 1) end)
                sent = sent or ok
            end
        end
        return sent
    end
    return false
end

function CombatController:Attack(tool, kind, preferredModel, preferredHum, preferredRoot, mobName)
    local now = tick()
    self:WatchTarget(preferredModel, preferredHum)

    -- Choose the desired physical range before dispatching. Fast/helper
    -- probes stay at safe hover; only an actual client-input backend asks the
    -- travel controller to descend into real melee/sword range.
    local candidateBackend = kind == "Gun" and "GUN-REMOTE"
        or self.PendingBackend or self:SelectBackend(now)
    self.DesiredClientRange = IsClientInputBackend(candidateBackend)
        or (not candidateBackend and IsClientInputBackend(self.VerifiedBackend))
    if not candidateBackend then
        _G.BobonDiagnostics.Packet = "WAIT-BACKEND"
        return false
    end
    local candidateInputBackend = IsClientInputBackend(candidateBackend)
    local candidateRange = candidateInputBackend
        and (_G.Settings.ClientAttackRange or 8)
        or (_G.Settings.FastAttackRange or 100)
    local me = HRP()
    local okPreferred, preferredPosition = pcall(function()
        return preferredRoot.Parent and preferredRoot.Position or nil
    end)
    if not me or not okPreferred or not IsValidPos(preferredPosition)
        or (preferredPosition - me.Position).Magnitude > candidateRange then
        if self.PendingBackend then self:AbortPending("APPROACHING") end
        _G.BobonDiagnostics.Packet = "APPROACHING"
        return false
    end
    if tool.Parent ~= Char() then
        self:AbortPending("WAIT-TOOL-READY")
        return false
    end
    if tool.Enabled == false then
        -- Normal M1 cooldown often disables the Tool before its server damage
        -- arrives. Keep the pending causal probe alive so that delayed HP loss
        -- can confirm the click instead of making combat reset after one hit.
        _G.BobonDiagnostics.Packet = "WAIT-TOOL-COOLDOWN"
        return false
    end
    if WeaponController and type(WeaponController.IsReady) == "function"
        and not WeaponController:IsReady(tool) then
        self:AbortPending("WAIT-EQUIP-SETTLE")
        return false
    end
    local character = Char()
    for _, flagName in ipairs({ "Stun", "Busy" }) do
        local flag = character and character:FindFirstChild(flagName)
        if flag and ((flag:IsA("BoolValue") and flag.Value)
            or (flag:IsA("NumberValue") and flag.Value > 0)) then
            self:AbortPending("WAIT-" .. string.upper(flagName))
            return false
        end
        local attribute = character and character:GetAttribute(flagName)
        if attribute == true or (type(attribute) == "number" and attribute > 0) then
            self:AbortPending("WAIT-" .. string.upper(flagName))
            return false
        end
    end

    -- Validate the streamed hit part before allowing an old pending probe to
    -- time out. A despawned limb/root is a target transition, not evidence
    -- that the combat backend failed.
    local candidateEntries = self:CollectTargets(preferredModel,
        candidateInputBackend and nil or mobName, candidateRange)
    if #candidateEntries == 0 then
        self:AbortPending("NO-TARGETS")
        return false
    end

    -- Before the first proof (or after TTL expiry), require a short quiet HP
    -- baseline. This makes ambient/DOT damage less likely to validate a bad
    -- backend. Existing in-flight probes are allowed to finish normally.
    if not self.PendingBackend and not self:IsDamageReady()
        and now - (self.WatchedStableSince or now)
            < (_G.Settings.CombatBaselineQuiet or 0.25) then
        _G.BobonDiagnostics.Packet = "WAIT-STABLE-HP"
        return false
    end

    -- Only expire a health probe while its target, tool and character are in
    -- a valid attacking state. Physical interruptions above abort, not fail.
    self:CheckPending(now)
    local backend = kind == "Gun" and "GUN-REMOTE" or self:SelectBackend(now)
    if not backend then
        self.DesiredClientRange = IsClientInputBackend(self.PendingBackend)
            or IsClientInputBackend(self.VerifiedBackend)
        _G.BobonDiagnostics.Packet = "WAIT-HP"
        return false
    end
    local inputBackend = IsClientInputBackend(backend)
    self.DesiredClientRange = inputBackend
    local range = inputBackend
        and (_G.Settings.ClientAttackRange or 8)
        or (_G.Settings.FastAttackRange or 100)
    if (preferredPosition - me.Position).Magnitude > range then
        if self.PendingBackend then self:AbortPending("APPROACHING") end
        _G.BobonDiagnostics.Packet = "APPROACHING"
        return false
    end
    local entries = backend == candidateBackend and candidateEntries
        or self:CollectTargets(preferredModel,
            inputBackend and nil or mobName, range)
    if #entries == 0 then
        self:AbortPending("NO-TARGETS")
        return false
    end
    if now - _G.State.LastAttackTime < (_G.Settings.AttackDelay or 0.08) then
        return false
    end
    _G.State.LastAttackTime = now
    if self.PendingBackend ~= backend then
        self.PendingBackend = backend
        self.PendingTarget = preferredModel
        self.PendingHumanoid = preferredHum
        self.PendingSince = now
        self.PendingLastDispatch = 0
        self.PendingSettleUntil = 0
        self.PendingAttempts = 0
    end
    -- Probe only the watched primary. Once that backend has produced real HP
    -- deltas, helper/remote backends may fan out to the matching cluster.
    local dispatchEntries = entries
    if self.VerifiedBackend ~= backend or not self:IsFastReady() then
        dispatchEntries = { entries[1] }
    end
    local attempted = self:Dispatch(backend, tool, dispatchEntries, preferredRoot)
    local diag = _G.BobonDiagnostics
    diag.Net = backend
    diag.Targets = #entries
    if attempted then
        self.PendingAttempts = self.PendingAttempts + 1
        self.PendingLastDispatch = now
        self.PendingSettleUntil = 0
        diag.Packet = "ATTEMPT:" .. backend
    else
        self:FailBackend(backend, "DISPATCH-ERROR")
        diag.Packet = "ERROR:" .. backend
    end
    return attempted
end

function CombatController:Cleanup()
    if self.HealthConnection then self.HealthConnection:Disconnect() end
    self.HealthConnection = nil
    self.WatchedHumanoid = nil
    self.WatchedModel = nil
    self.WatchedHealth = nil
    self.NativeHelper = nil
    self.HelperScanDone = 0
    self.SessionToken = nil
    self.SessionTokenSource = nil
    self.GameGlobal = nil
    self.VerifiedBackend = nil
    self.FastVerified = false
    self.FastVerifiedAt = 0
    self.LastConfirmedAt = 0
    self.PendingBackend = nil
    self.PendingTarget = nil
    self.PendingHumanoid = nil
    self.PendingSince = 0
    self.PendingLastDispatch = 0
    self.PendingSettleUntil = 0
    self.PendingAttempts = 0
    self.NextProbeAt = 0
    self.FailedUntil = {}
    self.BackendProofs = {}
    self.BackendLastProof = {}
    self.VerifiedMisses = {}
    self.NextFastUpgrade = 0
    self.DesiredClientRange = false
    self.WatchedStableSince = 0
end

local function Attack(preferredTarget, mobName)
    if not IsAlive() then return false end
    local c = Char()
    local tool = c and c:FindFirstChildOfClass("Tool")
    local kind = ToolCombatKind(tool)
    if not tool or not kind then
        _G.BobonDiagnostics.Tool = tool and ("INVALID:" .. tool.Name) or "NO-TOOL"
        _G.BobonDiagnostics.Packet = "BLOCKED-TOOL"
        return false
    end
    local targetRoot = preferredTarget and preferredTarget:IsA("BasePart")
        and preferredTarget
        or (preferredTarget and preferredTarget:FindFirstChild("HumanoidRootPart"))
    local targetModel = targetRoot and targetRoot:FindFirstAncestorOfClass("Model")
    local targetHum = targetModel and targetModel:FindFirstChildOfClass("Humanoid")
    if not targetRoot or not targetRoot.Parent or not targetHum or targetHum.Health <= 0 then
        _G.BobonDiagnostics.Packet = "INVALID-TARGET"
        return false
    end
    _G.BobonDiagnostics.Tool = tool.Name
    return CombatController:Attack(tool, kind, targetModel, targetHum, targetRoot, mobName)
end

local function PrepareCombatTarget(target)
    if not target then return end
    local root = target:IsA("BasePart") and target or target:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart") then return end
    pcall(function()
        -- Undo the exact 50^3 mutation made by the previous hotfix, then leave
        -- enemy geometry untouched. Direct/client combat does not need it.
        if root.Size == Vector3.new(50, 50, 50) then
            root.Size = Vector3.new(2, 2, 1)
        end
    end)
end


local MeleeList = {
    "Godhuman","Superhuman","Death Step","Electric Claw",
    "Dragon Talon","Sharkman Karate","Dragon Claw",
    "Fishman Karate","Water Kung Fu","Dark Step","Black Leg",
    "Electro","Combat","Dragon Breath","Sanguine Art"
}


-- [A-2] EQUIPMENT CONTROLLER — melee equip có cooldown + verify
-- [FIX-P5] EquipMelee() trả về true nếu đã có melee trên tay
local EquipmentController = {}
EquipmentController.LastEquip = 0
EquipmentController.LastResult = "none"
EquipmentController.PendingName = nil

local function ToolCategoryText(tool)
    if not tool or not tool:IsA("Tool") then return "" end
    local values = {}
    local okTip, tip = pcall(function() return tool.ToolTip end)
    if okTip and type(tip) == "string" then values[#values + 1] = tip end
    for _, attributeName in ipairs({ "ToolType", "Type", "Category", "WeaponType" }) do
        local okAttribute, value = pcall(function()
            return tool:GetAttribute(attributeName)
        end)
        if okAttribute and type(value) == "string" then
            values[#values + 1] = value
        end
        local valueObject = tool:FindFirstChild(attributeName)
        if valueObject and valueObject:IsA("StringValue") then
            values[#values + 1] = valueObject.Value
        end
    end
    return string.lower(table.concat(values, " "))
end

local function IsMeleeTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    for _, name in ipairs(MeleeList) do
        if tool.Name == name then return true end
    end
    local category = ToolCategoryText(tool)
    return string.find(category, "melee", 1, true) ~= nil
        or string.find(category, "fighting style", 1, true) ~= nil
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
    "Pipe","Dual-Headed Blade","Shark Saw","Soul Cane","Bisento",
    "Saber","Pole (1st Form)","Pole (2nd Form)","Jitte","Longsword",
    "Dragon Trident","Gravity Cane","Koko","Dark Blade",
    "True Triple Katana","Saddi","Shisui","Wando",
    "Rengoku","Midnight Blade","Yama","Tushita","Buddy Sword",
    "Canvander","Twin Hooks","Spikey Trident","Cursed Dual Katana",
    "Dark Dagger","Hallow Scythe","Shark Anchor","Fox Lamp",
    "Gravity Blade","Dragonheart",
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
    local category = ToolCategoryText(tool)
    return string.find(category, "sword", 1, true) ~= nil
        or string.find(category, "blade", 1, true) ~= nil
end

local function IsGunTool(tool)
    if ToolNameIn(GunList, tool) then return true end
    local category = ToolCategoryText(tool)
    return string.find(category, "gun", 1, true) ~= nil
        or string.find(category, "rifle", 1, true) ~= nil
        or string.find(category, "bow", 1, true) ~= nil
end

WeaponController = {
    LastEquip = 0,
    LastResult = "none",
    HeldTool = nil,
    ReadyAt = 0,
}

function WeaponController:IsCombatTool(tool)
    return IsMeleeTool(tool) or IsSwordTool(tool) or IsGunTool(tool)
end

function WeaponController:IsReady(tool)
    return tool ~= nil and tool.Parent == Char() and tool.Enabled ~= false
        and self.HeldTool == tool and tick() >= (self.ReadyAt or 0)
end

function WeaponController:EquipPreferred()
    local c = Char()
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if not c or not hum then
        self.HeldTool = nil
        self.ReadyAt = 0
        self.LastResult = "noChar"
        return false
    end
    local now = tick()
    local held = c:FindFirstChildOfClass("Tool")
    if held and self:IsCombatTool(held) then
        if self.HeldTool ~= held then
            self.HeldTool = held
            self.ReadyAt = now + (_G.Settings.EquipSettle or 0.35)
        end
        self.LastResult = "holding:" .. held.Name
        _G.BobonDiagnostics.Tool = held.Name
        return self:IsReady(held)
    end
    self.HeldTool = nil
    self.ReadyAt = 0
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
        self.LastResult = "noCombatTool"
        _G.BobonDiagnostics.Tool = "NO-TOOL"
        return false
    end
    self.LastEquip = now
    local ok = pcall(function() hum:EquipTool(candidate) end)
    local equipped = ok and candidate.Parent == c
    if equipped then
        self.HeldTool = candidate
        self.ReadyAt = now + (_G.Settings.EquipSettle or 0.35)
    end
    self.LastResult = equipped and "settling:" .. candidate.Name
        or (ok and "equipping:" .. candidate.Name or "equipError")
    _G.BobonDiagnostics.Tool = equipped and candidate.Name or self.LastResult
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
            if not IsAllowedWorldPosition(pos) then continue end
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
            IsSubmergedPosition(mobPos) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY),
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
    DLog("TEAM", "No team → selecting Pirates (retry " .. self.Retries .. ")")
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
local TravelManager
local FarmPositionController = {
    LastGather = 0,
    LastSimulationTry = 0,
    SimulationReady = false,
}


function FarmPositionController:GetFarmPos(mob, requestedHeight)
    if not mob then return nil end
    local root = mob:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local ok, pos = pcall(function() return root.Position end)
    if not ok or not IsValidPos(pos) then return nil end
    local hoverHeight = requestedHeight or _G.Settings.FarmHeight
    return Vector3.new(
        pos.X + _G.Settings.FarmOffsetX,
        math.max(pos.Y + hoverHeight,
            IsSubmergedPosition(pos) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY),
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
                and IsAllowedWorldPosition(pos)
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
            IsSubmergedPosition(avg) and (_G.Settings.UnderwaterMinY + 25) or _G.Settings.MinY),
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
            if IsAllowedWorldPosition(p)
                and (p - center).Magnitude <= _G.Settings.MobGatherRadius then
                return true
            end
        end
    end
    return false
end

-- Bring writes only an owned assembly's CFrame/current velocities. It never
-- leaves Humanoid, collision or anchored properties to restore. Releasing is
-- therefore a logical stop plus a diagnostic reset; the server keeps control
-- of every assembly that is not currently client-owned.
function FarmPositionController:ReleaseCluster()
    GatherGeneration = GatherGeneration + 1
    VerifiedGatherRoots = setmetatable({}, { __mode = "k" })
    _G.BobonDiagnostics.Bring = "OFF"
    _G.BobonDiagnostics.BringCandidates = 0
    _G.BobonDiagnostics.BringOwned = 0
    _G.BobonDiagnostics.BringMoved = 0
end

local function ExpandSimulationRadius()
    local now = tick()
    -- Public bring implementations refresh this continuously. Do it from the
    -- existing farm tick at a bounded rate so the executor/server cannot reset
    -- the radius and silently turn later moves into client-only ghosts.
    if now - (FarmPositionController.LastSimulationTry or 0)
        < (_G.Settings.GatherSimulationRefresh or 0.75) then
        return FarmPositionController.SimulationReady == true
    end
    FarmPositionController.LastSimulationTry = now
    local requested = false
    -- Keep the request inside the local farm envelope. Success here is never
    -- treated as ownership proof; every NPC is checked independently below.
    local radius = math.clamp(
        (_G.Settings.GatherMaxDistance or 250) + 75, 100, 500)

    if type(setscriptable) == "function" then
        local ok = pcall(function()
            setscriptable(LP, "SimulationRadius", true)
            LP.SimulationRadius = radius
        end)
        requested = requested or ok
    end
    if type(sethiddenproperty) == "function" then
        local ok = pcall(function()
            sethiddenproperty(LP, "SimulationRadius", radius)
            pcall(function()
                sethiddenproperty(LP, "MaximumSimulationRadius", radius)
            end)
        end)
        requested = requested or ok
    end
    if type(setsimulationradius) == "function" then
        local ok = pcall(function() setsimulationradius(radius, radius) end)
        requested = requested or ok
    end
    FarmPositionController.SimulationReady = requested
    return requested
end

ClientOwnsMob = function(root)
    -- true is the only state allowed to move. false means server/other-client
    -- ownership; nil means this executor cannot prove ownership. Treating nil
    -- as true was the exact source of the visible but invulnerable dummy mob.
    if type(isnetworkowner) == "function" then
        local ok, owned = pcall(isnetworkowner, root)
        if ok then return owned == true end
    end
    -- Some environments expose the Roblox method even when the convenience
    -- global is absent. It is normally server-restricted, hence the pcall.
    local ok, owner = pcall(function() return root:GetNetworkOwner() end)
    if ok then return owner == LP end
    return nil
end

-- Gather only the canonical mob of the quest that this session can identify.
-- Public bring scripts commonly request SimulationRadius and then CFrame every
-- NPC; that produces a client-only dummy whenever ownership was not granted.
-- Here `ClientOwnsMob(root) == true` is a hard precondition for every write.
function FarmPositionController:GatherMobCluster(mobName, primary)
    local function StopBring(mode)
        self:ReleaseCluster()
        _G.BobonDiagnostics.Bring = mode
        return 0
    end

    if not primary or not mobName then return StopBring("INVALID") end
    local activeQuestMob = _G.State.ActiveQuestMob
    if not activeQuestMob
        or string.lower(tostring(activeQuestMob))
            ~= string.lower(tostring(mobName))
        or not IsEnemyNamed(primary, activeQuestMob) then
        return StopBring(activeQuestMob and "QUEST-MISMATCH" or "QUEST-UNKNOWN")
    end

    local primaryRoot = primary:FindFirstChild("HumanoidRootPart")
    if _G.State.Mode ~= "Farming"
        or _G.State.ActiveActionToken ~= 0
        or not CombatController:IsDamageReady()
        or not _G.State:IsTargetValid(primary)
        or _G.State.FarmTarget ~= primary
        or not _G.State.IsTraveling
        or _G.State.MovementOwner ~= "Farm"
        or not TravelManager
        or TravelManager.TargetRef ~= primaryRoot
        or not TravelManager:IsAtCombatAnchor(primaryRoot) then
        return StopBring("WAIT-FARM-ANCHOR")
    end

    local now = tick()
    local verifiedTTL = _G.Settings.GatherVerifiedTTL or 0.6
    for root, verifiedAt in pairs(VerifiedGatherRoots) do
        if not root.Parent or now - verifiedAt > verifiedTTL then
            VerifiedGatherRoots[root] = nil
        end
    end
    if now - self.LastGather < (_G.Settings.GatherInterval or 0.15) then
        return 0
    end
    self.LastGather = now

    local folder = workspace:FindFirstChild("Enemies")
    if not primaryRoot or not folder then return StopBring("NO-ENEMIES") end
    local okOrigin, origin = pcall(function() return primaryRoot.Position end)
    if not okOrigin or not IsValidPos(origin) then
        return StopBring("INVALID-ANCHOR")
    end

    local playerRoot = HRP()
    local activeHeight = (CombatController:IsFastReady()
        or not CombatController:WantsClientRange())
        and (_G.Settings.FarmHeight or 15)
        or (_G.Settings.ClientHoverHeight or 5)
    local anchorPos = self:GetFarmPos(primary, activeHeight)
    if not playerRoot or not anchorPos then return StopBring("NO-PLAYER") end
    local okPlayerPos, playerPos = pcall(function() return playerRoot.Position end)
    if not okPlayerPos or not IsValidPos(playerPos)
        or (playerPos - anchorPos).Magnitude
            > (_G.Settings.HoverConfirmRadius or 5) then
        return StopBring("WAIT-FARM-ANCHOR")
    end

    local gatherAll = _G.Settings.GatherAllQuestMobs == true
    local maxDistance = gatherAll
        and math.min(_G.Settings.GatherMaxDistance or 250, 250)
        or math.min(_G.Settings.MobGatherRadius or 50, 250)
    local spacing = math.max(_G.Settings.GatherSpacing or 5, 3)
    local simulationRequested = ExpandSimulationRadius()
    local eligible = {}

    for _, mob in ipairs(folder:GetChildren()) do
        local hum = mob:FindFirstChildOfClass("Humanoid")
        local root = mob:FindFirstChild("HumanoidRootPart")
        if mob ~= primary and IsEnemyNamed(mob, activeQuestMob)
            and hum and hum.Health > 0 and root and root.Parent
            and not root.Anchored then
            local okPos, mobPos = pcall(function() return root.Position end)
            if okPos and IsValidPos(mobPos) and IsAllowedWorldPosition(mobPos)
                and IsSubmergedPosition(mobPos) == IsSubmergedPosition(origin) then
                local fromAnchor = (mobPos - origin).Magnitude
                local fromPlayer = (mobPos - playerPos).Magnitude
                if fromAnchor <= maxDistance and fromPlayer <= maxDistance then
                    eligible[#eligible + 1] = {
                        Model = mob,
                        Humanoid = hum,
                        Root = root,
                        Position = mobPos,
                        Distance = fromAnchor,
                    }
                end
            end
        end
    end

    table.sort(eligible, function(a, b) return a.Distance < b.Distance end)
    local candidateLimit = math.max(
        (_G.Settings.FastAttackMaxTargets or 12) - 1, 0)
    local candidates = math.min(#eligible, candidateLimit)
    local ownedCount = 0
    local moved = 0
    local sawUnknownOwnership = false
    local sawUnowned = false
    local attempted = {}
    local myGatherGeneration = GatherGeneration

    for index = 1, candidates do
        if GatherGeneration ~= myGatherGeneration then return 0 end
        local entry = eligible[index]
        local owned = ClientOwnsMob(entry.Root)
        if owned == nil then
            VerifiedGatherRoots[entry.Root] = nil
            sawUnknownOwnership = true
        elseif owned == false then
            VerifiedGatherRoots[entry.Root] = nil
            sawUnowned = true
        else
            ownedCount = ownedCount + 1
            local angle = ((index - 1) / math.max(candidates, 1))
                * math.pi * 2
            local destination = origin + Vector3.new(
                math.cos(angle) * spacing, 0, math.sin(angle) * spacing)

            -- Ownership is dynamic, so check it again immediately before the
            -- only physics write. Never freeze Humanoid/collision/anchor state.
            if ClientOwnsMob(entry.Root) == true then
                local okMove = pcall(function()
                    local rotation = entry.Root.CFrame.Rotation
                    entry.Root.CFrame = CFrame.new(destination) * rotation
                    entry.Root.AssemblyLinearVelocity = Vector3.zero
                    entry.Root.AssemblyAngularVelocity = Vector3.zero
                end)
                if okMove then
                    attempted[#attempted + 1] = {
                        Root = entry.Root,
                        Humanoid = entry.Humanoid,
                        Destination = destination,
                    }
                else
                    VerifiedGatherRoots[entry.Root] = nil
                end
            else
                VerifiedGatherRoots[entry.Root] = nil
                sawUnowned = true
            end
        end
    end

    -- Assignment success is not replication success. Wait one physics frame,
    -- then count only roots that remain owned and at the requested position.
    if #attempted > 0 then RunService.Heartbeat:Wait() end
    if GatherGeneration ~= myGatherGeneration
        or not SessionAlive()
        or _G.State.Mode ~= "Farming"
        or _G.State.ActiveQuestMob ~= activeQuestMob
        or _G.State.FarmTarget ~= primary
        or not _G.State.IsTraveling
        or _G.State.MovementOwner ~= "Farm"
        or TravelManager.TargetRef ~= primaryRoot
        or not TravelManager:IsAtCombatAnchor(primaryRoot) then
        return 0
    end
    local tolerance = _G.Settings.GatherPersistTolerance or 8
    for _, attempt in ipairs(attempted) do
        local okPersisted, position = pcall(function()
            return attempt.Root.Parent and attempt.Humanoid.Health > 0
                and attempt.Root.Position or nil
        end)
        if okPersisted and IsValidPos(position)
            and ClientOwnsMob(attempt.Root) == true
            and (position - attempt.Destination).Magnitude <= tolerance then
            moved = moved + 1
            VerifiedGatherRoots[attempt.Root] = tick()
        else
            VerifiedGatherRoots[attempt.Root] = nil
            sawUnowned = true
        end
    end

    local bringMode
    if candidates == 0 then
        bringMode = "SOLO"
    elseif moved > 0 then
        bringMode = "OWNED"
    elseif sawUnknownOwnership then
        bringMode = "NO-OWNERSHIP-API"
    elseif ownedCount > 0 then
        bringMode = "OWNERSHIP-LOST"
    elseif sawUnowned and simulationRequested then
        bringMode = "WAIT-OWNERSHIP"
    else
        bringMode = "SIM-UNAVAILABLE"
    end
    _G.BobonDiagnostics.Bring = bringMode
    _G.BobonDiagnostics.BringCandidates = candidates
    _G.BobonDiagnostics.BringOwned = ownedCount
    _G.BobonDiagnostics.BringMoved = moved
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
TravelManager = {}
TravelManager.ActiveThread = nil
TravelManager.CurrentToken = 0
TravelManager.TargetRef = nil
TravelManager.CurrentOptions = nil
TravelManager.AtCombatAnchor = false
TravelManager.AtCombatTarget = nil
TravelManager.DodgeOffset = Vector3.zero
TravelManager.DodgeUntil = 0
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
    if targetPos.X > 50000 then
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
    -- Never delete arbitrary movers created by the game, a weapon or another
    -- controller. Bobon owns only the two references above.
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
        if not SessionAlive() then return end
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
    self.CurrentOptions = nil
    self.AtCombatAnchor = false
    self.AtCombatTarget = nil
    self.DodgeOffset = Vector3.zero
    self.DodgeUntil = 0
    _G.State.IsTraveling = false
    -- [A-3] Release movement owner qua MovementManager API
    MovementManager:Release()
    self:CleanupPhysics(Char())
    self:DisableNoclip()
end

function TravelManager:IsAtCombatAnchor(target)
    return self.AtCombatAnchor and (not target or self.AtCombatTarget == target)
end

function TravelManager:ApplyDodgeOffset(offset, duration)
    if typeof(offset) ~= "Vector3" or not self.AtCombatAnchor
        or not self.CurrentOptions or not self.CurrentOptions.combatHover then
        return false
    end
    self.DodgeOffset = offset
    self.DodgeUntil = tick() + (duration or 0.25)
    return true
end

local function SameTravelOptions(a, b)
    if not a or not b then return false end
    return a.arrivalThreshold == b.arrivalThreshold
        and a.speed == b.speed
        and a.fallback == b.fallback
        and a.combatHover == b.combatHover
        and a.persistent == b.persistent
        and a.hoverHeight == b.hoverHeight
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

    local targetModel = nil
    local targetHumanoid = nil
    local targetPosition = nil
    if targetType == "Instance" then
        if not targetCF.Parent then return false, "InvalidTarget" end
        targetModel = targetCF:IsA("Model") and targetCF
            or targetCF:FindFirstAncestorOfClass("Model")
        targetHumanoid = targetModel and targetModel:FindFirstChildOfClass("Humanoid")
        if targetHumanoid and targetHumanoid.Health <= 0 then return false, "InvalidTarget" end
        local okPos, pos = pcall(function()
            if targetCF:IsA("BasePart") then return targetCF.Position end
            if targetCF:IsA("Model") then return targetCF:GetPivot().Position end
            return nil
        end)
        if not okPos or (pos and not IsValidPos(pos)) then return false, "InvalidTarget" end
        if pos and not IsAllowedWorldPosition(pos) then return false, "InvalidTarget" end
        targetPosition = pos
    elseif targetType == "CFrame" or targetType == "Vector3" then
        -- [FIX-P11] Reject NaN/invalid position ngay tại Request()
        local pos = typeof(targetCF) == "CFrame" and targetCF.Position or targetCF
        if not IsValidPos(pos) then return false, "InvalidTarget" end
        targetPosition = pos
    end

    local enemyFolder = workspace:FindFirstChild("Enemies")
    local inferredCombat = targetModel and targetHumanoid
        and enemyFolder and targetModel.Parent == enemyFolder
    local normalizedOptions = {
        combatHover = options.combatHover == true
            or (options.combatHover ~= false and inferredCombat == true),
        hoverHeight = options.hoverHeight,
        fallback = options.fallback,
        speed = options.speed or _G.Settings.FlySpeed,
        persistent = options.persistent == true
            or (options.persistent ~= false and owner == "Farm"
                and targetType ~= "Instance"),
    }
    normalizedOptions.arrivalThreshold = options.arrivalThreshold
        or (normalizedOptions.combatHover and _G.Settings.FarmArrivalThreshold)
        or _G.Settings.CloseThreshold


    -- A different owner must never invalidate the active travel token.
    if _G.State.IsTraveling and _G.State.MovementOwner ~= owner then
        return false, "MovementBusy"
    end

    -- Same owner may reuse a thread only when the complete goal is unchanged.
    -- Retargeting q.MC -> enemy must also replace threshold/fallback/cruise;
    -- keeping the old 35-stud goal was the permanent APPROACHING bug.
    local needsRetarget = false
    if _G.State.IsTraveling and _G.State.MovementOwner == owner and self.ActiveThread then
        if self.TargetRef == targetCF
            and SameTravelOptions(self.CurrentOptions, normalizedOptions) then
            return true, self.CurrentToken
        end
        needsRetarget = true
    end


    -- [FIX-P1] Detect long-distance travel → cruise mode + timeout động
    local startPos = HRP() and HRP().Position
    local startDist = nil
    local startSubmerged = startPos and IsSubmergedPosition(startPos) or false
    local targetSubmerged = targetPosition and IsSubmergedPosition(targetPosition) or false
    -- Submerged entry/exit is handled by its verified access controller.
    -- Reject a cross-boundary body flight before any ordinary entrance remote
    -- can yield or alter the currently safe travel goal.
    if targetSubmerged and not startSubmerged then
        return false, "AwaitingSubmergedEntrance"
    elseif startSubmerged and not targetSubmerged then
        return false, "SubmergedExitRequired"
    end

    if startPos and IsValidPos(startPos) then
        local tpos = targetPosition
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

    -- Validation above may yield while an entrance remote responds. Keep the
    -- old safe travel alive until the replacement goal is fully accepted.
    if needsRetarget then self:Stop("AtomicRetarget") end


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
    self.CurrentOptions = normalizedOptions
    self.AtCombatAnchor = false
    self.AtCombatTarget = nil
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
        local travelOptions = self.CurrentOptions or normalizedOptions
        local arrivalThresh = travelOptions.arrivalThreshold
        local flySpeed = travelOptions.speed
        local isCombatHover = travelOptions.combatHover == true
        local isPersistent = travelOptions.persistent == true
        local fallback = travelOptions.fallback

        -- [FIX-P1] Long-distance/cruise mode + timeout động theo khoảng cách
        local longTravel = startDist ~= nil
            and startDist > _G.Settings.CruiseThreshold
            and not (startSubmerged and targetSubmerged)
        local cruiseLogged = false
        local travelTimeout = _G.Settings.TravelTimeout
        local lastStepTime = tick()
        local safeRetreat = false
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
                isCombatHover = false
                isPersistent = true
                arrivalThresh = _G.Settings.CloseThreshold
                self.AtCombatAnchor = false
                self.AtCombatTarget = nil
                travelStart = os.time()
                stuckTimer = 0
                _G.BobonStatus = "Farm: " .. reason .. ", returning to farm area"
                return true
            end
            return false
        end


        while SessionAlive() and self.CurrentToken == myToken
            and char and char.Parent
            and IsAlive() do

            local stepNow = tick()
            local stepDt = math.clamp(stepNow - lastStepTime, 0, 0.1)
            lastStepTime = stepNow
            if _G.State.ActiveActionToken ~= 0
                and _G.State.ActionOwner == owner then
                _G.State:TouchAction(_G.State.ActiveActionToken)
            end


            -- Travel timeout (động theo khoảng cách khi long travel) [FIX-P1]
            if os.time() - travelStart > travelTimeout then
                -- Farm timeout → về khu farm (fallback), không recover giữa biển [FIX-13]
                if isCombatHover and HandleFarmInvalid("Timeout") then
                    continue
                end
                warn("[Travel] Timeout by " .. owner)
                DLog("TRAVEL", "Timeout by " .. owner)
                _G.State.IsRecovering = true
                break
            end


            -- Resolve target position + validate mỗi tick [FIX-4]
            local targetPos
            local combatLookPos = nil
            local targetType = typeof(self.TargetRef)
            if targetType == "Instance" then
                if not self.TargetRef.Parent then
                    -- Mob biến mất: farm → về khu farm (fallback), không drop giữa không trung [FIX-13]
                    if isCombatHover then
                        if HandleFarmInvalid("Target lost") then
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
                local liveModel = self.TargetRef:IsA("Model") and self.TargetRef
                    or self.TargetRef:FindFirstAncestorOfClass("Model")
                local hum = liveModel and liveModel:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then
                    -- Mob chết: farm → về khu farm (fallback) để tiếp tục [FIX-13]
                    if isCombatHover then
                        if HandleFarmInvalid("Target defeated") then
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
                    if isCombatHover then
                        if HandleFarmInvalid("Invalid target") then
                            continue
                        end
                        break
                    end
                    break
                end
                targetLostTimer = 0
                if isCombatHover then
                    -- Always anchor on the selected mob first.  Other quest
                    -- mobs are gathered only after the player arrives above it.
                    local model = self.TargetRef:IsA("Model") and self.TargetRef
                        or self.TargetRef:FindFirstAncestorOfClass("Model")
                    local hoverHeight = travelOptions.hoverHeight
                    if not hoverHeight then
                        if CombatController:IsFastReady()
                            or not CombatController:WantsClientRange() then
                            hoverHeight = owner == "Farm"
                                and (_G.Settings.FarmHeight or 15)
                                or (_G.Settings.BossFarmHeight or 24)
                        else
                            hoverHeight = _G.Settings.ClientHoverHeight or 5
                        end
                    end
                    local playerHum = char:FindFirstChildOfClass("Humanoid")
                    if playerHum and playerHum.MaxHealth > 0 then
                        local ratio = playerHum.Health / playerHum.MaxHealth
                        if ratio <= 0.35 then
                            safeRetreat = true
                        elseif ratio >= 0.75 then
                            safeRetreat = false
                        end
                    end
                    if safeRetreat then
                        hoverHeight = math.max(hoverHeight,
                            _G.Settings.BossFarmHeight or 24)
                        _G.BobonStatus = "Combat: Low HP safe hover"
                    end
                    combatLookPos = p
                    targetPos = FarmPositionController:GetFarmPos(model, hoverHeight)
                    if tick() < self.DodgeUntil then
                        targetPos = targetPos and (targetPos + self.DodgeOffset) or nil
                    else
                        self.DodgeOffset = Vector3.zero
                    end
                    if not targetPos then
                        targetPos = GetFarmPosition(p)
                    end
                    if not targetPos then
                        if HandleFarmInvalid("Position unavailable") then
                            continue
                        end
                        break
                    end
                else
                    targetPos = p
                end
                -- Reject target dưới biển
                if not IsAllowedWorldPosition(targetPos) then
                    warn("[Travel] Reject target dưới biển (Y=" .. string.format("%.1f", targetPos.Y) .. ")")
                    if isCombatHover then
                        if HandleFarmInvalid("Target below sea level") then
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
            if targetPos.Y < _G.Settings.MinY and not IsSubmergedPosition(targetPos) then
                if targetPos.Y <= -100 then break end
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
            if currentPos.Y < _G.Settings.MinY
                and not IsSubmergedPosition(currentPos) then
                local liftOffset = targetPos - currentPos
                local liftDir = liftOffset.Magnitude > 0.1 and liftOffset.Unit or Vector3.new(0, 0, 0)
                bv.Velocity = Vector3.new(liftDir.X * flySpeed, 60, liftDir.Z * flySpeed)
                local liftFace = combatLookPos or targetPos
                local liftFlat = Vector3.new(liftFace.X, currentPos.Y, liftFace.Z)
                if (liftFlat - currentPos).Magnitude > 0.05 then
                    bg.CFrame = CFrame.lookAt(currentPos, liftFlat)
                end
                task.wait(0.03)
                continue
            end


            -- Arrival detection
            if dist <= arrivalThresh then
                bv.Velocity = Vector3.zero
                if not isCombatHover then
                    self.AtCombatAnchor = false
                    self.AtCombatTarget = nil
                    if not isPersistent then break end
                    root.CFrame = CFrame.new(targetPos) * root.CFrame.Rotation
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    travelStart = os.time()
                    stuckTimer = 0
                    _G.State.LastMoveTime = os.time()
                    task.wait(0.03)
                    continue
                end
                local look = combatLookPos or targetPos
                local flatLook = Vector3.new(look.X, targetPos.Y, look.Z)
                local anchorCF
                if (flatLook - targetPos).Magnitude > 0.05 then
                    anchorCF = CFrame.lookAt(targetPos, flatLook)
                else
                    anchorCF = CFrame.new(targetPos) * root.CFrame.Rotation
                end
                root.CFrame = anchorCF
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                bg.CFrame = anchorCF
                self.AtCombatAnchor = true
                self.AtCombatTarget = self.TargetRef
                -- [FIX-11] Hover hợp lệ = activity, reset travel timeout
                travelStart = os.time()
                stuckTimer = 0
                _G.State.LastMoveTime = os.time()
                task.wait(0.03)
                continue
            end


            -- Movement with deceleration
            self.AtCombatAnchor = false
            self.AtCombatTarget = nil
            local direction = (targetPos - currentPos).Unit
            local speed = flySpeed
            if dist < 60 then speed = speed * math.max(dist / 60, 0.15) end


            bv.Velocity = direction * speed
            local face = combatLookPos or targetPos
            local flatFace = Vector3.new(face.X, currentPos.Y, face.Z)
            if (flatFace - currentPos).Magnitude > 0.05 then
                bg.CFrame = CFrame.lookAt(currentPos, flatFace)
            end


            -- Stuck detection (riêng cho từng mode) [FIX-P1]
            local moveDelta = (currentPos - lastPos).Magnitude
            if moveDelta < 1 then
                stuckTimer = stuckTimer + stepDt
                local stuckLimit = _G.Settings.StuckTimeout
                if isCombatHover then
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
            self.CurrentOptions = nil
            self.AtCombatAnchor = false
            self.AtCombatTarget = nil
            self.DodgeOffset = Vector3.zero
            self.DodgeUntil = 0
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
    if not SessionAlive() then return end
    HakiController:Reset()
    CombatController:Cleanup()
    FarmPositionController:ReleaseCluster()
    TravelManager:Stop("CharacterRemoving")
    _G.State:SetMode("Dead")
    _G.State:ClearTargets()
    _G.State:ForceReleaseAction("Death")
end)


LP.CharacterAdded:Connect(function(char)
    if not SessionAlive() then return end
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
    while SessionAlive() and task.wait(0.1) do
        pcall(function()
            if not IsAlive() then return end
            if _G.State.IsTraveling then return end
            local root = HRP()
            if not root then return end
            if root.Position.Y < _G.Settings.MinY
                and not IsSubmergedPosition(root.Position) then
                root.AssemblyLinearVelocity = Vector3.new(
                    root.AssemblyLinearVelocity.X, 45, root.AssemblyLinearVelocity.Z)
            end
        end)
    end
end)
-- ══════════════════════════════════════════════════════════════════
--         [D-1] DODGE CONTROLLER — NÉ CHIÊU KHI QUÁI TẤN CÔNG
--   Một monitor loop DUY NHẤT, chỉ DÒ chiêu (không điều khiển movement
--   liên tục nên không phá Single Movement Owner). Khi phát hiện quái
--   gần player đang tung chiêu (animation tấn công đang phát / tốc độ
--   lao nhanh về phía player) → dịch ngang 1 phát (CFrame offset) né,
--   rồi để TravelManager hover kéo về điểm farm như thường.
--   Có cooldown chống spam; không hoạt động khi bay xa (giver/island)
--   hay khi recovery/dead/respawn.
-- ══════════════════════════════════════════════════════════════════
local DodgeController = {
    LastDodge = 0,
}

local DODGE_ATTACK_KEYWORDS = {
    "attack","combo","kick","punch","slash","swing","hit",
    "strike","beat","smash","bite","claw","fist","spin","haki",
}

local function DodgeAnimIsAttack(track)
    local ok, name = pcall(function() return track.Name end)
    if not ok or type(name) ~= "string" then return false end
    local lower = string.lower(name)
    for _, kw in ipairs(DODGE_ATTACK_KEYWORDS) do
        if string.find(lower, kw, 1, true) then return true end
    end
    return false
end

local function DodgeEnemyIsAttacking(enemy, me)
    local hum = enemy:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local okTracks, tracks = pcall(function() return hum:GetPlayingAnimationTracks() end)
    if okTracks and tracks then
        for _, track in ipairs(tracks) do
            if track.IsPlaying and DodgeAnimIsAttack(track) then
                return true
            end
        end
    end
    local root = enemy:FindFirstChild("HumanoidRootPart")
    if root and me then
        local okVel, vel = pcall(function() return root.AssemblyLinearVelocity end)
        if okVel and type(vel) == "Vector3" then
            local toMe = me.Position - root.Position
            local dist = toMe.Magnitude
            if dist > 0.5 and dist <= (_G.Settings.DodgeRadius or 15) then
                local closing = toMe.Unit:Dot(vel)
                if closing > 35 then return true end
            end
        end
    end
    return false
end

function DodgeController:TryDodge()
    if not _G.Settings.DodgeAttacks then return false end
    if not IsAlive() then return false end
    if _G.State.Mode == "Recovering" or _G.State.Mode == "Dead"
        or _G.State.Mode == "Respawning" or _G.State.Mode == "ServerHop" then
        return false
    end
    local now = tick()
    if now - self.LastDodge < (_G.Settings.DodgeCooldown or 1.5) then return false end
    -- Không né khi đang bay xa tới giver/island (target là CFrame xa):
    -- dodge chỉ dành cho lúc đứng farm gần mob (target Instance/CFrame gần).
    if _G.State.IsTraveling then
        local ref = TravelManager.TargetRef
        if typeof(ref) == "CFrame" or typeof(ref) == "Vector3" then
            local me = HRP()
            local targetPos = typeof(ref) == "CFrame" and ref.Position or ref
            if not me or (me.Position - targetPos).Magnitude > 60 then
                return false
            end
        end
    end
    local me = HRP()
    if not me then return false end
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return false end
    local danger = nil
    local dangerRoot = nil
    for _, enemy in ipairs(folder:GetChildren()) do
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local p = root.Position
        if IsValidPos(p) and (p - me.Position).Magnitude <= (_G.Settings.DodgeRadius or 15)
            and DodgeEnemyIsAttacking(enemy, me) then
            danger, dangerRoot = enemy, root
            break
        end
    end
    if not danger or not dangerRoot then return false end
    -- Né: dịch ngang vuông góc với hướng quái → player + nhấc nhẹ lên,
    -- giữ rotation; hover của TravelManager sẽ kéo về điểm farm sau đó.
    local dir = (dangerRoot.Position - me.Position).Unit
    local side = Vector3.new(-dir.Z, 0, dir.X)
    local dodgeOffset = side * (_G.Settings.DodgeDistance or 12)
        + Vector3.new(0, _G.Settings.DodgeHeight or 4, 0)
    if not TravelManager:ApplyDodgeOffset(dodgeOffset, 0.25) then return false end
    self.LastDodge = now
    DLog("DODGE", "Né chiêu " .. tostring(danger.Name))
    _G.BobonStatus = "Farm: Né chiêu"
    return true
end

-- [D-1] Monitor loop duy nhất cho dodge (0.1s — phản xạ nhanh hơn farm
-- tick). Chỉ dò + dịch 1 phát, không điều khiển movement liên tục.
task.spawn(function()
    while SessionAlive() and task.wait(0.1) do
        pcall(function() DodgeController:TryDodge() end)
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
    FarmPositionController:ReleaseCluster()


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
            -- [G-3] Dùng Assembly* thay Velocity/RotVelocity đã deprecated.
            pcall(function()
                local hrp = HRP()
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
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
    while SessionAlive() and task.wait(5) do
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
                    DLog("RECOVERY", "Travel stalled (" .. lightFails .. " times) → stop + retry")
                    _G.BobonStatus = "Watchdog: Travel stalled, retrying"
                    TravelManager:Stop("WatchdogStuck")
                    if lightFails >= 3 then
                        lightFails = 0
                        RecoveryManager:Handle("WatchdogStuck")
                    end
                end
            end
            -- LIGHT 2: verify one shared melee/sword/gun controller. Never
            -- steal an equipped sword by running a separate melee watchdog.
            if EquipCombatTool() then
                DLog("RECOVERY", "Light fix: combat tool verified")
            end
            -- LIGHT 3: target chết/mất → main loop tự clear + chọn mới
            -- (không cần làm gì thêm ở đây, tránh duplicate logic)
        end)
    end
end)


-- ══════════════════════════════════════════════════════════════════
--          QUEST DATABASE v16.4 (SEA 1/2/3 COORDINATES)
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
    {Min=2475,Max=2499,Q="TikiQuest1",M="Island Boy",QL=2,QC=CFrame.new(-16547.75,61.14,-173.41),MC=CFrame.new(-16901.26,84.07,-192.89)},
    {Min=2500,Max=2524,Q="TikiQuest2",M="Sun-kissed Warrior",QL=1,QC=CFrame.new(-16539.078,55.686,1051.574),MC=CFrame.new(-16321.292,92.102,1111.195)},
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

-- Resolve an already-open quest after re-execution. Prefer an exact canonical
-- enemy name found in the source quest text; if Roblox only exposes translated
-- text, the main controller safely falls back to the current level's QDB entry.
local function ResolveQuestMobFromText()
    local text = GetQuestText()
    if not text then return nil end
    local lowerText = string.lower(text)
    local bestMatch = nil
    for _, entry in ipairs(QDB) do
        if string.find(lowerText, string.lower(entry.M), 1, true) then
            -- Prefer the longest match so `Galley Pirate` is not mistaken for
            -- the earlier generic `Pirate` entry (same for Bandit/Snow Bandit).
            if not bestMatch or #entry.M > #bestMatch then
                bestMatch = entry.M
            end
        end
    end
    return bestMatch
end

local SubmergedAccessController = {
    Confirmed = false,
    PendingUntil = 0,
    NextTry = 0,
    Failures = 0,
    LastResult = "idle",
}

function SubmergedAccessController:IsInside()
    local root = HRP()
    local inside = GetSea() == 3 and root
        and IsSubmergedPosition(root.Position) or false
    if inside then
        self.Confirmed = true
        self.PendingUntil = 0
        self.NextTry = 0
        self.Failures = 0
        self.LastResult = "inside"
    end
    return inside == true
end

function SubmergedAccessController:Fail(reason, now)
    self.PendingUntil = 0
    self.Failures = self.Failures + 1
    self.NextTry = now
        + math.min(15 * (2 ^ math.min(self.Failures - 1, 3)), 120)
    self.LastResult = reason
    _G.BobonStatus = "Sea: Submerged unavailable - farming Tiki"
    return "fallback"
end

function SubmergedAccessController:Tick(canAttempt)
    if GetSea() ~= 3 or Level() < 2600 then return "not-needed" end
    if self:IsInside() then return "inside" end
    local now = tick()
    if self.PendingUntil > 0 then
        if now < self.PendingUntil then return "pending" end
        return self:Fail("not-entered", now)
    end
    if not canAttempt or now < self.NextTry then return "fallback" end
    local net = ResolveNet()
    local speak = net and net:FindFirstChild("RF/SubmarineWorkerSpeak")
    if not speak or not speak:IsA("RemoteFunction") then
        return self:Fail("remote-missing", now)
    end
    local ok, result = pcall(function()
        return speak:InvokeServer("TravelToSubmergedIsland")
    end)
    if not ok then
        return self:Fail("invoke-error", now)
    end
    if self:IsInside() then return "inside" end
    self.PendingUntil = now + 4
    self.LastResult = "pending:" .. tostring(result)
    return "pending"
end

local TikiFallbackQuest = nil
for _, entry in ipairs(QDB) do
    if entry.M == "Skull Slayer" then
        TikiFallbackQuest = entry
        break
    end
end

local function GetQ()
    local lv = Level()
    local sea = GetSea()
    -- At a sea boundary the normal level table already points into the next
    -- world. Prove combat on the highest valid local quest before starting a
    -- mandatory boss/progression action; this avoids using a boss as a lethal
    -- first-click probe.
    if not CombatController:IsDamageReady() then
        local bootstrapMob = sea == 1 and lv >= 700 and "Galley Captain"
            or (sea == 2 and lv >= 1500 and "Water Fighter")
        if bootstrapMob then
            for _, entry in ipairs(QDB) do
                if entry.M == bootstrapMob then return entry end
            end
        end
    end
    -- Access is gated by Tyrant/Tiki progression. Until the entrance really
    -- moves the character underwater, keep farming a valid Tiki quest instead
    -- of flying blindly toward negative-Y coordinates.
    if GetSea() == 3 and lv >= 2600 and not SubmergedAccessController:IsInside() then
        return TikiFallbackQuest
    end
    for _, q in ipairs(QDB) do
        if lv >= q.Min and lv <= q.Max then return q end
    end
    return nil
end


-- Sea 1 fast-route controller.  This is deliberately called from the main
-- controller instead of creating another movement loop.  The route follows
-- the commonly used skip path: Fountain/Galley early, then live bosses, then
-- Upper Sky/Galley before the normal Sea 2 progression gate at level 700.
-- A live instance is always preferred; fallback coordinates only keep the
-- player over a safe island while a boss or mob is respawning.
local SkipRouteController = {
    Enabled = true,
    CurrentKey = nil,
    -- [D-4] Theo dõi hiệu quả của route: level tại lúc chọn route + thời
    -- điểm bắt đầu. Level không tăng trong SkipRouteFallbackTimeout giây
    -- → coi skip không hiệu quả → tắt hẳn, farm quest bình thường.
    RouteStartTime = nil,
    RouteStartLevel = nil,
}

local SkipRouteDB = {
    {Key="FountainEarly", Min=10, Max=54, Kind="Mob", Display="Galley Pirate", Names={"Galley Pirate"}, Fallback=CFrame.new(5551.02,78.90,3930.41)},
    {Key="Bobby", Min=55, Max=89, Kind="Boss", Display="Bobby", Names={"Bobby"}, Fallback=CFrame.new(-1141.07,14.81,4322.92)},
    {Key="Yeti", Min=90, Max=119, Kind="Boss", Display="Yeti", Names={"Yeti"}, Fallback=CFrame.new(1201.64,144.58,-1550.07)},
    {Key="MobLeader", Min=120, Max=129, Kind="Boss", Display="Mob Leader", Names={"Mob Leader"}, Fallback=CFrame.new(-4870.00,25.00,4300.00)},
    {Key="ViceAdmiral", Min=130, Max=219, Kind="Boss", Display="Vice Admiral", Names={"Vice Admiral"}, Fallback=CFrame.new(-4881.23,22.65,4273.75)},
    {Key="PrisonBosses", Min=220, Max=349, Kind="Boss", Display="Warden / Chief Warden", Names={"Warden","Chief Warden"}, Fallback=CFrame.new(5098.97,15.00,474.24)},
    {Key="MagmaAdmiral", Min=350, Max=424, Kind="Boss", Display="Magma Admiral", Names={"Magma Admiral"}, Fallback=CFrame.new(-5411.16,11.08,8454.29)},
    {Key="FishmanLord", Min=425, Max=499, Kind="Boss", Display="Fishman Lord", Names={"Fishman Lord"}, Fallback=CFrame.new(60878.30,18.48,1543.76)},
    {Key="Wysper", Min=500, Max=624, Kind="Boss", Display="Wysper", Names={"Wysper"}, Fallback=CFrame.new(-7678.49,5566.40,-497.22)},
    {Key="FountainLate", Min=625, Max=699, Kind="Mob", Display="Galley Pirate", Names={"Galley Pirate"}, Fallback=CFrame.new(5551.02,78.90,3930.41)},
}

function SkipRouteController:GetRoute()
    if not self.Enabled or _G.Settings.SkipLevelRoute == false or GetSea() ~= 1 then return nil end
    local lv = Level()
    for _, route in ipairs(SkipRouteDB) do
        if lv >= route.Min and lv <= route.Max then return route end
    end
    return nil
end

function SkipRouteController:Reset(reason)
    if self.CurrentKey then
        DLog("SKIP", "Route ended: " .. tostring(self.CurrentKey) .. " (" .. tostring(reason or "reset") .. ")")
        if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
            TravelManager:Stop("SkipRouteReset")
        end
        FarmPositionController:ReleaseCluster()
        _G.State:ClearTargets()
        self.CurrentKey = nil
    end
end

function SkipRouteController:FindTarget(route)
    if route.Kind == "Mob" then
        for _, name in ipairs(route.Names) do
            local mob = FindNearestMob(name)
            if mob then return mob, name end
        end
    else
        for _, name in ipairs(route.Names) do
            local boss = FindBoss(name)
            if boss then return boss, name end
        end
    end
    return nil, nil
end

function SkipRouteController:Run()
    -- High-level skip targets are lethal with ordinary M1. Normal quest farm
    -- is the runtime self-test; skip unlocks only after confirmed fast damage.
    if not CombatController:IsFastReady() then
        self:Reset("fast attack not health-verified")
        return false
    end
    local route = self:GetRoute()
    if not route then
        self:Reset("Sea or level outside skip route")
        return false
    end

    if self.CurrentKey ~= route.Key then
        self:Reset("level transition")
        self.CurrentKey = route.Key
        self.RouteStartTime = os.time()
        self.RouteStartLevel = Level()
        DLog("SKIP", "Route selected: " .. route.Key)
    end

    -- [D-4] SKIP KHÔNG HIỆU QUẢ → FARM QUEST BÌNH THƯỜNG:
    -- Cùng route quá SkipRouteFallbackTimeout giây mà level không tăng
    -- (boss không spawn, mob không giết được, quái quá khỏe...) → tắt
    -- hẳn skip route; main controller đi xuống quest gate và farm quest
    -- như thường (không bao giờ kẹt "Waiting for boss" vô hạn).
    if self.RouteStartTime and self.RouteStartLevel
        and os.time() - self.RouteStartTime > (_G.Settings.SkipRouteFallbackTimeout or 90)
        and Level() <= self.RouteStartLevel then
        self.Enabled = false
        _G.Settings.SkipLevelRoute = false
        self:Reset("skip not effective, back to normal quest farm")
        DLog("SKIP", "Skip không hiệu quả (" .. route.Key .. ") → tắt, farm quest bình thường")
        return false
    end

    _G.State:SetMode("Farming")
    _G.State.FState = "SKIP_FARM"
    _G.BobonStatus = "Skip Farm: " .. route.Display

    local target, targetName = self:FindTarget(route)
    if target and (not _G.State:IsTargetValid(target) or not target.Parent
        or not target:FindFirstChild("HumanoidRootPart")) then
        target = nil
    end
    if target then
        local hum = target:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then
            target = nil
        end
    end

    if target then
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        _G.State.FarmTarget = target
        _G.State.CurrentTarget = target
        PrepareCombatTarget(target)
        if _G.State:CanRequestTravel() then
            TravelManager:Request(targetRoot, "Farm", {
                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                fallback = route.Fallback,
                combatHover = true,
            })
        end

        local hrp = HRP()
        if hrp and targetRoot then
            local a = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
            local b = Vector3.new(targetRoot.Position.X, 0, targetRoot.Position.Z)
            local farmHolds = not _G.State.IsTraveling or _G.State.MovementOwner == "Farm"
            if (a - b).Magnitude <= _G.Settings.AttackRange and farmHolds
                and TravelManager:IsAtCombatAnchor(targetRoot) then
                -- Equip first; the shared health-verified adapter handles
                -- every melee style and sword.
                EquipCombatTool()
                Attack(target, targetName)
                DLog("SKIP", "Attacking " .. tostring(targetName or target.Name))
            end
        end
    else
        _G.State:ClearTargets()
        -- [D-5] KHÔNG CHỜ BOSS XUẤT HIỆN: route boss (Bobby/Yeti/Vice
        -- Admiral/Warden/Magma Admiral/Fishman Lord/Wysper...) mà boss
        -- không có mặt NGAY bây giờ → return false tức thời, main
        -- controller chạy farm quest như bình thường. BossManager vẫn
        -- tự săn boss khi boss thực sự xuất hiện trong Enemies.
        if route.Kind == "Boss" then
            self:Reset("boss not present, back to quest farm")
            DLog("SKIP", route.Display .. " chưa spawn → farm quest bình thường")
            return false
        end
        _G.BobonStatus = "Skip Farm: Waiting for " .. route.Display
        if _G.State:CanRequestTravel() then
            TravelManager:Request(route.Fallback, "Farm")
        end
    end
    return true
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

local function PrepareClaimedAction(owner)
    -- ClaimAction protects logical work; movement ownership is independent.
    -- Hand it over explicitly so a persistent Farm hover cannot make every
    -- Saber/Sea/Bartilo request fail with MovementBusy.
    if _G.State.IsTraveling then
        TravelManager:Stop(tostring(owner) .. "Priority")
    end
    FarmPositionController:ReleaseCluster()
    _G.State:ClearTargets()
    CombatController:WatchTarget(nil, nil)
end


function ItemProgression:CheckSaber()
    if not _G.Settings.AutoItems then return false end
    if HasItem("Saber") or Level() < 200 or GetSea() ~= 1 then return false end
    if not CombatController:IsDamageReady() then return false end
    if not self:OptionalReady("Saber") then return false end
    local myToken = _G.State:ClaimAction("Saber")
    if myToken == 0 then return false end
    PrepareClaimedAction("Saber")
    self:DelayOptional("Saber")
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Item: Saber Sword"


    task.spawn(function()
        local ok, err = xpcall(function()
            local function EquipNamed(name)
                local c = Char()
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                local backpack = LP:FindFirstChildOfClass("Backpack")
                local tool = (c and c:FindFirstChild(name))
                    or (backpack and backpack:FindFirstChild(name))
                if not tool or not hum then return false end
                if tool.Parent ~= c then pcall(function() hum:EquipTool(tool) end) end
                task.wait(0.2)
                return c and c:FindFirstChild(name) ~= nil
            end

            -- Current Saber flow: Jungle plates -> Torch/Burn -> Cup/SickMan
            -- -> RichSon/Mob Leader -> Relic -> Saber Expert.
            local map = workspace:FindFirstChild("Map")
            local jungle = map and map:FindFirstChild("Jungle")
            local plates = jungle and jungle:FindFirstChild("QuestPlates")
            local plateDoor = plates and plates:FindFirstChild("Door")
            if plateDoor and plateDoor.Transparency == 0 then
                for i = 1, 5 do
                    local plate = plates:FindFirstChild("Plate" .. i)
                    local button = plate and plate:FindFirstChild("Button")
                    if button and _G.State:IsActionValid(myToken) then
                        TravelAndWait("Saber", myToken, button.CFrame, {
                            timeout = 60, arrivalThreshold = 5, settle = 0.35,
                        })
                    end
                end
            end

            if not _G.State:IsActionValid(myToken) then return end
            if not HasItem("Torch") then
                TravelAndWait("Saber", myToken, CFrame.new(-1610,11,164), {
                    timeout = 90, arrivalThreshold = 6, settle = 1,
                })
            end
            if HasItem("Torch") and EquipNamed("Torch") then
                TravelAndWait("Saber", myToken, CFrame.new(1114,5,4350), {
                    timeout = 90, arrivalThreshold = 7, settle = 1,
                })
            end

            if not _G.State:IsActionValid(myToken) then return end
            local sickProgress
            pcall(function()
                sickProgress = CommF_:InvokeServer("ProQuestProgress", "SickMan")
            end)
            if sickProgress ~= 0 then
                pcall(function() CommF_:InvokeServer("ProQuestProgress", "GetCup") end)
                if EquipNamed("Cup") then
                    local cup = Char() and Char():FindFirstChild("Cup")
                    if cup then
                        pcall(function()
                            CommF_:InvokeServer("ProQuestProgress", "FillCup", cup)
                        end)
                    end
                end
                pcall(function() CommF_:InvokeServer("ProQuestProgress", "SickMan") end)
            end

            if not _G.State:IsActionValid(myToken) then return end
            local richProgress
            pcall(function()
                richProgress = CommF_:InvokeServer("ProQuestProgress", "RichSon")
            end)
            if richProgress == 0 then
                local boss = FindBoss("Mob Leader")
                if not boss then
                    _G.BobonStatus = "Item: Waiting for Mob Leader"
                    return
                end
                local deadline = tick() + 120
                while boss and _G.State:IsActionValid(myToken) and IsAlive()
                    and tick() < deadline do
                    local bh = boss:FindFirstChildOfClass("Humanoid")
                    local br = boss:FindFirstChild("HumanoidRootPart")
                    if not bh or bh.Health <= 0 or not br then break end
                    PrepareCombatTarget(boss)
                    EquipCombatTool()
                    TravelManager:Request(br, "Saber", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        combatHover = true,
                    })
                    if TravelManager:IsAtCombatAnchor(br) then
                        Attack(boss, "Mob Leader")
                    end
                    task.wait(0.12)
                end
                pcall(function() CommF_:InvokeServer("ProQuestProgress", "RichSon") end)
            end

            pcall(function()
                richProgress = CommF_:InvokeServer("ProQuestProgress", "RichSon")
            end)
            if richProgress == 1 or HasItem("Relic") then
                pcall(function() CommF_:InvokeServer("ProQuestProgress", "RichSon") end)
                EquipNamed("Relic")
                if TravelAndWait("Saber", myToken, CFrame.new(-1405,30,4), {
                    timeout=90, arrivalThreshold=8, settle=0.5,
                }) then
                    pcall(function()
                        CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
                    end)
                end
            end

            local saberBoss = FindBoss("Saber Expert")
            if not saberBoss then
                _G.BobonStatus = "Item: Waiting for Saber Expert"
                return
            end
            local timeout = os.time() + 180
            while _G.State:IsActionValid(myToken) and not HasItem("Saber")
                and os.time() < timeout and IsAlive() do
                local boss = saberBoss
                if boss and boss:FindFirstChild("HumanoidRootPart") and boss.Humanoid.Health > 0 then
                    PrepareCombatTarget(boss)
                    EquipCombatTool()
                    TravelManager:Request(boss.HumanoidRootPart, "Saber", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        combatHover = true,
                    })
                    if TravelManager:IsAtCombatAnchor(boss.HumanoidRootPart) then
                        Attack(boss, "Saber Expert")
                    end
                else
                    break
                end
                task.wait(0.1)
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Saber: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Saber" then
            TravelManager:Stop("SaberComplete")
        end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "GettingItem" then
            _G.State:SetMode("Idle")
        end
    end)
    return true
end


function ItemProgression:CheckPoleV1()
    if not _G.Settings.AutoItems then return false end
    if HasItem("Pole (1st Form)") or Level() < 575 or GetSea() ~= 1 then return false end
    if not CombatController:IsDamageReady() then return false end
    if not self:OptionalReady("PoleV1") then return false end
    local boss = FindBoss("Thunder God")
    if not boss then
        self:DelayOptional("PoleV1")
        return false
    end
    local myToken = _G.State:ClaimAction("PoleV1")
    if myToken == 0 then return false end
    PrepareClaimedAction("PoleV1")
    self:DelayOptional("PoleV1")
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Item: Pole v1"


    task.spawn(function()
        local ok, err = xpcall(function()
            local deadline = tick() + 180
            while _G.State:IsActionValid(myToken) and IsAlive()
                and tick() < deadline and not HasItem("Pole (1st Form)") do
                local hum = boss and boss:FindFirstChildOfClass("Humanoid")
                local root = boss and boss:FindFirstChild("HumanoidRootPart")
                if not boss or not boss.Parent or not hum or hum.Health <= 0 or not root then
                    break
                end
                PrepareCombatTarget(boss)
                EquipCombatTool()
                TravelManager:Request(root, "PoleV1", {
                    arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                    combatHover = true,
                })
                if TravelManager:IsAtCombatAnchor(root) then
                    Attack(boss, "Thunder God")
                end
                task.wait(0.12)
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: PoleV1: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "PoleV1" then
            TravelManager:Stop("PoleV1Complete")
        end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "GettingItem" then
            _G.State:SetMode("Idle")
        end
    end)
    return true
end


function ItemProgression:CheckSecondSea()
    if GetSea() >= 2 or Level() < 700 then return false end
    if not CombatController:IsDamageReady() then return false end
    if not self:OptionalReady("Sea2") then return false end
    local myToken = _G.State:ClaimAction("Sea2")
    if myToken == 0 then return false end
    PrepareClaimedAction("Sea2")
    self.NextOptional.Sea2 = tick() + 10
    _G.State:SetMode("UnlockingSea")
    _G.BobonStatus = "Sea: Unlock 2nd Sea"


    task.spawn(function()
        local ok, err = xpcall(function()
            if not _G.State:IsActionValid(myToken) then return end
            -- Correct Sea 2 gate: Military Detective gives the Key, the key
            -- opens the Ice cave, then Ice Admiral unlocks TravelDressrosa.
            if TravelAndWait("Sea2", myToken, CFrame.new(4851.87,5.65,718.47), {
                timeout=90, arrivalThreshold=8,
            }) then
                pcall(function() CommF_:InvokeServer("DressrosaQuestProgress","Detective") end)
            end
            local key = HasItem("Key")
            if key then
                local c, hum = Char(), Hum()
                if key.Parent ~= c and hum then pcall(function() hum:EquipTool(key) end) end
            end
            if not TravelAndWait("Sea2", myToken, CFrame.new(1347.71,37.38,-1325.65), {
                timeout=90, arrivalThreshold=8, settle=1,
            }) then
                return
            end
            task.wait(1.5)

            local boss = FindBoss("Ice Admiral")
            local deadline = tick() + 180
            while boss and _G.State:IsActionValid(myToken) and IsAlive()
                and tick() < deadline do
                local bh = boss:FindFirstChildOfClass("Humanoid")
                local br = boss:FindFirstChild("HumanoidRootPart")
                if not bh or bh.Health <= 0 or not br then break end
                PrepareCombatTarget(boss)
                EquipCombatTool()
                TravelManager:Request(br, "Sea2", {
                    arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                    combatHover = true,
                })
                if TravelManager:IsAtCombatAnchor(br) then
                    Attack(boss, "Ice Admiral")
                end
                task.wait(0.12)
            end

            if _G.State:IsActionValid(myToken) and IsAlive() then
                local traveled = false
                pcall(function()
                    CommF_:InvokeServer("TravelDressrosa")
                    traveled = true
                end)
                if traveled then _G.State.LastServerHop = os.time() end
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Sea2: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Sea2" then
            TravelManager:Stop("Sea2Complete")
        end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "UnlockingSea" then
            _G.State:SetMode("Idle")
        end
    end)
    return true
end


function ItemProgression:CheckBartilo()
    if GetSea() ~= 2 or Level() < 800 then return false end
    if not CombatController:IsDamageReady() then return false end
    if not self:OptionalReady("Bartilo") then return false end
    local progress
    local okProgress = pcall(function()
        progress = CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
    end)
    if not okProgress or type(progress) ~= "number" or progress >= 3 then return false end

    local myToken = _G.State:ClaimAction("Bartilo")
    if myToken == 0 then return false end
    PrepareClaimedAction("Bartilo")
    self.NextOptional.Bartilo = tick() + 10
    _G.State:SetMode("GettingItem")
    _G.BobonStatus = "Progression: Bartilo " .. tostring(progress)

    task.spawn(function()
        local ok, err = xpcall(function()
            if progress == 0 then
                if TravelAndWait("Bartilo", myToken, CFrame.new(-456.29,73.02,299.90), {
                    timeout=90, arrivalThreshold=10, settle=0.6,
                }) then
                    pcall(function() CommF_:InvokeServer("StartQuest", "BartiloQuest", 1) end)
                end
                local deadline = tick() + 600
                while _G.State:IsActionValid(myToken) and IsAlive() and tick() < deadline do
                    local current
                    pcall(function()
                        current = CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
                    end)
                    if type(current) == "number" and current ~= 0 then break end
                    local mob = FindMob("Swan Pirate")
                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        PrepareCombatTarget(mob)
                        EquipCombatTool()
                        TravelManager:Request(mob.HumanoidRootPart, "Bartilo", {
                            arrivalThreshold=_G.Settings.FarmArrivalThreshold,
                            combatHover=true,
                        })
                        if TravelManager:IsAtCombatAnchor(mob.HumanoidRootPart) then
                            Attack(mob, "Swan Pirate")
                        end
                    else
                        TravelManager:Request(CFrame.new(932.62,156.11,1180.27), "Bartilo")
                        task.wait(1)
                    end
                    task.wait(0.12)
                end
            elseif progress == 1 then
                local boss = FindBoss("Jeremy")
                if not boss then
                    _G.BobonStatus = "Progression: Waiting for Jeremy"
                    return
                end
                local deadline = tick() + 180
                while _G.State:IsActionValid(myToken) and IsAlive() and tick() < deadline do
                    local bh = boss:FindFirstChildOfClass("Humanoid")
                    local br = boss:FindFirstChild("HumanoidRootPart")
                    if not bh or bh.Health <= 0 or not br then break end
                    PrepareCombatTarget(boss)
                    EquipCombatTool()
                    TravelManager:Request(br, "Bartilo", {
                        arrivalThreshold=_G.Settings.FarmArrivalThreshold,
                        combatHover=true,
                    })
                    if TravelManager:IsAtCombatAnchor(br) then
                        Attack(boss, "Jeremy")
                    end
                    task.wait(0.12)
                end
            elseif progress == 2 then
                local maze = {
                    CFrame.new(-1850.49,13.18,1750.90), CFrame.new(-1858.87,19.38,1712.02),
                    CFrame.new(-1803.94,16.58,1750.90), CFrame.new(-1858.56,16.86,1724.80),
                    CFrame.new(-1869.54,15.99,1681.01), CFrame.new(-1800.10,16.50,1684.52),
                    CFrame.new(-1819.26,14.80,1717.91), CFrame.new(-1813.52,14.86,1724.80),
                }
                for _, cf in ipairs(maze) do
                    if not TravelAndWait("Bartilo", myToken, cf, {
                        timeout=30, arrivalThreshold=6, settle=0.25,
                    }) then break end
                end
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Bartilo: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Bartilo" then
            TravelManager:Stop("BartiloComplete")
        end
        _G.State:ReleaseAction(myToken)
        if _G.State.Mode == "GettingItem" then _G.State:SetMode("Idle") end
    end)
    return true
end


function ItemProgression:CheckThirdSea()
    if GetSea() ~= 2 or Level() < 1500 then return false end
    if not CombatController:IsDamageReady() then return false end
    if not self:OptionalReady("Sea3") then return false end
    local myToken = _G.State:ClaimAction("Sea3")
    if myToken == 0 then return false end
    PrepareClaimedAction("Sea3")
    self.NextOptional.Sea3 = tick() + 10
    _G.State:SetMode("UnlockingSea")
    _G.BobonStatus = "Sea: Unlock 3rd Sea"


    task.spawn(function()
        local ok, err = xpcall(function()
            if not _G.State:IsActionValid(myToken) then return end
            local progress
            pcall(function()
                progress = CommF_:InvokeServer("ZQuestProgress", "General")
            end)
            if progress ~= 0 then
                local donSwan = FindBoss("Don Swan")
                if donSwan then
                    local deadline = tick() + 180
                    while _G.State:IsActionValid(myToken) and IsAlive()
                        and tick() < deadline do
                        local bh = donSwan:FindFirstChildOfClass("Humanoid")
                        local br = donSwan:FindFirstChild("HumanoidRootPart")
                        if not bh or bh.Health <= 0 or not br then break end
                        PrepareCombatTarget(donSwan)
                        EquipCombatTool()
                        TravelManager:Request(br, "Sea3", {
                            arrivalThreshold=_G.Settings.FarmArrivalThreshold,
                            combatHover=true,
                        })
                        if TravelManager:IsAtCombatAnchor(br) then
                            Attack(donSwan, "Don Swan")
                        end
                        task.wait(0.12)
                    end
                    pcall(function()
                        progress = CommF_:InvokeServer("ZQuestProgress", "General")
                    end)
                end
            end
            if progress == 0 then
                if not TravelAndWait("Sea3", myToken, CFrame.new(-1926.32,12.82,1738.31), {
                    timeout=90, arrivalThreshold=10, settle=1.5,
                }) then
                    return
                end
                pcall(function() CommF_:InvokeServer("ZQuestProgress", "Begin") end)
                task.wait(1.5)

                local boss = FindBoss("rip_indra")
                if not boss then
                    _G.BobonStatus = "Sea: Waiting for rip_indra quest boss"
                    return
                end
                local deadline = tick() + 240
                while _G.State:IsActionValid(myToken) and IsAlive()
                    and tick() < deadline do
                    local bh = boss:FindFirstChildOfClass("Humanoid")
                    local br = boss:FindFirstChild("HumanoidRootPart")
                    if not bh or bh.Health <= 0 or not br then break end
                    PrepareCombatTarget(boss)
                    EquipCombatTool()
                    TravelManager:Request(br, "Sea3", {
                        arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                        combatHover = true,
                    })
                    if TravelManager:IsAtCombatAnchor(br) then
                        Attack(boss, "rip_indra")
                    end
                    task.wait(0.12)
                end
            end

            if _G.State:IsActionValid(myToken) and IsAlive() then
                local traveled = false
                pcall(function()
                    CommF_:InvokeServer("TravelZou")
                    traveled = true
                end)
                if traveled then _G.State.LastServerHop = os.time() end
            end
        end, debug.traceback)
        if not ok then warn("[BobonHub] Module Error: Sea3: " .. tostring(err)) end
        if _G.State.IsTraveling and _G.State.MovementOwner == "Sea3" then
            TravelManager:Stop("Sea3Complete")
        end
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
    if self:CheckBartilo() then return true end
    if self:CheckThirdSea() then return true end
    if not allowOptional then return false end
    if self:CheckSaber() then return true end
    if self:CheckPoleV1() then return true end
    return false
end
-- ══════════════════════════════════════════════════════════════════
--              BOSSMANAGER v16.4 — DATA-DRIVEN
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

-- Optional boss work must advance the kaitun instead of interrupting every
-- completed quest for unrelated bosses. Level-skip bosses are handled by the
-- dedicated SkipRouteController; this manager targets missing useful drops.
local BossDropItems = {
    ["Thunder God"] = "Pole (1st Form)",
    ["Awakened Ice Admiral"] = "Rengoku",
    ["Cake Queen"] = "Buddy Sword",
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
                local wantedItem = BossDropItems[entry.N]
                local progressionBoss = entry.N == "Tyrant of the Skies"
                    and level >= 2600 and not SubmergedAccessController.Confirmed
                if ((wantedItem and not HasItem(wantedItem)) or progressionBoss)
                    and entry.Sea == sea and level >= entry.MinLevel
                    and IsEnemyNamed(mob, entry.N) then
                    local p = mobRoot.Position
                    if IsValidPos(p) and IsAllowedWorldPosition(p) then
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
            local okTargetPos, liveTargetPos = pcall(function()
                return targetRoot.Position
            end)
            if not okTargetPos or not IsAllowedWorldPosition(liveTargetPos) then
                break
            end
            PrepareCombatTarget(targetRoot)
            TravelManager:Request(targetRoot, "Boss", {
                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                fallback = nil,
                combatHover = true,
            })
            local me = HRP()
            if me then
                local a = Vector3.new(me.Position.X, 0, me.Position.Z)
                local b = Vector3.new(targetRoot.Position.X, 0, targetRoot.Position.Z)
                if (a - b).Magnitude <= _G.Settings.AttackRange
                    and TravelManager:IsAtCombatAnchor(targetRoot) then
                    EquipCombatTool()
                    Attack(boss)
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
    if not CombatController:IsDamageReady() then return false end
    local boss, entry = self:FindLiveBoss()
    if not boss or not entry then return false end
    local token = _G.State:ClaimAction("Boss")
    if token == 0 then return false end
    PrepareClaimedAction("Boss")
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
    while SessionAlive() and task.wait(0.15) do
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
                _G.BobonStatus = "Team: Confirming Pirates"
                return
            end


            -- FARM-FIRST GATE: inspect the current level/quest before any
            -- optional progression.  A valid quest always wins, so item and
            -- boss routines cannot pull the player away mid-farm.
            local lv = Level()
            local questState = HasQuest() -- true / false / nil (UI not ready)
            if GetSea() == 3 and lv >= 2600
                and not SubmergedAccessController:IsInside() then
                local canAttemptEntrance = SubmergedAccessController.Confirmed
                    or questState == false
                local willInvokeEntrance = canAttemptEntrance
                    and SubmergedAccessController.PendingUntil <= 0
                    and tick() >= SubmergedAccessController.NextTry
                if willInvokeEntrance then
                    if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
                        TravelManager:Stop("SubmergedEntranceStart")
                    end
                    FarmPositionController:ReleaseCluster()
                    _G.State:ClearTargets()
                end
                local accessState = SubmergedAccessController:Tick(canAttemptEntrance)
                if accessState == "pending" then
                    if _G.State.IsTraveling and _G.State.MovementOwner == "Farm" then
                        TravelManager:Stop("SubmergedEntrancePending")
                    end
                    FarmPositionController:ReleaseCluster()
                    _G.State:ClearTargets()
                    _G.BobonStatus = "Sea: Verifying Submerged entrance"
                    return
                end
            end
            local q = GetQ()


            if not q then
                FarmPositionController:ReleaseCluster()
                _G.State.ActiveQuestMob = nil
                _G.State:ClearTargets()
                if _G.State.IsTraveling
                    and _G.State.MovementOwner == "Farm" then
                    TravelManager:Stop("NoQuest")
                end
                _G.State:SetMode("Idle")
                _G.BobonStatus = "Max Level / No Quest"
                return
            end

            -- Keep one canonical mob name for the quest wrapper that is
            -- currently active. On re-execution, adopt it only when the UI
            -- contains an exact QDB mob name. A localized/unreadable wrapper
            -- is still safe to farm by level, but bring stays disabled until
            -- this session accepts the next quest and knows its exact mob.
            if questState == false then
                FarmPositionController:ReleaseCluster()
                _G.State.ActiveQuestMob = nil
            elseif questState == true then
                local resolvedMob = ResolveQuestMobFromText()
                if resolvedMob then
                    local cachedMob = _G.State.ActiveQuestMob
                    if cachedMob and string.lower(tostring(cachedMob))
                        ~= string.lower(tostring(resolvedMob)) then
                        FarmPositionController:ReleaseCluster()
                        _G.State:ClearTargets()
                        if _G.State.IsTraveling
                            and _G.State.MovementOwner == "Farm" then
                            TravelManager:Stop("QuestIdentityChanged")
                        end
                        DLog("QUEST", "Active quest changed: "
                            .. tostring(cachedMob) .. " -> " .. resolvedMob)
                    end
                    _G.State.ActiveQuestMob = resolvedMob
                    if not cachedMob then
                        DLog("QUEST", "Adopted active quest mob: " .. resolvedMob)
                    end
                elseif not _G.State.ActiveQuestMob then
                    FarmPositionController:ReleaseCluster()
                    _G.BobonDiagnostics.Bring = "QUEST-UNKNOWN"
                    DLog("QUEST", "Active quest name unreadable; bring disabled")
                end
            end


            -- Fast Sea 1 route runs before the normal quest gate.  It keeps
            -- the level-skip behavior deterministic and still uses the same
            -- TravelManager, target validation, attack gate and watchdog.
            -- Never let the fast skip route interrupt an accepted quest. It
            -- previously activated right after the first verified hits, which
            -- looked exactly like "attacks briefly, then stops/leaves".
            if questState == true or _G.State.ActiveQuestMob then
                SkipRouteController:Reset("active quest has priority")
            elseif SkipRouteController:Run() then
                return
            end


            -- ═══ QUEST HANDLING (FIX-P2/P3) ═══
            local questMatch = QuestMatches(q.M)
            -- [G-6] Farm khi wrapper quest đang mở VÀ match KHÔNG bị xác
            -- nhận là SAI (nil = UI đổi cấu trúc sau update, đọc không ra
            -- title). Bản cũ đòi match == true nên nil khiến bot kẹt
            -- re-request quest vô hạn → không farm, không gom, không đánh.
            local hasQuest = questState == true and questMatch ~= false
            -- Right after StartQuest, some UI builds briefly hide/rebuild the
            -- Quest wrapper. Do not cancel the accepted quest and fly back to
            -- the giver during that short transition.
            if not hasQuest and questMatch ~= false
                and _G.State.LastQuestAccepted > 0
                and tick() - _G.State.LastQuestAccepted
                    <= (_G.Settings.QuestAcceptGrace or 6) then
                hasQuest = true
            end
            local questOk = hasQuest
            local questMobName = _G.State.ActiveQuestMob or q.M

            -- Quest-first invariant: quest vừa hết, bị mất, sai mob, hoặc UI
            -- không còn xác nhận được đều phải quay lại giver ngay trong tick
            -- này.  Dừng target/travel cũ trước để không bay tiếp tới mob cũ.
            if not hasQuest then
                local okSea, seaResult = pcall(function()
                    -- Sea gates vẫn là bắt buộc ở level 700/1500; optional
                    -- item/boss tuyệt đối không được chen vào giữa quest.
                    return ItemProgression:RunChecks(true, false)
                end)
                if not okSea then
                    warn("[BobonHub] Module Error: ItemProgression: " .. tostring(seaResult))
                elseif seaResult then
                    return
                end

                -- A confirmed closed quest is the only safe window for
                -- optional kaitun items/boss drops. The old placement was
                -- below this return path, so Saber/Pole/BossManager were
                -- logically unreachable and never ran at all.
                -- The wrapper is authoritative here. A completed quest can
                -- leave stale title text behind, so questMatch may still be
                -- true even though there is no active quest.
                local safeItemWindow = questState == false
                if safeItemWindow then
                    local okItems, itemResult = pcall(function()
                        return ItemProgression:RunChecks(true, true)
                    end)
                    if not okItems then
                        warn("[BobonHub] Module Error: ItemProgression: " .. tostring(itemResult))
                    elseif itemResult then
                        return
                    end

                    local okBoss, bossResult = pcall(function()
                        return BossManager:TryFightBoss()
                    end)
                    if not okBoss then
                        warn("[BobonHub] Module Error: BossManager: " .. tostring(bossResult))
                    elseif bossResult then
                        return
                    end
                end

                FarmPositionController:ReleaseCluster()
                _G.State:ClearTargets()
                -- Request(q.QC) below atomically replans a stale Farm goal.
                -- Do not destroy/recreate BodyMovers every 0.15 seconds.
                _G.State:SetMode("GettingQuest")
                _G.BobonStatus = "Quest: Refreshing " .. q.M
                DLog("QUEST", "Quest missing/complete/wrong → refresh " .. q.M)
                local hrp = HRP()
                local atGiver = hrp and (hrp.Position - q.QC.Position).Magnitude <= _G.Settings.CloseThreshold
                if HandleQuestAtGiver(q, atGiver) then
                    return
                end
                TravelManager:Request(q.QC, "Farm")
                return
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
                        _G.BobonStatus = "Quest: Verifying " .. q.M
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
                DLog("QUEST", "Missing or wrong quest → going to giver for " .. q.M)
                local hrp = HRP()
                local atGiver = hrp and (hrp.Position - q.QC.Position).Magnitude <= _G.Settings.CloseThreshold
                if HandleQuestAtGiver(q, atGiver) then
                    return
                else
                    _G.BobonStatus = "Quest: Traveling to " .. q.M
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
                _G.BobonStatus = "Team: Selecting Pirates"
                return
            end

            -- VERIFY_TARGET: clear NGAY nếu invalid → NEXT_TARGET
            _G.State.FState = "VERIFY_TARGET"
            if not _G.State:IsTargetValid(_G.State.FarmTarget)
                or not IsEnemyNamed(_G.State.FarmTarget, questMobName) then
                FarmPositionController:ReleaseCluster()
                _G.State:ClearTargets()
                _G.State.FState = "NEXT_TARGET"
                DLog("TARGET", "Old target invalid → selecting a new one")
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
                        or not IsAllowedWorldPosition(targetPos) then
                        _G.State:ClearTargets()
                        _G.State.FState = "NEXT_TARGET"
                        _G.BobonStatus = "Farm: Invalid target, returning to farm area"
                        DLog("TARGET", "Invalid target (far/below sea) → returning to farm area")
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
                            fallback = q.MC,
                            combatHover = true,
                        })
                    else
                        if _G.State:CanRequestTravel() then
                            TravelManager:Request(targetHRP, "Farm", {
                                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                                fallback = q.MC,
                                combatHover = true,
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
                        if flatDist <= _G.Settings.AttackRange and farmHolds
                            and TravelManager:IsAtCombatAnchor(targetHRP) then
                            _G.State.FState = "ATTACK"
                            -- Equip is asynchronous; the next tick runs the
                            -- same verified adapter for melee or sword.
                            EquipCombatTool()
                            Attack(_G.State.FarmTarget, questMobName)
                            if os.time() - lastAttackLog >= 5 then
                                lastAttackLog = os.time()
                                DLog("ATTACK", "Target: " .. _G.State.FarmTarget.Name)
                            end
                        end
                    end

                    -- GOM MOB [A-4]: gom mềm các mob quest ở gần vào cluster
                    -- cục bộ rồi để FastAttack xử lý cả nhóm; không tạo loop
                    -- movement riêng và không đụng mob ở xa.
                    -- `hasQuest` is the strict UI-verified quest state above;
                    -- q.M is therefore the mob of the quest currently held,
                    -- never a stale/next-level mob name.
                    local anchorHeight = (CombatController:IsFastReady()
                        or not CombatController:WantsClientRange())
                        and (_G.Settings.FarmHeight or 15)
                        or (_G.Settings.ClientHoverHeight or 5)
                    local anchorFarmPos = FarmPositionController:GetFarmPos(
                        _G.State.FarmTarget, anchorHeight)
                    local atAnchor = false
                    if anchorFarmPos and hrp then
                        atAnchor = (hrp.Position - anchorFarmPos).Magnitude
                            <= (_G.Settings.HoverConfirmRadius or 5)
                            and TravelManager:IsAtCombatAnchor(targetHRP)
                    end
                    -- Bring is allowed only while every farm/quest/anchor gate
                    -- is true. Leaving the anchor immediately stops forcing
                    -- NPC physics instead of retaining a stale cluster.
                    local canGather = _G.Settings.GatherMobs
                        and _G.State.ActiveQuestMob ~= nil
                        and atAnchor
                        and CombatController:IsDamageReady()
                    if canGather then
                        FarmPositionController:GatherMobCluster(
                            questMobName, _G.State.FarmTarget)
                    else
                        FarmPositionController:ReleaseCluster()
                        if _G.Settings.GatherMobs
                            and not _G.State.ActiveQuestMob then
                            _G.BobonDiagnostics.Bring = "QUEST-UNKNOWN"
                        elseif _G.Settings.GatherMobs
                            and not CombatController:IsDamageReady() then
                            _G.BobonDiagnostics.Bring = "DAMAGE-WAIT"
                        elseif _G.Settings.GatherMobs and not atAnchor then
                            _G.BobonDiagnostics.Bring = "WAIT-FARM-ANCHOR"
                        end
                    end
                end
            else
                -- SELECT_TARGET [A-5]: mob theo quest/level/sea hiện tại,
                -- chọn mob GẦN player nhất (không chọn ngẫu nhiên cả map)
                _G.State.FState = "SELECT_TARGET"
                DLog("FARM", "State = SELECT_TARGET")
                local mob, dist = FindNearestMob(questMobName)


                if mob and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    PrepareCombatTarget(mob)
                    if dist > _G.Settings.MaxFarmDistance then
                        -- Mob quá xa → về khu farm, KHÔNG giữ target xa
                        _G.State:ClearTargets()
                        _G.BobonStatus = "Farm: " .. questMobName .. " is far, returning to farm area"
                        DLog("TARGET", q.M .. " is too far (" .. string.format("%.0f", dist) .. ") → returning to farm area")
                        if _G.State:CanRequestTravel() then
                            TravelManager:Request(q.MC, "Farm")
                        end
                    else
                        _G.State.FarmTarget = mob
                        _G.State.CurrentTarget = mob
                        _G.State.FState = "MOVE_TO_TARGET"
                        _G.BobonStatus = "Farm: " .. questMobName
                        DLog("TARGET", "Found: " .. q.M .. " @" .. string.format("%.0f", dist) .. " studs")
                        if _G.State:CanRequestTravel() then
                            TravelManager:Request(mob.HumanoidRootPart, "Farm", {
                                arrivalThreshold = _G.Settings.FarmArrivalThreshold,
                                fallback = q.MC,
                                combatHover = true,
                            })
                        end
                    end
                else
                    _G.BobonStatus = "Farm: Waiting for " .. questMobName .. " spawn"
                    DLog("TARGET", "Waiting for " .. q.M .. " spawn")
                    if _G.State:CanRequestTravel() then
                        TravelManager:Request(q.MC, "Farm")
                    end
                end
            end
        end)
        if not okMain then
            FarmPositionController:ReleaseCluster()
            _G.State:ClearTargets()
            if _G.State.IsTraveling
                and _G.State.MovementOwner == "Farm" then
                TravelManager:Stop("MainControllerError")
            end
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
        _G.BobonStatus = "Haki: Waiting for character"
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
    if not SessionAlive() then return end
    pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
end)


-- Do not mutate Tool.Handle. Enlarging every melee/sword handle to 50 studs
-- and hiding it can invalidate the live Tool controller and was shared by all
-- weapons, which is why Combat, other melee styles and swords failed alike.
-- Enemy-side target preparation already supplies the local acquisition box.


-- Auto Stats batch limit (Fix #15 / FIX-P7)
-- Giữ batch limit, Points=0 → không làm gì, lỗi remote không ảnh hưởng
-- Farm. KHÔNG tạo ActionToken cho background stat.
task.spawn(function()
    while SessionAlive() and task.wait(3) do
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
            if not SessionAlive() then return end
            _G.State.KillCount = _G.State.KillCount + 1
        end)
    end
end


task.spawn(function()
    local function Watch()
        local f = workspace:FindFirstChild("Enemies")
        if not f then return end
        for _, mob in ipairs(f:GetChildren()) do HookMob(mob) end
        f.ChildAdded:Connect(function(mob)
            if not SessionAlive() then return end
            task.wait(0.1)
            if SessionAlive() then HookMob(mob) end
        end)
    end
    Watch()
    if not workspace:FindFirstChild("Enemies") then
        workspace.ChildAdded:Connect(function(c)
            if not SessionAlive() then return end
            if c.Name == "Enemies" then task.wait(0.3); Watch() end
        end)
    end
end)
-- ══════════════════════════════════════════════════════════════════
--                   FINAL INITIALIZATION
-- ══════════════════════════════════════════════════════════════════
_G.State.Sea = GetSea()
_G.State.StartTime = os.time()

-- Future executions call this hook before replacing the session. It releases
-- physics/movement and destroys the old overlay instead of leaving duplicate
-- farm controllers alive in the same Roblox process.
_G.BobonUnload = function()
    if not SessionAlive() then return end
    _G.BobonSessionID = SessionID + 1
    pcall(function() TravelManager:Stop("Reexecute") end)
    pcall(function() CombatController:Cleanup() end)
    pcall(function() FarmPositionController:ReleaseCluster() end)
    pcall(function() if SG and SG.Parent then SG:Destroy() end end)
end


print("[BobonHub v16.6 LIVE] Full Script Loaded Successfully!")
print("[BobonHub v16.6 LIVE] Architecture: Persistent Travel | ActionToken | Single Owner")
print("[BobonHub v16.6 LIVE] Core: TravelManager(v7+P1) | StateManager(v7) | RecoveryManager(v7+P10)")
print("[BobonHub v16.6 LIVE] Modules: QuestFarm | Health-Verified Combat | Ownership Bring | Responsive Glass HUD")
print("[BobonHub v16.6 LIVE] Progression: Saber | Pole | Sea2 | Bartilo | Sea3")
print("[BobonHub v16.6 LIVE] Data: Sea1/2/3 QDB 1-2800 | Submerged | Boss/item catalog")
print("[BobonHub v16.6 LIVE] Sea: " .. _G.State.Sea .. " | Level: " .. Level())
