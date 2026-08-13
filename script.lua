local RunService = game:GetService("RunService")

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

getgenv().SettingFarm = {
    ["Hide UI"] = false,
    ["White Screen"] = false,
    ["Lock Fps"] = { ["Enabled"] = false, ["FPS"] = 20 },
    ["Reset Teleport"] = { ["Enabled"] = false, ["Delay Reset"] = 3, ["Item Dont Reset"] = { ["Fruit"] = { ["Enabled"] = false, ["All Fruit"] = false, ["Select Fruit"] = { ["Enabled"] = false, ["Fruit"] = {} } } } },
    ["Get Items"] = { ["Saber"] = false, ["Godhuman"] = false, ["Skull Guitar"] = false, ["Mirror Fractal"] = false, ["Cursed Dual Katana"] = false, ["Upgrade Race V2-V3"] = false, ["Auto Pull Lever"] = false, ["Shark Anchor"] = false },
    ["Get Rare Items"] = { ["Rengoku"] = false, ["Dragon Trident"] = false, ["Pole (1st Form)"] = false, ["Gravity Blade"] = false },
    ["Farm Fragments"] = { ["Enabled"] = false, ["Fragment"] = 50000 },
    ["Auto Chat"] = { ["Enabled"] = false, ["Text"] = "" },
    ["Auto Summon Rip Indra"] = false,
    ["Select Hop"] = { ["Hop Server If Have Player Near"] = false, ["Hop Find Rip Indra Get Valkyrie Helm or Get Tushita"] = false, ["Hop Find Dough King Get Mirror Fractal"] = false, ["Hop Find Raids Castle [CDK]"] = false, ["Hop Find Cake Queen [CDK]"] = false, ["Hop Find Soul Reaper [CDK]"] = false, ["Hop Find Darkbeard [SG]"] = false, ["Hop Find Mirage [ Pull Lever ]"] = false },
    ["Farm Mastery"] = { ["Melee"] = false, ["Sword"] = false },
    ["Buy Haki"] = { ["Enhancement"] = false, ["Skyjump"] = false, ["Flash Step"] = false, ["Observation"] = false },
    ["Sniper Fruit Shop"] = { ["Enabled"] = false, ["Fruit"] = {"Leopard-Leopard","Kitsune-Kitsune","Dragon-Dragon","Yeti-Yeti","Gas-Gas"} },
    ["Lock Fruit"] = {},
    ["Webhook"] = { ["Enabled"] = false, ["WebhookUrl"] = "" }
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()

task.wait(5)

local function cutNewConnections(before)
    local events = {RunService.Heartbeat, RunService.Stepped, RunService.RenderStepped}
    local cutCount = 0
    for _, ev in ipairs(events) do
        local ok, conns = pcall(function() return getconnections(ev) end)
        if ok then
            for _, c in ipairs(conns) do
                if not (before[ev] and before[ev][c]) then
                    pcall(function() c:Disable() end)
                    cutCount = cutCount + 1
                end
            end
        end
    end
    return cutCount
end

local cut = cutNewConnections(before)
warn("[Banana Blocker] Da cat " .. cut .. " ket noi moi tu Banana")

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

getgenv().Configs = {
    ["Auto Collect Berry"] = false,
    ["Auto Evo Race"] = false,
    ["Auto Pull Lever"] = false,
    ["Auto Saber"] = true,
    ["Auto Spawn Dough King"] = true,
    ["Auto Spawn rip_indra"] = true,
    ["Awaken Fruit"] = false,
    ["Eat Fruit"] = "",
    ["Snipe Fruit"] = "Leopard-Leopard","Kitsune-Kitsune","Dragon-Dragon","Yeti-Yeti","Gas-Gas",
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
