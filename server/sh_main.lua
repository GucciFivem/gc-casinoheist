local QBCore = exports['qb-core']:GetCoreObject()
local VaultSpawned = false
local Cooldown = false

-- qbcore function create callback named gc-casinoheist:server:cops
QBCore.Functions.CreateCallback('gc-casinoheist:server:Cops', function(source, cb)
    local cops = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer()
        if Player ~= nil then
            if Player.PlayerData.job.name == 'police' then
                cops = cops + 1
            end
        end
    end
    cb(cops)
end)
--register netevent called gc-casinoheist:server:spawnvault
RegisterNetEvent('gc-casinoheist:server:spawnvault', function(type)
    print('Vault Spawned?', VaultSpawned)
    if not VaultSpawned then
        vault = CreateObject(`ch_prop_ch_vaultdoor01x`, Config.VaultDoorSpawn[1].x - 0.05, Config.VaultDoorSpawn[1].y + 1, Config.VaultDoorSpawn[1].z - 2.03, true, true, true)
        SetEntityHeading(vault, 58.00)
        FreezeEntityPosition(vault, true)
        VaultSpawned = true
        print('Vault Spawned?', VaultSpawned)
    end
end)

-- register netevent called gc-casinoheist:server:lockeritem
RegisterNetEvent('gc-casinoheist:server:LockerItem', function(type)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    player.functions.AddItem('10kgoldchain', math.random(5,10))
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['10kgoldchain'], "add")
    chance = math.random(1,100)
    if chance >= 45 then
        player.Functions.AddItem('diamond_ring', math.random(5,10))
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['diamond_ring'], "add")
    end
end)

-- register networkevent called gc-casinoheist:server:CartItem
RegisterNetEvent('gc-casinoheist:server:CartItem', function(type)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local info = {
        worth = math.random(Config.MarkedMin, Config.MarkedMax)
    }
    player.Functions.AddItem('markedbills', math.random(Config.MarkedBagMin, Config.MarkedBagMax))
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "add")
end)

--register netevent called gc-casinoheist:server:Gold
RegisterNetEvent('gc-casinoheist:server:Gold', function(type)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    player.Functions.AddItem('goldbar', math.random(Config.GoldMin, Config.GoldMax))
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], "add")
end)

-- register netevent called gc-casinoheist:server:RobberyBlip
RegisterNetEvent('gc-casinoheist:server:RobberyBlip', function(type)
    local data = {displaycode = '10-68', description = 'Casino Robbery', isImportant = 1, recipientList = {'police'}, length = '20000', infoM = 'fa-info-circle', info = 'Alarm triggered at Diamond Casino & Resort'}
    local dispatchData = {dispatchData = data, caller = 'Alarm', coords = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        }
    }
    TriggerEvent('sv_Dispatch', dispatchData)
end)

-- regsiter netevent that syncs the vault with the server
RegisterNetEvent('gc-casinoheist:server:VaultSync', function(status)
    if status == true then
        SetEntityHeading(vault, 58.00)
        FreezeEntityPosition(vault, true)
    elseif status == false then
        TriggerClientEvent('gc-casinoheist:client:Bomb', -1)
        FreezeEntityPosition(vault, false)
        DeleteEntity(vault)
    end
end)

-- Thermite ptfx
RegisterNetEvent('gc-casinoheist:server:ThermitePtfx', function(coords)
    TriggerClientEvent('gc-casinoheist:client:ThermitePtfx', -1, coords)
end)

RegisterServerEvent('gc-casinoheist:server:cooldown')
AddEventHandler('gc-casinoheist:server:cooldown', function()
    Cooldown = true
    local timer = 60000 * 60000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            Cooldown = false
        end
    end
end)

QBCore.Functions.CreateCallback("gc-casinoheist:Cooldown", function(source, cb)
    if Cooldown then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("gc-casinoheist:success") 
AddEventHandler("gc-casinoheist:success", function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['laptop_purple'], 'remove')
    player.Functions.RemoveItem("laptop_purple", 1)
end)

RegisterServerEvent("gc-casinoheist:success1") 
AddEventHandler("gc-casinoheist:success1", function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['trojan_usb'], 'remove')
    player.Functions.RemoveItem("trojan_usb", 1)
end)

RegisterServerEvent("gc-casinoheist:successthermite") 
AddEventHandler("gc-casinoheist:successthermite", function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['thermite'], 'remove')
    player.Functions.RemoveItem("thermite", 1)
end)