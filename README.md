# Nevera Realtime Weather v2.0.0 ⛈️

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/Nevera-Hard-Rp/Nevera-realtime-weather)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-2025_Ready-orange.svg)](https://fivem.net)

Nevera FiveM Realtime Weather and Clock is an advanced script for FiveM servers that synchronizes real-time weather and clock in-game using data from the real world through OpenWeatherMap API.

## 🆕 What's New in v2.0.0 (September 2025)

### Major Updates
- **Complete Code Rewrite** - Optimized for FiveM 2025 with 50% better performance
- **Enhanced Edition Support** - Full compatibility with GTA V Enhanced Edition features
- **Advanced Weather System** - Smooth transitions, lightning effects, and dynamic wind physics
- **Blackout Mode** - City-wide power outage simulation for roleplay scenarios
- **Weather Forecast** - 24-hour forecast system with API integration
- **Personal Weather/Time** - Players can have individual weather settings
- **Discord Webhooks** - Log weather changes and admin commands
- **Modern UI Options** - Glass-morphism style or native GTA notifications
- **Thread Pooling** - Better resource management for large servers
- **Cache System** - Reduces API calls and improves response time

### Performance Improvements
- Optimized render loop (from `Wait(0)` to dynamic waiting)
- Implemented weather data caching
- Added thread pooling for better CPU usage
- Resource usage: ~0.01ms idle, ~0.05ms during updates

## Requirements
- **Framework**: Compatible with **ESX**, **QBCore**, and **Standalone**
- **FiveM Server**: Build 6683 or higher (2025 recommended)
- **OneSync**: Recommended for best performance
- **API Key**: Free OpenWeatherMap API key required

## Features

### Core Features (Original)
- **Real-time synchronization**: Fetches real-time data from any city worldwide (default: Split, Croatia)
- **Automatic weather updates**: Weather conditions updated every 10 minutes (configurable)
- **Notification display**: Weather and time notifications shown for 15 seconds
- **Fog disable option**: Useful for areas where fog is rare

### New Advanced Features (v2.0.0)
- **Dynamic Wind System**: Realistic wind that affects vehicles and aircraft
- **Weather Effects**: 
  - Snow on ground with footprints
  - Wet roads with reflections
  - Lightning during thunderstorms
- **Blackout System**: Toggle city-wide power outages
- **Freeze Options**: Pause weather or time progression
- **Export Functions**: Full API for integration with other resources
- **Custom Events**: React to weather changes in your scripts
- **Admin Commands**: Complete control over weather and time

### View Images
1. **Data synchronization**:
   ![Data Sync](https://i.imgur.com/8S7uUxb.png)

2. **Data update**:
   ![Data Update](https://i.imgur.com/axpJm9s.png)

3. **Resmon value in game** (Optimized in v2.0):
   ![Resmon](https://i.imgur.com/0L9ETkn.png)

4. **Clock display** (Now with temperature and wind): 
   ![Clock Display](https://i.imgur.com/CovWD3l.png)

## Installation

1. **Download the script** and place it in the `resources` folder of your FiveM server.

2. **Configure your `server.cfg` file**:
```cfg
# Basic Configuration
ensure Nevera-realtime-weather

# API Configuration (REQUIRED - Old config names still work)
set my_sync_key "YOUR_API_KEY"           # Your API key
set my_sync_timezone "Europe/Zagreb"     # Your timezone
set my_sync_city "Split"                 # Your city
set disable_fog "true"                   # Disable fog

# New v2.0 Configuration Options (OPTIONAL)
set nv_weather_country "HR"              # Country code
set nv_weather_update_interval "600000"  # Update interval (ms)
set nv_disable_snow "false"              # Disable snow
set nv_weather_metric "true"             # Use metric units (Celsius, m/s)
set nv_weather_debug "false"             # Debug mode

# Admin Permissions (NEW)
add_ace group.admin command.weather allow
add_ace group.admin command.blackout allow
add_ace group.admin command.freezeweather allow
```

3. **Restart your server**

## How to Get Your API Key
1. Visit [OpenWeatherMap](https://openweathermap.org/)
2. **Sign up for a free account**: Click "Sign Up" and create an account
3. Go to **API keys** section in your profile
4. **Generate a new API key** and use it in server.cfg

## Commands (NEW in v2.0)

| Command | Description | Permission |
|---------|-------------|------------|
| `/weather [type]` | Change weather (clear/rain/thunder/snow) | admin |
| `/blackout` | Toggle city blackout | admin |
| `/freezeweather` | Pause/resume weather sync | admin |
| `/freezetime` | Pause/resume time progression | admin |
| `/forecast` | View 24-hour weather forecast | everyone |
| `/weatherinfo` | Show current weather details | everyone |

## Configuration (NEW)

All settings can be configured in the new `config.lua` file:

```lua
Config.Weather = {
    EnableDynamicWeather = true,      -- Dynamic weather changes
    TransitionTime = 15.0,            -- Smooth transition duration
    EnableSnowOnGround = true,        -- Snow effects
    EnableWetRoads = true,            -- Wet road reflections
    EnableLightning = true,           -- Lightning in storms
    RealisticWind = true              -- Wind affects vehicles
}

Config.UI = {
    ShowWeatherUI = true,             -- Display weather UI
    ShowTemperature = true,           -- Show temperature
    ShowWindSpeed = true,             -- Show wind speed
    UseModernUI = true                -- Modern glass style
}
```

## API & Exports (NEW)

### Client-Side Exports
```lua
-- Get current weather
local weather = exports['Nevera-realtime-weather']:getCurrentWeather()

-- Get current time
local time = exports['Nevera-realtime-weather']:getCurrentTime()

-- Get temperature
local temp = exports['Nevera-realtime-weather']:getTemperature()

-- Set personal weather (client only)
exports['Nevera-realtime-weather']:setPersonalWeather('RAIN')
```

### Server-Side Exports
```lua
-- Get full weather data
local data = exports['Nevera-realtime-weather']:getWeatherData()

-- Force weather update
exports['Nevera-realtime-weather']:forceWeatherUpdate()
```

### Events
```lua
-- Listen for weather changes
AddEventHandler('nv:weather:updated', function(data)
    print('Weather changed:', data.weather)
    print('Temperature:', data.temperature)
end)
```

## Performance Comparison

| Version | Idle CPU | Active CPU | Memory | Network |
|---------|----------|------------|---------|---------|
| v1.0.0 | ~0.02ms | ~0.10ms | ~3MB | High |
| v2.0.0 | ~0.01ms | ~0.05ms | <2MB | Optimized |

## Changelog

### v2.0.0 (September 2025) - MAJOR UPDATE
- Complete code rewrite for FiveM 2025
- Added Enhanced Edition support
- Implemented thread pooling and caching
- Added blackout mode
- Added weather forecast system
- Improved wind physics
- Added Discord webhook integration
- Modern UI with glass-morphism
- Performance improvements (50% better)
- Added extensive exports and events
- Fixed all known bugs from v1.0

### v1.0.0 (December 2024)
- Initial release
- Basic weather sync
- Time synchronization
- Simple UI display

## Known Issues
- Cayo Perico independent weather is still in development
- Some weather transitions may conflict with other weather scripts

## Contributions
If you would like to contribute to the project, feel free to:
1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## Support
- **GitHub Issues**: [Report bugs here](https://github.com/Nevera-Hard-Rp/Nevera-realtime-weather/issues)
- **Discord**: [Join our Discord](https://discord.gg/nevera)
- **Forum**: [FiveM Forum Thread](https://forum.cfx.re/t/free-nevera-realtime-weather-and-clock-script/5283767)

## License
Released under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits
- OpenWeatherMap for weather API
- FiveM/Cfx.re team for the platform
- Community contributors and testers
- Original author: Nevera Development Team

## Additional Information
- Visit [OpenWeatherMap](https://openweathermap.org/) to create your API key
- For more FiveM resources visit [forum.cfx.re](https://forum.cfx.re)
- Based in Split, Croatia 🇭🇷

---
**Note**: This script is actively maintained and updated. For the latest version, always check the GitHub repository.
