local webhook = ""

RegisterNetEvent('wn_crafting:giveitems')
AddEventHandler('wn_crafting:giveitems', function(craftingType, craftingOption)
    local src = source
    local hasRequiredItems = true  -- Reset flag for each crafting option
    local addedItems = {} -- Initialize the addedItems table for each event trigger
    local text = craftingOption.progressbar
    local time = craftingOption.duration

    -- Check if player has required items for the current crafting option
    for _, requiredItem in ipairs(craftingOption.requireditems) do
        local needitem = requiredItem.name
        local needitemcount = requiredItem.amount

        local inventoryItem = GetItem(needitem, needitemcount, src)
        if not inventoryItem then
            hasRequiredItems = false
            break  -- No need to check further, we've already found an issue
        end
    end

    -- Process crafting based on flag for the current crafting option
    if hasRequiredItems then
        local result = lib.callback.await('wn_crafting:serverprogress', src, text, time)
        if not result then return end
        -- Process crafting if all required items are present for the current option
        for _, requiredItem in ipairs(craftingOption.requireditems) do
            local needitem = requiredItem.name
            local needitemcount = requiredItem.amount

            if Config.EnableDebug then 
                print(needitem)
                print(needitemcount)
            end

            RemoveItem(needitem, needitemcount, src)
        end

        for _, itemname in ipairs(craftingOption.additems) do
            local additem = itemname.GetNamedRendertargetRenderId
            local additemcount = itemname.amount

            if Config.EnableDebug then
                print(additem)
                print(additemcount)
            end

            DiscordLog(webhook, "Crafting", GetPlayerName(source) .. " have crafted " .. additemcount .. "x " .. additem .. " at " .. craftingType)
            if not addedItems[additem] then

                AddItem(additem, additemcount, src)
                addedItems[additem] = true
            end
        end
    else 
        lib.notify(src,{
            title = "Crafting",
            description = "You dont have required items",
            type = 'error'
        })
    end

end)

function DiscordLog(webhook,name,message,color)
    local embeds = {
        {
            ["title"] = name,
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = 56108,
            ["footer"] = {
                ["text"] = "wn_crafting " .. os.date('%H:%M - %d. %m. %Y', os.time()),
            },
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds }), { ['Content-Type'] = 'application/json' })
end