local CONSTANTS = {
    LUCK_MIN = 2,
    LUCK_MIN_MAX = 20,
    PRIMARY_STAT_COST_MULTIPLIER = 5/6,
    LUCK_COST_MULTIPLIER = 3/4,
    BASE_COST = 100,
    DEFAULT_PRIMARY_STAT = "Strength",
    MAX_LEVEL = 11,
    -- XP scaling constants
    BASE_XP = 100,
    GROWTH_FACTOR = 1.5,
    SCALING_POWER = 2
}

-- Game data tables
local rarityMultipliers = {
    Common = { stat = 0.2, cost = 0.2 },
    Uncommon = { stat = 0.5, cost = 0.5 },
    Epic = { stat = 0.8, cost = 0.8 },
    Elite = { stat = 1.0, cost = 1.0 },
    Unique = { stat = 2.0, cost = 2.0 },
    Legendary = { stat = 3.0, cost = 3.0 },
}

local rarityChances = {
    { rarity = "Legendary", chance = 0.1 },
    { rarity = "Unique", chance = 2.0 },
    { rarity = "Elite", chance = 10.0 },
    { rarity = "Epic", chance = 15.0 },
    { rarity = "Uncommon", chance = 30.0 },
    { rarity = "Common", chance = 42.9 },
}

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

local primaryStats = {
    Vanguard = "Vitality",
    Spearsman = "Agility",
    Swordsman = "Dexterity",
    Marksman = "Agility",
    Mage = "Intelligence",
    Cleric = "Wisdom",
    Rogue = "Dexterity"
}

-- Pre-calculate XP requirements table
local xpRequirements = {}
for level = 2, CONSTANTS.MAX_LEVEL do
    xpRequirements[level] = math.floor(
        CONSTANTS.BASE_XP * 
        (CONSTANTS.GROWTH_FACTOR ^ (level - 1)) * 
        ((level - 1) ^ CONSTANTS.SCALING_POWER)
    )
end

-- Helper function to validate character data
local function validateCharacterData(stats, rarity)
    if not stats then
        error("Base stats cannot be nil")
    end
    if not rarityMultipliers[rarity] then
        error("Invalid rarity: " .. tostring(rarity))
    end
end

-- Core game mechanics functions
local function calculateStatsAndCost(stats, rarity, class)
    validateCharacterData(stats, rarity)
    
    local multiplier = rarityMultipliers[rarity]
    local luck = math.random(CONSTANTS.LUCK_MIN, CONSTANTS.LUCK_MIN_MAX)

    -- Calculate scaled stats
    local scaledStats = {
        Strength = math.floor(stats.Strength * multiplier.stat),
        Vitality = math.floor(stats.Vitality * multiplier.stat),
        Agility = math.floor(stats.Agility * multiplier.stat),
        Intelligence = math.floor(stats.Intelligence * multiplier.stat),
        Wisdom = math.floor(stats.Wisdom * multiplier.stat),
        Dexterity = math.floor(stats.Dexterity * multiplier.stat),
        Luck = luck
    }

    local primaryStat = primaryStats[class] or CONSTANTS.DEFAULT_PRIMARY_STAT
    local primaryStatValue = scaledStats[primaryStat] or 0

    -- Calculate cost using primary stat value, luck, and rarity multiplier
    local calculatedCost = math.floor(
        (primaryStatValue * CONSTANTS.PRIMARY_STAT_COST_MULTIPLIER) + 
        (luck * CONSTANTS.LUCK_COST_MULTIPLIER) + 
        CONSTANTS.BASE_COST * multiplier.cost
    )
    
    return scaledStats, calculatedCost
end

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

-- Character progression functions
local function addXP(character, xpGained)
    if type(xpGained) ~= "number" or xpGained < 0 then
        error("Invalid XP amount")
    end
    
    character.xp = character.xp + xpGained
    local canLevelUp = character.level < CONSTANTS.MAX_LEVEL and 
                       character.xp >= xpRequirements[character.level + 1]
    
    if canLevelUp then
        print("Level up available! Use gems to level up.")
    end
    
    return canLevelUp
end

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

-- Module exports
return {
    -- Constants and data tables
    baseStats = baseStats,
    rarityMultipliers = rarityMultipliers,
    
    -- Core game mechanics
    calculateStatsAndCost = calculateStatsAndCost,
    selectRarity = selectRarity,
    initializeCharacter = initializeCharacter,
    
    -- Character progression
    addXP = addXP,
    levelUp = levelUp,
    
    -- Expose constants for testing and configuration
    CONSTANTS = CONSTANTS
}
