for player in players_iterate() do

    -- help everybody out
    --log.verbose("Player: " .. player.name)
    -- change_gold(player, 100000000)

    
    if player.id == 0.0 then    -- todo:  get non-ai player or current player?

        -- give the current research
        -- edit.give_tech(player, nil, -1, False, "Free")
        -- edit.give_tech(player, nil, -1, False, "Free")
        -- edit.give_tech(player, nil, -1, False, "Free")
        -- edit.give_tech(player, nil, -1, False, "Free")

        -- give gold
        log.verbose("Player: " .. player.name)
        change_gold(player, 500000)

        -- upgrade all units
        
        
        for unit in player:units_iterate() do 
            unit:upgrade(0)
        end 

        for unit in player:units_iterate() do 
            if unit.utype:name_translation() == "Battleshipxxx" 
            or unit.utype:name_translation() == "xxArmor" 
            or unit.utype:name_translation() == "xxAlpine Troops" 
            or unit.utype:name_translation() == "Cruiserxxx" 
            or unit.utype:name_translation() == "xxEngineers" 
            or unit.utype:name_translation() == "xxMusketeers" 
            --or unit.utype:name_translation() == "Dragoons" 
            --or 1 == 1
            then
                log.verbose("Creating a new Unit: " .. unit.utype:name_translation() )
                edit.create_unit(player, unit.tile, unit.utype, 3, nil, -1)
            end
            --edit.create_unit(player, city.tile, unit.utype, 3, city, -1)
        end 

        local wonderlist = {}
        wonderlist["Palace"] = true

        for city in player:cities_iterate() do 

            if 1 == 0 then 
                if city.name == "Tokyo" then
                    for unit in player:units_iterate() do 
                        if unit.utype:name_translation() == "Marines" then
                            edit.create_unit(player, city.tile, unit.utype, 3, city, -1)
                        end
                    end
                    local ctile = city.tile
                    local utype = find.unit_type("Legion")
                    edit.create_unit(player, ctile, utype, 3, city, -1)
                end
            end 

            --local utype = find.unit_type("Archers")
            --edit.create_unit(player, ctile, utype, 3, city, -1)

            for bt = 1, 1000 do 
                local building = find.building_type(bt)
                if building == nil then
                    break
                end

                if 
                --not (building:is_wonder() or building:is_great_wonder() or building:is_small_wonder())
                not city:has_building(building)
                and building.name_translation(building) ~= "Coinage"
                and building.name_translation(building) ~= "Barracks"
                then
                    local can_build = player:can_build_direct(building)
                    if can_build then

                        local building_name = building.name_translation(building)

                        if building:is_wonder() or building:is_great_wonder() or building:is_small_wonder() 
                        then 
                            if not wonderlist[building_name] then 
                                wonderlist[building_name] = true
                                log.verbose("Adding wonder: " .. building_name .. " to city " .. city.name)
                                edit.create_building(city, building)
                            end 
                        else 

                            log.verbose("Adding normal building: " .. building_name .. " in city " .. city.name)
                            edit.create_building(city, building)
                        end 
                    end 
                end
            end

        end 


--        for bt = 1, 3 do 
--            local result = edit.give_tech(player, nil, -1, False, "Free")
--        end 
        
        --local armor = find.tech_type("Armor")
        --local result = player:give_tech(player, armor)
        --player:give_tech(player, "Amphibious Warfare", -1, False, "Free")
        --edit.give_tech(player, Armor, -1, False, "Free")
        --local result = edit.give_tech(player, "Machine Tools", -1, False, "Free")
        --log.verbose("Result: ", result)
    end

end