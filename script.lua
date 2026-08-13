--[[
    ╔════════════════════════════════════════════════════════╗
    ║     MERGED CONFIG - Suge + Banana Cat                  ║
    ║     Kết hợp tính năng từ cả 2 bản script              ║
    ╚════════════════════════════════════════════════════════╝
]]

-- ==================== CONFIG SUGE ====================
getgenv().Configs = {
    -- ===== AUTO COLLECT & FARM =====
    ["Auto Collect Berry"] = false,
    ["Auto Evo Race"] = false, --bug
    ["Auto Pull Lever"] = false, --bug
    ["Auto Saber"] = true,
    ["Auto Spawn Dough King"] = false,
    ["Auto Spawn rip_indra"] = false,
    
    -- ===== FRUIT & AWAKENING =====
    ["Awaken Fruit"] = false,
    ["Eat Fruit"] = "",
    ["Snipe Fruit"] = "",
    ["Get Fruits"] = true,
    
    -- ===== WEAPON AUTO GET =====
    ["Buy Stuffs"] = false, --bug
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

-- Load script Suge
loadstring(game:HttpGet("https://hune205.dev/api/v5/files/6a71e41ee9e85c97e79660b2.lua"))()
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Key = ""

-- ==================== CONFIG BANANA CAT ====================
getgenv().SettingFarm = {
    -- ===== UI & DISPLAY =====
    ["Hide UI"] = false,
    ["White Screen"] = false,
    
    -- ===== PERFORMANCE =====
    ["Lock Fps"] = {
        ["Enabled"] = false,
        ["FPS"] = 20,
    },
    
    -- ===== TELEPORT RESET =====
    ["Reset Teleport"] = {
        ["Enabled"] = false,
        ["Delay Reset"] = 3,
        ["Item Dont Reset"] = {
            ["Fruit"] = {
                ["Enabled"] = true,
                ["All Fruit"] = true,
                ["Select Fruit"] = {
                    ["Enabled"] = false,
                    ["Fruit"] = {},
                },
            },
        },
    },
    
    -- ===== AUTO GET ITEMS =====
    ["Get Items"] = {
        ["Saber"] = true,
        ["Godhuman"] = true,
        ["Skull Guitar"] = true,
        ["Mirror Fractal"] = true,
        ["Cursed Dual Katana"] = true,
        ["Upgrade Race V2-V3"] = true,
        ["Auto Pull Lever"] = true,
        ["Shark Anchor"] = true,
    },
    
    -- ===== RARE ITEMS =====
    ["Get Rare Items"] = {
        ["Rengoku"] = false,
        ["Dragon Trident"] = false,
        ["Pole (1st Form)"] = false,
        ["Gravity Blade"] = false,
    },
    
    -- ===== FRAGMENTS =====
    ["Farm Fragments"] = {
        ["Enabled"] = false,
        ["Fragment"] = 50000,
    },
    
    -- ===== AUTO CHAT =====
    ["Auto Chat"] = {
        ["Enabled"] = false,
        ["Text"] = "",
    },
    
    -- ===== BOSS SUMMON =====
    ["Auto Summon Rip Indra"] = true,
    
    -- ===== HOP ADVANCED =====
    ["Select Hop"] = {
        ["Hop Server If Have Player Near"] = false,
        ["Hop Find Rip Indra Get Valkyrie Helm or Get Tushita"] = true,
        ["Hop Find Dough King Get Mirror Fractal"] = false,
        ["Hop Find Raids Castle [CDK]"] = true,
        ["Hop Find Cake Queen [CDK]"] = true,
        ["Hop Find Soul Reaper [CDK]"] = true,
        ["Hop Find Darkbeard [SG]"] = true,
        ["Hop Find Mirage [ Pull Lever ]"] = false,
    },
    
    -- ===== MASTERY FARM =====
    ["Farm Mastery"] = {
        ["Melee"] = false,
        ["Sword"] = false,
    },
    
    -- ===== HAKI =====
    ["Buy Haki"] = {
        ["Enhancement"] = true,
        ["Skyjump"] = true,
        ["Flash Step"] = true,
        ["Observation"] = true,
    },
    
    -- ===== FRUIT SHOP =====
    ["Sniper Fruit Shop"] = {
        ["Enabled"] = true,
        ["Fruit"] = {"Leopard-Leopard","Kitsune-Kitsune","Dragon-Dragon","Yeti-Yeti","Gas-Gas"},
    },
    
    -- ===== LOCK FRUIT & WEBHOOK =====
    ["Lock Fruit"] = {},
    ["Webhook"] = {
        ["Enabled"] = false,
        ["WebhookUrl"] = "",
    }
}

-- Load script Banana Cat
loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaCat-kaitunBF.lua"))()

--[[
    ════════════════════════════════════════════════════════
    HƯỚNG DẪN SỬ DỤNG:
    
    1. Script này kết hợp toàn bộ config từ 2 bản
    2. Suge dùng getgenv().Configs
    3. Banana Cat dùng getgenv().SettingFarm
    4. Cả 2 script sẽ load theo thứ tự
    
    ĐIỀU CHỈNH:
    - Sửa các giá trị trong Config (true/false)
    - Để config của bạn, xóa những không dùng
    - Thêm Webhook URL nếu cần thông báo
    
    ════════════════════════════════════════════════════════
]]
