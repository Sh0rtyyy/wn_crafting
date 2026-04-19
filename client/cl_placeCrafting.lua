local spawnedCraftings = spawnedCraftings or {}
local placingCrafing = false

RegisterNetEvent("wn_crafting:placeCrafting", function(index)
    local craftingIndex = index
    local objectModel = Config.PlacebleCraftings[craftingIndex].model

    placingCrafing = not placingCrafing

    print("objectModel", objectModel)
    lib.requestModel(objectModel, 1000)

    object = CreateObject(objectModel, GetEntityCoords(cache.ped), true, true, false)

    SetEntityAlpha(object, 150, false)
    SetEntityCollision(object, false, false)
    FreezeEntityPosition(object, true)

    lib.showTextUI('[E] - Place  \n [L/R Arrow] Rotate Object', {
        position = "right-center",
    })

    CreateThread(function()
        while placingCrafing do
            local hit, coords, entity = RayCastGamePlayCamera(100)
            --local hit, _, coords, _, _ = lib.raycast.cam(1, 4)
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
                    print("heading", heading)
                    Wait(200)
                    DeleteObject(object)
                    print("heading2", heading)
                    TriggerServerEvent("wn_crafting:requestCraftingSpawn", craftingIndex, coords, heading)
                    placingCrafing = false
                end
            end

            Wait(0)
        end
    end)
end)

RegisterNetEvent("wn_crafting:spawnCrafting", function(craftingIndex, id, coords, heading)
    print("spawnCrafting", craftingIndex)
    print("spawn heading", heading)
    local objectModel = Config.PlacebleCraftings[craftingIndex].model
    local craftingData = Config.PlacebleCraftings[craftingIndex]
    object = CreateObject(objectModel, coords.x, coords.y, coords.z, heading, true, true, false)
    SetEntityHeading(object, heading)
    local zoneCoords = vector4(coords.x, coords.y, coords.z + 0.5, heading)
    local zoneName = ("crafting_%s_%s"):format(craftingIndex, id)
    AddSphereZone(zoneName, zoneCoords, 1, {
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
                print("id", id)
                TriggerServerEvent("wn_crafting:removeCrafting", id)
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

RegisterNetEvent("wn_crafting:deleteCrafting", function(id)
    print("Remove ID", index)
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
        local disable = false
        if reqSchematic ~= nil then
            disable = not hasPlayerRequiredSchematic(reqSchematic)
            print("disabled", disable)
        end
            local option = {
            title = co.title,
            description = co.description,
            disabled = disabled,
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
