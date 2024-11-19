# Nevera-realtime-weather
Nevera FiveM Realtime Weather and Clock is a script for FiveM servers that synchronizes real-time weather and clock in-game using data from the real world through an API.
## Requirements
- **Framework**: The script is compatible with **ESX**, **QBCore**, and **Standalone**.
- **FiveM Server**: The latest version of the FiveM server.

## Features
- **Real-time synchronization**: Fetches real-time data from the API for Split, Croatia.
- **Automatic weather updates**: Weather conditions are updated every 10 minutes.
- **Notification display**: Weather and time notifications are shown for 15 seconds.
- **Fog disable option**: `set disable_fog "true"` to disable fog (useful for areas like Dalmatia, where fog is rare).

## Installation
1. **Download the script** and place it in the `resources` folder of your FiveM server.
2. **Configure your `server.cfg` file**: Add the following lines to your `server.cfg` to run the script:
   ```cfg
   set my_sync_key "YOUR_API_KEY"           # Your API key
   set my_sync_timezone "Europe/Zagreb"     # Your country/city
   set my_sync_city "Split"                 # Your city
   set disable_fog "true"                   # Set to "false" if you want to enable fog
-

## How to Get Your API Key
1. Visit the [OpenWeatherMap](https://openweathermap.org/) website.
2. **Sign up for a free account**: Click on "Sign Up" and fill in your details to create an account.
3. Once registered, go to the **API keys** section in your profile.
4. **Generate a new API key** and use it in the server.cfg file.
## Usage
The script automatically fetches real-time weather and clock data and sets it in-game.
Weather condition notifications are shown every 10 minutes.
## Contributions
If you would like to contribute to the project, feel free to open an issue or submit a pull request.
## License
Released under the MIT license.
## Additional Information
Visit OpenWeatherMap to create your API key.
