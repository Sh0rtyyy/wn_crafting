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

-- Credits to V-Scripts for their v-raycast

function RotationToDirection(rotation)
    local radRotation = vector3(math.rad(rotation.x), math.rad(rotation.y), math.rad(rotation.z))
    return vector3(
        -math.sin(radRotation.z) * math.abs(math.cos(radRotation.x)),
        math.cos(radRotation.z) * math.abs(math.cos(radRotation.x)),
        math.sin(radRotation.x)
    )
end

function RayCastGamePlayCamera(distance)
    local camRot = GetGameplayCamRot()
    local camPos = GetGameplayCamCoord()
    local direction = RotationToDirection(camRot)
    local dest = camPos + (direction * distance)

    local rayHandle = StartShapeTestRay(camPos.x, camPos.y, camPos.z, dest.x, dest.y, dest.z, -1, playerId, 0)
    local _, hit, endCoords, _, entity = GetShapeTestResult(rayHandle)

    return hit, endCoords, entity
end

function DrawEntityBoundingBox(entity)
    if not DoesEntityExist(entity) then return end

    local model = GetEntityModel(entity)
    if not model or model == 0 then return end

    local min, max = GetModelDimensions(model)

    local frontBottomLeft  = GetOffsetFromEntityInWorldCoords(entity, min.x, min.y, min.z)
    local frontBottomRight = GetOffsetFromEntityInWorldCoords(entity, max.x, min.y, min.z)
    local backBottomLeft   = GetOffsetFromEntityInWorldCoords(entity, min.x, max.y, min.z)
    local backBottomRight  = GetOffsetFromEntityInWorldCoords(entity, max.x, max.y, min.z)

    local frontTopLeft  = GetOffsetFromEntityInWorldCoords(entity, min.x, min.y, max.z)
    local frontTopRight = GetOffsetFromEntityInWorldCoords(entity, max.x, min.y, max.z)
    local backTopLeft   = GetOffsetFromEntityInWorldCoords(entity, min.x, max.y, max.z)
    local backTopRight  = GetOffsetFromEntityInWorldCoords(entity, max.x, max.y, max.z)


    local function DrawEdge(p1, p2, r, g, b, a)
        DrawLine(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, r, g, b, a)
    end

    local edgeColor = boxcolor

    -- Bottom edges
    DrawEdge(frontBottomLeft, frontBottomRight, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)
    DrawEdge(frontBottomRight, backBottomRight, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)
    DrawEdge(backBottomRight, backBottomLeft, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)
    DrawEdge(backBottomLeft, frontBottomLeft, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)

    -- Top edges
    DrawEdge(frontTopLeft, frontTopRight, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)
    DrawEdge(frontTopRight, backTopRight, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)
    DrawEdge(backTopRight, backTopLeft, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)
    DrawEdge(backTopLeft, frontTopLeft, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)

    -- Vertical edges
    DrawEdge(frontBottomLeft, frontTopLeft, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)
    DrawEdge(frontBottomRight, frontTopRight, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)
    DrawEdge(backBottomLeft, backTopLeft, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)
    DrawEdge(backBottomRight, backTopRight, edgeColor.r, edgeColor.g, edgeColor.b, edgeColor.a)
end