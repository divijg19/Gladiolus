local characterData = require("src/characters")
local army = require("src/army")
local battleSystem = require("src/battleSystem")
local colors = require("src/colors")
local heroNames = require("src/hero_names")
local enemies = require("src/enemies")

-- Consolidated game state
local gameState = {
    currencies = {
        gold = 1000,
        gems = 100
    },
    LEVEL_UP_COST = 50,
    hasStarterUnit = false,
    

    -- Stats display configuration
    recruitmentStatsOrder = {
        "Strength", "Vitality", "Agility",
        "Intelligence", "Wisdom", "Dexterity"
    },
    
    fullStatsOrder = {
        "Strength", "Vitality", "Agility",
        "Intelligence", "Wisdom", "Dexterity",
        "Luck"
    }
}


-- Helper functions
local function getRandomElement(tbl)
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys[math.random(#keys)]
end

local function isValidIndex(index, tbl)
    return index and index >= 1 and index <= #tbl
end

local function getValidNumber(prompt)
    while true do
        print(prompt)
        local input = tonumber(io.read())
        if input then
            return input
        else
            print("\nInvalid input. Please enter a valid number.")
        end
    end
end


-- Unit generation and display functions
local function generateRandomUnits(count)
    local units = {}
    for _ = 1, count do
        local className = getRandomElement(characterData.baseStats)
        local rarity = characterData.selectRarity()
        local unit = characterData.initializeCharacter(className, rarity)
        
        -- Add hero name
        unit.name = heroNames.getRandomHeroName(unit.class)
        table.insert(units, unit)
    end
    return units
end


local function displayRecruitedUnit(unit, index, useFullStats)
   local statsOrder = useFullStats and gameState.fullStatsOrder or gameState.recruitmentStatsOrder
   
   print("-----------------------------")
   print(string.format("\nUnit %d: %-15s Cost: %d gold", index, colors.formatUnitName(unit.rarity, unit.name), unit.cost))
   print(string.format("Class: %s %s", unit.rarity, unit.class))
   print("\nLevel: " .. unit.level .. " (XP: " .. unit.xp .. ")")
   
   for _, statName in ipairs(statsOrder) do
       if unit.stats[statName] then
           print("  " .. statName .. ": " .. unit.stats[statName])
       end
   end
end




-- Army management function
local function manageArmy()
    while true do
        print("\n-----------------------------")
        print("Army Management")
        print("Current Gems: " .. gameState.currencies.gems)
        print("1. View Army")
        print("2. View Squad")
        print("3. Add Unit to Squad")
        print("4. Remove Unit from Squad")
        print("5. Dismiss Unit")
        print("6. Level Up Unit")
        print("7. Return to Main Menu")
        
        local choice = getValidNumber("\nEnter your choice:")
        
        if choice == 1 then
            army.displayArmy()
        elseif choice == 2 then
            army.displaySquad()
        elseif choice == 3 then
            army.displayArmy()
            local index = getValidNumber("\nSelect unit to add to squad (enter number):")
            
            if isValidIndex(index, army.active) then
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
            local index = getValidNumber("\nSelect unit to remove from squad (enter number):")
            local success, message = army.removeFromSquad(index)
            print("\n" .. message)
        elseif choice == 5 then
            army.displayArmy()
            local index = getValidNumber("\nSelect unit to dismiss (enter number):")
            
            if isValidIndex(index, army.active) then
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
            local index = getValidNumber("\nSelect unit to level up (enter number):")
            
            if isValidIndex(index, army.active) then
                local unit = army.active[index]
                if gameState.currencies.gems >= gameState.LEVEL_UP_COST then
                    local success = characterData.levelUp(unit, gameState.currencies.gems, gameState.LEVEL_UP_COST)
                    
                    if success then
                        gameState.currencies.gems = gameState.currencies.gems - gameState.LEVEL_UP_COST
                        print("\nUnit leveled up successfully!")
                        displayRecruitedUnit(unit, index)
                        print("Gems remaining: " .. gameState.currencies.gems)
                    end
                else
                    print("\nNot enough gems! Level up costs " .. gameState.LEVEL_UP_COST .. " gems.")
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


-- Recruitment function
local function recruitCharacter(gold)
    print("\nGold available: " .. gold)
    print("Generating 7 random units...")
    local units = generateRandomUnits(7)
    for i, unit in ipairs(units) do
        displayRecruitedUnit(unit, i)
    end
    
    local choice = getValidNumber("\nChoose a unit to recruit (1-7):")
    if isValidIndex(choice, units) then
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
            
            -- Automatically add to squad for the first 5 recruits
            if #army.active <= 5 then
                local squadSuccess, squadMessage = army.addToSquad(#army.active)
                print("\n" .. squadMessage)
            end
            

            return remainingGold, selectedUnit
        else
            print("\nNot enough gold! You need " .. (selectedUnit.cost - gold) .. " more gold.")
            return recruitCharacter(gold)
        end
    else
        print("\nInvalid choice. Try again.")
        return recruitCharacter(gold)
    end
end


-- Display functions
local function displayGameRules()
    print([[Game Rules and Mechanics
-----------------------
1. Army Management:
   - Maximum army size: 20 units
   - Squad size: 5 units
   - Units can be freely added or removed from squad
2. Leveling System:
   - Cost: 50 gems per level
   - Maximum level: 11, labelled Max
   - XP requirements increase with each level
   
3. Currencies:
   - Gold: Used for recruiting units
   - Gems: Used for leveling up units
]])
end


local function confirmAction(prompt)
    while true do
        print(prompt .. " (y/n)")
        local input = io.read():lower()
        if input == "y" or input == "yes" then
            return true
        elseif input == "n" or input == "no" then
            return false
        else
            print("\nInvalid input. Please enter 'y' or 'n'.")
        end
    end
end

local function displayMainMenu()
    while true do
        print("\n-----------------------------")
        print("Main Menu")
        print("Gold: " .. gameState.currencies.gold)
        print("Gems: " .. gameState.currencies.gems)
        print("1. Recruit a Unit")
        print("2. Manage Army")
        print("3. Initiate Battle")
        print("4. View Game Rules")
        print("5. Exit Game")

        local choice = getValidNumber("\nEnter your choice:")

        if choice == 1 then
            gameState.currencies.gold = recruitCharacter(gameState.currencies.gold)
        elseif choice == 2 then
            manageArmy()
        elseif choice == 3 then
            if #army.squad == 0 then
                print("\nYour squad is empty. You need units in your squad to initiate a battle.")
            else
                local enemySquad = battleSystem.generateEnemySquad()
        
                if #enemySquad == 0 then
                    print("\nError: Generated enemy squad is empty.")
                else
                    print("\n-----------------------------")
                    print("\n" .. colors.colorize("Wild Enemy Encountered!", "Legendary"))
        
                    -- Format and display Player Squad
                    print("\nPlayer Squad:")
                    for _, unit in ipairs(army.squad) do
                        local unitName = colors.formatUnitName(unit.rarity, unit.name or "Unnamed")
                        print(" - " .. unitName .. " (" .. unit.rarity .. " " .. unit.class .. "), HP: " .. (unit.stats.Vitality or 0))
                    end
        
                    -- Format and display Enemy Squad
                    print("\nEnemy Squad:")
                    for _, unit in ipairs(enemySquad) do
                        local unitName = colors.formatUnitName(unit.rarity, unit.name or "Unnamed")
                        print(" - " .. unitName .. " (" .. unit.rarity .. " " .. unit.class .. "), HP: " .. (unit.stats.Vitality or 0))
                    end
                            
                    battleSystem.battleFlow(army.squad, enemySquad, confirmAction)
                end
            end
                
        elseif choice == 4 then
            displayGameRules()
        elseif choice == 5 then
            print("\nThank you for playing! Goodbye.")
            break
        else
            print("\nInvalid choice. Please try again.")
        end
    end
end

-- Game introduction
local function gameIntroduction()
    print([[Welcome to **The Crown's Blade**!
---------------------------------
A kingdom in peril calls for brave warriors to rise and reclaim its glory.
As the leader of this campaign, it is your duty to assemble a mighty army.

-> For battles inside the kingdom, you may take a team of 5 Knights.
-> This limit is lifted when fighting the kingdom's invaders.

Each recruit brings their unique skills and strengths.
Choose wisely, for the fate of the realm rests on your shoulders!

Game Features:
- Recruit unique units of different classes and rarities
- Build a squad of 5 units for battle
- Strategic squad building with unique class bonuses
- Level up your units to increase their power

You start with:
- 1000 gold for recruiting
- 100 gems for leveling units
]])

 print("\nWould you like to recruit your first unit? (yes/no)")
    local answer = io.read():lower()
    if answer == "yes" then
        local remainingGold, unit = recruitCharacter(gameState.currencies.gold)
        gameState.currencies.gold = remainingGold or gameState.currencies.gold
        if unit then
            gameState.hasStarterUnit = true
        end
    end
end


-- Main execution
math.randomseed(os.time())
gameIntroduction()
displayMainMenu()
