# Auto Viewport Scroller

## Description

A utility script for OpenTTD Game Scripts designed to automatically scroll a specific client's viewport to newly built infrastructure and vehicles. It’s ideal for server administrators, spectators, or players wanting to automatically track new developments across the map.

---

## Features

- Automatically detects newly constructed stations, depots, and vehicles across all active companies.
- Scrolls the camera of a designated player (via Client ID) directly to the new entity's tile.
- Includes a configurable cooldown timer (in days) to prevent erratic or constant camera jumping.
- Fully customizable via in-game settings to toggle scrolling for stations, depots, and vehicles individually.

---

## How It Works

When the script starts, it enters a continuous monitoring loop (DoLoop()) that:

1. Scans and logs all existing stations (GSStationList), depots (GSDepotList across all transport types), and vehicles (GSVehicleList) into memory.
2. Checks for newly generated IDs or tiles that were not previously recorded.
3. Verifies if the configured cooldown period (scroll_cooldown_days) has elapsed.
4. Uses GSViewport.ScrollClientTo() to snap the specified client_id's view to the new location, provided the corresponding setting (scroll_on_station, scroll_on_depot, or scroll_on_vehicle) is enabled.
5. These actions use core OpenTTD GameScript functions like `GSMap`, `GSText`, and `GSCompanyMode`.

These actions utilize core OpenTTD GameScript functions and viewport management to keep track of world events.

---

## What's It For?

This script is best suited for:

- Spectators or broadcasters wanting to automatically follow the action in a multiplayer game.
- Server admins monitoring new player or AI company expansions.
- Players who want to keep a close eye on exactly where competitors are building.

---

## Installation

1. Place the `AutoViewportScroller` folder into your `OpenTTD\content_download\game` directory
2. Launch OpenTTD → Game Script Settings → Select Game Script → Choose **Auto Viewport Scroller**
3. Configure your script settings (set your target client_id, cooldown days, and which events to track).
4. Start a new game — the specified client's camera will now automatically pan to new stations, depots, or vehicles as they are built.
   Notes:

- You can get a list of current connected clients using the command clients in the OpenTTD console (opened with the \ or ~ key).
- The script settings can be changed at any time when in game as well.

---

## Bug Reporting & Help

To report bugs or get help the best place to go to is the Master Hellish Discord https://discord.masterhellish.net.
Here you can use the "openttd-mod-dev" channel for any conversations relating to this mod. Or you can use the "Help" forum for bug reporting.
If you are unable to use discord You can contact via another method [Master Hellish Links](https://linktr.ee/masterhellish).

---

## Usage & License

You are welcome to:

- Copy, modify, or expand this script
- Use it for public or private projects
- Share it with credit to Master Hellish

**Disclaimer:** Use at your own risk. No guarantees or warranties are provided.

---

## Created By

**Master Hellish**  
Part of the [Master Hellish Modding Projects](https://github.com/MasterHellish)
Part of the [Master Hellish Links](https://linktr.ee/masterhellish)
