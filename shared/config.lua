Config = {}

Config.Payout = 50 -- récompense pour chaque carton

Config.Locations = {
    Garage = vector4(2452.82, 1587.56, 32.03, 277.34), -- PED garage
    SpawnVeh = vector3(2468.44, 1598.06, 31.72),       -- Spawn du véhicule
    LoadZone = vector3(2458.66, 1579.31, 32.2),        -- marker pour récup un carton
    DeliveryZone = vector3(2347.01, 3142.96, 47.21)    -- marker pour livrer le carton
}


-- NE PAS TOUCHER
Config.Vehicles = {
    ['mule'] = {
        props = {
            { model = 'prop_cs_rub_box_01', offset = vector3(0.001, -2.736, 0.169),  rotation = vector3(0.158, -0.174, -0.774) },
            { model = 'prop_cs_rub_box_01', offset = vector3(-0.114, -0.142, 0.158), rotation = vector3(0.158, -0.174, -0.774) },
            { model = 'prop_cs_rub_box_01', offset = vector3(-0.875, -1.248, 0.153), rotation = vector3(0.158, -0.174, -0.774) },
            { model = 'prop_cs_rub_box_01', offset = vector3(-0.113, 1.154, 0.171),  rotation = vector3(0.158, -0.174, -0.774) },
            { model = 'prop_cs_rub_box_01', offset = vector3(0.699, -1.241, 0.157),  rotation = vector3(0.158, -0.174, -0.774) },
            { model = 'prop_cs_rub_box_01', offset = vector3(-0.868, -0.163, 0.172), rotation = vector3(0.158, -0.174, -0.774) },
            { model = 'prop_cs_rub_box_01', offset = vector3(0.681, -0.131, 0.168),  rotation = vector3(0.158, -0.174, -0.774) },
            { model = 'prop_cs_rub_box_01', offset = vector3(-0.075, -1.246, 0.170), rotation = vector3(0.158, -0.174, -0.774) },
            { model = 'prop_cs_rub_box_01', offset = vector3(0.724, 1.066, 0.181),   rotation = vector3(0.158, -0.174, -0.774) },
        }
    }
}
