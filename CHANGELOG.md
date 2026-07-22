# Changelog

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
