# Nevera Realtime Weather & Clock

<div align="center">
  <a href="https://i.imgur.com/pSlTAgv.png" target="_blank" rel="noopener noreferrer">
    <img src="https://i.imgur.com/pSlTAgv.png" alt="Nevera Realtime Weather" width="100%">
  </a>
</div>

<p align="center">
  <a href="https://github.com/Nevera-Hard-Rp/Nevera-realtime-weather" target="_blank" rel="noopener noreferrer"><img src="https://img.shields.io/badge/version-1.0.2-blue.svg" alt="Version"></a>
  <a href="LICENSE" target="_blank" rel="noopener noreferrer"><img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License"></a>
  <a href="https://fivem.net" target="_blank" rel="noopener noreferrer"><img src="https://img.shields.io/badge/FiveM-standalone-orange.svg" alt="FiveM"></a>
  <a href="https://github.com/Nevera-Hard-Rp/Nevera-realtime-weather" target="_blank" rel="noopener noreferrer"><img src="https://img.shields.io/badge/dependencies-none-brightgreen.svg" alt="Dependencies"></a>
</p>

A lightweight FiveM script that synchronizes **real-world weather and time**
in-game using OpenWeatherMap data. Built for roleplay servers that want
authentic conditions instead of randomly cycling weather.

Pick a city anywhere on the planet. If it's raining there, it rains on your
server. If the sun sets at 20:41, it sets at 20:41 in game.

---

## 🎯 Philosophy

- **Real-world simulation first** — the weather is not random, it is real
- **Zero player intervention** — players cannot change anything
- **Admin control when you need it** — one command for events, then it returns
  to reality on its own
- **Lightweight** — one API call per server, no per-player polling, no render
  loop while the panel is hidden

---

## ✨ Features

- **Worldwide** — any city, any timezone, no timezone configuration
- **Automatic DST** — summer and winter time come from the API
- **Drift-free clock** — synchronized every second against real time
- **Detailed weather mapping** — around 40 OpenWeatherMap condition IDs mapped
  individually, so drizzle, moderate rain and a thunderstorm each look different
- **Smooth transitions** — the sky fades between states over 15 seconds
- **Real wind direction** — wind follows the actual bearing from the API
- **Snow effects** — tyre trails and footprints enable automatically
- **On-screen panel** — time, conditions, temperature and wind, top-left
- **Admin override** — force any weather type for a set duration, with automatic
  return to real conditions
- **Resilient** — retries on failure, keeps last known data, explains errors clearly
- **No dependencies** — ESX, QBCore, QBox or standalone

---

## 🖼️ Preview

**On-screen panel** — time, conditions, temperature and wind direction

