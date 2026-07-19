# Vehicle Spammer

## Description

A powerful utility script designed to automate the mass cloning of vehicles for a specified company in OpenTTD. It is ideal for quickly populating a company's fleet, stress-testing map capacity, or rapidly setting up large-scale transport networks.

---

## Features

- Automated Mass Cloning: Rapidly clones vehicles directly from depots.
- Depot Balancing: Cycles through available depots to distribute new vehicles evenly.
- Smart Mapping: Automatically detects vehicle types inside depots to ensure the correct vehicle is cloned into the correct depot.
- Configurable Targeting: Allows you to specify which company ID the script should act upon.

---

## How It Works

When the script runs, it enters a continuous monitoring loop (DoLoop()) that:

1. Scans the specified company's vehicles to find those currently resting in depots.
2. Maps those depots to the compatible vehicle types.
3. Iteratively clones vehicles from those depots until the target limit (5000 per pass) is reached or an error occurs.
4. Logs progress to the game console, providing feedback every 100 clones.

---

## What's It For?

This script is best suited for:

- Stress Testing: Pushing OpenTTD’s vehicle limits to see how the engine handles high counts.

---

## Installation

1. Place the `VehicleSpammer` folder into your `OpenTTD\content_download\game` directory
2. Launch OpenTTD → Game Script Settings → Select Game Script → Choose **Vehicle Spammer**

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
