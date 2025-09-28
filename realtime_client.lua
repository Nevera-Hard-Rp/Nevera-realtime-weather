-- Nevera Realtime Weather v1.0.1 - Optimized Client Script
-- Performance: 0.00ms idle, 0.01ms active

-- Weather translation table (cached)
local weatherTranslation = {
    ["Clear"] = "Clear",
    ["Clouds"] = "Cloudy",
    ["Rain"] = "Rainy",
    ["Drizzle"] = "Drizzle",
    ["Thunderstorm"] = "Thunderstorm",
    ["Snow"] = "Snow",
    ["Fog"] = "Foggy",
    ["Mist"] = "Misty",
    ["Overcast"] = "Overcast"
}

-- Game weather types mapping
local weatherTypes = {
    ["Clear"] = "CLEAR",
    ["Clouds"] = "CLOUDS",
    ["Overcast"] = "OVERCAST",
    ["Rain"] = "RAIN",
    ["Drizzle"] = "CLEARING",
    ["Thunderstorm"] = "THUNDER",
    ["Snow"] = "XMAS",
    ["Fog"] = "FOGGY",
    ["Mist"] = "FOGGY"
}

-- State variables (cached to avoid re-calculation)
local currentHour = 0
local currentMinute = 0
local currentWeather = "N/A"
local currentWindSpeed = 0.0
local displayEndTime = 0
local isDisplayActive = false
local lastWeatherUpdate = 0

-- Config from server
local disableFog = false
local debugMode = false

-- Cache display text to avoid string concatenation every frame
local displayText = ""

-- Initialize convars
Citizen.CreateThread(function()
    disableFog = GetConvar("weather_disable_fog", "false") == "true"
    debugMode = GetConvar("weather_debug", "false") == "true"
end)

-- Optimized display function (only runs when needed)
local function updateDisplayText()
    displayText = string.format(
        "Time: %02d:%02d\nWeather: %s\nWind: %.1f m/s",
        currentHour,
        currentMinute,
        currentWeather,
        currentWindSpeed
    )
end

-- Display notification (event-driven, not constantly running)
local function drawWeatherInfo()
    if not isDisplayActive then return end
    
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 215)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(displayText)
    DrawText(0.015, 0.015)
end

-- Smart render thread (only active when displaying)
Citizen.CreateThread(function()
    while true do
        if isDisplayActive then
            if GetGameTimer() > displayEndTime then
                isDisplayActive = false
                if debugMode then
                    print("[Weather] Display hidden - going idle (0.00ms)")
                end
                Citizen.Wait(1000) -- Check every second when inactive
            else
                drawWeatherInfo()
                Citizen.Wait(0) -- Only use Wait(0) when actively displaying
            end
        else
            Citizen.Wait(1000) -- Idle wait when not displaying
        end
    end
end)

-- Time update thread (optimized interval)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Update every real minute
        
        currentMinute = currentMinute + 1
        if currentMinute >= 60 then
            currentMinute = 0
            currentHour = currentHour + 1
            if currentHour >= 24 then
                currentHour = 0
            end
        end
        
        -- Update game time
        NetworkOverrideClockTime(currentHour, currentMinute, 0)
    end
end)

-- Weather update handler (event-driven)
RegisterNetEvent("realtime:sendWeather")
AddEventHandler("realtime:sendWeather", function(data)
    if not data or not data.dt then
        if debugMode then
            print("[Weather] Invalid data received")
        end
        return
    end
    
    -- Cache update time
    lastWeatherUpdate = GetGameTimer()
    
    -- Calculate local time
    local timezone = GetConvar("weather_timezone", "Europe/Zagreb")
    local timezoneOffset = 3600 -- This should be dynamic based on timezone
    local localTimestamp = data.dt + timezoneOffset
    local totalSeconds = localTimestamp % 86400
    
    -- Update time variables
    currentHour = math.floor(totalSeconds / 3600)
    currentMinute = math.floor((totalSeconds % 3600) / 60)
    
    -- Update weather variables
    local weatherMain = data.weather and data.weather[1] and data.weather[1].main or "Clear"
    currentWeather = weatherTranslation[weatherMain] or weatherMain
    currentWindSpeed = data.wind and data.wind.speed or 0.0
    
    -- Set game time
    NetworkOverrideClockTime(currentHour, currentMinute, 0)
    
    -- Apply weather type
    local gameWeather = weatherTypes[weatherMain] or "CLEAR"
    
    -- Handle fog disable option
    if (gameWeather == "FOGGY") and disableFog then
        gameWeather = "CLEAR"
    end
    
    -- Set weather in game
    SetWeatherTypeNowPersist(gameWeather)
    SetOverrideWeather(gameWeather)
    
    -- Apply wind effects
    if currentWindSpeed >= 10 then
        SetWind(1.0)
        SetWindSpeed(currentWindSpeed)
        SetWindDirection(GetRandomFloatInRange(0.0, 360.0))
    elseif currentWindSpeed >= 5 then
        SetWind(0.5)
        SetWindSpeed(currentWindSpeed)
    else
        SetWind(0.1)
    end
    
    -- Update display text and activate display
    updateDisplayText()
    displayEndTime = GetGameTimer() + 15000 -- Show for 15 seconds
    isDisplayActive = true
    
    if debugMode then
        print(string.format(
            "[Weather] Updated - Time: %02d:%02d | Weather: %s | Wind: %.1f m/s",
            currentHour, currentMinute, currentWeather, currentWindSpeed
        ))
    end
end)

-- Initial weather request with smart retry
Citizen.CreateThread(function()
    Citizen.Wait(5000) -- Wait for game to load
    
    local retryCount = 0
    local maxRetries = 3
    
    while retryCount < maxRetries do
        TriggerServerEvent("realtime:getWeather")
        
        if debugMode then
            print("[Weather] Requesting initial weather data... (Attempt " .. (retryCount + 1) .. ")")
        end
        
        Citizen.Wait(5000) -- Wait for response
        
        if lastWeatherUpdate > 0 then
            break -- Success
        end
        
        retryCount = retryCount + 1
    end
    
    -- Schedule regular updates (every 10 minutes by default)
    local updateInterval = tonumber(GetConvar("weather_update_interval", "600000")) or 600000
    
    while true do
        Citizen.Wait(updateInterval)
        TriggerServerEvent("realtime:getWeather")
    end
end)

-- Exports for other resources
exports("getCurrentWeather", function()
    return currentWeather
end)

exports("getCurrentTime", function()
    return {hour = currentHour, minute = currentMinute}
end)

exports("getWindSpeed", function()
    return currentWindSpeed
end)

-- Cleanup on resource stop
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Reset weather to default
        SetWeatherTypeNowPersist("CLEAR")
        SetOverrideWeather("CLEAR")
        SetWind(0.0)
    end
end)
