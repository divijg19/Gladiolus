local characterData = require("src/characters")
local army = require("src/army")
local colors = require("src/colors")

-- Game currencies
local currencies = {
    gold = 1000,
    gems = 100  -- Starting gems amount
}

-- Constants
local LEVEL_UP_COST = 50  -- Gems cost per level up

-- Stats display orders
local recruitmentStatsOrder = {
    "Strength", "Vitality", "Agility",
    "Intelligence", "Wisdom", "Dexterity"
}

local fullStatsOrder = {
    "Strength", "Vitality", "Agility",
    "Intelligence", "Wisdom", "Dexterity",
    "Luck"
}

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
        local stats, cost = characterData.calculateStatsAndCost(characterData.baseStats[className], rarity, className)
        local unit = characterData.initializeCharacter(className, rarity)
        unit.cost = cost
        table.insert(units, unit)
    end
    return units
end

-- Function to display a unit during recruitment (without Luck)
local function displayRecruitmentUnit(unit, index)
    print("\nUnit " .. index .. ": " .. colors.formatUnitName(unit.rarity, unit.class) .. 
          " (Cost: " .. unit.cost .. " gold)")
    for _, statName in ipairs(recruitmentStatsOrder) do
        if unit.stats[statName] then
            print("  " .. statName .. ": " .. unit.stats[statName])
        end
    end
end

-- Enhanced function to display a recruited unit (with Luck and Level)
local function displayRecruitedUnit(unit, index)
    print("\nUnit " .. index .. ": " .. colors.formatUnitName(unit.rarity, unit.class))
    print("Level: " .. unit.level .. " (XP: " .. unit.xp .. ")")
    for _, statName in ipairs(fullStatsOrder) do
        if unit.stats[statName] then
            print("  " .. statName .. ": " .. unit.stats[statName])
        end
    end
end

-- Function to manage army
local function manageArmy()
    while true do
        print("\nArmy Management")
        print("Current Gems: " .. currencies.gems)
        print("1. View Army")
        print("2. View Squad")
        print("3. Add Unit to Squad")
        print("4. Remove Unit from Squad")
        print("5. Dismiss Unit")
        print("6. Level Up Unit")
        print("7. Return to Main Menu")
        
        local choice = tonumber(io.read())
        
        if choice == 1 then
            army.displayArmy()
        elseif choice == 2 then
            army.displaySquad()
        elseif choice == 3 then
            army.displayArmy()
            print("\nSelect unit to add to squad (enter number):")
            local index = tonumber(io.read())
            
            if index and index >= 1 and index <= #army.active then
                local unitToAdd = army.active[index]
                local isInSquad = false
                for _, squadUnit in ipairs(army.squad) do
                    if squadUnit == unitToAdd then
                        isInSquad = true
                        break
                    end
                end
            
                if isInSquad then
                    print("\nUnit already in squad.")
                else
                    local success, message = army.addToSquad(index)
                    print("\n" .. message)
                end
            else
                print("\nInvalid unit index.")
            end
        elseif choice == 4 then
            army.displaySquad()
            print("\nSelect unit to remove from squad (enter number):")
            local index = tonumber(io.read())
            local success, message = army.removeFromSquad(index)
            print("\n" .. message)
        elseif choice == 5 then
            army.displayArmy()
            print("\nSelect unit to dismiss (enter number):")
            local index = tonumber(io.read())
            
            if index and index >= 1 and index <= #army.active then
                local unitToDismiss = army.active[index]
                -- Remove from squad if present
                for squadIndex, squadUnit in ipairs(army.squad) do
                    if squadUnit == unitToDismiss then
                        army.removeFromSquad(squadIndex)
                        break
                    end
                end
                local success, message = army.removeUnit(index)
                print("\n" .. message)
            else
                print("\nInvalid unit index.")
            end
        elseif choice == 6 then
            army.displayArmy()
            print("\nSelect unit to level up (enter number):")
            local index = tonumber(io.read())
            
            if index and index >= 1 and index <= #army.active then
                local unit = army.active[index]
                local success = characterData.levelUp(unit, currencies.gems, LEVEL_UP_COST)
                
                if success then
                    currencies.gems = currencies.gems - LEVEL_UP_COST
                    print("\nUnit leveled up successfully!")
                    displayRecruitedUnit(unit, index)
                    print("Gems remaining: " .. currencies.gems)
                end
            else
                print("\nInvalid unit index.")
            end
        elseif choice == 7 then
            break
        else
            print("\nInvalid choice. Try again.")
        end
    end
end

-- Modified recruitment system
local function recruitCharacter(gold)
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
            local success, message = army.addUnit(selectedUnit)
            if not success then
                print("\n" .. message)
                return gold, nil
            end
            
            local remainingGold = gold - selectedUnit.cost
            print("\nYou recruited a " .. colors.formatUnitName(selectedUnit.rarity, selectedUnit.class) .. "!")
            displayRecruitedUnit(selectedUnit, choice)
            print("\nGold remaining: " .. remainingGold)
            return remainingGold, selectedUnit
        else
            print("\nNot enough gold! Choose again.")
            return recruitCharacter(gold)
        end
    else
        print("\nInvalid choice. Try again.")
        return recruitCharacter(gold)
    end
end

-- Modified main menu
local function mainMenu()
    while true do
        print("\nMain Menu")
        print("\nYour journey begins now!")
        print("Lead your army to victory and restore the kingdom's honor.")
        print("Current Gold: " .. currencies.gold)
        print("Current Gems: " .. currencies.gems)
        print("1. Recruit New Unit")
        print("2. Manage Army")
        print("3. Quit Game")
        
        local choice = tonumber(io.read())
        
        if choice == 1 then
            local remainingGold, unit = recruitCharacter(currencies.gold)
            currencies.gold = remainingGold or currencies.gold
        elseif choice == 2 then
            manageArmy()
        elseif choice == 3 then
            print("\nThanks for playing!")
            break
        else
            print("\nInvalid choice. Try again.")
        end
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

You start with 1000 gold for recruiting units and 100 gems for leveling them up.
]])
end

-- Main execution
gameIntroduction()
local firstGold, firstCharacter = recruitCharacter(currencies.gold)
currencies.gold = firstGold or currencies.gold
mainMenu()
