local PlayerData = {}
local PlayerSchematics = {}
local PlayerJob

if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
        PlayerJob = PlayerData.job
        Wait(2000)
        local schematics = lib.callback.register('wn_crafting:requestChematicsData')
        PlayerSchematics = schematics
    end)

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        PlayerData.job = job
        PlayerJob = job
        Wait(500)
    end)

elseif Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()

    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        PlayerData = QBCore.Functions.GetPlayerData()
    end)

    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
        PlayerData.job = JobInfo
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        PlayerData = {}
    end)

elseif Config.Framework == "qbox" then
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        PlayerData = QBCore.Functions.GetPlayerData()
    end)

    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
        PlayerData.job = JobInfo
    end)

end

function requestPlayerSchematics()
    return PlayerSchematics
end

function hasPlayerRequiredSchematic(schematic)
    for _, v in ipairs(PlayerSchematics) do
        if v == schematic then
            return true
        end
    end
    return false
end

local targetZones = {}

if Config.Target == "ox" then
    function AddSphereZone(name, coords, radius, options, debug)
        local target = exports.ox_target:addSphereZone({
            coords = coords,
            radius = radius,
            name = name,
            debug = targetDebug or debug,
            options = options
        })
        table.insert(targetZones, { name = name, id = target, creator = GetInvokingResource() })
        return target
    end

    function RemoveZone(name)
        if not name then return end
        for _, data in pairs(targetZones) do
            if data.name == name then
                exports.ox_target:removeZone(data.id)
                table.remove(targetZones, _)
                break
            end
        end
    end

    function AddNetworkedEntity(netids, options)
        exports.ox_target:addEntity(netids, options)
    end

    AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
        for _, target in pairs(targetZones) do
            if target.creator == resource then
                exports.ox_target:removeZone(target.id)
            end
        end
        targetZones = {}
    end)
else
    function AddSphereZone(name, coords, radius, options, debug)
        local target = exports.qb_target:AddCircleZone(name, coords, radius, {
            name = name,
            debugPoly = targetDebug or debug,
        }, {
            options = options,
            distance = options.distance or 1.5,
        })
        table.insert(targetZones, { name = name, creator = GetInvokingResource() })
        return target
    end

    function RemoveZone(name)
        if not name then return end
        for _, data in pairs(targetZones) do
            if data.name == name then
                exports.qb_target:RemoveZone(name)
                table.remove(targetZones, _)
                break
            end
        end
    end

    AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
        for _, target in pairs(targetZones) do
            if target.creator == resource then
                exports.qb_target:RemoveZone(target.name)
            end
        end
        targetZones = {}
    end)
end