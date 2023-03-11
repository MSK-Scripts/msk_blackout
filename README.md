# msk_blackout
Weather Blackout Miniheist

## Description
It's a little Blackout Miniheist for ESX and QBCore.

CFX Forum: https://forum.cfx.re/t/esx-qbcore-msk-blackout-weather-blackout-miniheist/5041917

Preview: https://youtu.be/lS1PQw3oq8k

## Installation
* Install the Requirements below
* You only need `ox_lib` for ESX. For QBCore it's optional.
* You can set `Config.Skillbar = 'qbcore'` for QBCore Servers or use `ox_lib` Skillbar.

If you don't want to use the `ox_lib` Skillbar then remove it from `fxmanifest.lua`

## Events
If you want to implement a Listener to other Scripts, so the Job Notifications f.e. Robberies won't get triggert then add this to your scripts.

**It works clientside and serverside**
```lua
local isBlackout = false -- Add this at the TOP of your client file

blackoutPowerOn = function()
    isBlackout = false
end

blackoutPowerOff = function()
    isBlackout = true
end

AddEventHandler('msk_blackout:powerOn', blackoutPowerOn)
AddEventHandler('msk_blackout:powerOff', blackoutPowerOff)
```
**Example**
```lua
 -- Only if Power is ON the Notification to Cops will be triggered
if not isBlackout then
    TriggerClientEvent('notifyCops', -1)
end
```

## Requirements
* [ESX 1.2 and above](https://github.com/esx-framework/esx_core) or [QBCore](https://github.com/qbcore-framework)
* [msk_core](https://github.com/MSK-Scripts/msk_core)
* [ox_lib](https://github.com/overextended/ox_lib) - *Skillbar*
* [datacrack by utkuali](https://github.com/utkuali/datacrack) - *Hacking Minigame*
* [oxmysql](https://github.com/overextended/oxmysql) - *ox_doorlock*

## Optional Requirements
* [doors_creator by Jaksam](https://www.jaksam-scripts.com/) - *To unlock all doors while blackout*
* [ox_doorlock](https://github.com/overextended/ox_doorlock) - *To unlock all doors while blackout*
