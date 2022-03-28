local QBCore = exports['qb-core']:GetCoreObject()

Config = Config or {}
local isBusy = false
local call = false
local VaultSpawned = false
local cops = 0


RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('qb-police:CopCount', function()
    cops = amount
end)


CreateThread(function()
    Wait(2000)
    ks_casino_vault = getInteriorByType(946.251,43.2715,58.9172,"ks_casino_vault", "ks_casino_vault_milo_")
	DisableInteriorProp(ks_casino_vault, "set_vault_door_broken")
	DisableInteriorProp(ks_casino_vault, "set_vault_door")
	EnableInteriorProp(ks_casino_vault, "set_vault_door_closed")
	RefreshInterior(ks_casino_vault)
    TriggerServerEvent('gc-casinoheist:server:spawnvault')
end)

function getInteriorByType(x, y, z, name, iplName)
    local id = 0

    if not IsIplActive(iplName) then
        RequestIpl(iplName)
        
        while not IsIplActive(iplName) do 
            Wait(20)
        end
    end

    while id == 0 do 
        id = GetInteriorAtCoords(x, y, z, name)
        Wait(20)
    end

    return id
end

-- loads animation
local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

--Updates the casino IPL
local function UpdateIPL()
    EnableInteriorProp(ks_casino_vault, "set_vault_door_broken")
    Wait(500)
    RefreshInterior(ks_casino_vault)
    print('made by gucci')
end

--Spawns the cash carts
function Carts()
    local model = "hei_prop_hei_cash_trolly_01"
    RequestModel(model)
    while not HasModelLoaded(model) do RequestModel(model) Wait(100) end
    ClearAreaOfObjects(989.14, 50.54, 10, 0)
    for i = 1, 4 do
        local obj = GetClosestObjectOfType(Config.Trolleys[i].coords, 3.0, `hei_prop_hei_cash_trolly_01`, false, false, false)
        if obj ~= 0 then
            DeleteObject(obj)
            Wait(1)
        end
        CreateObject(model, Config.Trolleys[i].coords, true, true, false)
        exports['qb-target']:AddBoxZone("cashcarts"..i, vector3(Config.Trolleys[i].coords), 1, 1, {
            name = "cashcarts"..i,
            heading = Config.Trolleys[i].h,
            debugPoly = false,
            minZ = Config.Trolleys[i].coords.z,
            maxZ = Config.Trolleys[i].coords.z + 1.2,
        }, {
            options = {
                {
                    type = "client",
                    event = "gc-casinoheist:client:CashGrab",
                    icon = "fas fa-hand",
                    label = "Grab Cash",
                },
            },
            distance = 1.5
        })
    end
end
--Spawns gold carts
local function GoldCarts()
    local model = "ch_prop_gold_trolly_01a"
    RequestModel(model)
    while not HasModelLoaded(model) do RequestModel(model) Wait(100) end
    ClearAreaOfObjects(989.14, 50.54, 59.65, 10, 0)
    for i = 1, 1 do
        local obj = GetClosestObjectOfType(Config.GoldTrolleys[i].coords, 3.0, `ch_prop_gold_trolly_01a`, false, false, false)
        if obj ~= 0 then
            DeleteObject(obj)
            Wait(1)
        end
        CreateObject(model, Config.GoldTrolleys[i].coords, true, true, false)
        exports['qb-target']:AddBoxZone("GoldTrolly"..i, vector3(Config.GoldTrolleys[i].coords), 1, 1, {
            name = "GoldTrolly"..i,
            heading = Config.GoldTrolleys[i].h,
            debugPoly = false,
            minZ = Config.GoldTrolleys[i].coords.z,
            maxZ = Config.GoldTrolleys[i].coords.z + 1.2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "gc-casinoheist:client:GoldGrab",
                        icon = "fas fa-hand",
                        label = "Grab Gold Bars",
                    },
                },
                distance = 1.5
        })
    end
end
--Spawns cash piles
local function CashPile()
    local model = "h4_prop_h4_cash_stack_01a"
    RequestModel(model)
    while not HasModelLoaded(model) do RequestModel(model) Wait(100) end
    for i = 1, 7 do
        local obj = GetClosestObjectOfType(Config.CashPile[i].coords, 3.0, `h4_prop_h4_cash_stack_01a`, false, false, false)
        if obj ~= 0 then
            DeleteObject(obj)
            Wait(1)
        end
        local cock = CreateObject(model, Config.CashPile[i].coords, true, true, false)
        SetEntityHeading(cock, Config.CashPile[i].h)
        exports['qb-target']:AddBoxZone("CashPile"..i, vector3(Config.CashPile[i].coords), 1, 1, {
            name = "CashPile"..i,
            heading = Config.CashPile[i].h,
            debugPoly = false,
            minZ = Config.CashPile[i].coords.z - 0.5,
            maxZ = Config.CashPile[i].coords.z + 0.5,
            }, {
                options = {
                    {
                        type = "client",
                        event = "gc-casinoheist:client:CashPile",
                        icon = "fas fa-hand",
                        label = "Grab Cash",
                    },
                },
                distance = 1.5
        })
    end
