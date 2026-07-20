# Changelog

## [1.0.2]

Reliability and configuration release. Everything reported in the Cfx.re
forum thread is addressed, plus admin controls for events.

### 🌍 Worldwide timezone support

The clock now derives its UTC offset from the API response for your configured
city, so daylight saving is handled automatically anywhere on the planet.
There is no timezone to configure — set the city correctly and the clock is
correct. *(raised by @TheAgentDap)*

### ⏱️ Drift-free clock

Game time is now synchronized every second against real time. No accumulated
drift, no correction jump when new data arrives.

### 🛠️ Admin override

Three new commands, gated behind the `nevera.weather` ACE permission:

| Command | Description |
|---|---|
| `/setweather <TYPE> [minutes]` | Force a weather type. Default 30 min, max 720. |
| `/resetweather` | Cancel immediately and resync. |
| `/weatherstatus` | Show real conditions and override state. |

Real-time sync pauses for the duration and resumes on its own. The on-screen
panel shows which admin set it, so players know it isn't real weather.

The clock deliberately has no override — players build their roleplay around
the time of day.

### 📊 Richer on-screen panel

Now shows **temperature** in Celsius and **wind direction** as a compass point,
alongside time, conditions and wind speed.

### 🌦️ Detailed weather mapping

Around 40 OpenWeatherMap condition IDs are now mapped individually instead of
six broad categories. Light drizzle, moderate rain and a thunderstorm each look
different. Snow resolves to `SNOWLIGHT`, `SNOW` or `BLIZZARD` by intensity and
enables tyre trails and footprints. Weather now fades between states over 15
seconds instead of snapping.

### 💨 True wind direction

Wind now follows the real bearing from the API, converted to radians and
oriented correctly — OpenWeatherMap reports where wind blows *from*, GTA
expects where it blows *to*.

### ⚙️ Configurable panel duration

How long the panel stays on screen is now `my_sync_display` in `server.cfg`,
in milliseconds. Set `0` to hide it entirely. No source editing.
*(raised by @Patronum_Studio)*

### 🎯 Unambiguous city selection

Added `my_sync_country` for an ISO country code, so `Split,HR` cannot resolve
to a different Split. *(raised by @Jota.Fivem)*

### 🌫️ Fog control

`disable_fog` is now read on the server and applied on every client.

### 🔌 Connection reliability

Requests now use HTTPS with full URL encoding, so city names with spaces or
accents work. Failed requests retry up to three times, 30 seconds apart, while
keeping the last known good data in play. Console output explains each HTTP
status in plain English instead of printing a bare number.
*(raised by @SrKaiross)*

Configuration is re-read on every cycle, so the resource recovers automatically if server.cfg sets its convars after the resource has started.

### ⚡ Performance

The render loop now idles at 500 ms and only runs per-frame while the panel is
actually visible. The server polls the API on its own schedule and serves all
clients from cache — one call per interval regardless of player count. Players
joining mid-cycle receive current data immediately instead of waiting for the
next update.

### 🧹 Stability

Malformed API responses are handled gracefully. Stopping the resource now
releases the clock and weather overrides back to the game.

### 🔑 API key

No default key ships with the resource. Set `my_sync_key` in `server.cfg`
before starting.

### 🔌 Exports

All v1.0.1 exports are unchanged. `getCurrentTime()` now returns `second`
alongside `hour` and `minute`. New: `getTemperature()`, `getWindDirection()`,
`getWeatherCache()`, `isOverrideActive()`.

---

## ⬆️ Upgrading from 1.0.0 or 1.0.1

Replace the files. Your existing `server.cfg` continues to work — both
generations of convar names are read, and the old millisecond interval is
converted automatically.

To use the new features, add:

```cfg
set my_sync_country  "HR"       # ISO country code
set my_sync_display  "15000"    # panel duration in ms, 0 = hidden
set my_sync_debug    "false"

add_ace group.admin nevera.weather allow   # required for admin commands
```

`my_sync_timezone` and `weather_timezone` are no longer used. Leaving them in
place is harmless.
