local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local realGenv = getgenv()
local bananaFakeGenv = {}

bananaFakeGenv.SettingFarm = setmetatable({}, {
    __newindex = function(t, k, v)
        if type(v) == "boolean" then
            rawset(t, k, false)
        else
            rawset(t, k, v)
        end
    end,
    __index = function(t, k)
        return false
    end
})

local gmt = getrawmetatable(game)
local oldNamecall = gmt.__namecall
setreadonly(gmt, false)

local isBananaLoading = true

gmt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if isBananaLoading and not checkcaller() then
        if method == "FireServer" or method == "InvokeServer" then
            return nil
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(gmt, true)

task.spawn(function()
    realGenv.SettingFarm = bananaFakeGenv.SettingFarm
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()
    end)
end)

task.wait(6)

isBananaLoading = false
realGenv.SettingFarm = nil

repeat task.wait() until game:IsLoaded() and LocalPlayer

realGenv.Configs = {
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
