local army = require("src/army")
local colors = require("src/colors")
local enemyCodex = require("src/enemy_codex")  -- Require the enemy codex

local battleSystem = {}

-- Constants for battle system
local CONSTANTS = {
    TURN_ORDER_STATS = "Agility", -- Determines turn order
    BASE_DAMAGE = 10,            -- Base damage multiplier
    CRITICAL_HIT_CHANCE = 0.1,   -- 10% chance for critical hits
    CRITICAL_HIT_MULTIPLIER = 1.5,  -- Critical hits do 1.5x damage
    DEFENSE_MULTIPLIER = 0.5
}

-- Helper function to determine turn order based on Agility
local function determineTurnOrder(playerSquad, enemySquad)
    local sortedUnits = {}
    
    -- Add player units with isPlayer flag
    for _, unit in ipairs(playerSquad) do
        table.insert(sortedUnits, {
            name = unit.name,
            class = unit.class,
            rarity = unit.rarity,
            stats = unit.stats,
            alive = true,
            isPlayer = true
        })
    end

    -- Add enemy units with isPlayer flag set to false
    for _, unit in ipairs(enemySquad) do
        table.insert(sortedUnits, {
            name = unit.name,
            class = unit.class,
            rarity = unit.rarity,
            stats = unit.stats,
            alive = true,
            isPlayer = false
        })
    end
    
    -- Sort by agility
    table.sort(sortedUnits, function(a, b)
        return a.stats[CONSTANTS.TURN_ORDER_STATS] > b.stats[CONSTANTS.TURN_ORDER_STATS]
    end)
    
    return sortedUnits
end

-- Function to calculate damage
local function calculateDamage(attacker, defender)
    local baseDamage = CONSTANTS.BASE_DAMAGE + (attacker.stats.Strength * 0.5)
    local defense = defender.stats.Vitality * CONSTANTS.DEFENSE_MULTIPLIER
    local damage = math.max(1, math.floor(baseDamage - defense))
    
    if math.random() < CONSTANTS.CRITICAL_HIT_CHANCE then
        damage = math.floor(damage * CONSTANTS.CRITICAL_HIT_MULTIPLIER)
        print(colors.colorize("\nCritical Hit!", "Legendary"))
    end
    
    return damage
end

-- Function to validate squads
local function validateSquad(squad, squadType)
    for i, unit in ipairs(squad) do
        if not unit.name then
            return false, squadType .. " unit at index " .. i .. " is missing a name."
        end
        if not unit.stats or not unit.stats.Vitality then
            return false, squadType .. " unit " .. (unit.name or "Unknown") .. " is missing stats or Vitality."
        end
    end
    return true
end

-- Function to generate an enemy squad from the enemy codex
local function generateEnemySquad()
    local enemySquad = {}
    local unitCounts = {} -- Track how many of each enemy type has been added
    local numberOfEnemies = math.random(1, 4) -- Randomize squad size (1-4 enemies)

    for i = 1, numberOfEnemies do
        -- Randomly select an enemy from the codex
        local randomIndex = math.random(#enemyCodex.enemies)
        local randomEnemy = enemyCodex.enemies[randomIndex]

        -- Increment the count for this enemy type
        unitCounts[randomEnemy.name] = (unitCounts[randomEnemy.name] or 0) + 1
        local numberedName = randomEnemy.name

        -- Append a number only if the same type has appeared before
        if unitCounts[randomEnemy.name] > 1 then
            numberedName = randomEnemy.name .. " #" .. unitCounts[randomEnemy.name]
        end

        -- Create the enemy unit
        table.insert(enemySquad, {
            name = numberedName,
            class = randomEnemy.class or "Unknown",
            rarity = randomEnemy.rarity or "Common",
            level = randomEnemy.level or 1,
            stats = randomEnemy.stats or { Vitality = 10, Strength = 5, Agility = 3 },
            alive = true
        })
    end

    return enemySquad
end

-- Battle function
function battleSystem.battleFlow(playerSquad, enemySquad)
    -- Validate squads
    local isValid, errorMessage = validateSquad(playerSquad, "Player")
    if not isValid then
        error(errorMessage)
    end

    isValid, errorMessage = validateSquad(enemySquad, "Enemy")
    if not isValid then
        error(errorMessage)
    end
    
    -- Create turn order
    local turnOrder = determineTurnOrder(playerSquad, enemySquad)
    
    print("The battle begins!")
    
    -- Track original vitality for each unit
    local originalVitality = {}
    for _, unit in ipairs(playerSquad) do
        originalVitality[unit] = unit.stats.Vitality
    end
    for _, unit in ipairs(enemySquad) do
        originalVitality[unit] = unit.stats.Vitality
    end
    
    -- Battle loop
    while #playerSquad > 0 and #enemySquad > 0 do
        for _, unit in ipairs(turnOrder) do
            if not unit.alive then
                goto continue
            end
            
            local targetSquad = unit.isPlayer and enemySquad or playerSquad
            if #targetSquad == 0 then
                break
            end
            
            local target = targetSquad[math.random(1, #targetSquad)]
            local damage = calculateDamage(unit, target)
            
            target.stats.Vitality = target.stats.Vitality - damage
            
            print(string.format("%s attacks %s for %d damage! (%d HP remaining)",
                colors.formatUnitName(unit.rarity, unit.name),
                colors.formatUnitName(target.rarity, target.name),
                damage,
                math.max(0, target.stats.Vitality)))
            
            if target.stats.Vitality <= 0 then
                print(colors.formatUnitName(target.rarity, target.name) .. " has been defeated!")
                target.alive = false

                -- Remove defeated unit
                for i, t in ipairs(targetSquad) do
                    if t == target then
                        table.remove(targetSquad, i)
                        break
                    end
                end
            end

            if #playerSquad == 0 then
                print("Defeat. Your squad has been defeated. Retry? (y/n)")
                local retry = io.read()
                if retry == "y" then
                    return battleSystem.battleFlow(playerSquad, generateEnemySquad())
                end
            end
            
            ::continue::
        end
    end

    -- Restore original vitality after battle
    for unit, vitality in pairs(originalVitality) do
        unit.stats.Vitality = vitality
    end

    -- Determine battle outcome
    if #playerSquad > 0 then
        print("Victory! Your squad has won the battle.")
    else
        print("Defeat. Your squad has been defeated.")
    end
end

-- Exporting functions
battleSystem.generateEnemySquad = generateEnemySquad
battleSystem.battleFlow = battleSystem.battleFlow

return battleSystem
