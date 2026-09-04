# Grand Auction Junction

## Description

A minimal example script for OpenTTD Game Scripts, designed to showcase how to send messages and interact with the game world in multiple ways. It’s ideal as a **starting point** or **template** for new Game Script developers.

---

## Features

- Logs a message via `GSLog`
- Posts a general news item to all players
- Places a sign in the centre of the map
- Renames the first company to `"Hello Tycoon Company"`

---

## How It Works

When the script starts, it executes a `PostInit()` function that:

1. Sends `"Hello Tycoons!"` to the game log using `GSLog.Info()`
2. Posts the same message to the in-game news feed using `GSNews.Create()`
3. Places a sign in the middle of the map using `GSSign.BuildSign()`
4. Renames the first company (if it exists) using `GSCompany.SetName()`

These actions use core OpenTTD GameScript functions like `GSMap`, `GSText`, and `GSCompanyMode`.

---

## What's It For?

This script is best suited for:

- Learning the basics of OpenTTD GameScript development
- Testing message output and map interaction features
- Creating a personal Game Script template or boilerplate
- Demonstrating community mods or beginner tutorials

---

## Installation

1. Place the `HelloTycoons` folder into your `OpenTTD\content_download\game` directory
2. Launch OpenTTD → Game Script Settings → Select Game Script → Choose **Hello Tycoons**
3. Start a new game — you’ll see greetings appear automatically:
   - In the game log
   - As a pop-up news item
   - As a sign in the middle of the map
   - (Optional) As the name of the first company

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
