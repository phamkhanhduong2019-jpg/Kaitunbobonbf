repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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

local function disableBananaLogic()
    for k, v in pairs(getgenv()) do
        if type(v) == "function" and (
            string.find(k:lower(), "farm") or 
            string.find(k:lower(), "tween") or 
            string.find(k:lower(), "teleport") or 
            string.find(k:lower(), "attack") or
            string.find(k:lower(), "hop")
        ) then
            getgenv()[k] = function() return end
        end
    end
end

disableBananaLogic()

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()
    end)
end)

task.wait(4)

disableBananaLogic()

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
