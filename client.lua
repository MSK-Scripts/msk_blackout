if Config.Framework:match('ESX') then -- ESX Framework
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework:match('QBCore') then -- QBCore Framework
    QBCore = exports['qb-core']:GetCoreObject()
end

local startedBlackout, startBlackoutTeleport, hackedLaptop = false, false, false
local showHackLaptopHelp, teleportedOutOfBuilding, startedSabotage = false, false, false
local setBlackout = false
local Blips, SabotageLocations = {}, {}

CreateThread(function()
	local blip = Config.startPoint.blip
	local coords = Config.startPoint.coords

    if blip.enable then
        local xBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        
        SetBlipSprite(xBlip, blip.id)
        SetBlipScale(xBlip, blip.scale)
        SetBlipDisplay(xBlip, 4)
        SetBlipColour(xBlip, blip.color)
        SetBlipAsShortRange(xBlip, true)
        BeginTextCommandSetBlipName('STRING') 
        AddTextComponentString(blip.label)
        EndTextCommandSetBlipName(xBlip)
    end
end)

CreateThread(function()
	while true do
		local sleep = 500
		local playerPed = PlayerPedId()
		local dist = #(GetEntityCoords(playerPed) - Config.startPoint.coords)
		local playerJob
		
		if Config.blacklistedJobs.enable then
			if Config.Framework:match('ESX') then -- ESX Framework
				playerJob = ESX.GetPlayerData().job.name
			elseif Config.Framework:match('QBCore') then -- QBCore Framework
				playerJob = QBCore.Functions.GetPlayerData().job.name
			end
		end

		if dist <= Config.startPoint.distance and not IsPlayerDead(PlayerId()) and not startedBlackout then
			sleep = 0

			if Config.startPoint.marker.enable then
				DrawMarker(Config.startPoint.marker.type, Config.startPoint.coords.x, Config.startPoint.coords.y, Config.startPoint.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.startPoint.marker.size.a, Config.startPoint.marker.size.b, Config.startPoint.marker.size.c, Config.startPoint.marker.color.a, Config.startPoint.marker.color.b, Config.startPoint.marker.color.c, 100, false, true, 0, false)
			end

			if Config.startPoint.draw3dtext.enable then
				MSK.Draw3DText(Config.startPoint.coords, Config.startPoint.draw3dtext.label, Config.startPoint.draw3dtext.size)
			end

			if dist <= 2.5 and not IsPlayerDead(PlayerId()) and not startedBlackout then
				MSK.HelpNotification(Translation[Config.Locale]['open_blackout'])

				if IsControlJustPressed(0, Config.Hotkey) and (not Config.blacklistedJobs.enable or not MSK.Table_Contains(Config.blacklistedJobs.jobs, playerJob)) then
					local OnlineCops = 0

					if Config.Cops.enable then
						OnlineCops = MSK.TriggerCallback('msk_blackout:getCops')
					end

					if not Config.Cops.enable or (Config.Cops.enable and OnlineCops >= Config.Cops.amount) then
						local hasItem = MSK.HasItem(Config.Items['startDoor'])

						if hasItem and hasItem.count > 0 then
							if Config.SkillCheck.animation.enable then
								RequestAnimDict(Config.SkillCheck.animation.dict)
								while not HasAnimDictLoaded(Config.SkillCheck.animation.dict) do
									Wait(0)
								end
								TaskPlayAnim(playerPed, Config.SkillCheck.animation.dict, Config.SkillCheck.animation.anim, 8.0, 1.0, -1, 49, 0, false, false, false)
							end

							local success = false
							if Config.Skillbar:match('oxlib') then
								success = lib.skillCheck({Config.SkillCheck.difficulty['1'], Config.SkillCheck.difficulty['2'], {areaSize = 60, speedMultiplier = 2}, Config.SkillCheck.difficulty['3']}, Config.SkillCheck.inputs)
							elseif Config.Skillbar:match('qbcore') then
								local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
								Skillbar.Start({
									duration = math.random(1000, 5000), -- how long the skillbar runs for
									pos = math.random(10, 30), -- how far to the right the static box is
									width = math.random(10, 20), -- how wide the static box is
								}, function()
									success = true
								end, function()
									success = false
								end)
							end

							if Config.SkillCheck.animation.enable then
								RemoveAnimDict(Config.SkillCheck.animation.dict)
								ClearPedTasks(playerPed)
							end

							if success then
								TriggerServerEvent('msk_blackout:removeItem', hasItem.name)
								startedBlackout = true
								blackoutTeleport()
							end
						else
							Config.Notification(nil, Translation[Config.Locale]['no_items']:format(hasItem.label))
						end
					else
						Config.Notification(nil, Translation[Config.Locale]['no_online_cops'])
					end
				end
			end
		end
		
		Wait(sleep)
	end
end)