end
-- drilling spots
local function Lockers()
    for i = 1, 4 do
        exports['qb-target']:AddBoxZone("DrillSpots"..i, vector3(Config.DrillSpots[i].coords), 1, 1, {
            name = "DrillSpots"..i,
            heading = 0.00,
            debugPoly = false,
            minZ = Config.DrillSpots[i].coords.z - 0.5,
            maxZ = Config.DrillSpots[i].coords.z + 0.5,
            }, {
                options = {
                    {
                        type = "client",
                        event = "gc-casinoheist:client:Drill",
                        icon = "fas fa-circle",
                        label = "Drill Security Boxes",
                    },
                },
                distance = 1.5
        })
    end
end   
-- thermite plantinfg
function ThermitePlanting()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end

    local ped = PlayerPedId()
    SetEntityHeading(ped, 253.63)
    local pos = vector3(950.60, 26.6, 71.84)
    Citizen.Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(ped)))
    local bagscene = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), pos.x, pos.y, pos.z,  true,  true, false)
    SetEntityCollision(bag, false, true)

    local x, y, z = table.unpack(GetEntityCoords(ped))
    local thermite = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.2,  true,  true, true)
    SetEntityCollision(thermite, false, true)
    AttachEntityToEntity(thermite, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(5000)
    DetachEntity(thermite, 1, 1)
    FreezeEntityPosition(thermite, true)
    DeleteObject(bag)
    NetworkStopSynchronisedScene(bagscene)
    Citizen.CreateThread(function()
        Citizen.Wait(15000)
        DeleteEntity(thermite)
    end)
end
-- thermite effect
function ThermiteEffect()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") do
        Citizen.Wait(50)
    end
    local ped = PlayerPedId()
    local ptfx = vector3(950.60, 26.6, 71.84)
    Citizen.Wait(1500)
    TriggerServerEvent("gc-casinoheist:server:ThermitePtfx", ptfx)
    Citizen.Wait(500)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
    Citizen.Wait(12000)
    ClearPedTasks(ped)
    Citizen.Wait(2000)
    QBCore.Functions.Notify("The lock had been melted", "success")
    TriggerServerEvent('qb-doorlock:server:updateState', Config.CasinoDoor1, false)
end
-- drill anim
local function DrillAnim(Config)
    local animDict = "anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_01@male@"
    local animDict2 = "anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_02@male@"
    local ped = GetPlayerPed(-1)
    coords = GetEntityCoords(ped)

    Locker = GetClosestObjectOfType(coords, 1.5, `ch_prop_ch_sec_cabinet_01j`, false, false, false)

    if Locker == 0 then
        return 
    end

    LockerPos = GetEntityCoords(Locker)
    LockerHead = GetEntityCoords(Locker)
    rot = GetEntityHeading(Locker)
    SetEntityVisible(Locker, false)
    SetEntityAsMissionEntity(Locker, true, true)
    DeleteEntity(Locker)
    DeleteObject(Locker)

    Locker2 = GetClosestObjectOfType(coords, 1.5, `ch_prop_ch_sec_cabinet_01j`, false, false, false)
    print('Locker',Locker)
    print('Locker2', Locker2)
    SetEntityVisible(Locker2, false)
    SetEntityAsMissionEntity(Locker2, true, true)
    DeleteEntity(Locker2)
    DeleteObject(Locker2)

    local obj = CreateObject(-2110344306, LockerPos, 1, 0, 0)
    SetEntityHeading(obj, LockerHead)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    SetEntityCollision(obj, true, true)

    NewLockerPos = GetEntityCoords(obj)

    while not NetworkHasControlOfEntity(obj) do
		Wait(1)
		NetworkRequestControlOfEntity(obj)
	end

    RequestModel("ch_p_m_bag_var02_arm_s")
    RequestModel("ch_prop_vault_drill_01a")
    RequestModel("ch_prop_ch_moneybag_01a")
    RequestAnimDict(animDict)
    RequestAnimDict(animDict2)
    while not HasAnimDictLoaded(animDict) or not HasAnimDictLoaded(animDict2) or not HasModelLoaded('ch_p_m_bag_var02_arm_s') or not HasModelLoaded('ch_prop_ch_moneybag_01a') or not HasModelLoaded('ch_prop_vault_drill_01a') do
        Wait(100)
        print('Requesting Assets')
    end

    local targetPosition = GetEntityCoords(obj)
    local targetRotation = vector3(0.0, 0.0, rot)
    local animPos = GetAnimInitialOffsetPosition(animDict, "enter", targetPosition[1], targetPosition[2], targetPosition[3], targetRotation, 0, 2)
    local targetHeading = rot
    TaskGoStraightToCoord(ped, animPos, 0.025, 5000, targetHeading, 0.05)

    Citizen.Wait(4000)
    SetPedComponentVariation(ped, 5, 0, 0, 0)

    local bag = CreateObject(`ch_p_m_bag_var02_arm_s`, targetPosition, 1, 1, 0)
    local drill = CreateObject(`ch_prop_vault_drill_01a`, targetPosition, 1, 1, 0)
    local money = CreateObject(`ch_prop_vault_drill_01a`, targetPosition, 1, 1, 0)
    SetEntityVisible(money, false)

    local netScene = NetworkCreateSynchronisedScene(NewLockerPos[1], NewLockerPos[2], NewLockerPos[3], targetRotation, 2, true, false, 1065353216, 0, 1065353216)
    NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "enter", 1.0, -4.0, 157, 92, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "enter_p_m_bag_var22_arm_s", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(drill, netScene, animDict, "enter_ch_prop_vault_drill_01a", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(obj, netScene, animDict, "enter_ch_prop_ch_sec_cabinet_01abc", 1.0, -4.0, 157)
    

    local netScene2 = NetworkCreateSynchronisedScene(NewLockerPos[1], NewLockerPos[2], NewLockerPos[3], targetRotation, 2, false, true, 1065353216, 0, 1065353216)
    NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "action", 1.0, -4.0, 157, 92, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "action_p_m_bag_var22_arm_s", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(drill, netScene2, animDict, "action_ch_prop_vault_drill_01a", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(obj, netScene2, animDict, "action_ch_prop_ch_sec_cabinet_01abc", 1.0, -4.0, 157)
   

    local netScene3 = NetworkCreateSynchronisedScene(NewLockerPos[1], NewLockerPos[2], NewLockerPos[3], targetRotation, 2, true, false, 1065353216, 0, 1065353216)
    NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "reward", 1.0, -4.0, 157, 92, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "reward_p_m_bag_var22_arm_s", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(drill, netScene3, animDict, "reward_ch_prop_vault_drill_01a", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(money, netScene3, animDict, "reward_ch_prop_ch_moneybag_01a", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(obj, netScene3, animDict, "reward_ch_prop_ch_sec_cabinet_01abc", 4.0, -8.0, 157)
    

    local netScene5 = NetworkCreateSynchronisedScene(NewLockerPos[1], NewLockerPos[2], NewLockerPos[3], targetRotation, 2, false, true, 1065353216, 0, 1065353216)
    NetworkAddPedToSynchronisedScene(ped, netScene5, animDict2, "action", 1.0, -4.0, 157, 92, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene5, animDict2, "action_p_m_bag_var22_arm_s", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(drill, netScene5, animDict2, "action_ch_prop_vault_drill_01a", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(obj, netScene5, animDict2, "action_ch_prop_ch_sec_cabinet_01abc", 1.0, -4.0, 157)
    

    local netScene6 = NetworkCreateSynchronisedScene(NewLockerPos[1], NewLockerPos[2], NewLockerPos[3], targetRotation, 2, true, false, 1065353216, 0, 1065353216)
    NetworkAddPedToSynchronisedScene(ped, netScene6, animDict2, "reward", 1.0, -4.0, 157, 92, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene6, animDict2, "reward_p_m_bag_var22_arm_s", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(drill, netScene6, animDict2, "reward_ch_prop_vault_drill_01a", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(money, netScene6, animDict2, "reward_ch_prop_ch_moneybag_01a", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(obj, netScene6, animDict2, "reward_ch_prop_ch_sec_cabinet_01abc", 4.0, -8.0, 157)
    

    local netScene7 = NetworkCreateSynchronisedScene(NewLockerPos[1], NewLockerPos[2], NewLockerPos[3], targetRotation, 2, true, false, 1065353216, 0, 1065353216)
    NetworkAddPedToSynchronisedScene(ped, netScene7, "anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_03@male@", "exit", 1.0, -4.0, 157, 92, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, netScene7, "anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_03@male@", "exit_p_m_bag_var22_arm_s", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(drill, netScene7, "anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_03@male@", "exit_ch_prop_vault_drill_01a", 1.0, -4.0, 157)
    NetworkAddEntityToSynchronisedScene(obj, netScene7, "anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_03@male@", "exit_ch_prop_ch_sec_cabinet_01abc", 4.0, -8.0, 157)
    

    local netScene8 = NetworkCreateSynchronisedScene(NewLockerPos[1], NewLockerPos[2], NewLockerPos[3], targetRotation, 2, true, true, 1065353216, 0, 1065353216, 2.0)
    NetworkAddEntityToSynchronisedScene(obj, netScene8, 'anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_03@male@', "idle_ch_prop_ch_sec_cabinet_01abc", 4.0, -8.0, 157)

    NetworkStartSynchronisedScene(netScene)
    Wait(GetAnimDuration(animDict, 'enter') * 1000)

    NetworkStartSynchronisedScene(netScene2)
    Wait(GetAnimDuration(animDict, 'action') * 1000)
    
    SetEntityVisible(money, true)
    NetworkStartSynchronisedScene(netScene3)
    Wait(GetAnimDuration(animDict, 'reward') * 1000)
    
    SetEntityVisible(money, false)

   

    NetworkStartSynchronisedScene(netScene5)
    Wait(GetAnimDuration(animDict2, 'action') * 1000)
  
    SetEntityVisible(money, true)
    NetworkStartSynchronisedScene(netScene6)
    Wait(GetAnimDuration(animDict2, 'reward') * 1000)
    

    NetworkStartSynchronisedScene(netScene7)
    Wait(GetAnimDuration('anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_03@male@', 'exit') * 1000)
    NetworkStartSynchronisedScene(netScene8)
    
    RemoveAnimDict(animDict)
    RemoveAnimDict(animDict2)
    RemoveAnimDict("anim_heist@hs3f@ig10_lockbox_drill@pattern_01@lockbox_03@male@")
    
    DeleteObject(bag)
    DeleteObject(drill)
    DeleteObject(money)
    -- DeleteObject(obj)
    SetEntityVisible(Locker, true)
    FreezeEntityPosition(ped, false)
    SetPedComponentVariation(ped, 5, 82, 3, 0)
end
-- events 
-- cash grab event
RegisterNetEvent('gc-casinoheist:client:CashGrab', function()
    TriggerEvent('gc-casinoheist:client:Closest', closestTrolley)
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"
    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, `hei_prop_hei_cash_trolly_01`, false, false, false)
    local CashAppear = function()
	    local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)
        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Wait(100)
        end
	    local grabobj = CreateObject(grabmodel, pedCoords, true)
	    FreezeEntityPosition(grabobj, true)
	    SetEntityInvincible(grabobj, true)
	    SetEntityNoCollisionEntity(grabobj, ped)
	    SetEntityVisible(grabobj, false, false)
	    AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	    local startedGrabbing = GetGameTimer()
	    Citizen.CreateThread(function()
		    while GetGameTimer() - startedGrabbing < 37000 do
			    Wait(1)
			    DisableControlAction(0, 73, true)
			    if HasAnimEventFired(ped, `CASH_APPEAR`) then
				    if not IsEntityVisible(grabobj) then
					    SetEntityVisible(grabobj, true, false)
				    end
			    end
			    if HasAnimEventFired(ped, `RELEASE_CASH_DESTROY`) then
				    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
				    end
			    end
		    end
		    DeleteObject(grabobj)
	    end)
    end
	local trollyobj = Trolley
    local emptyobj = `hei_prop_hei_cash_trolly_03`

	if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return
    end

    print(GetEntityHeading(trollyobj))
    local rot = GetEntityHeading(trollyobj)
    local targetPosition = GetEntityCoords(trollyobj)
    local targetRotation = vector3(0.0, 0.0, rot)
    local animPos = GetAnimInitialOffsetPosition('anim@heists@ornate_bank@grab_cash', "intro", targetPosition[1], targetPosition[2], targetPosition[3], targetRotation, 0, 2)
    local targetHeading = rot
    TaskGoStraightToCoord(ped, animPos, 0.025, 5000, targetHeading, 0.05)
    Wait(2500)

    local baghash = `ch_p_m_bag_var02_arm_s`
    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Wait(100)
    end
	while not NetworkHasControlOfEntity(trollyobj) do
		Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	local bag = CreateObject(`ch_p_m_bag_var02_arm_s`, GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(scene1)
	Wait(1500)
	CashAppear()
	local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, true, true, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)
	Wait(37000)
	local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)
    TriggerServerEvent('gc-casinoheist:server:CartItem')
	Wait(1800)
	DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 82, 3, 0)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
	SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(`ch_p_m_bag_var02_arm_s`)
    LocalPlayer.state:set("inv_busy", false, true)
    print('closestTrolly',closestTrolly)
    Config.Trolleys[closestTrolly].hit = true
end)
-- cash pile grab
RegisterNetEvent('gc-casinoheist:client:CashPile', function()
    LocalPlayer.state:set("inv_busy", true, true)
    local ped = PlayerPedId()
    local model = "h4_prop_h4_cash_stack_01a"
    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, `h4_prop_h4_cash_stack_01a`, false, false, false)
	local trollyobj = Trolley

	if IsEntityPlayingAnim(trollyobj, "anim@scripted@heist@ig1_table_grab@cash@male@", "grab_cash", 3) then
		return
    end

    local baghash = `ch_p_m_bag_var02_arm_s`
    RequestAnimDict("anim@scripted@heist@ig1_table_grab@cash@male@")
    RequestModel(baghash)
    while not HasAnimDictLoaded("anim@scripted@heist@ig1_table_grab@cash@male@") and not HasModelLoaded(baghash) do
        Wait(100)
    end
	while not NetworkHasControlOfEntity(trollyobj) do
		Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end

    local rot = GetEntityHeading(trollyobj)
    local targetPosition = GetEntityCoords(trollyobj)
    local targetRotation = vector3(0.0, 0.0, rot)
    local animPos = GetAnimInitialOffsetPosition('anim@scripted@heist@ig1_table_grab@cash@male@', "enter", targetPosition[1], targetPosition[2], targetPosition[3], targetRotation, 0, 2)
    local targetHeading = rot
    TaskGoStraightToCoord(ped, animPos, 0.025, 5000, targetHeading, 0.05)
    Wait(2500)

	local bag = CreateObject(`ch_p_m_bag_var02_arm_s`, GetEntityCoords(PlayerPedId()), true, false, false)

    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, true, false, 1065353216, 0, 1.0)
	NetworkAddPedToSynchronisedScene(ped, scene1, "anim@scripted@heist@ig1_table_grab@cash@male@", "enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@scripted@heist@ig1_table_grab@cash@male@", "enter_bag", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(scene1)

	Wait(1750)

	local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, true, false, 1065353216, 0, 1.0)
	NetworkAddPedToSynchronisedScene(ped, scene2, "anim@scripted@heist@ig1_table_grab@cash@male@", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@scripted@heist@ig1_table_grab@cash@male@", "grab_bag", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@scripted@heist@ig1_table_grab@cash@male@", "grab_cash", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)

	Wait(14000)

	local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, true, false, 1065353216, 0, 1.0)
	NetworkAddPedToSynchronisedScene(ped, scene3, "anim@scripted@heist@ig1_table_grab@cash@male@", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@scripted@heist@ig1_table_grab@cash@male@", "exit_bag", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)

    Wait(1700)

	while not NetworkHasControlOfEntity(trollyobj) do
		Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
    
    TriggerServerEvent('gc-casinoheist:server:CartItem')

	DeleteObject(trollyobj)
    DeleteEntity(trollyobj)
	DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 82, 3, 0)
	RemoveAnimDict("anim@scripted@heist@ig1_table_grab@cash@male@")
    SetModelAsNoLongerNeeded(`ch_p_m_bag_var02_arm_s`)
    LocalPlayer.state:set("inv_busy", false, true)
end)

local function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == `mp_m_freemode_01` then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

RegisterNetEvent("gc-casinoheist:client:ThermitePtfx", function(coords)
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_ornate_heist_thernite_burn", coords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Citizen.Wait(5000)
    StopParticleFxLooped(effect, 0)
end)

function HackFailed()
    QBCore.Functions.Notify("Should of worked! sikeee you failed L bozo", "error", "6000")
    if math.random(1, 100) <= 40 then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        QBCore.Functions.Notify("You left a fingerprint!", "success", "6000")
    end
end

function call()
    local chance = 10
    if math.random(1, 100) <= chance then
        TriggerServerEvent('police:server:policeAlert', 'Casino Robbery')
    end
end

local function hackanim()
    local animDict = "anim@heists@ornate_bank@hack"
    RequestAnimDict(animDict)
    RequestModel("hei_prop_hst_laptop")
    RequestModel("ch_p_m_bag_var03_arm_s") 
    local loc = {x,y,z,h}
    loc.x = 969.66 
    loc.y = 12.60
    loc.z = 71.50
    loc.h = 58.32
    while not HasAnimDictLoaded(animDict)
        or not HasModelLoaded("hei_prop_hst_laptop")
        or not HasModelLoaded("ch_p_m_bag_var03_arm_s") do
        Wait(100)
    end
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
    local animPos = GetAnimInitialOffsetPosition(animDict, "hack_enter", loc.x + 0, loc.y + 0, loc.z + 0.85)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, "hack_loop", loc.x + 0, loc.y + 0, loc.z + 0.85)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "hack_exit", loc.x + 0, loc.y + 0, loc.z + 0.85)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasitem)
            if hasitem then
                
                bag = CreateObject(`ch_p_m_bag_var03_arm_s`, targetPosition, 1, 1, 0)
                laptop = CreateObject(`hei_prop_hst_laptop`, targetPosition, 1, 1, 0)
                local IntroHack = NetworkCreateSynchronisedScene(animPos, targetRotation, 0, true, false, 1065353216, 0, 1.3)
                NetworkAddPedToSynchronisedScene(ped, IntroHack, animDict, "hack_enter", 0, 0, 1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(bag, IntroHack, animDict, "hack_enter_bag", 4.0, -8.0, 1)
                NetworkAddEntityToSynchronisedScene(laptop, IntroHack, animDict, "hack_enter_laptop", 4.0, -8.0, 1)
                HackLoop = NetworkCreateSynchronisedScene(animPos2, targetRotation, 2, false, true, 1065353216, -1, 1.0)
                NetworkAddPedToSynchronisedScene(ped, HackLoop, animDict, "hack_loop", 0, 0, -1, 1, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(bag, HackLoop, animDict, "hack_loop_bag", 1.0, 0.0, 1)
                NetworkAddEntityToSynchronisedScene(laptop, HackLoop, animDict, "hack_loop_laptop", 1.0, -0.0, 1)
                HackLoopFinish = NetworkCreateSynchronisedScene(animPos3, targetRotation, 2, false, false, 1065353216, -1, 1.3)
                NetworkAddPedToSynchronisedScene(ped, HackLoopFinish, animDict, "hack_exit", 0, 0, -1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(bag, HackLoopFinish, animDict, "hack_exit_bag", 4.0, -8.0, 1)
                NetworkAddEntityToSynchronisedScene(laptop, HackLoopFinish, animDict, "hack_exit_laptop", 4.0, -8.0, 1)
                SetPedComponentVariation(ped, 5, 0, 0, 0)
                NetworkStartSynchronisedScene(IntroHack)
                TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["laptop_purple"], "remove")
                TriggerServerEvent("QBCore:Server:RemoveItem", "laptop_purple", 1)
                Wait(6000)
                FreezeEntityPosition(PlayerPedId(), true)
                NetworkStopSynchronisedScene(IntroHack)
                NetworkStartSynchronisedScene(HackLoop)
                exports['hacking']:OpenHackingGame(8, 4, 1, function(Success)
                    if Success then -- success
                        NetworkStopSynchronisedScene(HackLoop)
                        NetworkStartSynchronisedScene(HackLoopFinish)
                        Wait(6000)
                        NetworkStopSynchronisedScene(HackLoopFinish)
                        DeleteObject(bag)
                        DeleteObject(laptop)
                        HackSuccess()
                        FreezeEntityPosition(PlayerPedId(), false)
                        SetPedComponentVariation(PlayerPedId(), 5, 82, 3, 0)
       
                    else
                        NetworkStopSynchronisedScene(HackLoop)
                        NetworkStartSynchronisedScene(HackLoopFinish)
                        Wait(6000)
                        NetworkStopSynchronisedScene(HackLoopFinish)
                        DeleteObject(bag)
                        DeleteObject(laptop)
                        HackFailed()
                        FreezeEntityPosition(PlayerPedId(), false)
                        SetPedComponentVariation(PlayerPedId(), 5, 82, 3, 0)
                    end
                end)
            
            else
                QBCore.Functions.Notify('You do not have the required items!', "error")
            end
        end, "laptop_purple")
end

    
function HackSuccess()
    QBCore.Functions.Notify("Vault opened", "success", "6000")
    TriggerServerEvent('gc-casinoheist:server:cooldown')
    TriggerServerEvent('qb-doorlock:server:updateState', Config.UpperVault, false)
    CashPile()
    Carts()
    Lockers()
end

RegisterNetEvent('gc-casinoheist:client:UpperVaultHack', function()
    hackanim()
end)

exports['qb-target']:AddBoxZone('uppervault', vector3(969.66, 12.80, 71.50), 1, 1, {
    name = 'uppervault',
    heading = 57.59,
    debugpoly = false,
    minZ = 71.50,
    maxZ = 72.50,
    }, {
        options = {
            {
                type = 'client',
                event = 'gc-casinoheist:client:UpperVaultHack',
                icon = 'fas fa-laptop',
                label = 'Hack Upper Vault',
            },
        },
    distance = 1.5
})

function Doorhack()
    local pos = GetEntityCoords(PlayerPedId())
    if LocalPlayer.state.isLoggedIn then
        QBCore.Functions.TriggerCallback("gc-casinoheist:Cooldown", function(cooldown)
            if not Cooldown then
                if cops >= 0 then
                    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasitem)
                        if hasitem then
                            call()
                            exports['hacking']:OpenHackingGame(8, 4, 1, function(Success)
                                if Success then -- success
                                    ClearPedTasksImmediately(PlayerPedId())
                                    HackSuccess1()
                                else
                                    Citizen.Wait(1000)
                                    ClearPedTasksImmediately(PlayerPedId())
                                    HackFailed1()
                                end
                            end)
                        else
                            QBCore.Functions.Notify('You do not have the required items!', "error")
                        end
                    end, "trojan_usb")
                else
                    QBCore.Functions.Notify('Not Enough Cops', "error")
                end
            else
                QBCore.Functions.Notify('Cooldown', "error")
            end
        end)
    else
        Citizen.Wait(3000)
    end
