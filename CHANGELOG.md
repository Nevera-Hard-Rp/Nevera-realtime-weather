# Changelog

All notable changes to **Nevera Realtime Weather** are documented in this file.

The recommended convars are `my_sync_*` (and `disable_fog`). Older
`weather_*` names remain as compatibility aliases only.

---

## [1.0.2]

### Added

- Admin commands `/setweather`, `/resetweather`, `/weatherstatus` (`nevera.weather` ACE)
- Panel: temperature (°C) and wind direction (compass)
- `my_sync_country` — ISO code so cities like `Split,HR` resolve correctly
- `my_sync_display` — panel duration in ms (`0` hides the panel)
- `my_sync_interval` — minutes between API calls
- `my_sync_debug` — print raw API response
- Smooth weather transitions (15 seconds)
- Snow by intensity (`SNOWLIGHT` / `SNOW` / `BLIZZARD`) with tyre trails and footprints
- Server exports: `getWeatherCache()`, `isOverrideActive()`, `forceUpdate()`, `getLastUpdate()`

### Fixed

- Timezone and DST follow the configured city (worldwide)
- `disable_fog` now applied correctly (was documented but ignored)
- HTTPS + URL encoding for city names with spaces or accents
- Clear console messages for HTTP `0` / `401` / `404` / `429`
- Clock no longer drifts between updates
- One API call per server (not per player); joining players get cached data
- Config re-read every fetch cycle (wrong `set` / `ensure` order recovers alone)
- No default API key shipped in the resource

### Upgrade from 1.0.0 / 1.0.1

Replace all resource files, then add if missing:

```cfg
set my_sync_key      "YOUR_API_KEY"
set my_sync_city     "Split"
set my_sync_country  "HR"
set my_sync_interval "10"
set my_sync_display  "15000"
set disable_fog      "true"
set my_sync_debug    "false"

add_ace group.admin nevera.weather allow

ensure Nevera-realtime-weather
```

Keep `set` lines **above** `ensure`.

If you still use old names (`weather_api_key`, `weather_city`, …), they work —
prefer `my_sync_*` for new installs. Remove unused `my_sync_timezone` /
`weather_timezone`.

---

## [1.0.1] / [1.0.0]

Initial public releases (city sync, basic panel, OpenWeatherMap).
