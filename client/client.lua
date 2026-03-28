local spawnedObjects = {}

RegisterNetEvent('wn_crafting:setup')
AddEventHandler('wn_crafting:setup', function()
    for name, craftingData in pairs(Config.Craftings) do
        for _, coords in pairs(craftingData.coords) do
            if craftingData.model then
                local object = CreateObject(craftingData.model, coords.x, coords.y, coords.z - 1, true, false, false)
                SetEntityHeading(object, coords.w)
                table.insert(spawnedObjects, object)  -- Store reference to the spawned object

                AddSphereZone(name, coords, 1, {
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
                })
            else
                AddSphereZone(name, coords, 1, {
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
                })
            end
        end
    end
end)

RegisterNetEvent('wn_crafting:menu')
AddEventHandler('wn_crafting:menu', function(craftingType)
    local schematics = requestPlayerSchematics()
    local craftingData = Config.Craftings[craftingType]

    local Options = {}

    for _, craftingOption in ipairs(craftingData.items) do
        local co = craftingOption
        local reqSchematic = co.requiredSchematics
        local disabled = false
        if reqSchematic ~= nil then 
            disabled = not hasPlayerRequiredSchematic(reqSchematic)
        end
            local option = {
            title = co.title,
            description = co.description,
            disable = disabled,
            image = co.image,
            onSelect = function()
                TriggerServerEvent('wn_crafting:giveitems', craftingType, co)
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

