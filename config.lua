Config = {}
Config.Locale = 'en'

Config.Framework = "ESX" -- ESX or qbcore

Config.EnableDebug = false -- Enable/Disable prints and showing box of targets
Config.Target = "ox_target" -- ox_target or qb-target


Config.Craftings = {
    ["police"] = {
        jobs = {["police"] = 0}, -- Required jobs to access table
        model = `gr_prop_gr_bench_04b`, -- Table model.
        label = 'Open police crafting', -- Target label
        icon = "fas fa-shield",
        coords = { -- Table Coords
            [1] = vector4(461.5177, -981.1409, 30.6896, 273.3867),
            [2] = vector4(457.3632, -982.7820, 30.6896, 184.8602),
        },
        items = { -- Items in the crafting table.
            {
                title = "Armour 25",
                description = "50x Copper",
                progressbar = "Making armour 25",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189358208767250472/25armour.png?ex=659ddf26&is=658b6a26&hm=e9184d45d88fc272873504d4353f370f0b2e429b8ee27ec6625009a309d8bd29&",
                duration = 1000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "copper", amount = 50},
                },
                additems = { -- Items that will be given after craft is done
                    {name = "25armour", amount = 1},
                },
            },
            {
                title = "Heavysniper",
                description = "50x Steel, 50x Iron",
                progressbar = "Making Heavysniper",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189358403714297896/WEAPON_HEAVYSNIPER.png?ex=659ddf54&is=658b6a54&hm=efbe8aefbc5bae6b2f404ddc030bebb594a70e375a8bb66b52bf7eefb48e61d1&",
                duration = 5000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "steel", amount = 50},
                    {name = "iron", amount = 50},
                },
                additems = { -- Items that will be given after craft is done
                    {name = "WEAPON_HEAVYSNIPER", amount = 1},
                },
            },
            {
                title = "Extended Sniper Clip",
                description = "50x Steel",
                progressbar = "Making Extended Sniper Clip",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189358633268564028/at_clip_extended_sniper.png?ex=659ddf8b&is=658b6a8b&hm=b0eabc7464cc0c9eb514e4aac798dee5180de6e97276742b85ece910330e6e4f&",
                duration = 5000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "steel", amount = 50},
                },
                additems = { -- Items that will be given after craft is done
                    {name = "at_clip_extended_sniper", amount = 1},
                },
            },
        },
    },
    ["illegal"] = {
        jobs = nil, -- Required jobs to access table
        model = `gr_prop_gr_bench_04b`, -- Table model.
        label = 'Open illegal crafting',  -- Target label
        icon = "fas fa-gun",
        coords = { -- Table Coords
            [1] = vector4(-478.1669, -1708.2946, 18.6960, 85.0696),
        },
        items = { -- Items in the crafting table.
            {
                title = "Armour 75",
                description = "75x Copper",
                progressbar = "Making armour 75",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189358952408944770/75armour.png?ex=659ddfd7&is=658b6ad7&hm=a405c9326fb66f84931210529adf589028e3910c909ce701005259a3df08b302&",
                duration = 1000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "copper", amount = 75},
                },
                additems = { -- Items that will be given after craft is done
                    {name = "75armour", amount = 1},
                },
            },
            {
                title = "AP Pistol",
                description = "50x Steel, 50x Iron",
                progressbar = "Making AP Pistol",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189359244521254943/WEAPON_APPISTOL.png?ex=659de01d&is=658b6b1d&hm=b73881577f3d0b4e93aee141dfd7b943cb410fd8d2d758b108e6365621273ddf&",
                duration = 5000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "steel", amount = 50},
                    {name = "iron", amount = 50},
                },
                additems = { -- Items that will be given after craft is done
                    {name = "WEAPON_APPISTOL", amount = 1},
                },
            },
            {
                title = "Bomb",
                description = "50x Steel",
                progressbar = "Making Bomb",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189359394786377798/thermite_h.png?ex=659de040&is=658b6b40&hm=f37dcd4b5f9ae8bba5834fe138f953551d5752942b40ec052c399bfa25ca49ee&",
                duration = 5000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "steel", amount = 50},
                },
                additems = { -- Items that will be given after craft is done
                    {name = "thermite_h", amount = 1},
                },
            },
        },
    },
    ["burgershot"] = {
        jobs = {["burgershot"] = 0},, -- Required jobs to access table
        model = nil, -- Table model.
        label = 'Open burgershot crafting',  -- Target label
        icon = "fas fa-burger",
        coords = { -- Table Coords
            [1] = vector4(-1194.9108, -897.4638, 13.8862, 324.5184),
        },
        items = { -- Items in the crafting table.
            {
                title = "Bigmac",
                description = "1x Salat, 1x Meat, 1x Bund",
                progressbar = "Making Bigmac",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189359941039964231/bigmac.png?ex=659de0c3&is=658b6bc3&hm=2e38cc805e661c848eb374b109070b6d6038c4187a1c4056428b9139388a8e20&",
                duration = 1000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "salat", amount = 1},
                    {name = "meat", amount = 1},
                    {name = "bund", amount = 1},
                },
                additems = { -- Items that will be given after craft is done
                    {name = "bigmac", amount = 1},
                },
            },
            {
                title = "Big Bigmac",
                description = "4x Salat, 4x Meat, 2x Bund",
                progressbar = "Making Big Bigmac",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189360113794940938/food_hamburger_extralarge.png?ex=659de0ec&is=658b6bec&hm=d0af414295b0c106a554c9896501e67545a7bfcf63cb4582341498340132a63e&",
                duration = 1000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "salat", amount = 4},
                    {name = "meat", amount = 4},
                    {name = "bund", amount = 2},
                },
                additems = { -- Items that will be given after craft is done
                    {name = "food_hamburger_extralarge", amount = 1},
                },
            },
            {
                title = "Quarter Pounder",
                description = "1x Salat, 2x Meat, 1x Bund",
                progressbar = "Making Quarter Pounder",
                image = "https://cdn.discordapp.com/attachments/886558594408022028/1189360461221724210/dquarterpounder.png?ex=659de13f&is=658b6c3f&hm=ebe8df6f8cf128628d17f45f94576864fe1874652d80020a7a49128f5a56881e&",
                duration = 5000, -- duration to craft the item after action is complete.
                requireditems = { -- Items required to craft.
                    {name = "salat", amount = 1},
                    {name = "meat", amount = 2},
                    {name = "bund", amount = 1},
                },
                additems = { -- Items that will be given after craft is done
                    {name = "dquarterpounder", amount = 1},
                },
            },
        },
    },
}