![Panel](https://i.imgur.com/WQPenFf.png)

**Rain**

![Rain](https://i.imgur.com/6e2Bmko.png)

**Clear**

![Clear](https://i.imgur.com/c2LESqA.png)

**Console output on sync**

![Data Sync](https://i.imgur.com/8S7uUxb.png)

**Resource monitor**

![Resmon](https://i.imgur.com/B9qORXN.png)

---

## 📦 Requirements

- FiveM server artifacts supporting `fx_version 'cerulean'`
- A free <a href="https://openweathermap.org/" target="_blank" rel="noopener noreferrer">OpenWeatherMap</a> API key
- Outbound HTTPS access from your server

---

## 🚀 Installation

**1.** Download and place the folder in your `resources` directory.

**2.** Get an API key:

- Register at <a href="https://openweathermap.org/" target="_blank" rel="noopener noreferrer">OpenWeatherMap</a>
- Open the **API keys** section of your profile
- Generate a key

> ⚠️ A brand new key can take **up to 2 hours** to activate. A `401` right after
> signing up means the key is fine but not live yet — wait and try again.

**3.** Add to `server.cfg` — put all `set` lines **above** `ensure`:

```cfg
# ---- Nevera Realtime Weather ----
set my_sync_key      "YOUR_API_KEY"   # your OpenWeatherMap key
set my_sync_city     "Split"          # city name
set my_sync_country  "HR"             # ISO country code
set my_sync_interval "10"             # minutes between API calls
set my_sync_display  "15000"          # panel duration in ms, 0 = never show
set disable_fog      "true"           # "false" to allow fog
set my_sync_debug    "false"          # "true" prints the raw API response

# admin permission for the weather commands
add_ace group.admin nevera.weather allow

ensure Nevera-realtime-weather
```

**4.** Start the server. A successful sync looks like:

```
[nevera-weather] Split: Clouds, 29.6 C, wind 1.6 m/s from 228 deg
```

---

## ⚙️ Configuration

| Convar | Default | Description |
|---|---|---|
| `my_sync_key` | *(empty)* | OpenWeatherMap API key. **Required.** |
| `my_sync_city` | `Split` | City name. Spaces and accents are handled. |
| `my_sync_country` | `HR` | ISO 3166 country code. Prevents matching the wrong city. |
| `my_sync_interval` | `10` | Minutes between API calls. |
| `my_sync_display` | `15000` | How long the panel stays on screen, in ms. `0` hides it entirely. |
| `my_sync_tzoffset` | *(auto)* | Manual UTC offset **in seconds**. Only set this if the automatic value is wrong. |
| `disable_fog` | `true` | Replaces fog with overcast. Useful where fog is rare. |
| `my_sync_debug` | `false` | Prints the full API response to console. |

### Choosing a city

Always pair the city with a country code. `Split,HR` is Split in Croatia —
without `HR` the API may return a different Split entirely. Same for
`San Juan,PR`, `Tallahassee,US`, `Valencia,ES`.

The timezone is derived from the API response for that city, so **you never
configure a timezone**. Set the city correctly and the clock is correct.

### Keep your key private

Don't commit the API key, don't show it on stream, and don't type `my_sync_key`
alone in the console (it prints the value). If a key is exposed, delete it in
your OpenWeatherMap profile and generate a new one.

---

## 🛠️ Admin Commands

All three require the `nevera.weather` ACE permission. They also work from the
server console.

| Command | Description |
|---|---|
| `/setweather <TYPE> [minutes]` | Force a weather type. Default 30 minutes, max 720. |
| `/resetweather` | Cancel the override immediately and resync. |
| `/weatherstatus` | Show real conditions and override state. |

**Available types:**
`CLEAR` `EXTRASUNNY` `CLOUDS` `OVERCAST` `CLEARING` `RAIN` `THUNDER`
`FOGGY` `SMOG` `SNOW` `SNOWLIGHT` `BLIZZARD` `XMAS` `NEUTRAL` `HALLOWEEN`

**Examples:**

```
/setweather BLIZZARD 45
/setweather FOGGY
/resetweather
```

While an override is active, real-time sync pauses and the panel shows which
admin set it. When the timer expires, the script returns to real weather on its
own.

### Granting permission

```cfg
add_principal identifier.license:YOUR_LICENSE group.admin
add_ace group.admin nevera.weather allow
```

> **QBCore:** being a QBCore admin does **not** grant ACE. You still need
> `add_principal` / `add_ace` as above.

> There is no command to change the clock. Time always follows the real world.

---

## 🌍 Translating the on-screen panel

Open `realtime_client.lua`. Change only the **right-hand side** of these tables
at the top of the file:

```lua
local LABELS = {
    time    = "Time",
    weather = "Weather",
    temp    = "Temp",
    wind    = "Wind",
    forced  = "Forced by admin"
}

local conditionNames = {
    Clear  = "Clear",
    Clouds = "Cloudy",
    Rain   = "Rain",
    -- ...
}
```

Leave the keys in `conditionNames` exactly as they are — those are API values.

To move the panel, find `EndTextCommandDisplayText(0.015, 0.045)` in the same
file. First number is horizontal, second is vertical.

---

## 🔌 Exports

**Server:**

```lua
exports['Nevera-realtime-weather']:getWeatherCache()     -- full cached table
exports['Nevera-realtime-weather']:isOverrideActive()    -- boolean
exports['Nevera-realtime-weather']:forceUpdate()         -- trigger a fetch now
exports['Nevera-realtime-weather']:getLastUpdate()       -- unix timestamp
```

---

## 📊 Performance

| State | Cost |
|---|---|
| Panel hidden | **0.00 ms** |
| Panel visible | ~0.03 ms |

Set `my_sync_display "0"` if you prefer no panel at all.

One API call per interval regardless of player count (~4,300/month at the
default 10 minutes — inside the free tier).

---

## 🧩 Troubleshooting

| Symptom | Cause and fix |
|---|---|
| `status 0` | Outbound HTTPS blocked, firewall, or outdated artifacts. |
| `status 401` | Bad key, or a new key that hasn't activated yet (wait up to 2 hours). |
| `401` on boot, works after `restart` | `set` lines are below `ensure` in `server.cfg` — move them above. |
| `status 404` | Wrong city or country code. |
| `status 429` | Quota exceeded. Increase `my_sync_interval`. |
| Clock off by hours | Wrong city. Set `my_sync_country`, or override with `my_sync_tzoffset`. |
| No fog | `disable_fog` is `"true"`. Set it to `"false"`. |
| Panel never shows | `my_sync_display` is `0`, or the API hasn't responded yet. |
| Weather won't stay | Another weather script is fighting this one. Run only one. |
| Admin command denied | ACE not set, or QBCore admin without ACE — see *Granting permission*. |

Test your key in a browser:

```
https://api.openweathermap.org/data/2.5/weather?q=Split,HR&appid=YOUR_KEY&units=metric
```

Set `my_sync_debug "true"` to print the full API response in console.

---

## 🤝 Credits

- **Created by:** Nevera
- **For:** Nevera Hard RP Server
- **Weather data:** <a href="https://openweathermap.org/" target="_blank" rel="noopener noreferrer">OpenWeatherMap</a>
- **Platform:** FiveM / Cfx.re

Thanks to **@TheAgentDap**, **@Patronum_Studio**, **@Jota.Fivem** and
**@SrKaiross** for feedback on the forum thread.

## 📄 License

MIT — see <a href="LICENSE" target="_blank" rel="noopener noreferrer">LICENSE</a>.

## 🔗 Links

- <a href="CHANGELOG.md" target="_blank" rel="noopener noreferrer">Changelog</a>
- <a href="https://github.com/Nevera-Hard-Rp/Nevera-realtime-weather" target="_blank" rel="noopener noreferrer">GitHub Repository</a>
- <a href="https://forum.cfx.re/t/free-nevera-realtime-weather-and-clock-script/5283767" target="_blank" rel="noopener noreferrer">Cfx.re Forum Thread</a>
- <a href="https://openweathermap.org/current" target="_blank" rel="noopener noreferrer">OpenWeatherMap Current Weather API</a>
- <a href="https://discord.gg/k7uADMdFes" target="_blank" rel="noopener noreferrer">Nevera Hard RP Discord</a>

---

*Made in Split, Croatia.*
