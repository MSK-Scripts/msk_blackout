Config = {}
----------------------------------------------------------------
Config.Locale = 'de'
Config.VersionChecker = true
Config.Debug = true
----------------------------------------------------------------
-- !!! This function is clientside AND serverside !!!
Config.Notification = function(source, message)
    if IsDuplicityVersion() then -- serverside
        MSK.Notification(source, message)
    else -- clientside
        MSK.Notification(message)
    end
end
----------------------------------------------------------------
Config.Framework = 'ESX' -- 'ESX' or 'QBCore'
Config.Hotkey = 38 -- deafult: 38 = E
----------------------------------------------------------------
Config.useDoorsCreator = false -- Set to true if you use Jaksams Doors Creator and want to unlock all Doors while blackout
----------------------------------------------------------------
Config.Blackout = {
    generalLights = true, -- Set to true turns off all artificial light sources in the map
    vehicleLights = true, -- Set to false ignores Vehicles

    duration = 1 -- in minutes // Blackout Time
}

Config.useWeatherScript = true -- Set false the Blackout does not work and add your Event below
Config.weatherScript = function(state)
    -- This is a Server Event

    TriggerClientEvent('vSync:updateWeather', -1, 'CLEAR', state) -- vSync
    --exports["qb-weathersync"]:setBlackout(state) -- qb-weathersync
end
----------------------------------------------------------------
Config.Cops = {
    enable = true,
    jobs = {'police', 'fib', 'sheriff'},
    amount = 2 -- Minimum amount of Online Players with Police Job
}

Config.blacklistedJobs = {
    enable = true, -- Set false if you don't want to blacklist any job
    jobs = {'police', 'fib', 'sheriff'}
}

Config.notifyJobs = {
    enable = true, -- Set false if you don't want to notify specific jobs when Skillcheck was successfull
    jobs = {'police', 'fib', 'sheriff'}
}
----------------------------------------------------------------
Config.startPoint = {
    distance = 10.0,
    coords = vec3(2854.65, 1502.01, 24.72),
    blip = {enable = true, label = 'Kraftwerk', id = 354, color = 5, scale = 0.8},
    draw3dtext = {enable = true, label = '~g~Start Blackout', size = 0.8}, 
    marker = {enable = true, type = 27, size = {a = 1.0, b = 1.0, c = 1.0}, color = {a = 255, b = 255, c = 255}}
}

Config.Coords = {
    ['startBlackout'] = vec4(1087.81, -3099.43, -39.0, 259.88),
    ['hackLaptop'] = vec3(1088.41, -3101.21, -39.0)
}
----------------------------------------------------------------
Config.Skillbar = 'oxlib' -- 'oxlib' or 'qbcore'

Config.SkillCheck = {
    difficulty = { -- Only if Config.Skillbar = 'oxlib'
        ['1'] = 'easy', -- 'easy', 'medium', 'hard'
        ['2'] = 'easy', -- 'easy', 'medium', 'hard'
        ['3'] = 'easy' -- 'easy', 'medium', 'hard'
    },
    inputs = {'w', 'a', 's', 'd'}, -- Only if Config.Skillbar = 'oxlib'

    animation = {
        enable = true, -- Set false to disable animation while SkillCheck
        dict = 'mp_arresting',
        anim = 'a_uncuff'
    }
}
----------------------------------------------------------------
Config.SabotageTrafo = {
    animation = {
        enable = true, -- Set false to disable animation while sabotage trafostation
        dict = 'mp_arresting',
        anim = 'a_uncuff',
        duration = 10 -- in seconds // How long the sabotage will take
    },
    settings = {
        {coords = vec3(2831.52, 1496.69, 24.73), distance = 10.0, blip = {enable = true, label = 'Sabotage', id = 270, color = 1, scale = 0.5}, marker = {enable = true, type = 0, size = {a = 1.0, b = 1.0, c = 1.0}, color = {a = 255, b = 0, c = 0}}},
        {coords = vec3(2833.65, 1512.28, 24.73), distance = 10.0, blip = {enable = true, label = 'Sabotage', id = 270, color = 1, scale = 0.5}, marker = {enable = true, type = 0, size = {a = 1.0, b = 1.0, c = 1.0}, color = {a = 255, b = 0, c = 0}}},
        {coords = vec3(2839.99, 1548.33, 24.73), distance = 10.0, blip = {enable = true, label = 'Sabotage', id = 270, color = 1, scale = 0.5}, marker = {enable = true, type = 0, size = {a = 1.0, b = 1.0, c = 1.0}, color = {a = 255, b = 0, c = 0}}},
        {coords = vec3(2847.47, 1540.28, 24.73), distance = 10.0, blip = {enable = true, label = 'Sabotage', id = 270, color = 1, scale = 0.5}, marker = {enable = true, type = 0, size = {a = 1.0, b = 1.0, c = 1.0}, color = {a = 255, b = 0, c = 0}}},
    }
}