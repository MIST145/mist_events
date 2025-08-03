fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Dynamic Menu System'
description 'Sistema de Menu Dinâmico Configurável'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'  -- Opcional - apenas se usar persistência SQL
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/app.js',
}