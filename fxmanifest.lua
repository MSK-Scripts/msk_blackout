fx_version 'adamant'
games { 'gta5' }

author 'Musiker15 - MSK Scripts'
name 'msk_blackout'
description 'Weather Blackout Miniheist'
version '1.5'

lua54 'yes'

shared_scripts {
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
	'msk_core', -- https://github.com/MSK-Scripts/msk_core
	'oxmysql',
	'ox_lib', -- https://github.com/overextended/ox_lib
	'datacrack' -- https://github.com/utkuali/datacrack
}