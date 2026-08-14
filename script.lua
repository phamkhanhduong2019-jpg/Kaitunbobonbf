-- ================================================================= --
--                  TELEPORT FIX - BAY THẲNG KHÔNG RESPAWN
-- ================================================================= --
local function TeleportTo(cf)
    if _G.Kaitun.IsTraveling then return end
    _G.Kaitun.IsTraveling = true
    _G.Kaitun.Status = "Teleporting..."
    
    local hrp = HRP()
    if not hrp then 
        _G.Kaitun.IsTraveling = false 
        return 
    end
    
    -- Nâng cao hơn 30 stud để tránh kẹt đất/biển
    local targetCF = cf + Vector3.new(0, 30, 0)
    
    -- Spam CFrame trong 3 giây (giữ chắc vị trí)
    local start = tick()
    while tick() - start < 3.0 do
        pcall(function()
            local hrp2 = HRP()
            if hrp2 and hrp2.Parent then
                hrp2.CFrame = targetCF
                hrp2.Velocity = Vector3.zero
                hrp2.RotVelocity = Vector3.zero
                -- Tắt va chạm toàn bộ cơ thể
                local c = Char()
                if c then
                    for _, p in ipairs(c:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end
        end)
        task.wait(0.02)
    end
    
    -- Hạ xuống vị trí thật (vẫn giữ cao 5 stud)
    local finalCF = cf + Vector3.new(0, 5, 0)
    start = tick()
    while tick() - start < 1.5 do
        pcall(function()
            local hrp2 = HRP()
            if hrp2 and hrp2.Parent then
                hrp2.CFrame = finalCF
                hrp2.Velocity = Vector3.zero
                hrp2.RotVelocity = Vector3.zero
            end
        end)
        task.wait(0.02)
    end
    
    _G.Kaitun.IsTraveling = false
    _G.Kaitun.Status = "Ready"
end

-- Hàm gọi teleport nhanh (không chờ)
local function QuickTeleport(cf)
    task.spawn(function()
        TeleportTo(cf)
    end)
end
-- ================================================================= --
--                          TEAM + HAKI (1 LẦN DUY NHẤT)
-- ================================================================= --
task.spawn(function()
    task.wait(3)
    
    -- Chọn team PIRATES
    local teamSet = false
    for i = 1, 10 do
        if LP.Team and LP.Team.Name == "Pirates" then 
            teamSet = true
            break 
        end
        pcall(function() CommF_:InvokeServer("SetTeam", "Pirates") end)
        task.wait(1)
        pcall(function() CommF_:InvokeServer("ChooseTeam", "Pirates") end)
        task.wait(1)
    end
    
    if teamSet or (LP.Team and LP.Team.Name == "Pirates") then
        _G.Kaitun.Status = "Team: Pirates ✓"
    else
        _G.Kaitun.Status = "Team: Pirates (Manual)"
    end
    
    -- Bật Haki 1 LẦN
    task.wait(1)
    local hakiOn = false
    for i = 1, 3 do
        pcall(function()
            CommF_:InvokeServer("Ken", true)
            CommF_:InvokeServer("Buso", true)
            hakiOn = true
        end)
        task.wait(0.5)
        if hakiOn then break end
    end
    
    if hakiOn then
        _G.Kaitun.Status = "Haki: ON ✓"
    else
        _G.Kaitun.Status = "Haki: Check manually"
    end
    
    task.wait(0.5)
    _G.Kaitun.Status = "✅ Ready!"
    print("[Kaitun] Loaded - Haki ON, Team Pirates")
end)
-- ================================================================= --
--                    MAIN FARM LOOP (FIXED)
-- ================================================================= --
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if _G.Kaitun.IsTraveling then 
                task.wait(0.1)
                return 
            end
            
            local lv = Level()
            local sea = GetSea()
            
            -- Auto unlock sea
            if lv >= 700 and sea == 1 then
                if AutoSecondSea() then return end
            end
            if lv >= 1500 and sea == 2 then
                if AutoThirdSea() then return end
            end
            
            -- Auto items
            if lv >= 200 and lv < 700 and sea == 1 and not HasItem("Saber") then
                if AutoSaber() then return end
            end
            if lv >= 150 and lv < 700 and sea == 1 and not HasItem("Pole (1st Form)") then
                if AutoPoleV1() then return end
            end
            
            -- Get quest
            local q = GetQ()
            if not q then
                _G.Kaitun.Status = "No quest for lv " .. lv
                return
            end
            
            local hrp = HRP()
            if not hrp then return end
            
            -- Check if at NPC
            local distToNPC = (hrp.Position - q.QC.Position).Magnitude
            
            -- Nếu xa NPC > 100 -> về NPC (dùng QuickTeleport)
            if distToNPC > 100 then
                _G.Kaitun.Status = "Going to NPC: " .. q.Q
                QuickTeleport(q.QC)
                task.wait(0.5)
                return
            end
            
            -- Nhận quest nếu chưa có
            if not HasQuest() then
                _G.Kaitun.Status = "Getting quest: " .. q.Q
                QuickTeleport(q.QC)
                task.wait(0.3)
                pcall(function()
                    CommF_:InvokeServer("StartQuest", q.Q, q.QL)
                end)
                task.wait(0.5)
                return
            end
            
            -- Tìm mob
            local mob = FindMob(q.M)
            if not mob then
                _G.Kaitun.Status = "Finding " .. q.M
                QuickTeleport(q.MC)
                return
            end
            
            -- Đánh mob
            _G.Kaitun.Status = "Farming " .. q.M
            EquipMelee()
            
            local mobPos = mob.HumanoidRootPart.Position
            local hrpPos = hrp.Position
            local distToMob = (hrpPos - mobPos).Magnitude
            
            if distToMob > 60 then
                QuickTeleport(CFrame.new(mobPos))
                return
            end
            
            -- Teleport gần mob + tấn công
            local attackPos = mobPos + Vector3.new(0, 15, 0)
            pcall(function()
                hrp.CFrame = CFrame.new(attackPos)
                hrp.Velocity = Vector3.zero
            end)
            Attack()
        end)
    end
