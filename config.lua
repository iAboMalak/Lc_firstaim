Config = {}

Config.Debug = false -- Set to true to print debug messages

-- Camera View Modes
-- These are the values accepted by SetCamViewModeForContext:
--   1 = close third-person view (the default in most servers)
--   4 = over-the-shoulder aim camera
-- You can experiment with other numbers if you want a different camera feel

-- The view mode the camera returns to when the player is not aiming or shooting
Config.DefaultViewMode = 1

-- The view mode the camera switches to as soon as the driver aims or fires a weapon
Config.AimViewMode = 4

-- Vehicle Contexts
-- Every vehicle in GTA V falls under a specific "context", and the script needs
-- to change the view mode for each one separately so it works across all vehicle types.
-- These are fixed game IDs (they don't change between FiveM servers):
--   1 = Vehicle (cars)
--   2 = Bike (motorcycles)
--   3 = Boat
--   4 = Heli
--   5 = Submarine
--   6 = Plane
-- Remove a number from this list if you want that vehicle type to be unaffected
Config.VehicleContexts = { 1, 2, 3, 4, 5, 6 }

-- Camera Reset Delay
-- The number of ticks it takes for the camera to return to the default view mode
-- after the player stops aiming or shooting
Config.ResetDelayTicks = 20

-- Script By AboMalak | https://discord.gg/LcStore | https://discord.gg/8w8r6Vx8ZJs