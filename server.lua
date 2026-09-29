local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Function to buy car
ESX.RegisterServerCallback('car_dealership_tycoon:buyCar', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local carPrice = Config.BaseCarPrice

    if xPlayer.getMoney() >= carPrice then
        xPlayer.removeMoney(carPrice)
        TriggerClientEvent('car_dealership_tycoon:spawnCar', source, 'adder')
        cb(true)
    else
        TriggerClientEvent('car_dealership_tycoon:showNotification', source, 'You do not have enough money to buy this car')
        cb(false)
    end
end)

-- Function to sell car
ESX.RegisterServerCallback('car_dealership_tycoon:sellCar', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local carPrice = Config.BaseCarPrice * Config.PriceMultiplier

    xPlayer.addMoney(carPrice)
    TriggerClientEvent('car_dealership_tycoon:showNotification', source, 'You have sold your car for ~g~$' .. carPrice)
    cb(true)
end)

-- Function to view inventory
ESX.RegisterServerCallback('car_dealership_tycoon:viewInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = {}

    MySQL.Async.fetchAll('SELECT * FROM car_dealership_tycoon WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        for i=1, #result, 1 do
            table.insert(inventory, {
                label = result[i].car_model .. ' - Condition: ' .. result[i].car_condition .. '%',
                value = result[i].id
            })
        end

        cb(inventory)
    end)
end)