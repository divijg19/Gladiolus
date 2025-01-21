local characterData = require("src/characters")

-- Rarity colors
local rarityColors = {
    Common = "\27[90m", -- Grey
    Uncommon = "\27[92m", -- Green
    Epic = "\27[94m", -- Blue
    Elite = "\27[95m", -- Purple
    Unique = "\27[93m", -- Gold
    Legendary = "\27[91m", -- Red
}

-- Stats display order (without Luck)
local recruitmentStatsOrder = {
    "Strength",
    "Vitality",
    "Agility",
    "Intelligence",
    "Wisdom",
    "Dexterity"
}

-- Full stats order (with Luck)
local fullStatsOrder = {
    "Strength",
    "Vitality",
    "Agility",
    "Intelligence",
    "Wisdom",
    "Dexterity",
    "Luck"
}

local resetColor = "\27[0m"

-- Helper function to get random element from a table
local function getRandomElement(tbl)
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys[math.random(#keys)]
end

-- Function to generate random units
local function generateRandomUnits(count)
    local units = {}
    for _ = 1, count do
        local className = getRandomElement(characterData.baseStats)
        local rarity = characterData.selectRarity()
        local stats, cost = characterData.calculateStatsAndCost(characterData.baseStats[className], rarity)
        table.insert(units, {
            class = className,
            rarity = rarity,
            stats = stats,
            cost = cost,
        })
    end
    return units
end

-- Function to display a unit during recruitment (without Luck)
local function displayRecruitmentUnit(unit, index)
    local color = rarityColors[unit.rarity] or resetColor
    print(color .. "\nUnit " .. index .. ": " .. unit.rarity .. " " .. unit.class .. resetColor .. " (Cost: " .. unit.cost .. " gold)")
    for _, statName in ipairs(recruitmentStatsOrder) do
        if unit.stats[statName] then
            print("  " .. statName .. ": " .. unit.stats[statName])
        end
    end
end

-- Function to display a recruited unit (with Luck)
local function displayRecruitedUnit(unit, index)
    local color = rarityColors[unit.rarity] or resetColor
    print(color .. "\nUnit " .. index .. ": " .. unit.rarity .. " " .. unit.class .. resetColor .. " (Cost: " .. unit.cost .. " gold)")
    for _, statName in ipairs(fullStatsOrder) do
        if unit.stats[statName] then
            print("  " .. statName .. ": " .. unit.stats[statName])
        end
    end
end

-- Recruitment system
local function recruitCharacter()
    local gold = 1000 -- Starting gold
    print("\nGold available: " .. gold)
    print("Generating 7 random units...")
    local units = generateRandomUnits(7)
    for i, unit in ipairs(units) do
        displayRecruitmentUnit(unit, i)
    end
    
    print("\nChoose a unit to recruit (1-7):")
    local choice = tonumber(io.read())
    if choice and units[choice] then
        local selectedUnit = units[choice]
        if selectedUnit.cost <= gold then
            gold = gold - selectedUnit.cost
            print("\nYou recruited a " .. selectedUnit.rarity .. " " .. selectedUnit.class .. "!")
            displayRecruitedUnit(selectedUnit, choice)
            print("\nRemaining gold: " .. gold)
            return selectedUnit
        else
            print("\nNot enough gold! Choose again.")
            return recruitCharacter()
        end
    else
        print("\nInvalid choice. Try again.")
        return recruitCharacter()
    end
end

-- Introduction to the game
local function gameIntroduction()
    print([[
Welcome to **The Crown's Blade**!
---------------------------------
A kingdom in peril calls for brave warriors to rise and reclaim its glory.
As the leader of this campaign, it is your duty to assemble a mighty army.
For battles inside the kingdom, you may take a team of 5 Knights.
This limit is lifted when fighting the kingdom's invaders.
Each recruit brings their unique skills and strengths.
Choose wisely, for the fate of the realm rests on your shoulders!
]])
end

-- Main execution
gameIntroduction()
print("To begin, recruit your first character.")
local firstCharacter = recruitCharacter()
print("\nYour journey begins now!")
print("Lead your army to victory and restore the kingdom's honor.")
