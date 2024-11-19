-- Set Convars for timezone, city, and API key
local timezone = GetConvar("my_sync_timezone", "Europe/Zagreb")
local city = GetConvar("my_sync_city", "Split") 
local apiKey = GetConvar("my_sync_key", "Your_API_Key")

local baseUrl = "http://api.openweathermap.org/data/2.5/weather?q=" .. city .. "&appid=" .. apiKey

RegisterServerEvent("realtime:getWeather")
AddEventHandler("realtime:getWeather", function()
    PerformHttpRequest(baseUrl, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            print("[DEBUG] API Response: " .. response)

            TriggerClientEvent("realtime:sendWeather", -1, data)
        else
            print("Error retrieving time: " .. statusCode)
        end
    end, "GET", "", {["Content-Type"] = "application/json"})
end)
