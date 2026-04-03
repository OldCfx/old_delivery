local ESX = exports['es_extended']:getSharedObject()
local currentVehicle = nil
local spawnedProps = {}
local isCarrying = false
local carriedObject = nil
local boxesInTruck = 0
local deliveryBlip = nil

local function cleanUpProps()
    for _, prop in ipairs(spawnedProps) do
        if DoesEntityExist(prop) then DeleteEntity(prop) end
    end
    spawnedProps = {}
    boxesInTruck = 0
end

local function carryAnim()
    lib.requestAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 49, 0, false, false, false)
end

local function manageTruckDoors(vehicle, open)
    if open then
        SetVehicleDoorOpen(vehicle, 2, false, false)
        SetVehicleDoorOpen(vehicle, 3, false, false)
    else
        SetVehicleDoorShut(vehicle, 2, false)
        SetVehicleDoorShut(vehicle, 3, false)
    end
end


local function setMissionBlip(coords)
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end
    deliveryBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(deliveryBlip, 1)
    SetBlipColour(deliveryBlip, 5)
    SetBlipRoute(deliveryBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Objectif de livraison")
    EndTextCommandSetBlipName(deliveryBlip)
end

local function removeMissionBlip()
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
        deliveryBlip = nil
    end
end

CreateThread(function()
    RequestModel(`s_m_m_postal_01`)
    while not HasModelLoaded(`s_m_m_postal_01`) do Wait(0) end
    local ped = CreatePed(4, `s_m_m_postal_01`, Config.Locations.Garage.x, Config.Locations.Garage.y,
        Config.Locations.Garage.z, Config.Locations.Garage.w, false, true)

    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        if isCarrying then
            sleep = 0
            if not IsEntityPlayingAnim(playerPed, "anim@heists@box_carry@", "idle", 3) then
                carryAnim()
            end
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 24, true)
        end

        if currentVehicle and not DoesEntityExist(currentVehicle) then
            cleanUpProps()
            currentVehicle = nil
            ESX.ShowNotification("~r~Véhicule perdu, mission annulée.")
        end

        local distGarage = #(coords - Config.Locations.Garage.xyz)
        if distGarage < 2.0 and not currentVehicle then
            sleep = 0
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour sortir le camion.")
            if IsControlJustReleased(0, 38) then
                ESX.Game.SpawnVehicle('mule', Config.Locations.SpawnVeh.xyz, Config.Locations.SpawnVeh.w, function(veh)
                    currentVehicle = veh
                    TaskWarpPedIntoVehicle(playerPed, veh, -1)
                    ESX.ShowNotification(
                        "Rendez-vous au point mis sur le GPS pour charger les cartons dans votre véhicule")

                    setMissionBlip(Config.Locations.LoadZone)
                end)
            end
        end

        local distLoad = #(coords - Config.Locations.LoadZone)
        if distLoad < 10.0 and currentVehicle and boxesInTruck < #Config.Vehicles['mule'].props then
            sleep = 0
            DrawMarker(0, Config.Locations.LoadZone, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0, 255, 0, 100, false, true, 2,
                false, nil, nil, false)
            if distLoad < 1.5 and not isCarrying then
                if not IsPedInAnyVehicle(playerPed, false) then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour prendre un carton.")
                    if IsControlJustReleased(0, 38) then
                        if GetVehicleDoorAngleRatio(currentVehicle, 2) < 0.1 then
                            manageTruckDoors(currentVehicle, true)
                        end
                        isCarrying = true
                        RequestModel(`prop_cs_rub_box_01`)
                        while not HasModelLoaded(`prop_cs_rub_box_01`) do Wait(0) end
                        carriedObject = CreateObject(`prop_cs_rub_box_01`, coords, true, true, true)
                        AttachEntityToEntity(
                            carriedObject,
                            playerPed,
                            GetPedBoneIndex(playerPed, 18905),
                            0.1200, 0.2900, 0.2900,
                            -77.0, 0.0, 35.9,
                            true, true, false, true, 1, true
                        )
                        carryAnim()
                        ESX.ShowNotification("Installe le carton à l'arrière du véhicule")
                    end
                end
            end
        end

        if isCarrying and currentVehicle then
            local vehCoords = GetEntityCoords(currentVehicle)
            local distToVeh = #(coords - vehCoords)
            if distToVeh < 5.5 then
                sleep = 0
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour charger le camion.")
                if IsControlJustReleased(0, 38) then
                    if lib.progressCircle({ duration = 1500, label = 'Chargement...', disable = { move = true } }) then
                        DeleteEntity(carriedObject)
                        ClearPedTasks(playerPed)
                        isCarrying = false
                        boxesInTruck = boxesInTruck + 1

                        local propCfg = Config.Vehicles['mule'].props[boxesInTruck]
                        local model = GetHashKey(propCfg.model)
                        RequestModel(model)
                        while not HasModelLoaded(model) do Wait(0) end
                        local p = CreateObject(model, vehCoords, true, true, true)
                        AttachEntityToEntity(p, currentVehicle, 0, propCfg.offset, propCfg.rotation, false, false, true,
                            false, 2, true)
                        table.insert(spawnedProps, p)
                        if boxesInTruck == #Config.Vehicles['mule'].props then
                            ESX.ShowNotification("~g~Chargement complet !~s~ Rendez-vous au point de livraison.")
                            setMissionBlip(Config.Locations.DeliveryZone)
                        end
                    end
                end
            end
        end

        if currentVehicle and boxesInTruck > 0 and not isCarrying then
            local vehCoords = GetEntityCoords(currentVehicle)
            if not IsPedInAnyVehicle(playerPed, false) then
                if #(coords - vehCoords) < 5.5 and #(coords - Config.Locations.DeliveryZone) < 10.0 then
                    sleep = 0
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récupérer un carton du camion.")
                    if IsControlJustReleased(0, 38) then
                        if GetVehicleDoorAngleRatio(currentVehicle, 2) < 0.1 then
                            manageTruckDoors(currentVehicle, true)
                        end
                        local lastProp = spawnedProps[#spawnedProps]
                        if DoesEntityExist(lastProp) then
                            DeleteEntity(lastProp)
                            table.remove(spawnedProps)
                            boxesInTruck = boxesInTruck - 1
                            isCarrying = true
                            RequestModel(`prop_cs_rub_box_01`)
                            while not HasModelLoaded(`prop_cs_rub_box_01`) do Wait(0) end
                            carriedObject = CreateObject(`prop_cs_rub_box_01`, coords, true, true, true)
                            AttachEntityToEntity(
                                carriedObject,
                                playerPed,
                                GetPedBoneIndex(playerPed, 18905),
                                0.1200, 0.2900, 0.2900,
                                -77.0, 0.0, 35.9,
                                true, true, false, true, 1, true
                            )
                            carryAnim()
                        end
                    end
                end
            end
        end

        local distDeliv = #(coords - Config.Locations.DeliveryZone)
        if distDeliv < 10.0 and isCarrying then
            sleep = 0
            DrawMarker(0, Config.Locations.DeliveryZone, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2,
                false, nil, nil, false)
            if distDeliv < 1.5 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour livrer le carton.")
                if IsControlJustReleased(0, 38) then
                    if lib.progressCircle({ duration = 1500, label = 'Livraison...', disable = { move = true } }) then
                        DeleteEntity(carriedObject)
                        ClearPedTasks(playerPed)
                        isCarrying = false
                        TriggerServerEvent('old_delivery:payout')
                        if boxesInTruck == 0 then
                            removeMissionBlip()
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