blackoutTeleport = function()
	local playerPed = PlayerPedId()
	
	SetEntityCoords(playerPed, Config.Coords['startBlackout'].x, Config.Coords['startBlackout'].y, Config.Coords['startBlackout'].z, false, false, false, true)
	SetEntityHeading(playerPed, Config.Coords['startBlackout'][4])
	Config.Notification(nil, Translation[Config.Locale]['door_success_skillcheck'])
	TriggerServerEvent('msk_blackout:notifyJobs')
	startBlackoutTeleport = true
end

CreateThread(function()
	while true do
		local sleep = 500

		if startedBlackout and startBlackoutTeleport and not hackedLaptop then
			if startBlackoutTeleport then
				local dist = #(GetEntityCoords(PlayerPedId()) - vec3(Config.Coords['startBlackout'].x, Config.Coords['startBlackout'].y, Config.Coords['startBlackout'].z))

				if dist > 50.0 then
					stopBlackoutTask()
				end
			end
		elseif startedBlackout and startBlackoutTeleport and hackedLaptop and teleportedOutOfBuilding then
			local dist = #(GetEntityCoords(PlayerPedId()) - Config.startPoint.coords)

			if dist > 150.0 then
				stopBlackoutTask()
			end
		end

		Wait(sleep)
	end
end)

CreateThread(function()
	while true do
		local sleep = 500

		if startBlackoutTeleport and not hackedLaptop then
			sleep = 0 
			local dist = #(GetEntityCoords(PlayerPedId()) - Config.Coords['hackLaptop'])

			if dist <= 2.5 then
				if not showHackLaptopHelp then
					MSK.HelpNotification(Translation[Config.Locale]['start_hack_Laptop'])
				end

				if dist <= 1.5 then
					if IsControlJustPressed(0, Config.Hotkey) then
						local hasItem = MSK.HasItem(Config.Items['hackLaptop'])

						if hasItem and hasItem.count > 0 then
							showHackLaptopHelp = true
							exports["datacrack"]:Start(4)
						else
							teleportOutOfBuilding('return')
							Config.Notification(nil, Translation[Config.Locale]['no_items']:format(hasItem.label))
						end
					end
				end
			end
		elseif startBlackoutTeleport and hackedLaptop then
			sleep = 0 
			local dist = #(GetEntityCoords(PlayerPedId()) - Config.Coords['hackLaptop'])

			if dist <= 5.0 then
				MSK.Draw3DText(Config.Coords['startBlackout'], Translation[Config.Locale]['success_hack_Laptop_show3d'], 0.5)

				if dist <= 2.0 then
					if IsControlJustPressed(0, Config.Hotkey) then
						teleportOutOfBuilding()
					end
				end
			end
		end

		if teleportedOutOfBuilding then
			sleep = 0
			local playerPed = PlayerPedId()

			for k, v in pairs(SabotageLocations) do
				local dist = #(GetEntityCoords(playerPed) - v.coords)

				if dist <= v.distance then
					if v.marker.enable then
						DrawMarker(v.marker.type, v.coords.x, v.coords.y, v.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.marker.size.a, v.marker.size.b, v.marker.size.c, v.marker.color.a, v.marker.color.b, v.marker.color.c, 100, false, true, 0, false)
					end

					if dist <= 2.0 then
						MSK.HelpNotification(Translation[Config.Locale]['sabotage_trafo_loc'])

						if IsControlJustPressed(0, Config.Hotkey) then
							local hasItem = MSK.HasItem(Config.Items['trafos'])

							if hasItem and hasItem.count > 0 then
								startedSabotage = true

								if Config.SabotageTrafo.animation.enable then
									RequestAnimDict(Config.SabotageTrafo.animation.dict)
									while not HasAnimDictLoaded(Config.SabotageTrafo.animation.dict) do
										Wait(0)
									end
									TaskPlayAnim(playerPed, Config.SabotageTrafo.animation.dict, Config.SabotageTrafo.animation.anim, 8.0, 1.0, -1, 49, 0, false, false, false)
								end

								local success = false
								if Config.Skillbar:match('oxlib') then
									success = lib.skillCheck({Config.SkillCheck.difficulty['1'], Config.SkillCheck.difficulty['2'], {areaSize = 60, speedMultiplier = 2}, Config.SkillCheck.difficulty['3']}, Config.SkillCheck.inputs)
								elseif Config.Skillbar:match('qbcore') then
									local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
									Skillbar.Start({
										duration = math.random(1000, 5000), -- how long the skillbar runs for
										pos = math.random(10, 30), -- how far to the right the static box is
										width = math.random(10, 20), -- how wide the static box is
									}, function()
										success = true
									end, function()
										success = false
									end)
								end

								if Config.SabotageTrafo.animation.enable then
									RemoveAnimDict(Config.SabotageTrafo.animation.dict)
									ClearPedTasks(playerPed)
								end

								if success then
									TriggerServerEvent('msk_blackout:removeItem', hasItem.name)
									removeBlip(v.coords)
									table.remove(SabotageLocations, k)
								end
							else
								Config.Notification(nil, Translation[Config.Locale]['no_items']:format(hasItem.label))
							end
						end
					end
				end
			end
		end

		if startedSabotage then
			if #SabotageLocations == 0 then
				stopBlackoutTask(true)
			end
		end

		Wait(sleep)
	end
end)

