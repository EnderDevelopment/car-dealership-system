local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    -- Create dealership blip
    local blip = AddBlipForCoord(Config.DealershipBlip.x, Config.DealershipBlip.y, Config.DealershipBlip.z)
    SetBlipSprite(blip, 225)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Config.DealershipName)
    EndTextCommandSetBlipName(blip)

    -- Create dealership marker
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - vector3(Config.DealershipMarker.x, Config.DealershipMarker.y, Config.DealershipMarker.z))

            if distance < 10.0 then
                DrawMarker(1, Config.DealershipMarker.x, Config.DealershipMarker.y, Config.DealershipMarker.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)

                if distance < 1.5 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to access the dealership')

                    if IsControlJustReleased(0, 38) then
                        OpenDealershipMenu()
                    end
                end
            end
        end
    end)

    -- Function to open dealership menu
    function OpenDealershipMenu()
        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dealership_menu', {
            title = Config.DealershipName,
            align = 'top-left',
            elements = {
                {label = 'Buy Car', value = 'buy_car'},
                {label = 'Sell Car', value = 'sell_car'},
                {label = 'View Inventory', value = 'view_inventory'}
            }
        }, function(data, menu)
            if data.current.value == 'buy_car' then
                TriggerServerEvent('car_dealership_tycoon:buyCar')
            elseif data.current.value == 'sell_car' then
                TriggerServerEvent('car_dealership_tycoon:sellCar')
            elseif data.current.value == 'view_inventory' then
                TriggerServerEvent('car_dealership_tycoon:viewInventory')
            end
        end, function(data, menu)
            menu.close()
        end)
    end

    -- Function to spawn car
    function SpawnCar(carModel)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)

        ESX.Game.SpawnVehicle(carModel, vector3(Config.CarSpawnPoint.x, Config.CarSpawnPoint.y, Config.CarSpawnPoint.z), heading, function(vehicle)
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            SetVehicleNumberPlateText(vehicle, 'DEALER')
        end)
    end

    -- Event to spawn car
    RegisterNetEvent('car_dealership_tycoon:spawnCar')
    AddEventHandler('car_dealership_tycoon:spawnCar', function(carModel)
        SpawnCar(carModel)
    end)

    -- Event to show notification
    RegisterNetEvent('car_dealership_tycoon:showNotification')
    AddEventHandler('car_dealership_tycoon:showNotification', function(message)
        ESX.ShowNotification(message)
    end)
end)