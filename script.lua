-- ══════════════════════════════════════════════════════════════════
--    LOOP 1 — QUEST LOOP (CONTINUED & OPTIMIZED)
-- ══════════════════════════════════════════════════════════════════
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if _G.State.IsTraveling then return end

            local lv = Level()
            local sea = GetSea()

            -- Priority Item/Progression Checks
            if sea == 1 then
                if lv >= 200 and lv < 700 and not HasItem("Saber") then
                    if AutoSaber() then return end
                end
                if lv >= 150 and lv < 700 and not HasItem("Pole (1st Form)") then
                    if AutoPoleV1() then return end
                end
                if lv >= 700 then
                    if AutoSecondSea() then return end
                end
            elseif sea == 2 and lv >= 1500 then
                if AutoThirdSea() then return end
            end

            -- Core Farming Logic
            local qData = GetQ()
            if not qData then
                _G.BobonStatus = "Max Level / No Quest"
                return
            end

            -- Check & Accept Quest
            if not HasQuest() or (LP.PlayerGui.Main.Quest.Title.Text:find(qData.M) == nil) then
                Travel(qData.QC)
                task.wait(0.8)
                pcall(function() CommF_:InvokeServer("StartQuest", qData.Q, qData.QL) end)
                task.wait(0.5)
                _G.BobonStatus = "Accepting: " .. qData.M
                return
            end

            -- Find & Engage Target
            local mob = FindMob(qData.M)
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                _G.State.CurrentTarget = mob.Name
                _G.BobonStatus = "Farming: " .. mob.Name
                
                -- Positioning & Attack
                local offset = Vector3.new(0, _G.Settings.FarmHeight, 0)
                Travel(mob.HumanoidRootPart.CFrame + offset)
                
                EquipMelee()
                Attack()
                
                -- Bring other nearby mobs closer (AoE optimization)
                for _, v in ipairs(workspace.Enemies:GetChildren()) do
                    if v.Name == qData.M and v ~= mob and v:FindFirstChild("HumanoidRootPart") then
                        pcall(function()
                            v.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame
                        end)
                    end
                end
            else
                -- Mob not found, travel to spawn area
                _G.BobonStatus = "Searching: " .. qData.M
                Travel(qData.MC)
                task.wait(0.5)
            end
        end)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--    LOOP 2 — OBSERVATION HAKI & HEALTH REGEN
-- ══════════════════════════════════════════════════════════════════
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            local h = Hum()
            if h and h.Health < h.MaxHealth * 0.6 then
                -- Use healing fruit or wait if none available
                local healItem = LP.Backpack:FindFirstChildWhichIsA("Tool") 
                if healItem and healItem.Name:match("Heal|Apple|Banana") then
                    h:EquipTool(healItem)
                    task.wait(0.5)
                    VU:ClickButton1(Vector2.new())
                end
            end
            
            -- Re-activate Ken Haki if it dropped
            CommF_:InvokeServer("Ken", true)
        end)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--    CLEANUP & ERROR HANDLING WRAPPER
-- ══════════════════════════════════════════════════════════════════
game:BindToClose(function()
    _G.BobonStatus = "Shutting Down..."
    task.wait(1)
end)

print("[BobonHub v13] ✅ FULLY INITIALIZED | READY TO FARM")
_G.BobonStatus = "Operational"
