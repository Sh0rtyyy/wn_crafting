local spawnedCraftings = spawnedCraftings or {}

for index, data in pairs(Config.PlacebleCraftings) do
    local requiredItem = data.itemName
    RegisterUsable(requiredItem, function(source)
        local src = source
        if not GetItem(requiredItem, 1, src) then return end
        RemoveItem(requiredItem, 1, src)
        TriggerClientEvent("wn_crafting:spawnCrafting", src, index)
    end)
end

RegisterNetEvent("wn_crafting:requestCraftingSpawn", function(craftingIndex, coords)
    local src = source
    if not CheckDistance(src, coords) then
        print("Hačker")
        return
    end

    local id = #spawnedCraftings + 1

    spawnedCraftings[id] = {
        index = craftingIndex,
        coords = coords,
        heading = heading
    }

    TriggerClientEvent("wn_crafting:spawnCrafting", -1, craftingIndex, id, coords, heading)
end)

RegisterNetEvent("wn_crafting:removeCrafting", function(id)
    local src = source
    if not spawnedCraftings[id] then
        print("Hačker")
        return
    end

    local craftingCoords = spawnedCraftings[id].coords
    local giveItem = spawnedCraftings[id].craftingIndex
    if not CheckDistance(src, craftingCoords) then
        print("Hačker")
        return
    end

    AddItem(giveItem, 1, src)
    spawnedCraftings[id] = nil

    TriggerClientEvent("wn_crafting:deleteCrafting", -1, id)
end)
