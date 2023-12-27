fx_version 'cerulean'
game 'gta5'

author 'mrshortyno'
description 'Weed shop job for ESX and QB'
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

escrow_ignore {
    'locales/*.lua',
    'server.lua',
    'config.lua',
    'client.lua',
    'install/*.txt',
    'install/*.sql',
    'install/images/.png',
}

files {
	'locales/en.json'
}
