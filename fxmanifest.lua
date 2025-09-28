fx_version 'cerulean'
game 'gta5'

name 'Nevera Realtime Weather'
author 'Nevera Development Team'
description 'Ultra-lightweight real-time weather and clock synchronization for FiveM'
version '1.0.1'
repository 'https://github.com/Nevera-Hard-Rp/Nevera-realtime-weather'

-- Optimized for 0.00ms idle performance
lua54 'yes'

server_scripts {
    'realtime_server.lua'
}

client_scripts {
    'realtime_client.lua'
}

-- Exports
exports {
    -- Client exports
    'getCurrentWeather',
    'getCurrentTime',
    'getWindSpeed'
}

server_exports {
    'forceUpdate',
    'getLastUpdate',
    'getWeatherCache',
    'getStats'
}
