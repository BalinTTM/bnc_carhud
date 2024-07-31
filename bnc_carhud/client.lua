function open()
    SendNUIMessage({
        type = 'ui',
        status = true,
    })
end

function close()
    SendNUIMessage({
        type = 'ui',
        status = false,
    })
end

local speed = 0
local rpm = 0
local isPause = false
local sleep = 450
local visible = false
local inveh = false

-- Send data to HTML
Citizen.CreateThread(function()
    while true do
        local ped =  PlayerPedId()
        inveh = IsPedInAnyVehicle(PlayerPedId(), false)
        if inveh then
            if not visible then
                open()
                visible = true
            end
            sleep = 125
            local veh = GetVehiclePedIsIn(ped, false)
            local speed = GetEntitySpeed(veh) * 3.6 -- Calculate kmh use 2.2 for mph
            local rpm = GetVehicleCurrentRpm(veh) * 10000
            local gear = GetVehicleCurrentGear(veh)
            if gear == 0 then
                gear = 'R'
                if speed < 1 then
                    gear = 'N'
                end
            end
            rpm = math.floor(rpm)
            speed = math.floor(speed)
            SendNUIMessage({
                type = 'update',
                speed = speed,
                rpm = rpm,
                gear = gear,
            })
        else
            if visible then
                close()
                visible = false
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- Disable HUD while pause menu is active
Citizen.CreateThread(function()
    while true do
        if inveh then
            if IsPauseMenuActive() then 
                isPause = true
                SendNUIMessage({
                    type = 'ui',
                    status = false,
                })
            
            elseif not IsPauseMenuActive() and isPause then
                isPause = false
                SendNUIMessage({
                    type = 'ui',
                    status = true,
                })
            end
        end
        Citizen.Wait(250)
    end
end)