-- battleSystem.lua
local army = require("src/army")
local colors = require("src/colors")
local enemyCodex = require("src/enemy_codex")

local battleSystem = {}

local BATTLE_CONSTANTS = {
   TURN_ORDER_STAT = "Agility",
   BASE_DAMAGE = 5,  -- Reduced base damage
   CRITICAL_HIT_CHANCE = 0.1,
   CRITICAL_HIT_MULTIPLIER = 1.5,
   DEFENSE_MULTIPLIER = 0.3,  -- Reduced defense impact
   MAX_DAMAGE_VARIANCE = 0.4  -- Add randomness to damage
}

local function getValidNumber(prompt)
   while true do
       print(prompt)
       local input = tonumber(io.read())
       if input then return input
       else print("Invalid input. Please enter a valid number.") end
   end
end

local function displaySquadDetails(squad, squadType)
   print(string.format("\n%s Squad Details:", squadType))
   for _, unit in ipairs(squad) do
       print(string.format(" - %s (%s)", 
           colors.formatUnitName(unit.rarity, unit.name), 
           unit.class))
       print(string.format("    HP: %d, Attack: %d, Defense: %d", 
           unit.stats.Vitality or 0, 
           unit.stats.Strength or 0, 
           unit.stats.Defense or 0))
   end
end

