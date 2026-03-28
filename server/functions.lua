for schematic, _ in pairs(Config.Schematics) do
    UseItem(schematic)
end

if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

function GetItem(name, count, source)
    local src = source 

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getInventoryItem(name).count >= count then
            return true
        else
            return false
        end
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if xPlayer.Functions.GetItemByName(name) ~= nil then
            if xPlayer.Functions.GetItemByName(name).amount >= count then
                return true
            else
                return false
            end
        else
            return false
        end
    elseif Config.Framework == "qbcore-new" then
        local hasItem = exports['qb-inventory']:HasItem(src, name, count)
        if hasItem then
            return true
        else
            return false
        end
    end
end

function AddItem(name, count, source)
    local src = source
    print(src)

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addInventoryItem(name, count)
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        xPlayer.Functions.AddItem(name, count, nil, nil)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[name], "add", count)
    elseif Config.Framework == "qbcore-new" then
        exports['qb-inventory']:AddItem(src, name, count, false, false, 'wn_crafting:additem')
    end
end

function RemoveItem(name, count, source)
    local src = source 

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem(name, count)
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        xPlayer.Functions.RemoveItem(name, count, nil, nil)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[name], "remove", count)
    elseif Config.Framework == "qbcore-new" then
        exports['qb-inventory']:RemoveItem(src, name, count, false, 'wn_upnatom:removeitem')
    end
end

function UseItem(name)
    if Config.Framework == "ESX" then
        ESX.RegisterUsableItem(name, function(src, item)
            local xPlayer = ESX.GetPlayerFromId(src)
            UnlockSchematic(src, name)
        end)

    elseif Config.Framework == "QB" then
        QBCore.Functions.CreateUseableItem(name, function(src, item)
            UnlockSchematic(src, name)
        end)

    elseif Config.Framework == "OX" then
        exports.qbx_core:RegisterUsableItem(name, function(src, item)
            UnlockSchematic(src, name)
        end)
    end
end

function GetIdentifier(source)
    local src = source

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        return xPlayer.getIdentifier(src)
    elseif Config.Framework == "qbcore" then
        local xPlayer = QBCore.Functions.GetIdentifier(src)
        return xPlayer.PlayerData.citizenid
    elseif Config.Framework == "qbox" then
        local xPlayer = exports.qbx_core:GetPlayer(src)
        return xPlayer.PlayerData.citizenid
    end
end

function RequestSchematicsFromDatabase(source)
    local src = source
    local identf = GetIdentifier(src)

    local result = MySQL.single.await(
        'SELECT schematics FROM users WHERE identifier = ?',
        { identf }
    )

    if result and result.schematics then
        return json.decode(result.schematics)
    end

    return {}
end


--- DATABAZA: ALTER TABLE users ADD COLUMN schematics JSON;
--- STRUCTURE: ["armour25", "gunparts"]

function UnlockSchematic(source, schematic)
    local identifier = GetIdentifier(src) -- you need to define this based on framework

    -- Add to player table (runtime)
    PlayerSchematics = PlayerSchematics or {}
    table.insert(PlayerSchematics, schematic)

    -- Save to database (example with JSON column)
    MySQL.update('UPDATE users SET schematics = JSON_ARRAY_APPEND(schematics, "$", ?) WHERE identifier = ?', {
        schematic,
        identifier
    })

    -- Optional: notify player
    TriggerClientEvent('ox_lib:notify', src, {
        title = "Schematic learned",
        description = Config.Schematics[schematic] or schematic,
        type = "success"
    })
end