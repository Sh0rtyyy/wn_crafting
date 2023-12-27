fx_version 'cerulean'
game 'gta5'

author 'mrshortyno'
description 'Crafting system for ESX and QB'
version '1.0.0'
lua54 'yes'

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
}