AddEventHandler("datacrack", function(success)
    hackedLaptop = success

	if success then
		TriggerServerEvent('msk_blackout:removeItem', Config.Items['hackLaptop'])
		Config.Notification(nil, Translation[Config.Locale]['success_hack_Laptop'])
	else
		showHackLaptopHelp = false
	end
end)

teleportOutOfBuilding = function(stop)
	SetEntityCoords(PlayerPedId(), Config.startPoint.coords.x, Config.startPoint.coords.y, Config.startPoint.coords.z, false, false, false, true)
	if stop == 'return' then return stopBlackoutTask() end
	
	Config.Notification(nil, Translation[Config.Locale]['sabotage_trafostation'])
	showSabotageBlips()
	addSabotagePoints()
	teleportedOutOfBuilding = true
end

addSabotagePoints = function()
	SabotageLocations = {}

	for k, v in pairs(Config.SabotageTrafo.settings) do
		table.insert(SabotageLocations, v)
	end
end

removeBlip = function(coord)
	for k, v in pairs(Blips) do
		if v.coord == coord then
			RemoveBlip(v.blip)
			table.remove(Blips, k)
		end
	end
end

showSabotageBlips = function()
	CreateThread(function()
        for k, v in pairs(Blips) do
            RemoveBlip(v.blip)
            Blips = {}
        end

		for k, v in pairs(Config.SabotageTrafo.settings) do
			if v.blip.enable then
				local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)

				SetBlipSprite(blip, v.blip.id)
				SetBlipScale(blip, v.blip.scale)
				SetBlipDisplay(blip, 4)
				SetBlipColour(blip, v.blip.color)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName('STRING') 
				AddTextComponentString(v.blip.label)
				EndTextCommandSetBlipName(blip)
				
				table.insert(Blips, {blip = blip, coord = v.coords})
			end
		end
	end)
end

stopBlackoutTask = function(success)
	logging('debug', 'Blackout has been stopped')
	startedBlackout, startBlackoutTeleport, hackedLaptop, showHackLaptopHelp, teleportedOutOfBuilding, startedSabotage = false, false, false, false, false, false
	SabotageLocations = {}

	for k, v in pairs(Blips) do
		RemoveBlip(v)
		Blips = {}
	end

	if success then
		TriggerServerEvent('msk_blackout:syncBlackout', true)
		Config.Notification(nil, Translation[Config.Locale]['successfully_done'])
	end
end

stopBlackout = function()
	TriggerServerEvent('msk_blackout:syncBlackout', false)
end

RegisterCommand('blackouton', function(source, args, raw)
	stopBlackoutTask(true)
end)

RegisterNetEvent('msk_blackout:setBlackout')
AddEventHandler('msk_blackout:setBlackout', function(state)
	setBlackout = state

	if state then
		addTimeout = MSK.AddTimeout(Config.Blackout.duration * 60000, function()
			stopBlackout()
			MSK.DelTimeout(addTimeout)
		end)
	end
end)

if not Config.useWeatherScript then
	CreateThread(function()
		while true do
			local sleep = 100

			if setBlackout then
				SetArtificialLightsState(Config.Blackout.generalLights)
				SetArtificialLightsStateAffectsVehicles(Config.Blackout.vehicleLights)
				ClearOverrideWeather()
				ClearWeatherTypePersist()
			else
				SetArtificialLightsState(false)
				SetArtificialLightsStateAffectsVehicles(false)
			end

			Wait(sleep)
		end
	end)
end

logging = function(code, ...)
    if Config.Debug then
        local script = "[^2"..GetCurrentResourceName().."^0]"
        MSK.logging(script, code, ...)
    end
end