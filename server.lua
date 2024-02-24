if Config.Framework:match('QBCore') then -- QBCore Framework
    QBCore = exports['qb-core']:GetCoreObject()
end

local isBlackout, blackoutInProgress = false, false

RegisterServerEvent('msk_blackout:notifyJobs')
AddEventHandler('msk_blackout:notifyJobs', function()
    if not Config.notifyJobs.enable then return end

    if Config.Framework:match('ESX') then
        local xPlayers = ESX.GetExtendedPlayers()

        for k, xPlayer in pairs(xPlayers) do
            if MSK.Table_Contains(Config.notifyJobs.jobs, xPlayer.job.name) then
                Config.Notification(xPlayer.source, Translation[Config.Locale]['job_notify_blackout_started'])
                TriggerClientEvent('msk_blackout:sendJobBlipNotify', xPlayer.source)
            end
        end
    elseif Config.Framework:match('QBCore') then
        local Players = QBCore.Functions.GetQBPlayers()

        for k, Player in pairs(Players) do
            if MSK.Table_Contains(Config.notifyJobs.jobs, Player.PlayerData.job.name) then
                Config.Notification(Player.PlayerData.source, Translation[Config.Locale]['job_notify_blackout_started'])
                TriggerClientEvent('msk_blackout:sendJobBlipNotify', Player.PlayerData.source)
            end
        end
    end
end)

RegisterServerEvent('msk_blackout:syncBlackout')
AddEventHandler('msk_blackout:syncBlackout', function(state)
    logging('debug', 'syncBlackout', state)
    if Config.useWeatherScript then
        Config.weatherScript(state)
    end
    TriggerClientEvent('msk_blackout:setBlackout', -1, state)

    if state then -- If Blackout is enabled
        TriggerEvent('msk_blackout:powerOff')

        blackoutInProgress = true
        local blackoutTimeout = MSK.AddTimeout(Config.Timeout * 60000, function()
			blackoutInProgress = false
		end)
    elseif not state then -- If Blackout is disabled
        TriggerEvent('msk_blackout:powerOn')
    end

    if not Config.useDoorlock then return end
    if not Config.DoorlockScript then return end
    if not (GetResourceState(Config.DoorlockScript) == "started") then
        return logging('error', ('Doorlock Script ^3%s^0 not found'):format(Config.DoorlockScript))
    end

    if state then -- If Blackout is enabled
        if Config.DoorlockScript:match('doors_creator') then
            local doors = exports["doors_creator"]:getAllDoors()
            for k, doorData in pairs(doors) do
                exports["doors_creator"]:setDoorState(doorData.id, 0)
            end
        elseif Config.DoorlockScript:match('ox_doorlock') then
            MySQL.query('SELECT id FROM ox_doorlock', {}, function(result)
                if result then
                    for i = 1, #result do
                        local door = exports.ox_doorlock:getDoor(result[i].id)
                        TriggerEvent('ox_doorlock:setState', door.id, 0)
                    end
                end
            end)
        else
            logging('error', ('Unsupported doorlock script: ^3%s^0'):format(Config.DoorlockScript))
        end
    elseif not state then -- If Blackout is disabled
        if Config.DoorlockScript:match('doors_creator') then
            local doors = exports["doors_creator"]:getAllDoors()
            for k, doorData in pairs(doors) do
                exports["doors_creator"]:setDoorState(doorData.id, 1)
            end
        elseif Config.DoorlockScript:match('ox_doorlock') then
            MySQL.query('SELECT id FROM ox_doorlock', {}, function(result)
                if result then
                    for i = 1, #result do
                        local door = exports.ox_doorlock:getDoor(result[i].id)
                        TriggerEvent('ox_doorlock:setState', door.id, 1)
                    end
                end
            end)
        else
            logging('error', ('Unsupported doorlock script: ^3%s^0'):format(Config.DoorlockScript))
        end
    end
end)

RegisterServerEvent('msk_blackout:removeItem')
AddEventHandler('msk_blackout:removeItem', function(item)
    if not Config.removeItem then return end
    local src = source

    if Config.Framework:match('ESX') then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem(item, 1)
    elseif Config.Framework:match('QBCore') then
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.RemoveItem(item, 1)
    end
end)

MSK.Register('msk_blackout:getCops', function(source)
    local OnlineCops = 0

    if Config.Framework:match('ESX') then
        local xPlayers = ESX.GetExtendedPlayers()

        for k, xPlayer in pairs(xPlayers) do
            if MSK.Table_Contains(Config.Cops.jobs, xPlayer.job.name) then
                OnlineCops = OnlineCops + 1
            end
        end
    elseif Config.Framework:match('QBCore') then
        local Players = QBCore.Functions.GetQBPlayers()

        for k, Player in pairs(Players) do
            if MSK.Table_Contains(Config.Cops.jobs, Player.PlayerData.job.name) then
                OnlineCops = OnlineCops + 1
            end
        end
    end

    return OnlineCops
end)

MSK.Register('msk_blackout:isBlackoutInProgress', function(source)
    return blackoutInProgress
end)

if Config.Command.enable then
    MSK.RegisterCommand(Config.Command.command, Config.Command.groups, function(source, args, raw)
        if isBlackout then 
            TriggerEvent('msk_blackout:syncBlackout', false)
            isBlackout = false
        else
            TriggerEvent('msk_blackout:syncBlackout', true)
            isBlackout = true
        end
    end, true, false, {help = 'Toggle Blackout'})
end

AddEventHandler('msk_blackout:powerOn', function() isBlackout = false logging('debug', 'Toggled Blackout off') end)
AddEventHandler('msk_blackout:powerOff', function() isBlackout = true logging('debug', 'Toggled Blackout on') end)

logging = function(code, ...)
    if not Config.Debug then return end
    MSK.logging(code, ...)
end

GithubUpdater = function()
    GetCurrentVersion = function()
	    return GetResourceMetadata( GetCurrentResourceName(), "version" )
    end
    
    local CurrentVersion = GetCurrentVersion()
    local resourceName = "[^2"..GetCurrentResourceName().."^0]"

    if Config.VersionChecker then
        PerformHttpRequest('https://raw.githubusercontent.com/MSK-Scripts/msk_blackout/main/VERSION', function(Error, NewestVersion, Header)
            print("###############################")
            if CurrentVersion == NewestVersion then
                print(resourceName .. '^2 ✓ Resource is Up to Date^0 - ^5Current Version: ^2' .. CurrentVersion .. '^0')
            elseif CurrentVersion ~= NewestVersion then
                print(resourceName .. '^1 ✗ Resource Outdated. Please Update!^0 - ^5Current Version: ^1' .. CurrentVersion .. '^0')
                print('^5Newest Version: ^2' .. NewestVersion .. '^0 - ^6Download here:^9 https://github.com/MSK-Scripts/msk_blackout/releases/tag/v'.. NewestVersion .. '^0')
            end
            print("###############################")
        end)
    else
        print("###############################")
        print(resourceName .. '^2 ✓ Resource loaded^0')
        print("###############################")
    end
end
GithubUpdater()