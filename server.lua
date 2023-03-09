AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() ~= 'msk_blackout' then
        print('^1Please rename the Script to^3 msk_blackout^0!')
        print('^1Server will be shutdown^0!')
        os.exit()
    end
end)

if Config.Framework:match('ESX') then -- ESX Framework
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework:match('QBCore') then -- QBCore Framework
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterServerEvent('msk_blackout:notifyJobs')
AddEventHandler('msk_blackout:notifyJobs', function()
    if not Config.notifyJobs.enable then return end

    if Config.Framework:match('ESX') then
        local xPlayers = ESX.GetPlayers()

        for i = 1, #xPlayers do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

            if MSK.Table_Contains(Config.notifyJobs.jobs, xPlayer.job.name) then
                Config.Notification(xPlayer.source, Translation[Config.Locale]['job_notify_blackout_started'])
            end
        end
    elseif Config.Framework:match('QBCore') then
        local Players = QBCore.Functions.GetQBPlayers()

        for i = 1, #Players do
            local Player = QBCore.Functions.GetPlayer(Players[i])

            if MSK.Table_Contains(Config.notifyJobs.jobs, Player.PlayerData.job.name) then
                Config.Notification(Player.PlayerData.source, Translation[Config.Locale]['job_notify_blackout_started'])
            end
        end
    end
end)

RegisterServerEvent('msk_blackout:syncBlackout')
AddEventHandler('msk_blackout:syncBlackout', function(state)
    if Config.useWeatherScript then
        Config.weatherScript(state)
    end
    TriggerClientEvent('msk_blackout:setBlackout', -1, state)

    if Config.useDoorsCreator and state then
        local doors = exports["doors_creator"]:getAllDoors()
        for k, doorData in pairs(doors) do
            exports["doors_creator"]:setDoorState(doorData.id, 0)
        end
    elseif Config.useDoorsCreator and not state then
        local doors = exports["doors_creator"]:getAllDoors()
        for k, doorData in pairs(doors) do
            exports["doors_creator"]:setDoorState(doorData.id, 1)
        end
    end
end)

MSK.RegisterCallback('msk_blackout:getCops', function(source, cb)
    local OnlineCops = 0

    if Config.Framework:match('ESX') then
        local xPlayers = ESX.GetPlayers()

        for i = 1, #xPlayers do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

            if MSK.Table_Contains(Config.Cops.jobs, xPlayer.job.name) then
                OnlineCops = OnlineCops + 1
            end
        end
    elseif Config.Framework:match('QBCore') then
        local Players = QBCore.Functions.GetQBPlayers()

        for i = 1, #Players do
            local Player = QBCore.Functions.GetPlayer(Players[i])

            if MSK.Table_Contains(Config.Cops.jobs, Player.PlayerData.job.name) then
                OnlineCops = OnlineCops + 1
            end
        end
    end

    cb(OnlineCops)
end)

logging = function(code, ...)
    if Config.Debug then
        local script = "[^2"..GetCurrentResourceName().."^0]"
        MSK.logging(script, code, ...)
    end
end

GithubUpdater = function()
    GetCurrentVersion = function()
	    return GetResourceMetadata( GetCurrentResourceName(), "version" )
    end
    
    local CurrentVersion = GetCurrentVersion()
    local resourceName = "^4["..GetCurrentResourceName().."]^0"

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