end

function HackFailed1()
    QBCore.Functions.Notify("Should of worked! sikeee you failed L bozo", "error", "6000")
    if math.random(1, 100) <= 40 then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        QBCore.Funtions.Notify("You left a fingerprint!", "success", "6000")
    end
end

function HackSuccess1()
    QBCore.Functions.Notify("Door opened", "success", "6000")
    ClearPedTasksImmediately(PlayerPedId())
    TriggerServerEvent("gc-casinoheist:success1")
    TriggerServerEvent('gc-casinoheist:server:cooldown')
    TriggerServerEvent('qb-doorlock:server:updateState', Config.LowerDoor, false)
end

function progress1()
    Anim = true
    QBCore.Functions.Progressbar("hack_gate", "Doing hacker tings...", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
    end, function() -- Canceled
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
    end)
end

RegisterNetEvent('gc-casinoheist:client:DoorHack', function()
    progress1()
    Wait(10000)
    Doorhack()
end)

exports['qb-target']:AddBoxZone('doorhack', vector3(962.87, 20.47, 59.84), 1.00, 1.00, {
    name='doorhack',
    heading=328.97,
    debugPoly=false,
    minZ = 59.84,
    maxZ = 60.84,
    }, {
        options = {
            {
                type = 'client',
                event = 'gc-casinoheist:client:DoorHack',
                icon = 'fas fa-laptop',
                label = ' Hack Panel',
            },
        },
    distance = 1.5
})

