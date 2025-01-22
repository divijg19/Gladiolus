-- Constants for game balance
local CONSTANTS = {
    LUCK_MIN = 2,
    LUCK_MIN_MAX = 20,
    PRIMARY_STAT_COST_MULTIPLIER = 5/6,
    LUCK_COST_MULTIPLIER = 3/4,
    BASE_COST = 100,
    DEFAULT_PRIMARY_STAT = "Strength",
    MAX_LEVEL = 11,
    -- XP scaling constants
    BASE_XP = 100,        -- Base XP needed for level 2
    GROWTH_FACTOR = 1.5,  -- How quickly XP requirements grow
    SCALING_POWER = 2     -- Power factor for exponential scaling
}

-- Rarity multipliers
local rarityMultipliers = {
    Common = { stat = 0.2, cost = 0.2 },
    Uncommon = { stat = 0.5, cost = 0.5 },
    Epic = { stat = 0.8, cost = 0.8 },
    Elite = { stat = 1.0, cost = 1.0 },
    Unique = { stat = 2.0, cost = 2.0 },
    Legendary = { stat = 3.0, cost = 3.0 },
}

-- Rarity chances (maintained exact order and values from original)
local rarityChances = {
    { rarity = "Legendary", chance = 0.1 },
    { rarity = "Unique", chance = 2.0 },
    { rarity = "Elite", chance = 10.0 },
    { rarity = "Epic", chance = 15.0 },
    { rarity = "Uncommon", chance = 30.0 },
    { rarity = "Common", chance = 42.9 },
}

-- Base stats for level 10 Elite units (maintained exactly as in original)
local baseStats = {
    Vanguard = {
        Strength = 80,
        Vitality = 110,
        Agility = 60,
        Intelligence = 40,
        Wisdom = 70,
        Dexterity = 50
    },
    Spearsman = {
        Strength = 60,
        Vitality = 90,
        Agility = 80,
        Intelligence = 50,
        Wisdom = 50,
        Dexterity = 60
    },
    Swordsman = {
        Strength = 75,
        Vitality = 75,
        Agility = 70,
        Intelligence = 50,
        Wisdom = 50,
        Dexterity = 100
    },
    Marksman = {
        Strength = 60,
        Vitality = 70,
        Agility = 100,
        Intelligence = 60,
        Wisdom = 50,
        Dexterity = 60
    },
    Mage = {
        Strength = 40,
        Vitality = 60,
        Agility = 50,
        Intelligence = 100,
        Wisdom = 80,
        Dexterity = 70
    },
    Cleric = {
        Strength = 40,
        Vitality = 80,
        Agility = 60,
        Intelligence = 80,
        Wisdom = 90,
        Dexterity = 50
    },
    Rogue = {
        Strength = 90,
        Vitality = 90,
        Agility = 70,
        Intelligence = 30,
        Wisdom = 30,
        Dexterity = 90
    }
}

-- Primary stat mapping for each class
local primaryStats = {
    Vanguard = "Vitality",
    Spearsman = "Agility",
    Swordsman = "Dexterity",
    Marksman = "Agility",
    Mage = "Intelligence",
    Cleric = "Wisdom",
    Rogue = "Dexterity"
}

-- Function to calculate stats and cost (maintaining original formula)
local function calculateStatsAndCost(baseStats, rarity, class)
    if not baseStats then
        error("Base stats cannot be nil")
    end
    
    local multiplier = rarityMultipliers[rarity]
    if not multiplier then
        error("Invalid rarity: " .. tostring(rarity))
    end
    
    local luck = math.random(CONSTANTS.LUCK_MIN, CONSTANTS.LUCK_MIN_MAX)

    -- Calculate scaled stats
    local scaledStats = {
        Strength = math.floor(baseStats.Strength * multiplier.stat),
        Vitality = math.floor(baseStats.Vitality * multiplier.stat),
        Agility = math.floor(baseStats.Agility * multiplier.stat),
        Intelligence = math.floor(baseStats.Intelligence * multiplier.stat),
        Wisdom = math.floor(baseStats.Wisdom * multiplier.stat),
        Dexterity = math.floor(baseStats.Dexterity * multiplier.stat),
        Luck = luck
    }

    -- Determine the primary stat for the class
    local primaryStat = primaryStats[class] or CONSTANTS.DEFAULT_PRIMARY_STAT
    local primaryStatValue = scaledStats[primaryStat] or 0

    -- Calculate cost using original formula
    local calculatedCost = math.floor(((5 * primaryStatValue)/6) + (luck*(3/4)) + 100 * multiplier.cost)
    return scaledStats, calculatedCost
end

-- Function to select a rarity (maintained exactly as in original)
local function selectRarity()
    local totalWeight = 0
    for _, entry in ipairs(rarityChances) do
        totalWeight = totalWeight + entry.chance
    end
    
    local randomValue = math.random() * totalWeight
    local cumulative = 0
    
    for _, entry in ipairs(rarityChances) do
        cumulative = cumulative + entry.chance
        if randomValue <= cumulative then
            return entry.rarity
        end
    end
    
    return "Common"
end

-- Calculate XP requirements table with exponential scaling
local xpRequirements = {}
for level = 2, CONSTANTS.MAX_LEVEL do
    -- Formula: BASE_XP * (GROWTH_FACTOR^(level-1)) * ((level-1)^SCALING_POWER)
    xpRequirements[level] = math.floor(
        CONSTANTS.BASE_XP * 
        (CONSTANTS.GROWTH_FACTOR ^ (level - 1)) * 
        ((level - 1) ^ CONSTANTS.SCALING_POWER)
    )
end

-- Function to initialize a character (maintained as in original)
local function initializeCharacter(class, rarity)
    if not baseStats[class] then
        error("Invalid class: " .. tostring(class))
    end
    
    local stats, cost = calculateStatsAndCost(baseStats[class], rarity, class)
    return {
        class = class,
        rarity = rarity,
        level = 1,
        xp = 0,
        stats = stats,
        cost = cost
    }
end

-- Function to add XP to a character (maintaining original behavior with additional returns)
local function addXP(character, xpGained)
    character.xp = character.xp + xpGained
    local canLevelUp = character.level < CONSTANTS.MAX_LEVEL and 
                       character.xp >= xpRequirements[character.level + 1]
    
    if canLevelUp then
        print("Level up available! Use gems to level up.")
    end
    
    return canLevelUp
end

-- Function to level up a character (maintaining original behavior)
local function levelUp(character, gemsAvailable, gemCostPerLevel)
    if character.level >= CONSTANTS.MAX_LEVEL then
        print("Character is already at max level.")
        return false
    end
    
    local nextLevelXP = xpRequirements[character.level + 1]
    if character.xp < nextLevelXP then
        print("Not enough XP to level up.")
        return false
    end
    
    if gemsAvailable < gemCostPerLevel then
        print("Not enough gems to level up.")
        return false
    end
    
    character.level = character.level + 1
    character.xp = character.xp - nextLevelXP
    return true
end

-- Return the module with all original exports
return {
    baseStats = baseStats,
    rarityMultipliers = rarityMultipliers,
    calculateStatsAndCost = calculateStatsAndCost,
    selectRarity = selectRarity,
    initializeCharacter = initializeCharacter,
    addXP = addXP,
    levelUp = levelUp
}
