local spawnedCraftings = spawnedCraftings or {}

for index, data in pairs(Config.PlacebleCraftings) do
    local requiredItem = data.itemName
    print(requiredItem)
    RegisterUsable(requiredItem, function(source)
        local src = source
        if not GetItem(requiredItem, 1, src) then return end
        TriggerClientEvent("wn_crafting:placeCrafting", src, index)
    end)
end

RegisterNetEvent("wn_crafting:requestCraftingSpawn", function(craftingIndex, coords, heading)
    local src = source
    print("coords", coords)
    if not CheckDistance(src, coords) then
        print("Hačker")
        return
    end

    print("Spawning ", craftingIndex)
    print("heading", heading)

    local requiredItem = Config.PlacebleCraftings[craftingIndex].itemName
    RemoveItem(requiredItem, 1, src)

    local id = #spawnedCraftings + 1

    spawnedCraftings[id] = {
        index = craftingIndex,
        coords = coords,
        heading = heading
    }

    TriggerClientEvent("wn_crafting:spawnCrafting", -1, craftingIndex, id, coords, heading)
end)

RegisterNetEvent("wn_crafting:removeCrafting", function(id)
    print("id", id)
    local src = source
    if not spawnedCraftings[id] then
        print("Hačker")
        return
    end

    local craftingCoords = spawnedCraftings[id].coords
    print("spawnedCraftings[id].craftingIndex", spawnedCraftings[id].index)
    local craftingData = Config.PlacebleCraftings[spawnedCraftings[id].index]
    local giveItem = craftingData.itemName
    print("giveItem", giveItem)
    if not CheckDistance(src, craftingCoords) then
        print("Hačker")
        return
    end

    AddItem(giveItem, 1, src)
    spawnedCraftings[id] = nil

    TriggerClientEvent("wn_crafting:deleteCrafting", -1, id)
end)