function DoorThermite()
    local pos = GetEntityCoords(PlayerPedId())
    if LocalPlayer.state.isLoggedIn then
        QBCore.Functions.TriggerCallback("gc-casinoheist:Cooldown", function(cooldown)
            if not Cooldown then
                if cops >= 0 then
                    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasitem)
                        if hasitem then
                            call()
                            exports["memorygame"]:thermiteminigame(18, 3, 5, 45,
                            function() -- success
                                ThermiteEffect()
                                HackSuccessThermite()
                            end,
                            function() -- fail
                                HackFailedThermite()
                            end)
                        else
                            QBCore.Functions.Notify('You do not have the required items!', "error")
                        end
                    end, "thermite")
                else
                    QBCore.Functions.Notify('Not Enough Cops', "error")
                end
            else
                QBCore.Functions.Notify('Cooldown', "error")
            end
        end)
    else
        Citizen.Wait(3000)
    end
end

function HackFailedThermite()
    QBCore.Functions.Notify("Should of worked! sikeee you failed L bozo", "error", "6000")
    if math.random(1, 100) <= 40 then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        QBCore.Functions.Notify("You left a fingerprint!", "success", "6000")
    end
end

function HackSuccessThermite()
    QBCore.Functions.Notify("Door opened", "success", "6000")
    ClearPedTasksImmediately(PlayerPedId())
    TriggerServerEvent("gc-casinoheist:successthermite")
    TriggerServerEvent('gc-casinoheist:server:cooldown')
    TriggerServerEvent('qb-doorlock:server:updateState', Config.CasinoDoor1, false)
