local shot = false
local check = false
local check2 = false
local count = 0
local currentVeh = nil
local lastSeat = nil
local ResourceIsValid = true

CreateThread(function()
    local currentName = GetCurrentResourceName()

    if currentName ~= "Lc-firstaim" then
        ResourceIsValid = false
        print("^1══════════════════════════════════════^7")
        print("^1[Lc-firstaim]^7 Resource name mismatch!")
        print("^1[Lc-firstaim]^7 Expected: ^7" .. "Lc-firstaim" .. " ^1| Found: ^7" .. currentName)
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

function setAllViewModes(mode)
    for _, ctx in ipairs(Config.VehicleContexts) do
        SetCamViewModeForContext(ctx, mode)
    end
end

function resetState()
    setAllViewModes(Config.DefaultViewMode)
    shot, check, check2, count, currentVeh, lastSeat = false, false, false, 0, nil, nil
end


CreateThread(function()
    while true do
        Wait(1)

        if not ResourceIsValid then
            goto continue
        end

        local ped = cache.ped
        local veh = GetVehiclePedIsUsing(ped)

        if veh and veh ~= 0 then
            local seat = -2 
            for i = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
                if GetPedInVehicleSeat(veh, i) == ped then
                    seat = i
                    break
                end
            end

            if seat ~= lastSeat then
                debugPrint("Seat changed from " .. tostring(lastSeat) .. " to " .. tostring(seat))
                lastSeat = seat

                if seat == -1 then
                    debugPrint("Player is now driver")
                    currentVeh = veh
                else
                    if currentVeh then
                        debugPrint("Player left driver seat")
                        resetState()
                    end
                end
            end

            if seat == -1 then
                if IsPlayerFreeAiming(PlayerId()) then
                    if not check then
                        debugPrint("Player is aiming")
                        setAllViewModes(Config.AimViewMode)
                        check = true
                    end
                elseif check then
                    debugPrint("Player stopped aiming")
                    setAllViewModes(Config.DefaultViewMode)
                    check = false
                end

                if IsPedShooting(ped) then
                    if not shot then
                        debugPrint("Player is shooting (first shot)")
                        setAllViewModes(Config.AimViewMode)
                        shot = true
                        check2 = true
                        count = 0
                    else
                        count = 0
                        debugPrint("Player is shooting")
                    end
                elseif shot then
                    count = count + 1
                    if count > Config.ResetDelayTicks and check2 then
                        debugPrint("Shooting ended, reset camera")
                        resetState()
                    end
                end
            end

        else
            if currentVeh then
                debugPrint("Player left vehicle")
                resetState()
            end
        end

        ::continue::
    end
end)

-- Script By AboMalak | https://discord.gg/LcStore | https://discord.gg/8w8r6Vx8ZJs