local function sabotageEnemy(enemySquad, playerSquad)
   print("\nAttempting to sabotage the enemy...")
   
   -- Calculate sabotage base chance based on player squad's intelligence
   local totalIntelligence = 0
   local unitCount = 0
   for _, unit in ipairs(playerSquad) do
       totalIntelligence = totalIntelligence + (unit.stats.Intelligence or 3)
       unitCount = unitCount + 1
   end
   local baseIntelligenceMultiplier = (totalIntelligence / unitCount) / 10

   for _, unit in ipairs(enemySquad) do
       -- Dynamic success chance calculation
       local sabotageChance = 0.5 * baseIntelligenceMultiplier
       local randomRoll = math.random()
       
       if randomRoll < sabotageChance then
           -- Different sabotage effects based on random selection
           local sabotageEffects = {
               function() 
                   local agilityLoss = math.random(1, 3)
                   unit.stats.Agility = math.max(1, unit.stats.Agility - agilityLoss)
                   print(string.format("%s lost %d Agility!", 
                       colors.formatUnitName(unit.rarity, unit.name), 
                       agilityLoss))
               end,
               function() 
                   local strengthLoss = math.random(1, 3)
                   unit.stats.Strength = math.max(1, unit.stats.Strength - strengthLoss)
                   print(string.format("%s lost %d Strength!", 
                       colors.formatUnitName(unit.rarity, unit.name), 
                       strengthLoss))
               end,
               function() 
                   local vitalityLoss = math.random(1, 5)
                   unit.stats.Vitality = math.max(1, unit.stats.Vitality - vitalityLoss)
                   print(string.format("%s lost %d Vitality!", 
                       colors.formatUnitName(unit.rarity, unit.name), 
                       vitalityLoss))
               end
           }
           
           -- Randomly choose a sabotage effect
           sabotageEffects[math.random(#sabotageEffects)]()
       else
           print(string.format("%s resisted sabotage.", 
               colors.formatUnitName(unit.rarity, unit.name)))
       end
   end
end

local function validateSquad(squad, squadType)
   for i, unit in ipairs(squad) do
       if not unit.name then
           unit.name = squadType .. " Unit_" .. i
       end
       if not unit.stats or not unit.stats.Vitality then
           return false, squadType .. " unit missing vital stats."
       end
       if unit.stats.Vitality <= 0 then
           unit.stats.Vitality = 1
           print(squadType .. " unit at index " .. i .. " had invalid Vitality. Adjusted to 1.")
       end
   end
   return true
end

local function determineTurnOrder(playerSquad, enemySquad)
   local sortedUnits = {}

   for _, unit in ipairs(playerSquad) do
       table.insert(sortedUnits, {
           name = unit.name or unit.class,
           class = unit.class,
           rarity = unit.rarity,
           stats = unit.stats,
           ref = unit,  -- Add a reference to the original unit
           alive = true,
           isPlayer = true
       })
   end

   for _, unit in ipairs(enemySquad) do
       table.insert(sortedUnits, {
           name = unit.name or unit.class,
           class = unit.class,
           rarity = unit.rarity,
           stats = unit.stats,
           ref = unit,  -- Add a reference to the original unit
           alive = true,
           isPlayer = false
       })
   end

   table.sort(sortedUnits, function(a, b)
       return a.stats[BATTLE_CONSTANTS.TURN_ORDER_STAT] > 
              b.stats[BATTLE_CONSTANTS.TURN_ORDER_STAT]
   end)

   return sortedUnits
end

local function calculateDamage(attacker, defender)
   local strengthFactor = attacker.stats.Strength or 5
   local defenseFactor = (defender.stats.Defense or 1) * BATTLE_CONSTANTS.DEFENSE_MULTIPLIER
   
   -- Base damage with variance
   local baseDamage = BATTLE_CONSTANTS.BASE_DAMAGE + 
                      (strengthFactor * 1.5)
   
   -- Add random variance to damage
   local damageVariance = math.random() * BATTLE_CONSTANTS.MAX_DAMAGE_VARIANCE * baseDamage
   baseDamage = baseDamage + (math.random() > 0.5 and 1 or -1) * damageVariance
   
   local damage = math.max(1, math.floor(baseDamage - defenseFactor))

   local critChance = BATTLE_CONSTANTS.CRITICAL_HIT_CHANCE + (attacker.stats.Luck or 0) * 0.05
   if math.random() < critChance then
       damage = math.floor(damage * BATTLE_CONSTANTS.CRITICAL_HIT_MULTIPLIER)
       print(colors.colorize("\nCritical Hit!", "Legendary"))
   end

   return math.floor(damage)
end

function battleSystem.preBattleMenu(playerSquad, enemySquad, confirmAction)
   while true do
       print("\n-----------------------------")
       print("Pre-Battle Menu")
       local menuOptions = {
           {text = "Engage in Battle", action = function() 
               local isValid, errorMessage = validateSquad(playerSquad, "Player")
               if not isValid then
                   print("Warning: " .. errorMessage)
                   return nil
               end
               
               if confirmAction and confirmAction("Are you sure you want to engage in battle?") then
                   return "engage"
               end
               return nil
           end},
           {text = "Retreat from Battle", action = function() return "retreat" end},
           {text = "View Player Squad Details", action = function() 
               displaySquadDetails(playerSquad, "Your") 
               return nil 
           end},
           {text = "View Enemy Squad Details", action = function() 
               displaySquadDetails(enemySquad, "Enemy")
               return nil 
           end},
           {text = "Sabotage Enemy Squad", action = function() 
               sabotageEnemy(enemySquad, playerSquad)
               return nil 
           end}
       }

       for i, option in ipairs(menuOptions) do
           print(string.format("%d. %s", i, option.text))
       end

       local choice = getValidNumber("Enter your choice: ")
       
       if choice > 0 and choice <= #menuOptions then
           local result = menuOptions[choice].action()
           if result == "retreat" then
               print("You have chosen to retreat. Exiting pre-battle.")
               return "retreat"
           elseif result == "engage" then
               print("Preparing to engage in battle!")
               return "engage"
           end
       else
           print("\nInvalid choice. Please try again.")
       end
   end
end


function battleSystem.generateEnemySquad()
   local enemySquad = {}
   local numberOfEnemies = math.random(1, 4)
   local unitCounts = {}

   for _ = 1, numberOfEnemies do
       local randomEnemy = enemyCodex.enemies[
           math.random(#enemyCodex.enemies)
       ]

       local enemyCount = (unitCounts[randomEnemy.name] or 0) + 1
       unitCounts[randomEnemy.name] = enemyCount

       local numberedName = enemyCount > 1 
           and randomEnemy.name .. " #" .. enemyCount 
           or randomEnemy.name

       local enemyUnit = {
           name = numberedName,
           class = randomEnemy.class or "Unknown",
           rarity = randomEnemy.rarity or "Common",
           level = randomEnemy.level or 1,
           stats = {
               Vitality = randomEnemy.stats.Vitality or 10, 
               Strength = randomEnemy.stats.Strength or 5, 
               Agility = randomEnemy.stats.Agility or 3,
               Luck = randomEnemy.stats.Luck or 1
           },
           alive = true
       }

       table.insert(enemySquad, enemyUnit)
   end

   return enemySquad
end

local function safeValidateSquad(squad, squadType)
    for i, unit in ipairs(squad) do
        if not unit.name then 
            unit.name = squadType .. " Unit_" .. i 
        end
        if not unit.stats then 
            unit.stats = {} 
        end
        -- Ensure all necessary stats have default values
        unit.stats.Vitality = math.max(1, unit.stats.Vitality or 10)
        unit.stats.Strength = unit.stats.Strength or 5
        unit.stats.Agility = unit.stats.Agility or 3
        unit.stats.Defense = unit.stats.Defense or 1
        unit.stats.Luck = unit.stats.Luck or 1
        unit.alive = true
    end
    return true
end

function battleSystem.battleFlow(playerSquad, enemySquad, confirmAction)
    -- Restore pre-battle menu
    local preBattleChoice = battleSystem.preBattleMenu(
        playerSquad, 
        enemySquad, 
        confirmAction
    )
   
    if preBattleChoice == "retreat" then
        print("You have retreated from the battle.")
        return false
    end

    -- Validate squads
    safeValidateSquad(playerSquad, "Player")
    safeValidateSquad(enemySquad, "Enemy")

    local turnOrder = determineTurnOrder(playerSquad, enemySquad)

    print("\n=============================")
    print("\n" .. colors.colorize("Battle Begins!", "Legendary"))
    print("=============================")

    while #playerSquad > 0 and #enemySquad > 0 do
        for _, turnUnit in ipairs(turnOrder) do
            if turnUnit.alive and turnUnit.ref.alive then
                local targetSquad = turnUnit.isPlayer and enemySquad or playerSquad
               
                if #targetSquad == 0 then break end

                -- Interactive target selection for player units
                local target
                if turnUnit.isPlayer then
                    print(string.format("\n%s's turn", 
                        colors.formatUnitName(turnUnit.ref.rarity, turnUnit.ref.name)))
                    
                    print("Choose a target:")
                    for i, enemyUnit in ipairs(targetSquad) do
                        print(string.format("%d. %s (HP: %d)", 
                            i, 
                            colors.formatUnitName(enemyUnit.rarity, enemyUnit.name), 
                            enemyUnit.stats.Vitality))
                    end

                    local choice
                    while true do
                        choice = getValidNumber("Enter target number: ")
                        if choice > 0 and choice <= #targetSquad then
                            target = targetSquad[choice]
                            break
                        else
                            print("Invalid target. Try again.")
                        end
                    end
                else
                    -- Random targeting for enemy units
                    target = targetSquad[math.random(#targetSquad)]
                end

                local damage = calculateDamage(turnUnit.ref, target)
               
                target.stats.Vitality = target.stats.Vitality - damage

                print(string.format("%s attacks %s for %d damage! (%d HP remaining)",
                    colors.formatUnitName(turnUnit.ref.rarity, turnUnit.ref.name),
                    colors.formatUnitName(target.rarity, target.name),
                    damage,
                    math.max(0, target.stats.Vitality)))

                if target.stats.Vitality <= 0 then
                    print(colors.formatUnitName(target.rarity, target.name) .. " has been defeated!")
                    target.alive = false

                    for i, t in ipairs(targetSquad) do
                        if t == target then
                            table.remove(targetSquad, i)
                            break
                        end
                    end
                end

                -- Battle end conditions
                if #playerSquad == 0 then
                    print("\nYou have been defeated! The enemy is victorious.")
                    return false
                elseif #enemySquad == 0 then
                    print("\nVictory! The enemy has been defeated.")
                    return true
                end

                -- Pause between turns for readability
                print("\nPress Enter to continue...")
                io.read()
            end
        end
    end

    return false
end

battleSystem.validateSquad = validateSquad
return battleSystem