end

function progressthermite()
    Anim = true
    QBCore.Functions.Progressbar("hack_gate", "Placing Thermite...", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
    end, function() -- Canceled
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
    end)
end

RegisterNetEvent('gc-casinoheist:client:ThermiteCasinoDoor', function()
    progressthermite()
    Wait(10000)
    ThermitePlanting()
    DoorThermite()
end)

exports['qb-target']:AddBoxZone('casinothermite', vector3(951.17, 26.9, 71.83), 1.00, 1.00, {
    name = 'casinothermite', 
    heading = 265.85,
    debugpoly = false,
    minZ = 71.83,
    maxZ = 72.93,
    }, {
    options = {
        { 
            type = 'client',
            event = 'gc-casinoheist:client:ThermiteCasinoDoor',
            icon = 'fas fa-bomb',
            label = 'Blow Door',
            door = k,
        }
    },
    distance = 1.5,
})

RegisterNetEvent('gc-casinoheist:client:GoldGrab', function()
    LocalPlayer.state:set("inv_busy", true, true)
    local ped = PlayerPedId()
    local model = "ch_prop_gold_bar_01a"
    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, `ch_prop_gold_trolly_01a`, false, false, false)
    local GoldAppear = function()
        local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)
        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Wait(50)
        end
        local grabobj = CreateObject(grabmodel, pedCoords, true)
        FreezeEntityPosition(grabobj, true)
        SetEntityInvincible(grabobj, true)
        SetEntityNoCollisionEntity(grabobj, ped)
        SetEntityVisible(grabobj, false, false)
        AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
        local startedGrabbing = GetGameTimer()
        Citizen.CreateThread(function()
            while GetGameTimer() - startedGrabbing < 37000 do
                Wait(1)
                DisableControlAction(0, 73, true)
                if HasAnimEventFired(ped, `CASH_APPEAR`) then
                    if not IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, true, false)
                    end
                end
                if HasAnimEventFired(ped, `RELEASE_CASH_DESTROY`) then
                    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
                    end
                end
            end
            DeleteObject(grabobj)
        end)
    end
    local trollyobj = Trolley
    local emptyobj = `hei_prop_hei_cash_trolly_03`
    if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
        return
    end
    local baghash = `ch_p_m_bag_var03_arm_s`
    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and
        not HasModelLoaded(baghash) do
        Wait(100)
    end
    while not NetworkHasControlOfEntity(trollyobj) do
        Wait(1)
        NetworkRequestControlOfEntity(trollyobj)
    end

    local rot = GetEntityHeading(trollyobj)
    local targetPosition = GetEntityCoords(trollyobj)
    local targetRotation = vector3(0.0, 0.0, rot)
    local animPos = GetAnimInitialOffsetPosition('anim@heists@ornate_bank@grab_cash', "intro", targetPosition[1], targetPosition[2], targetPosition[3], targetRotation, 0, 2)
    local targetHeading = rot
    TaskGoStraightToCoord(ped, animPos, 0.025, 5000, targetHeading, 0.05)
    Wait(2500)

    local bag = CreateObject(`ch_p_m_bag_var03_arm_s`, GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(scene1)
    Wait(1500)
    GoldAppear()
    local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, true, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene2)
    Wait(37000)
    local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene3)
    TriggerServerEvent('gc-casinoheist:server:Gold')
    Wait(1800)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 82, 3, 0)
    RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
    SetModelAsNoLongerNeeded(`ch_p_m_bag_var03_arm_s`)
    LocalPlayer.state:set("inv_busy", false, true)
    Config.GoldTrolleys[1].hit = true
