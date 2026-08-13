local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- 1. Lưu snapshot kết nối trước khi load
local function snapshotConnections()
    local snap = {}
    local events = {RunService.Heartbeat, RunService.Stepped, RunService.RenderStepped}
    for _, ev in ipairs(events) do
        local ok, conns = pcall(function() return getconnections(ev) end)
        if ok then
            snap[ev] = {}
            for _, c in ipairs(conns) do
                snap[ev][c] = true
            end
        end
    end
    return snap
end

local before = snapshotConnections()

-- 2. Khóa Config Banana
getgenv().SettingFarm = {
    ["Hide UI"] = false,
    ["White Screen"] = false,
    ["Lock Fps"] = { ["Enabled"] = false, ["FPS"] = 60 },
    ["Reset Teleport"] = { ["Enabled"] = false },
    ["Get Items"] = {},
    ["Get Rare Items"] = {},
    ["Farm Fragments"] = { ["Enabled"] = false },
    ["Auto Chat"] = { ["Enabled"] = false },
    ["Auto Summon Rip Indra"] = false,
    ["Select Hop"] = {},
    ["Farm Mastery"] = { ["Melee"] = false, ["Sword"] = false },
    ["Buy Haki"] = {},
    ["Sniper Fruit Shop"] = { ["Enabled"] = false },
    ["Lock Fruit"] = {},
    ["Webhook"] = { ["Enabled"] = false }
}

-- 3. CHẶN METATABLE (Chặn Banana can thiệp CFrame/Position/RemoteEvent)
local rawTweenCreate = TweenService.Create
local rawTaskSpawn = task.spawn

-- Chặn Tween
TweenService.Create = function(self, instance, info, properties)
    if instance and (instance:IsA("BasePart") or instance:IsA("Model")) then
        if properties.CFrame or properties.Position then
            return { Play = function() end, Cancel = function() end, Destroy = function() end }
        end
    end
    return rawTweenCreate(self, instance, info, properties)
end

-- Tạm đóng task.spawn để không tạo thread ngầm
task.spawn = function(...)
    return nil
end

-- Hook Metatable __index và __newindex để đóng băng di chuyển
local gmt = getrawmetatable(game)
local oldIndex = gmt.__index
local oldNewIndex = gmt.__newindex
setreadonly(gmt, false)

gmt.__newindex = newcclosure(function(t, k, v)
    -- Chặn các thao tác set CFrame/Position/Velocity lên nhân vật từ Banana
    if not checkcaller() then
        if (k == "CFrame" or k == "Position" or k == "Velocity") and t:IsDescendantOf(LocalPlayer.Character) then
            return
        end
    end
    return oldNewIndex(t, k, v)
end)

setreadonly(gmt, true)

-- 4. Load Banana Cat
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()

task.wait(5)

-- 5. Cắt toàn bộ Event mới phát sinh từ Banana
local function cutNewConnections(before)
    local events = {RunService.Heartbeat, RunService.Stepped, RunService.RenderStepped}
    for _, ev in ipairs(events) do
        local ok, conns = pcall(function() return getconnections(ev) end)
        if ok then
            for _, c in ipairs(conns) do
                if not (before[ev] and before[ev][c]) then
                    pcall(function() c:Disable() end)
                end
            end
        end
    end
end
cutNewConnections(before)

-- 6. MỞ KHÓA HOÀN TOÀN CHO SUGE CHẠY
TweenService.Create = rawTweenCreate
task.spawn = rawTaskSpawn

setreadonly(gmt, false)
gmt.__newindex = oldNewIndex
setreadonly(gmt, true)

warn("[System] Da xoa bỏ hoàn toàn quyền can thiệp của Banana Cat. Dang load Suge...")

-- 7. Cấu hình & Load Suge Script
repeat task.wait() until game:IsLoaded() and LocalPlayer

getgenv().Configs = {
    ["Auto Collect Berry"] = false,
    ["Auto Evo Race"] = false,
    ["Auto Pull Lever"] = false,
    ["Auto Saber"] = true,
    ["Auto Spawn Dough King"] = false,
    ["Auto Spawn rip_indra"] = false,
    ["Awaken Fruit"] = false,
    ["Eat Fruit"] = "",
    ["Snipe Fruit"] = {"Leopard-Leopard","Kitsune-Kitsune","Dragon-Dragon","Yeti-Yeti","Gas-Gas"},
    ["Get Fruits"] = true,
    ["Buy Stuffs"] = false,
    ["Cursed Dual Katana"] = true,
    ["Skull Guitar"] = true,
    ["Switch Melee"] = true,
    ["FPS Boost"] = {
        ["Enable"] = false,
        ["FPS Cap"] = 40,
        ["Hide Game UI"] = false,
        ["Disable 3D Render"] = false,
    },
    ["Farm Boss Drops"] = {
        ["Enable"] = false,
        ["When x2 Exp Expired"] = false,
    },
    ["Farm Config"] = {
        ["Farm Bone Get x2 Exp"] = {
            ["Enable"] = true,
            ["Level"] = 1500,
        },
        ["First Farm At Sky"] = true,
    },
    ["Farm Mastery"] = {
        ["Enable"] = false,
        ["Farm Mastery Weapons"] = {},
        ["Guns To Farm"] = {},
        ["Mastery Health (%)"] = 40,
        ["Swords To Farm"] = {},
    },
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
    ["Fruit to use for auto third sea"] = {},
    ["Lock Fragment"] = 0,
    ["Rainbow Haki"] = false,
    ["Shutdown"] = false,
    ["Team"] = "Pirates",
}

loadstring(game:HttpGet("https://hune205.dev/api/v5/files/6a71e41ee9e85c97e79660b2.lua"))()
