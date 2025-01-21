-- army.lua
local colors = require("src/colors")

local army = {
    active = {},
    squad = {},
    maxSquadSize = 5,
    maxArmySize = 20
}

-- Function to add a unit to the army
function army.addUnit(unit)
    if #army.active >= army.maxArmySize then
        return false, "Army is full! Cannot add more units."
    end
    table.insert(army.active, unit)
    return true, "Unit added to army."
end

-- Function to remove a unit from the army with confirmation
function army.removeUnit(index)
    if index < 1 or index > #army.active then
        return false, "Invalid unit index."
    end
    
    local unit = army.active[index]
    local inSquad = false
    
    -- Check if the unit is in the squad
    for _, squadUnit in ipairs(army.squad) do
        if squadUnit == unit then
            inSquad = true
            break
        end
    end

    -- Warning message if the unit is in the squad
    if inSquad then
        print("Warning: The unit " .. colors.formatUnitName(unit.rarity, unit.class) .. " is currently in the squad.")
        print("Please note that there's an army management option to remove from the squad instead.")
    end

    -- Confirmation prompt before removal
    print("Are you sure you want to dismiss " .. colors.formatUnitName(unit.rarity, unit.class) .. "? (yes/no)")
    local confirmation = io.read()
    
    if confirmation:lower() == "yes" then
        table.remove(army.active, index)
        return true, "Unit dismissed from army."
    else
        return false, "Dismissal canceled."
    end
end

-- Function to add a unit to the squad
function army.addToSquad(index)
    if #army.squad >= army.maxSquadSize then
        return false, "Squad is full! Cannot add more units."
    end
    local unit = army.active[index]
    if not unit then
        return false, "Invalid unit index."
    end
    table.insert(army.squad, unit)
    return true, "Unit added to squad."
end

-- Function to remove a unit from the squad
function army.removeFromSquad(index)
    if index < 1 or index > #army.squad then
        return false, "Invalid squad index."
    end
    table.remove(army.squad, index)
    return true, "Unit removed from squad."
end

-- Display army with colors
function army.displayArmy()
    print("\nArmy (" .. #army.active .. "/" .. army.maxArmySize .. " units):")
    print("----------------------------------------")
    for i, unit in ipairs(army.active) do
        print("\n" .. i .. ". " .. colors.formatUnitName(unit.rarity, unit.class))
        for _, statName in ipairs({"Strength", "Vitality", "Agility", "Intelligence", "Wisdom", "Dexterity", "Luck"}) do
            if unit.stats[statName] then
                print("   " .. statName .. ": " .. unit.stats[statName])
            end
        end
    end
end

-- Display squad with colors
function army.displaySquad()
    print("\nBattle Squad (" .. #army.squad .. "/" .. army.maxSquadSize .. " units):")
    print("----------------------------------------")
    for i, unit in ipairs(army.squad) do
        print("\n" .. i .. ". " .. colors.formatUnitName(unit.rarity, unit.class))
        for _, statName in ipairs({"Strength", "Vitality", "Agility", "Intelligence", "Wisdom", "Dexterity", "Luck"}) do
            if unit.stats[statName] then
                print("   " .. statName .. ": " .. unit.stats[statName])
            end
        end
    end
end

return army
