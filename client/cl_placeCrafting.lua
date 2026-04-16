local spawnedCraftings = spawnedCraftings or {}
local placingCrafing = false

RegisterNetEvent("wn_crafting:spawnCrafting", function(index)
    local craftingIndex = index
    local model = Config.PlacebleCraftings[craftingIndex].model
    local objectModel = GetHashKey(model)

    placingCrafing = not placingCrafing

    lib.requestModel(objectModel, 1000)

    object = CreateObject(objectModel, GetEntityCoords(cache.ped), true, true, false)

    SetEntityAlpha(object, 150, false)
    SetEntityCollision(object, false, false)
    FreezeEntityPosition(object, true)

    lib.showTextUI('[E] - Place  \n [L/R Arrow] Rotate Object', {
        position = "right-center",
    })

    CreateThread(function()
        while inObjectPreview do
            local hit, _, coords, _, _ = lib.raycast.cam(1, 4)
            if hit then
                SetEntityCoords(object, coords.x, coords.y, coords.z)
                PlaceObjectOnGroundProperly(object)

                if IsControlPressed(0, 174) then
                    SetEntityHeading(object, GetEntityHeading(object) - 1.0)
                end

                if IsControlPressed(0, 175) then
                    SetEntityHeading(object, GetEntityHeading(object) + 1.0)
                end

                if IsControlJustPressed(0, 38) then
                    lib.hideTextUI()
                    local heading = GetEntityHeading(object)
                    TriggerServerEvent("wn_crafting:requestCraftingSpawn", craftingIndex, coords, heading)
                    placingCrafing = false
                end
            end

            Wait(0)
        end
    end)
end)

RegisterNetEvent("wn_crafitng:spawnCrafting", function(craftingIndex, id, coords, heading)
    local model = Config.PlacebleCraftings[craftingIndex].model
    local objectModel = GetHashKey(model)
    local craftingData = Config.PlacebleCraftings[craftingIndex]
    object = CreateObject(objectModel, coords.x, coords.y, coords.z, heading, true, true, false)

    local zoneName = ("crafting_%s_%s"):format(craftingIndex, id)
    AddSphereZone(zoneName, coords, 1, {
        {
            icon = craftingData.icon,
            label = craftingData.label,
            onSelect = function()
                TriggerEvent("wn_crafting:menuPlaceble", craftingIndex)
            end,
            distance = 1,
        },
        {
            icon = craftingData.icon,
            label = "Remove crafting",
            onSelect = function()
                TriggerEvent("wn_crafting:removeCrafting", id)
            end,
            distance = 1,
        },
    })

    spawnedCraftings[id] = {
        index = craftingIndex,
        coords = coords,
        heading = heading,
        object = object
    }
end)

RegisterNetEvent("wn_crafitng:deleteCrafting", function(id)
    local deleteObject = spawnedCraftings[id].object
    local craftingIndex = spawnedCraftings[id].index
    local deleteCrafting = ("crafting_%s_%s"):format(craftingIndex, id)
    DeleteObject(deleteObject)
    RemoveZone(deleteCrafting)

    spawnedCraftings[id] = nil
end)

RegisterNetEvent('wn_crafting:menuPlaceble', function(craftingType)
    local schematics = requestPlayerSchematics()
    local craftingData = Config.PlacebleCraftings[craftingType]

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