end)
-- ================================================================= --
--                    AUTO UNLOCK SEA (FIXED)
-- ================================================================= --
local function AutoSecondSea()
    if GetSea() >= 2 or Level() < 700 then return false end
    _G.Kaitun.Status = "Unlocking Sea 2..."
    QuickTeleport(CFrame.new(-4909, 4, 4450))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Detective") end)
    task.wait(1)
    QuickTeleport(CFrame.new(932, 13, 4482))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Bartilo") end)
    task.wait(1)
    local kills = 0
    while kills < 50 do
        local mob = FindMob("Swan Pirate")
        if mob then
            EquipMelee()
            QuickTeleport(CFrame.new(mob.HumanoidRootPart.Position + Vector3.new(0, 22, 0)))
            Attack()
            if mob.Humanoid.Health <= 0 then kills = kills + 1 end
        else
            QuickTeleport(CFrame.new(878, 122, 1235))
            task.wait(2)
        end
        task.wait(0.1)
    end
    QuickTeleport(CFrame.new(932, 13, 4482))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Bartilo") end)
    task.wait(1)
    QuickTeleport(CFrame.new(-12471, 374, -7551))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("DressrosaQuestProgress", "Door") end)
    task.wait(1)
    TP:Teleport(4442272183, LP)
    return true
end

local function AutoThirdSea()
    if GetSea() ~= 2 or Level() < 1500 then return false end
    _G.Kaitun.Status = "Unlocking Sea 3..."
    QuickTeleport(CFrame.new(-285, 306, 611))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("ZQuestProgress", "Check") end)
    task.wait(1)
    local timeout = os.time() + 300
    while os.time() < timeout do
        local boss = FindBoss("Don Swan")
        if boss and boss.Humanoid.Health > 0 then
            EquipMelee()
            QuickTeleport(CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0, 22, 0)))
            Attack()
        else break end
        task.wait(0.1)
    end
    QuickTeleport(CFrame.new(-285, 306, 611))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("ZQuestProgress", "Begin") end)
    task.wait(1)
    TP:Teleport(7449423635, LP)
    return true
