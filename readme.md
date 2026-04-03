# 📦 old\_delivery

A highly immersive and optimized parcel delivery job for **FiveM**. This script focuses on manual interactions, realistic vehicle loading, and server-side security to provide a high-quality experience for your players.

## 📺 Preview

[](https://youtu.be/_hPf616SQDg)

## 🚀 Main Features

  * **Service Start**: Players begin the mission at the depot by interacting with a dedicated NPC (Ped) to spawn their work vehicle and receive instructions.
  * **Realistic Loading System**: Players must manually pick up boxes and place them inside the truck. Props are physically attached to the vehicle's chassis using precise offsets and rotations.
  * **Mission Objectives**: Once the truck is fully loaded, a notification is sent to the player, and a dynamic mission waypoint (Yellow Route) is automatically set to the delivery zone.
  * **Interactive Unloading**: Upon arrival, players must exit the vehicle, open the rear doors, and retrieve boxes one by one to drop them at the delivery point.
  * **Dynamic Door Management**: Truck doors automatically open during loading/unloading and close once the job is finished for maximum immersion.
  * **Anti-Cheat Protection**: Includes server-side distance validation to prevent cheaters from triggering payouts remotely.
  * **Forced Animations**: If a player falls or tries to glitch the carrying animation, the script automatically resumes the "box carry" pose.
  * **Map Visibility**: A permanent "Delivery Job" blip is displayed on the map to help players locate the starting point.

## 🛠️ Dependencies

  * [es\_extended](https://www.google.com/search?q=https://github.com/esx-framework/es_extended) (Any version)
  * [ox\_lib](https://github.com/overextended/ox_lib) (Required for progress bars and notifications)

## 📥 Installation

1.  Download the resource.
2.  Extract the `old_delivery` folder into your `resources` directory.
3.  Add `ensure old_delivery` to your `server.cfg`.
4.  Configure your locations and payouts in `shared/config.lua`.

## ⚙️ Configuration

The `shared/config.lua` file allows you to easily modify:

  * **Locations**: Garage, Vehicle Spawn, Loading Zone, and Delivery Zone.
  * **Rewards**: Amount of money paid per delivery.
  * **Props & Vehicles**: Add support for different trucks using the built-in prop exporter.

-----