-- roster.lua
local colors = require("src/colors")

local roster = {
    active = {},
    squad = {},
    maxSquadSize = 5,
    maxRosterSize = 20
}

-- [Previous functions remain the same until display functions]

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
