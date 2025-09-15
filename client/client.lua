local spawnedObjects = {}

RegisterNetEvent('wn_crafting:setup')
AddEventHandler('wn_crafting:setup', function()
    for name, craftingData in pairs(Config.Craftings) do
        for _, coords in pairs(craftingData.coords) do
            if craftingData.model then
                local object = CreateObject(craftingData.model, coords.x, coords.y, coords.z - 1, true, false, false)
                SetEntityHeading(object, coords.w)
                table.insert(spawnedObjects, object)  -- Store reference to the spawned object

                if Config.Target == 'ox_target' then
                    exports.ox_target:addSphereZone({
                        coords = vector4(coords.x, coords.y, coords.z-1, coords.w),
                        radius = 1,
                        debug = Config.EnableDebug,
                        options = {
                            {
                                icon = craftingData.icon,
                                label = craftingData.label,
                                groups = craftingData.jobs,
                                event = 'wn_crafting:menu',
                                onSelect = function()
                                    TriggerEvent("wn_crafting:menu", name)
                                end,
                                distance = 1,
                            }
                        }
                    })
                elseif Config.Target == 'qb-target' then
                    exports['qb-target']:AddBoxZone('crafting' .. name, vector3(coords.x, coords.y, coords.z), 1.5, 1.6, {
                        name = 'crafting' .. name,
                        heading = coords.w,
                        debugPoly = Config.EnableDebug,
                            minZ = coords.z - 10,
                            maxZ = coords.z + 10,
                        }, {
                        options = {
                            {
                                num = 1,
                                icon = craftingData.icon,
                                label = craftingData.label,
                                targeticon = craftingData.icon,
                                item = craftingData.item,
                                action = function()
                                    TriggerEvent("wn_crafting:menu", name)
                                end,
                                job = craftingData.jobs,
                                gang = craftingData.gang,
                            }
                        },
                        distance = 2.5,
                    })
                end
            else
                if Config.Target == 'ox_target' then
                    exports.ox_target:addSphereZone({
                        coords = vector4(coords.x, coords.y, coords.z, coords.w),
                        radius = 1,
                        debug = Config.EnableDebug,
                        options = {
                            {
                                icon = craftingData.icon,
                                label = craftingData.label,
                                groups = craftingData.jobs,
                                event = 'wn_crafting:menu',
                                onSelect = function()
                                    TriggerEvent("wn_crafting:menu", name)
                                end,
                                distance = 1,
                            }
                        }
                    })
                elseif Config.Target == 'qb-target' then
                    exports['qb-target']:AddBoxZone('crafting' .. name, vector3(coords.x, coords.y, coords.z), 1.5, 1.6, {
                        name = 'crafting' .. name,
                        heading = coords.w,
                        debugPoly = Config.EnableDebug,
                            minZ = coords.z - 10,
                            maxZ = coords.z + 10,
                        }, {
                        options = {
                            {
                                num = 1,
                                icon = craftingData.icon,
                                label = craftingData.label,
                                targeticon = craftingData.icon,
                                item = craftingData.item,
                                action = function()
                                    TriggerEvent("wn_crafting:menu", name)
                                end,
                                job = craftingData.jobs,
                                gang = craftingData.gang,
                            }
                        },
                        distance = 2.5,
                    })
                end
            end
        end
    end
end)

RegisterNetEvent('wn_crafting:menu')
AddEventHandler('wn_crafting:menu', function(craftingType)

    local craftingData = Config.Craftings[craftingType]

    local Options = {}

    for _, craftingOption in ipairs(craftingData.items) do
        local option = {
            title = craftingOption.title,
            description = craftingOption.description,
            image = craftingOption.image,
            onSelect = function()
                TriggerServerEvent('wn_crafting:giveitems', craftingType, craftingOption)
            end,
        }

        table.insert(Options, option)
    end

    lib.registerContext({
        id = 'packmenu',
        title = "Crafting menu",
        options = Options,
    })
    lib.showContext('packmenu')
end)

lib.callback.register('wn_crafting:serverprogress', function(src, text, time)

    if lib.progressBar({
        duration = text,
        label = src,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer',
        }
    }) then
        return true
    else
        return false
    end

end)

function despawnAllObjects()
    for _, object in ipairs(spawnedObjects) do
        DeleteEntity(object)
    end
    spawnedObjects = {} 
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerEvent('wn_crafting:setup')
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        despawnAllObjects()
    end
end)

