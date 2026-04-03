CreateThread(function()
    local garageCoords = Config.Locations.Garage
    local blip = AddBlipForCoord(garageCoords.x, garageCoords.y, garageCoords.z)

    SetBlipSprite(blip, 477)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Job Livraison")
    EndTextCommandSetBlipName(blip)
end)
