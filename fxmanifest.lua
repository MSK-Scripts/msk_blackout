fx_version 'adamant'
games { 'gta5' }

author 'Musiker15 - MSK Scripts'
name 'msk_blackout'
description 'Weather Blackout Miniheist'
version '1.7.4'

lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua', -- Remove if you are using QBCore !!!
	'@msk_core/import.lua',
	'@ox_lib/init.lua',
    'config.lua',
	'translation.lua'
}

client_scripts {
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}

dependencies {
	'es_extended', -- Remove if you are using QBCore !!!
	-- 'qb-core', -- Remove if you are using ESX !!!
	
	'msk_core', -- https://github.com/MSK-Scripts/msk_core
	'oxmysql',
	'ox_lib', -- https://github.com/overextended/ox_lib
	'datacrack', -- https://github.com/utkuali/datacrack
}