local shot = false
local check = false
local check2 = false
local count = 0
local currentVeh = nil
local lastSeat = nil

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

function resetState()
    SetCamViewModeForContext(1, 1) -- Vehicle
    SetCamViewModeForContext(2, 1) -- Motorcycle
    SetCamViewModeForContext(3, 1) -- Boat
    SetCamViewModeForContext(4, 1) -- Helicopter
    SetCamViewModeForContext(5, 1) -- Submarine
    SetCamViewModeForContext(6, 1) -- Plane
    shot, check, check2, count, currentVeh, lastSeat = false, false, false, 0, nil, nil
end

CreateThread(function()
    while true do
        Wait(1)
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
                        SetCamViewModeForContext(1, 4) -- Vehicle
                        SetCamViewModeForContext(2, 4) -- Motorcycle
                        SetCamViewModeForContext(3, 4) -- Boat
                        SetCamViewModeForContext(4, 4) -- Helicopter
                        SetCamViewModeForContext(5, 4) -- Submarine
                        SetCamViewModeForContext(6, 4) -- Plane
                        check = true
                    end
                elseif check then
                    debugPrint("Player stopped aiming")
                    SetCamViewModeForContext(1, 1) -- Vehicle
                    SetCamViewModeForContext(2, 1) -- Motorcycle
                    SetCamViewModeForContext(3, 1) -- Boat
                    SetCamViewModeForContext(4, 1) -- Helicopter
                    SetCamViewModeForContext(5, 1) -- Submarine
                    SetCamViewModeForContext(6, 1) -- Plane
                    check = false
                end

                if IsPedShooting(ped) then
                    if not shot then
                        debugPrint("Player is shooting (first shot)")
                        SetCamViewModeForContext(1, 4) -- Vehicle
                        SetCamViewModeForContext(2, 4) -- Motorcycle
                        SetCamViewModeForContext(3, 4) -- Boat
                        SetCamViewModeForContext(4, 4) -- Helicopter
                        SetCamViewModeForContext(5, 4) -- Submarine
                        SetCamViewModeForContext(6, 4) -- Plane
                        shot = true
                        check2 = true
                        count = 0
                    else
                        count = 0
                        debugPrint("Player is shooting")
                    end
                elseif shot then
                    count = count + 1
                    if count > 20 and check2 then
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
    end
end)

-- Script By AboMalak | https://discord.gg/LcStore | https://discord.gg/8w8r6Vx8ZJs