end)

RegisterNetEvent('gc-casinoheist:client:Drill', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    TriggerEvent('gc-casinoheist:client:Closest', closetDrill)
    if closetDrill ~= nil then
        print(closetDrill)
        print(Config.DrillSpots[closetDrill].hit)
        if not Config.DrillSpots[closetDrill].hit then
            if math.random(1, 100) <= 45 and not ISWearingHandshoes() then
                TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
            end
            QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
                if result then
                    Busy = true
                    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                    Wait(1000)
                    DrillAnim(Config)
                    LocalPlayer.state:set("inv_busy", false, true)
                    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["drill"], "remove")
                    TriggerServerEvent("QBCore:Server:RemoveItem", "drill", 1)
                    TriggerServerEvent('gc-casinoheist:server:LockerItem')
                else 
                    QBCore.Functions.Notify("You need a drill to do this.", "error")
                end
            end, "drill")
        end
    end
end) 

function LowerVault()
    local pos = GetEntityCoords(PlayerPedId())
    if LocalPlayer.state.isLoggedIn then
        QBCore.Functions.TriggerCallback("gc-casinoheist:Cooldown", function(cooldown)
            if not Cooldown then
                if cops >= 0 then
                    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasitem)
                        if hasitem then
                            call()
                            exports['hacking']:OpenHackingGame(8, 4, 1, function(Success)
                                if Success then -- success
                                    ClearPedTasksImmediately(PlayerPedId())
                                    HackSuccessLowerVault()
                                else
                                    ClearPedTasksImmediately(PlayerPedId())
                                    HackFailedLowerVault()
                                end
                            end)
                        else
                            QBCore.Functions.Notify('You do not have the required items!', "error")
                        end
                    end, "trojan_usb")
                else
                    QBCore.Functions.Notify('Not Enough Cops', "error")
                end
            else
                QBCore.Functions.Notify('Cooldown', "error")
            end
        end)
    else
        Citizen.Wait(3000)
    end
