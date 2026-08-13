--[[
    ╔════════════════════════════════════════════════════════╗
    ║     CONFIG - Suge FARM CHÍNH + Banana Menu             ║
    ║     Banana chỉ hiển thị, không tự động làm gì         ║
    ╚════════════════════════════════════════════════════════╝
]]
 
-- ==================== CONFIG SUGE (FARM CHÍNH) ====================
getgenv().Configs = {
    -- ===== AUTO COLLECT & FARM =====
    ["Auto Collect Berry"] = false,
    ["Auto Evo Race"] = false,
    ["Auto Pull Lever"] = false,
    ["Auto Saber"] = true,
    ["Auto Spawn Dough King"] = false,
    ["Auto Spawn rip_indra"] = false,
    
    -- ===== FRUIT & AWAKENING =====
    ["Awaken Fruit"] = false,
    ["Eat Fruit"] = "",
    ["Snipe Fruit"] = "",
    ["Get Fruits"] = true,
    
    -- ===== WEAPON AUTO GET =====
    ["Buy Stuffs"] = false,
    ["Cursed Dual Katana"] = true,
    ["Skull Guitar"] = true,
    ["Switch Melee"] = true,
    
    -- ===== PERFORMANCE =====
    ["FPS Boost"] = {
        ["Enable"] = true,
        ["FPS Cap"] = 5,
        ["Hide Game UI"] = true,
        ["Disable 3D Render"] = true,
    },
    
    -- ===== FARMING =====
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
    
    -- ===== HOP =====
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
    
    -- ===== KHÁC =====
    ["Fruit to use for auto third sea"] = {},
    ["Lock Fragment"] = 0,
    ["Rainbow Haki"] = false,
    ["Shutdown"] = false,
    ["Team"] = "Pirates",
}
 
-- Load script Suge (FARM CHÍNH)
loadstring(game:HttpGet("https://hune205.dev/api/v5/files/6a71e41ee9e85c97e79660b2.lua"))()
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
 
-- ==================== CONFIG BANANA (CHỈ MENU, KHÔNG FARM) ====================
getgenv().SettingFarm = {
    -- ===== TẮT HẾT TỰ ĐỘNG =====
    ["Hide UI"] = false,
    ["White Screen"] = false,
    
    ["Lock Fps"] = {
        ["Enabled"] = false,
        ["FPS"] = 20,
    },
    
    ["Reset Teleport"] = {
        ["Enabled"] = false,
        ["Delay Reset"] = 3,
        ["Item Dont Reset"] = {
            ["Fruit"] = {
                ["Enabled"] = false,
                ["All Fruit"] = false,
                ["Select Fruit"] = {
                    ["Enabled"] = false,
                    ["Fruit"] = {},
                },
            },
        },
    },
    
    ["Get Items"] = {
        ["Saber"] = false,
        ["Godhuman"] = false,
        ["Skull Guitar"] = false,
        ["Mirror Fractal"] = false,
        ["Cursed Dual Katana"] = false,
        ["Upgrade Race V2-V3"] = false,
        ["Auto Pull Lever"] = false,
        ["Shark Anchor"] = false,
    },
    
    ["Get Rare Items"] = {
        ["Rengoku"] = false,
        ["Dragon Trident"] = false,
        ["Pole (1st Form)"] = false,
        ["Gravity Blade"] = false,
    },
    
    ["Farm Fragments"] = {
        ["Enabled"] = false,
        ["Fragment"] = 50000,
    },
    
    ["Auto Chat"] = {
        ["Enabled"] = false,
        ["Text"] = "",
    },
    
    ["Auto Summon Rip Indra"] = false,
    
    ["Select Hop"] = {
        ["Hop Server If Have Player Near"] = false,
        ["Hop Find Rip Indra Get Valkyrie Helm or Get Tushita"] = false,
        ["Hop Find Dough King Get Mirror Fractal"] = false,
        ["Hop Find Raids Castle [CDK]"] = false,
        ["Hop Find Cake Queen [CDK]"] = false,
        ["Hop Find Soul Reaper [CDK]"] = false,
        ["Hop Find Darkbeard [SG]"] = false,
        ["Hop Find Mirage [ Pull Lever ]"] = false,
    },
    
    ["Farm Mastery"] = {
        ["Melee"] = false,
        ["Sword"] = false,
    },
    
    ["Buy Haki"] = {
        ["Enhancement"] = false,
        ["Skyjump"] = false,
        ["Flash Step"] = false,
        ["Observation"] = false,
    },
    
    ["Sniper Fruit Shop"] = {
        ["Enabled"] = false,
        ["Fruit"] = {"Leopard-Leopard","Kitsune-Kitsune","Dragon-Dragon","Yeti-Yeti","Gas-Gas"},
    },
    
    ["Lock Fruit"] = {},
    ["Webhook"] = {
        ["Enabled"] = false,
        ["WebhookUrl"] = "",
    }
}
 
-- Load script Banana (CHỈ MENU)
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()
 
--[[
    ════════════════════════════════════════════════════════
    CẤU HÌNH:
    
    ✅ SUGE: Farm chính (tất cả config của Suge)
    ✅ BANANA: Chỉ hiển thị menu (hết tính năng tự động)
    
    CÁCH DÙNG:
    getgenv().Key = "YOUR_BANANA_KEY_HERE"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/phamkhanhduong2019-jpg/Kaitunbobonbf/refs/heads/main/suge_main_banana_menu.lua"))()
    
    ════════════════════════════════════════════════════════
]]
 
