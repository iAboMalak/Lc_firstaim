-- ══════════════════════════════════════════════════════════
-- Lc-firstaim
-- Automatically switches the camera view mode when aiming/shooting while driving
-- All configurable values live in config.lua
-- ══════════════════════════════════════════════════════════

-- Verifies the resource wasn't renamed. If the folder name doesn't match
-- Config.ExpectedResourceName, the script prints a warning and disables itself.
-- (StopResource only works server-side, so on the client we just block the script's logic instead)
local ResourceIsValid = true

CreateThread(function()
    local currentName = GetCurrentResourceName()

    if currentName ~= Config.ExpectedResourceName then
        ResourceIsValid = false
        print("^1══════════════════════════════════════^7")
        print("^1[Lc-firstaim]^7 Resource name mismatch!")
        print("^1[Lc-firstaim]^7 Expected: ^7" .. Config.ExpectedResourceName .. " ^1| Found: ^7" .. currentName)
        print("^1[Lc-firstaim]^7 Do not rename this resource. Script disabled.")
        print("^1══════════════════════════════════════^7")
        return
    end

    print("^3══════════════════════════════════════^7")
    print("^2[Lc-firstaim]^7 Script By ^6AboMalak^7")
    print("^2[Lc-firstaim]^7 Discord: ^5https://discord.gg/LcStore^7")
    print("^2[Lc-firstaim]^7 Discord: ^5https://discord.gg/8w8r6Vx8ZJs^7")
    print("^3══════════════════════════════════════^7")
end)

-- Local state variables — change while the script runs, don't edit these manually
local shot = false        -- true = player fired recently and we're still in the cooldown window
local check = false       -- true = player is currently free-aiming
local check2 = false      -- true = at least one shot has been fired, enables the reset counter
local count = 0           -- ticks elapsed since the last shot (compared against Config.ResetDelayTicks)
local currentVeh = nil    -- the vehicle the player is currently driving (nil = not driving)
local lastSeat = nil      -- the last seat the player was in, used to detect seat changes

-- Prints debug messages to the console when Config.Debug is enabled
-- Accepts any number of arguments and joins them with " | "
function debugPrint(...)
    if not Config.Debug then return end
    local args = {...}
    local out = ""
    for i = 1, #args do
        out = out .. tostring(args[i])
        if i < #args then out = out .. " | " end
    end
    print("^5[Lc-firstaim]^7 " .. out)
end

-- Applies the same view mode to every vehicle context listed in Config.VehicleContexts
-- (instead of repeating the same line 6 times, we loop over the list once)
local function setAllViewModes(mode)
    for _, ctx in ipairs(Config.VehicleContexts) do
        SetCamViewModeForContext(ctx, mode)
    end
end

-- Resets the camera to its default mode and clears all state variables
-- Called when the player leaves the driver seat, exits the vehicle, or the post-shot delay ends
function resetState()
    setAllViewModes(Config.DefaultViewMode)
    shot, check, check2, count, currentVeh, lastSeat = false, false, false, 0, nil, nil
end

-- Main loop: continuously checks the player's state (driving? aiming? shooting?)
-- and switches the camera accordingly
CreateThread(function()
    while true do
        Wait(Config.LoopWait)

        if not ResourceIsValid then
            -- Resource was renamed — stop running any logic (loop still ticks, but does nothing)
            goto continue
        end

        local ped = cache.ped
        local veh = GetVehiclePedIsUsing(ped)

        if veh and veh ~= 0 then
            -- Player is inside a vehicle — figure out exactly which seat
            local seat = -2 -- -2 = not found in any known seat yet (initial search value)
            for i = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
                if GetPedInVehicleSeat(veh, i) == ped then
                    seat = i -- -1 always means the driver seat
                    break
                end
            end

            -- If the seat changed since last check, update state
            if seat ~= lastSeat then
                debugPrint("Seat changed from " .. tostring(lastSeat) .. " to " .. tostring(seat))
                lastSeat = seat

                if seat == -1 then
                    -- Player became (or returned to being) the driver
                    debugPrint("Player is now driver")
                    currentVeh = veh
                else
                    -- Player left the driver seat (e.g. moved to a passenger seat) — reset everything
                    if currentVeh then
                        debugPrint("Player left driver seat")
                        resetState()
                    end
                end
            end

            -- Everything below only applies while the player is actually driving (seat -1)
            if seat == -1 then

                -- ── Aiming ──
                if IsPlayerFreeAiming(PlayerId()) then
                    if not check then
                        -- The moment aiming starts
                        debugPrint("Player is aiming")
                        setAllViewModes(Config.AimViewMode)
                        check = true
                    end
                elseif check then
                    -- Stopped aiming (and hasn't fired) → reset the camera immediately
                    debugPrint("Player stopped aiming")
                    setAllViewModes(Config.DefaultViewMode)
                    check = false
                end

                -- ── Shooting ──
                if IsPedShooting(ped) then
                    if not shot then
                        -- First shot fired
                        debugPrint("Player is shooting (first shot)")
                        setAllViewModes(Config.AimViewMode)
                        shot = true
                        check2 = true
                        count = 0 -- reset the counter every time a new shot is fired
                    else
                        -- Still shooting → keep resetting the counter so the camera doesn't reset mid-fire
                        count = 0
                        debugPrint("Player is shooting")
                    end
                elseif shot then
                    -- Stopped shooting: start counting ticks until Config.ResetDelayTicks is reached
                    count = count + 1
                    if count > Config.ResetDelayTicks and check2 then
                        debugPrint("Shooting ended, reset camera")
                        resetState()
                    end
                end
            end

        else
            -- Player is not inside any vehicle — if they were just driving, reset everything
            if currentVeh then
                debugPrint("Player left vehicle")
                resetState()
            end
        end

        ::continue::
    end
end)