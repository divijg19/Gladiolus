-- army.lua
local colors = require("src/colors")

local army = {
    active = {},
    squad = {},
    maxSquadSize = 5,
    maxArmySize = 20
}

-- Constants for army management
local CONSTANTS = {
    MIN_SQUAD_SIZE = 1,
    SQUAD_LEVEL_BONUS = 0.1, -- 10% stat bonus for squad members
    MAX_EQUIPMENT_SLOTS = 3
}

-- Helper functions
local function validateIndex(index, arr)
    return type(index) == "number" and index >= 1 and index <= #arr
end

local function isUnitInSquad(unit)
    for _, squadUnit in ipairs(army.squad) do
        if squadUnit == unit then
            return true
        end
    end
    return false
end

-- Calculate enhanced stats for a unit
local function calculateEffectiveStats(unit)
    local stats = {}
    for stat, value in pairs(unit.stats) do
        stats[stat] = value
    end

    if unit.equipment then
        for _, item in pairs(unit.equipment) do
            for stat, bonus in pairs(item.stats or {}) do
                stats[stat] = (stats[stat] or 0) + bonus
            end
        end
    end

    if isUnitInSquad(unit) then
        for stat, value in pairs(stats) do
            if type(value) == "number" then
                stats[stat] = math.floor(value * (1 + CONSTANTS.SQUAD_LEVEL_BONUS))
            end
        end
    end

    return stats
end

-- Add a unit to the army
function army.addUnit(unit)
    if #army.active >= army.maxArmySize then
        return false, "Army is full! Cannot add more units."
    end

    unit.equipment = unit.equipment or {}
    table.insert(army.active, unit)
    return true, "Unit added to army."
end

-- Remove a unit from the army
function army.removeUnit(index)
    if not validateIndex(index, army.active) then
        return false, "Invalid unit index."
    end

    local unit = army.active[index]
    if isUnitInSquad(unit) then
        print("Warning: This unit is currently in the squad. Remove it from the squad first.")
        return false, "Cannot dismiss unit in squad."
    end

    if next(unit.equipment or {}) then
        print("Warning: This unit has equipment that will be lost upon dismissal!")
    end

    print("Are you sure you want to dismiss " .. colors.formatUnitName(unit.rarity, unit.class) .. "? (yes/no)")
    local confirmation = io.read()

    if confirmation:lower() == "yes" then
        table.remove(army.active, index)
        return true, "Unit dismissed from army."
    else
        return false, "Dismissal canceled."
    end
end

-- Add a unit to the squad
function army.addToSquad(index)
    if #army.squad >= army.maxSquadSize then
        return false, "Squad is full! Cannot add more units."
    end

    if not validateIndex(index, army.active) then
        return false, "Invalid unit index."
    end

    local unit = army.active[index]
    table.insert(army.squad, unit)
    return true, "Unit added to squad."
end

-- Remove a unit from the squad
function army.removeFromSquad(index)
    if not validateIndex(index, army.squad) then
        return false, "Invalid squad index."
    end

    table.remove(army.squad, index)
    return true, "Unit removed from squad."
end

-- Display army details
function army.displayArmy()
    print("\nArmy (" .. #army.active .. "/" .. army.maxArmySize .. " units):")
    print("----------------------------------------")

    for i, unit in ipairs(army.active) do
        local effectiveStats = calculateEffectiveStats(unit)
        print("\n" .. i .. ". " .. colors.formatUnitName(unit.rarity, unit.class))
        print("   Level: " .. unit.level .. " (XP: " .. unit.xp .. ")")

        for _, statName in ipairs({"Strength", "Vitality", "Agility", "Intelligence", "Wisdom", "Dexterity", "Luck"}) do
            local baseValue = unit.stats[statName]
            local effectiveValue = effectiveStats[statName]

            if baseValue then
                local display = "   " .. statName .. ": " .. baseValue
                if effectiveValue > baseValue then
                    display = display .. " (+" .. (effectiveValue - baseValue) .. ")"
                end
                print(display)
            end
        end

        if next(unit.equipment or {}) then
            print("   Equipment:")
            for slot, item in pairs(unit.equipment) do
                print("      " .. slot .. ": " .. item.name)
            end
        end
    end
end


-- Display squad details
function army.displaySquad()
    print("\nBattle Squad (" .. #army.squad .. "/" .. army.maxSquadSize .. " units):")
    print("----------------------------------------")

    local totalPower = 0
    local roleCount = {}

    local squadStats = {Strength = 0, Vitality = 0, Agility = 0, Intelligence = 0, Wisdom = 0, Dexterity = 0, Luck = 0}


    for i, unit in ipairs(army.squad) do
        local effectiveStats = calculateEffectiveStats(unit)
        roleCount[unit.class] = (roleCount[unit.class] or 0) + 1

        local power = 0
        for _, statName in ipairs({"Strength", "Vitality", "Agility", "Intelligence", "Wisdom", "Dexterity", "Luck"}) do
            local statValue = effectiveStats[statName]
            if statValue then
                power = power + statValue
                squadStats[statName] = squadStats[statName] + statValue

            end
        end
        totalPower = totalPower + power

        print("\n" .. i .. ". " .. colors.formatUnitName(unit.rarity, unit.class))
        print("   Level: " .. unit.level .. " (Power Rating: " .. power .. ")")

        for _, statName in ipairs({"Strength", "Vitality", "Agility", "Intelligence", "Wisdom", "Dexterity", "Luck"}) do
            if effectiveStats[statName] then
                print("   " .. statName .. ": " .. effectiveStats[statName])
            end
        end
    end

    if #army.squad > 0 then
        print("\nSquad Summary:")
        print("Total Power Rating: " .. totalPower)
        print("Average Squad Stats:")
        for statName, total in pairs(squadStats) do
            print("   " .. statName .. ": " .. math.floor(total / #army.squad))
        end

        print("Role Composition:")
        for role, count in pairs(roleCount) do
            print("   " .. role .. ": " .. count)
        end
    end
end

return army
