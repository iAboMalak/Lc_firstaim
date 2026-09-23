Config = {}

-- ═══════════════════════════════════════════
-- Resource Protection
-- ═══════════════════════════════════════════

-- The exact folder name this resource must be run under (as it appears in server.cfg / resources folder)
-- If someone renames the resource folder, the script detects the mismatch and disables itself
Config.ExpectedResourceName = "Lc-firstaim"

-- ═══════════════════════════════════════════
-- General Settings
-- ═══════════════════════════════════════════

-- true  = prints debug messages in the client console (F8) for every action the script takes
-- false = disables debug printing (keep this false in production)
Config.Debug = false

-- ═══════════════════════════════════════════
-- Camera View Modes
-- ═══════════════════════════════════════════
-- These are the values accepted by SetCamViewModeForContext:
--   1 = close third-person view (the default in most servers)
--   4 = over-the-shoulder aim camera
-- You can experiment with other numbers if you want a different camera feel

-- The view mode the camera returns to when the player is not aiming or shooting
Config.DefaultViewMode = 1

-- The view mode the camera switches to as soon as the driver aims or fires a weapon
Config.AimViewMode = 4

-- ═══════════════════════════════════════════
-- Vehicle Contexts
-- ═══════════════════════════════════════════
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

-- ═══════════════════════════════════════════
-- Camera Reset Delay
-- ═══════════════════════════════════════════
-- After the player stops shooting, the script doesn't reset the camera immediately —
-- it waits a number of "ticks" (loop iterations) before switching back to normal.
-- One tick = one pass of the main loop (see Config.LoopWait below).
-- Since the loop runs roughly every 1ms, 20 ticks ≈ about a third of a second.
-- Increase this value for a longer delay before resetting, or decrease it for a faster reset
Config.ResetDelayTicks = 20

-- ═══════════════════════════════════════════
-- Main Loop Speed
-- ═══════════════════════════════════════════
-- How many milliseconds the script waits between each check in the main loop.
-- Keep this low (1) so the script reacts instantly with no noticeable delay,
-- but don't set it to 0 — that would waste performance for no benefit
Config.LoopWait = 1