end
-- ================================================================= --
--                    AUTO SABER + POLE (FIXED)
-- ================================================================= --
local function AutoSaber()
    if HasItem("Saber") or Level() < 200 or GetSea() ~= 1 then return false end
    _G.Kaitun.Status = "Getting Saber..."
    local torches = {
        {N="Torch1", C=CFrame.new(-1610, 11, 163)},
        {N="Torch2", C=CFrame.new(1114, 4, 4350)},
        {N="Torch3", C=CFrame.new(1400, 101, -1250)},
        {N="Torch4", C=CFrame.new(-5070, 23, 4325)},
        {N="Torch5", C=CFrame.new(-1675, 7, -2985)},
    }
    for _, t in ipairs(torches) do
        QuickTeleport(t.C)
        task.wait(2)
        pcall(function() CommF_:InvokeServer("Torch", t.N) end)
        task.wait(0.5)
    end
    local timeout = os.time() + 300
    while not HasItem("Saber") and os.time() < timeout do
        local boss = FindBoss("Saber Expert")
        if boss then
            EquipMelee()
            QuickTeleport(CFrame.new(boss.HumanoidRootPart.Position + Vector3.new(0, 22, 0)))
            Attack()
        else
            QuickTeleport(CFrame.new(-1405, 30, -3330))
            task.wait(3)
        end
        task.wait(0.1)
    end
    return true
end

local function AutoPoleV1()
    if HasItem("Pole (1st Form)") or Level() < 150 or GetSea() ~= 1 then return false end
    _G.Kaitun.Status = "Getting Pole..."
    QuickTeleport(CFrame.new(-7748, 5606, -2305))
    task.wait(2)
    pcall(function() CommF_:InvokeServer("BuyPoleV1") end)
    task.wait(1)
    return true
end
-- ================================================================= --
--              ANTI FALL + NOCLIP (RUNNING BACKGROUND)
-- ================================================================= --
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local hrp = HRP()
            if not hrp then return end
            
            -- Nếu đang ở biển (Y < 5) thì kéo lên
            if hrp.Position.Y < 5 and not _G.Kaitun.IsTraveling then
                _G.Kaitun.Status = "Anti-Fall: Rescuing..."
                local target = _G.Kaitun.LastPos or CFrame.new(0, 50, 0)
                hrp.CFrame = target + Vector3.new(0, 30, 0)
                hrp.Velocity = Vector3.zero
                hrp.RotVelocity = Vector3.zero
                task.wait(0.5)
                _G.Kaitun.Status = "Ready"
            end
            
            -- Lưu vị trí cuối để dùng khi rớt
            if hrp.Position.Y > 10 then
                _G.Kaitun.LastPos = hrp.CFrame
            end
        end)
    end
end)
-- ================================================================= --
--              HANDLE RESPAWN (KHI CHẾT VÔ TÌNH)
-- ================================================================= --
LP.CharacterAdded:Connect(function(newChar)
    task.spawn(function()
        -- Đợi HRP xuất hiện
        local hrp2 = newChar:WaitForChild("HumanoidRootPart", 10)
        if not hrp2 then return end
        
        -- Tắt va chạm
        for _, p in ipairs(newChar:GetDescendants()) do
            if p:IsA("BasePart") then 
                p.CanCollide = false 
            end
        end
        
        -- Đưa lên trời an toàn
        local safePos = CFrame.new(0, 100, 0)
        local start = tick()
        while tick() - start < 2.0 do
            pcall(function()
                hrp2.CFrame = safePos
                hrp2.Velocity = Vector3.zero
                hrp2.RotVelocity = Vector3.zero
            end)
            task.wait(0.02)
        end
        
        -- Chờ vài giây rồi về NPC gần nhất
        task.wait(2)
        _G.Kaitun.IsTraveling = false
        _G.Kaitun.Status = "Respawned - Ready"
    end)
end)
