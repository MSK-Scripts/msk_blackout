Config = {}
----------------------------------------------------------------
Config.Locale = 'de'
Config.VersionChecker = true
Config.Debug = true
----------------------------------------------------------------
-- !!! This function is clientside AND serverside !!!
Config.Notification = function(source, message)
    if IsDuplicityVersion() then -- serverside
        MSK.Notification(source, 'MSK Blackout', message)
    else -- clientside
        MSK.Notification('MSK Blackout', message)
    end
end
----------------------------------------------------------------
Config.Framework = 'ESX' -- 'ESX' or 'QBCore' // Remove es_extended from fxmanifest.lua if you are using QBCore
Config.Hotkey = 38 -- deafult: 38 = E

Config.Timeout = 10 -- in minutes // Timeout before the next blackout can be started
----------------------------------------------------------------
Config.useDoorlock = true -- Set to true if you want to unlock all Doors while blackout
Config.DoorlockScript = 'doors_creator' -- 'doors_creator' or 'ox_doorlock'
----------------------------------------------------------------
Config.Command = {
    enable = true, -- Set to false if you don't want to use the Commands
    groups = {'superadmin', 'admin'}, 
    command = 'toggleblackout' -- Toggles blackout on or off
}
----------------------------------------------------------------
Config.removeItem = true -- Remove the Item after use

Config.Items = { -- Add those items to your database or inventory or insert your own items
    ['startDoor'] = 'lockpick',
    ['hackLaptop'] = 'usb_stick',
    ['trafos'] = 'boltcutter'
}
----------------------------------------------------------------
Config.Blackout = {
    generalLights = true, -- Set to true turns off all artificial light sources in the map
    vehicleLights = false, -- Set to false ignores Vehicles
    duration = 10 -- in minutes // Blackout Time
}

Config.useWeatherScript = true -- Set false the Blackout does not work and add your Event below
Config.weatherScript = function(state) -- This is a Server Event
    -- qb-weathersync
    -- exports["qb-weathersync"]:setBlackout(state)

    -- cd_easytime
    local weather = exports['cd_easytime']:GetWeather()
    weather.blackout = state
    TriggerEvent('cd_easytime:ForceUpdate', weather)
end
----------------------------------------------------------------
Config.Cops = {
    enable = false,
    jobs = {'police', 'fib', 'sheriff'},
    amount = 2, -- Minimum amount of Online Players with Police Job
    blip = {enable = true, color = 1},
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
    },
    settings = {
        {coords = vec3(2831.52, 1496.69, 24.73), distance = 10.0, blip = {enable = true, label = 'Sabotage', id = 270, color = 1, scale = 0.5}, marker = {enable = true, type = 0, size = {a = 1.0, b = 1.0, c = 1.0}, color = {a = 255, b = 0, c = 0}}},
        {coords = vec3(2833.65, 1512.28, 24.73), distance = 10.0, blip = {enable = true, label = 'Sabotage', id = 270, color = 1, scale = 0.5}, marker = {enable = true, type = 0, size = {a = 1.0, b = 1.0, c = 1.0}, color = {a = 255, b = 0, c = 0}}},
        {coords = vec3(2839.99, 1548.33, 24.73), distance = 10.0, blip = {enable = true, label = 'Sabotage', id = 270, color = 1, scale = 0.5}, marker = {enable = true, type = 0, size = {a = 1.0, b = 1.0, c = 1.0}, color = {a = 255, b = 0, c = 0}}},
        {coords = vec3(2847.47, 1540.28, 24.73), distance = 10.0, blip = {enable = true, label = 'Sabotage', id = 270, color = 1, scale = 0.5}, marker = {enable = true, type = 0, size = {a = 1.0, b = 1.0, c = 1.0}, color = {a = 255, b = 0, c = 0}}},
    }
}