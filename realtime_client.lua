-- Tablica za prevođenje vremenskih uvjeta
local prijevodVremena = {
    ["Clear"] = "Vedro",
    ["Clouds"] = "Oblacno",
    ["Rain"] = "Kiša",
    ["Thunderstorm"] = "Grmljavina",
    ["Snow"] = "Snijeg",
    ["Fog"] = "Magla",
    ["Mist"] = "Magla",
    ["OVERCAST"] = "Oblačno"
}


local disableFog = true 


local currentHour = 0
local currentMinute = 0
local currentWeather = "N/A"
local currentWindSpeed = "0.0"
local prikaziVrijeme = false 


function prikaziObavijestGoreLijevo()
    if prikaziVrijeme then

        local tekst = string.format("Sati: %02d:%02d\nVrijeme: %s\nVjetar: Brzina %s m/s", currentHour, currentMinute, currentWeather, currentWindSpeed)
        
        SetTextFont(4)
        SetTextProportional(1)
        SetTextScale(0.35, 0.35) 
        SetTextColour(255, 255, 255, 200)
        SetTextOutline() 
        SetTextEntry("STRING")
        AddTextComponentString(tekst)
        
        DrawText(0.015, 0.015) 
    end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 
        prikaziObavijestGoreLijevo()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        currentMinute = currentMinute + 1

        if currentMinute >= 60 then
            currentMinute = 0
            currentHour = currentHour + 1 

            if currentHour >= 24 then
                currentHour = 0 
            end
        end

        NetworkOverrideClockTime(currentHour, currentMinute, 0)
    end
end)

RegisterNetEvent("realtime:sendWeather")
AddEventHandler("realtime:sendWeather", function(data)
    if not data or not data.dt then
        return
    end

    local timestamp = data.dt

    local timezoneOffset = 3600 

    local localTimestamp = timestamp + timezoneOffset

    local totalSeconds = localTimestamp % 86400 
    currentHour = math.floor(totalSeconds / 3600) 
    currentMinute = math.floor((totalSeconds % 3600) / 60) 

    local engWeather = data.weather and data.weather[1] and data.weather[1].main or "N/A"
    currentWeather = prijevodVremena[engWeather] or engWeather

    local windSpeed = data.wind and data.wind.speed or 0.0
    currentWindSpeed = string.format("%.2f", windSpeed)


    NetworkOverrideClockTime(currentHour, currentMinute, 0)

    if currentWeather == "Snijeg" then
        SetWeatherTypeNowPersist("XMAS")
        SetOverrideWeather("XMAS")
    elseif currentWeather == "Kiša" then
        SetWeatherTypeNowPersist("RAIN")
        SetOverrideWeather("RAIN")
    elseif currentWeather == "Grmljavina" then
        SetWeatherTypeNowPersist("THUNDER")
        SetOverrideWeather("THUNDER")
    elseif currentWeather == "Magla" and not disableFog then
        SetWeatherTypeNowPersist("FOGGY")
        SetOverrideWeather("FOGGY")
    else
        SetWeatherTypeNowPersist(engWeather)
        SetOverrideWeather(engWeather)
    end

    if windSpeed >= 10 then
        SetWind(1.0)
        SetWindSpeed(windSpeed)
        SetWindDirection(0.0)
    elseif windSpeed < 2 then
        SetWind(0.0)
    else
        SetWind(0.2)
        SetWindSpeed(windSpeed)
    end

    prikaziVrijeme = true
    Citizen.SetTimeout(15000, function()
        prikaziVrijeme = false
    end)
end)

Citizen.CreateThread(function()
    while true do
        TriggerServerEvent("realtime:getWeather")
        Citizen.Wait(600000)
    end
end)
