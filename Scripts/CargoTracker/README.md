# Cargo Tracker

## Description

Cargo Tracker is a Game Script for OpenTTD that measures how much of a chosen cargo type each company delivers.  
The amount is tracked for the town nearest to that company’s headquarters, and the results are displayed in a league table.

---

## Features

- Automatic league table ranking companies by delivered cargo
- Tracks deliveries to the town closest to each company HQ
- Configurable cargo type (set via script settings)
- Save/load support – continues tracking across saved games
- Handles company events: new companies, bankruptcies, and mergers

---

## How It Works

- Each in-game month, the script checks every company’s HQ
- It finds the nearest town to that HQ
- Using the cargo monitor, it calculates how much of the chosen cargo was delivered there
- The totals are added to each company’s score and shown in a league table
- If companies appear, go bankrupt, or merge, their entries are updated automatically

---

## What's It For?

This script is designed for OpenTTD players and communities who want to:

- Run competitions between companies
- Track progress during multiplayer games
- Add an extra challenge by focusing on specific cargo delivery goals
- Use league tables as a scoring or achievement system

---

## Installation

1. Place the `CargoTracker` folder into your `OpenTTD\content_download\game` directory
2. In OpenTTD, go to **Game Script Settings** and select _Cargo Tracker_
3. Choose which cargo type you want to track via the script’s settings
4. During the game, click the **League Table button** to view company standings

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