end

function VaultOpening()
    QBCore.Functions.Notify("Vault will open in 20 seconds stand back", "error", "6000")
    Wait(20000)
    AddExplosion(Config.Explosion[1].x, Config.Explosion[1].y, Config.Explosion[1].z, 82, 5.0, true, false, 15.0)
    TriggerServerEvent('gc-casinoheist:server:VaultSync', false)
    Carts()
    GoldCarts()
    CashPile()
    Lockers()
    UpdateIPL()
end

function HackFailedLowerVault()
    QBCore.Functions.Notify("Should of worked! sikeee you failed L bozo", "error", "6000")
    if math.random(1, 100) <= 40 then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        QBCore.Funtions.Notify("You left a fingerprint!", "success", "6000")
    end
end

function HackSuccessLowerVault()
    QBCore.Functions.Notify("Door opened", "success", "6000")
    ClearPedTasksImmediately(PlayerPedId())
    TriggerServerEvent("gc-casinoheist:success1")
    TriggerServerEvent('gc-casinoheist:server:cooldown')
    VaultOpening()
    QBCore.Functions.Notify("What have you done??", "error", "6000")
    QBCore.Functions.Notify("The Police Are Aware", "error", "6000")
    Wait(6000)
    QBCore.Functions.Notify("Be Quick That was loud", "error", "6000")
