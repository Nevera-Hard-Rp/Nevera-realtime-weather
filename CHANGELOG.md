# Changelog

All notable changes to **Nevera Realtime Weather** are documented in this file.

The recommended convars are `my_sync_*` (and `disable_fog`). Older
`weather_*` names remain as compatibility aliases only.

---

## [1.2.0]

### Fixed

- **Clock now shows the real current time.** Earlier versions set the clock from the
  API field `dt`, which is the *observation time* of the weather station and is often
  5-30 minutes old. The clock is now built from the server's current UTC time plus the
  city offset, so it is accurate to the second.
- **All players see the same time.** Players joining later no longer start from an
  older cached timestamp.
- **No more clock jumps** on every API update, on a failed fetch, or on `/setweather` / `/resetweather`.
- **No slow drift** between updates: the clock is computed from `GetGameTimer()`
  instead of counting `Wait(1000)` ticks.
- **Heavy rain no longer becomes a thunderstorm.** OpenWeatherMap IDs 500-531 now map
  to `RAIN`; lightning only appears for real thunderstorms (2xx). Also applied to the
  farm API (`stormRisk`, `weatherType`).

### Added

- **NUI panel**: the on-screen panel is now HTML, so accented letters
  (č, š, ž, ä, é, ñ...) display correctly. Same position and look as before.
- **0.00 ms in resmon, also while the panel is visible** (was ~0.03 ms): Lua no longer
  draws the panel every frame — it sends the text once and the NUI page draws it.
- **Languages**: `my_sync_locale` (`en` default, `hr` included) for the panel, condition
  names, wind compass and admin chat messages. Adding a language = copy one block.
- **No rain indoors**: rain and thunder (and their sound) are suppressed inside MLO / IPL
  interiors, shells and `qs-housing` houses. Toggle with `my_sync_interior` (default `true`).
- **City ID**: optional `my_sync_cityid` to request weather by OpenWeatherMap city ID
  (most precise). City name + country still works as before.
- `/weatherstatus` now also shows the city name returned by the API.
- Server exports `getTzOffset()` and `getLocalTime()`: the city's local time for other
  scripts (shops, markets, opening hours), independent of the server OS timezone.
- Client export `isInsideHouse()` (true when the player is in any detected interior).
- `server.cfg.example` included.

### Upgrading from 1.0.x / 1.1.0

Replace all files (including the new `html/` folder). Optional new convars:

```cfg
set my_sync_locale   "en"
set my_sync_interior "true"
#set my_sync_cityid  ""
```

No other changes to `server.cfg` are required.

`server.cfg` is read only when the whole server starts: after editing it, restart the server
(or run the `set` line in the server console, then `ensure Nevera-realtime-weather`).

---

## [1.1.0]

### Added

- `getFarmWeather()` server export: flat table (`weatherType`, `temp`, `rainMm`, `snowMm`, `humidity`, `clouds`, `windSpeed`, `sunrise`, `sunset`, `forced`, `updatedAt`, `forecast`) for farming / agriculture scripts. Reflects the admin override.
- `getFarmForecast()` server export: 12h outlook (`minTemp`, `maxTemp`, `maxPop`, `rainMm`, `frostRisk`, `stormRisk`, `heatRisk`).
- Cache now stores humidity, cloudiness, rain/snow volume and sunrise/sunset.
- `my_sync_forecast` convar (default `true`): one extra API call per cycle. Set `false` to disable.

### Notes

- No changes to the client, commands or existing exports.

## [1.0.2]

### Added

- Admin commands: `/setweather`, `/resetweather`, `/weatherstatus` (`nevera.weather` ACE)
- Temperature and wind direction on the on-screen panel
- `my_sync_country`, `my_sync_display`, `my_sync_debug`, `my_sync_interval`
- Smooth weather transitions (15 seconds)
- Snow types by intensity (`SNOWLIGHT` / `SNOW` / `BLIZZARD`) with tyre trails and footprints
- Server exports: `getWeatherCache()`, `isOverrideActive()`, `forceUpdate()`, `getLastUpdate()`

### Fixed

- Timezone now follows the configured city (works worldwide, including DST)
- `disable_fog` was documented but ignored — now applied correctly
- HTTPS + URL encoding for city names with spaces or accents
- Clear console messages for HTTP errors (`0` / `401` / `404` / `429`)
- Clock no longer drifts between API updates
- One API call per server (not per player); new players get cached data on join
- Panel duration configurable without editing source
- Config is re-read every cycle (wrong `server.cfg` order recovers on its own)
- No API key ships as a default

### Upgrading from 1.0.0 / 1.0.1

Replace the files, then add if missing:

```cfg
set my_sync_country  "HR"
set my_sync_display  "15000"
set my_sync_debug    "false"

add_ace group.admin nevera.weather allow
```

Old convar names (`weather_api_key`, `weather_city`, …) still work.
`my_sync_timezone` / `weather_timezone` are unused and can be removed.
