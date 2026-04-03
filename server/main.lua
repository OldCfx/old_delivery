local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('old_delivery:payout', function()
    local xSource = source
    local xPlayer = ESX.GetPlayerFromId(xSource)

    if not xPlayer then return end

    local playerPed = GetPlayerPed(xSource)
    local playerCoords = GetEntityCoords(playerPed)
    local deliveryCoords = Config.Locations.DeliveryZone
    local distance = #(playerCoords - deliveryCoords)

    if distance <= 20.0 then
        xPlayer.addAccountMoney('money', Config.Payout)
        TriggerClientEvent('esx:showNotification', xSource, "Livraison effectuée : ~g~" .. Config.Payout .. "$")
    else
        print(("Joueur %s a tenté de trigger le paiement trop loin (%s m)"):format(GetPlayerName(xSource), distance))
    end
end)