end

function progresslowervault()
    Anim = true
    QBCore.Functions.Progressbar("hack_gate", "Accessing main frame like a nerd...", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
    end, function() -- Canceled
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
    end)
end

RegisterNetEvent('gc-casinoheist:client:LowerHack', function()
    progresslowervault()
    Wait(10000)
    LowerVault()
end)

exports['qb-target']:AddBoxZone('lowerhack',vector3(971.99, 65.08, 59.67), 1.00, 1.00, {
    name='lowerhack',
    heading=7.9,
    debugPoly=false,
    minZ = 59.67,
    maxZ = 60.67,
    }, {
        options = {
            {
                type = 'client',
                event = 'gc-casinoheist:client:LowerHack',
                icon = 'fas fa-laptop',
                label = 'Access Vault Door (Requires USB)',
            },
        },
    distance = 1.5
})

RegisterNetEvent('gc-casinoheist:client:Closest', function(data)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local dist
    inRange = false
    for k,v in pairs(Config.DrillSpots) do
        dist = #(pos - vector3(Config.DrillSpots[k].coords.x, Config.DrillSpots[k].coords.y, Config.DrillSpots[k].coords.z))
        if dist < 1.5 and Config.DrillSpots[k].hit == false then
            closestDrill = k
            inRange = true
        end
    end
    if not inRange then
        closestDrill = nil
    end
    for k, v in pairs(Config.Trolleys) do
        dist = #(pos - vector3(Config.Trolleys[k].coords.x, Config.Trolleys[k].coords.y, Config.Trolleys[k].coords.z))
        if dist < 1.5 and Config.Trolleys[k].hit == false then
            closestTrolly = k
            inRange = true
        end
    end
    if not inRange then
        closestTrolly = nil
    end
end)