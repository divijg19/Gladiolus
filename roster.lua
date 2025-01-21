-- roster.lua
local colors = require("src/colors")

local roster = {
    active = {},
    squad = {},
    maxSquadSize = 5,
    maxRosterSize = 20
}

-- Function to add a unit to the roster
function roster.addUnit(unit)
    if #roster.active >= roster.maxRosterSize then
        return false, "Roster is full! Cannot add more units."
    end
    table.insert(roster.active, unit)
    return true, "Unit added to roster."
end

-- Function to remove a unit from the roster with confirmation
function roster.removeUnit(index)
    if index < 1 or index > #roster.active then
        return false, "Invalid unit index."
    end
    
    local unit = roster.active[index]
    local inSquad = false
    
    -- Check if the unit is in the squad
    for _, squadUnit in ipairs(roster.squad) do
        if squadUnit == unit then
            inSquad = true
            break
        end
    end

    -- Warning message if the unit is in the squad
    if inSquad then
        print("Warning: The unit " .. colors.formatUnitName(unit.rarity, unit.class) .. " is currently in the squad.")
        print("Removing it from the squad before dismissal.")
        roster.removeFromSquad(index) -- Optionally remove from squad before dismissal.
    end

    -- Confirmation prompt before removal
    print("Are you sure you want to dismiss " .. colors.formatUnitName(unit.rarity, unit.class) .. "? (yes/no)")
    local confirmation = io.read()
    
    if confirmation:lower() == "yes" then
        table.remove(roster.active, index)
        return true, "Unit dismissed from roster."
    else
        return false, "Dismissal canceled."
    end
end

-- Function to add a unit to the squad
function roster.addToSquad(index)
    if #roster.squad >= roster.maxSquadSize then
        return false, "Squad is full! Cannot add more units."
    end
    local unit = roster.active[index]
    if not unit then
        return false, "Invalid unit index."
    end
    table.insert(roster.squad, unit)
    return true, "Unit added to squad."
end

-- Function to remove a unit from the squad
function roster.removeFromSquad(index)
    if index < 1 or index > #roster.squad then
        return false, "Invalid squad index."
    end
    table.remove(roster.squad, index)
    return true, "Unit removed from squad."
end

-- Display roster with colors
function roster.displayRoster()
    print("\nArmy Roster (" .. #roster.active .. "/" .. roster.maxRosterSize .. " units):")
    print("----------------------------------------")
    for i, unit in ipairs(roster.active) do
        print("\n" .. i .. ". " .. colors.formatUnitName(unit.rarity, unit.class))
        for _, statName in ipairs({"Strength", "Vitality", "Agility", "Intelligence", "Wisdom", "Dexterity", "Luck"}) do
            if unit.stats[statName] then
                print("   " .. statName .. ": " .. unit.stats[statName])
            end
        end
    end
end

-- Display squad with colors
function roster.displaySquad()
    print("\nBattle Squad (" .. #roster.squad .. "/" .. roster.maxSquadSize .. " units):")
    print("----------------------------------------")
    for i, unit in ipairs(roster.squad) do
        print("\n" .. i .. ". " .. colors.formatUnitName(unit.rarity, unit.class))
        for _, statName in ipairs({"Strength", "Vitality", "Agility", "Intelligence", "Wisdom", "Dexterity", "Luck"}) do
            if unit.stats[statName] then
                print("   " .. statName .. ": " .. unit.stats[statName])
            end
        end
    end
end

return roster
