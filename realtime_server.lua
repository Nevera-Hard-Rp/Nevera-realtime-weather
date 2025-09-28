-- Nevera Realtime Weather v1.0.1 - Optimized Server Script
-- Performance optimized with caching and error handling

-- Configuration from convars
local apiKey = GetConvar("weather_api_key", "")
local city = GetConvar("weather_city", "Split")
local timezone = GetConvar("weather_timezone", "Europe/Zagreb")
local debugMode = GetConvar("weather_debug", "false") == "true"
local updateInterval = tonumber(GetConvar("weather_update_interval", "600000")) or 600000

-- Backwards compatibility with old convar names
if apiKey == "" then
    apiKey = GetConvar("my_sync_key", "")
    city = GetConvar("my_sync_city", "Split")
    timezone = GetConvar("my_sync_timezone", "Europe/Zagreb")
end

-- Validate API key
if apiKey == "" or apiKey == "Your_API_Key" or apiKey == "YOUR_API_KEY_HERE" then
    print("^1[Weather] ERROR: No valid API key found!^0")
    print("^3[Weather] Please set 'weather_api_key' in your server.cfg^0")
    print("^3[Weather] Get your free key at: https://openweathermap.org/^0")
    return
end

-- API endpoint
local baseUrl = string.format(
    "http://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s&units=metric",
    city, apiKey
)

-- Cache system to reduce API calls
local weatherCache = {
    data = nil,
    lastUpdate = 0,
    updateInterval = 60000 -- Minimum time between API calls (1 minute)
}

-- Statistics tracking
local stats = {
    totalRequests = 0,
    apiCalls = 0,
    cacheHits = 0,
    errors = 0,
    startTime = os.time()
}

-- Function to get cached or fresh weather data
local function getWeatherData(forceUpdate)
    local currentTime = GetGameTimer()
    
    -- Check if we can use cached data
    if not forceUpdate and weatherCache.data and 
       (currentTime - weatherCache.lastUpdate) < weatherCache.updateInterval then
        stats.cacheHits = stats.cacheHits + 1
        if debugMode then
            print("[Weather] Using cached data (Cache hits: " .. stats.cacheHits .. ")")
        end
        return weatherCache.data
    end
    
    -- Fetch fresh data from API
    stats.apiCalls = stats.apiCalls + 1
    
    PerformHttpRequest(baseUrl, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            
            if data then
                -- Update cache
                weatherCache.data = data
                weatherCache.lastUpdate = currentTime
                
                -- Broadcast to all clients
                TriggerClientEvent("realtime:sendWeather", -1, data)
                
                if debugMode then
                    local weatherMain = data.weather and data.weather[1] and data.weather[1].main or "Unknown"
                    local temp = data.main and data.main.temp or 0
                    local windSpeed = data.wind and data.wind.speed or 0
                    
                    print(string.format(
                        "[Weather] API Update - City: %s | Weather: %s | Temp: %.1f°C | Wind: %.1f m/s",
                        city, weatherMain, temp, windSpeed
                    ))
                    print(string.format(
                        "[Weather] Stats - API Calls: %d | Cache Hits: %d | Errors: %d",
                        stats.apiCalls, stats.cacheHits, stats.errors
                    ))
                end
            else
                stats.errors = stats.errors + 1
                print("^1[Weather] ERROR: Failed to parse API response^0")
            end
        else
            stats.errors = stats.errors + 1
            print("^1[Weather] ERROR: API request failed with status code: " .. statusCode .. "^0")
            
            -- Use cached data if available
            if weatherCache.data then
                print("^3[Weather] Using last known good data^0")
                TriggerClientEvent("realtime:sendWeather", -1, weatherCache.data)
            end
        end
    end, "GET", "", {["Content-Type"] = "application/json"})
end

-- Handle client weather requests
RegisterServerEvent("realtime:getWeather")
AddEventHandler("realtime:getWeather", function()
    local source = source
    stats.totalRequests = stats.totalRequests + 1
    
    -- Send cached data immediately if available
    if weatherCache.data then
        TriggerClientEvent("realtime:sendWeather", source, weatherCache.data)
    end
    
    -- Check if we need to update from API
    local currentTime = GetGameTimer()
    if (currentTime - weatherCache.lastUpdate) >= updateInterval then
        getWeatherData(false)
    end
end)

-- Automatic weather updates
Citizen.CreateThread(function()
    -- Initial delay to let server start properly
    Citizen.Wait(10000)
    
    -- Initial weather fetch
    getWeatherData(true)
    
    -- Schedule regular updates
    while true do
        Citizen.Wait(updateInterval)
        getWeatherData(false)
    end
end)

-- Admin command to force update (optional - can be removed for pure realism)
RegisterCommand("forceweatherupdate", function(source, args, rawCommand)
    if source == 0 then -- Console only
        print("^2[Weather] Forcing weather update...^0")
        getWeatherData(true)
    end
end, true)

-- Export functions for other resources
exports("forceUpdate", function()
    getWeatherData(true)
end)

exports("getLastUpdate", function()
    return weatherCache.lastUpdate
end)

exports("getWeatherCache", function()
    return weatherCache.data
end)

exports("getStats", function()
    return stats
end)

-- Resource cleanup
AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print("^2[Weather] Nevera Realtime Weather v1.0.1 Started^0")
        print("^2[Weather] City: " .. city .. " | Timezone: " .. timezone .. "^0")
        print("^2[Weather] Update Interval: " .. (updateInterval / 60000) .. " minutes^0")
        
        if debugMode then
            print("^3[Weather] Debug mode enabled^0")
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if debugMode then
            local runtime = os.time() - stats.startTime
            print("^3[Weather] Statistics for this session:^0")
            print(string.format(
                "  Runtime: %d minutes | Total Requests: %d | API Calls: %d | Cache Hits: %d",
                runtime / 60, stats.totalRequests, stats.apiCalls, stats.cacheHits
            ))
        end
    end
end)
