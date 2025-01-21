-- Rarity multipliers
local rarityMultipliers = {
    Common = { stat = 0.2, cost = 0.2 },
    Uncommon = { stat = 0.5, cost = 0.5 },
    Epic = { stat = 0.8, cost = 0.8 },
    Elite = { stat = 1.0, cost = 1.0 },
    Unique = { stat = 2.0, cost = 2.0 },
    Legendary = { stat = 3.0, cost = 3.0 },
}

-- Rarity chances
local rarityChances = {
    { rarity = "Legendary", chance = 0.1 },
    { rarity = "Unique", chance = 2.0 },
    { rarity = "Elite", chance = 10.0 },
    { rarity = "Epic", chance = 15.0 },
    { rarity = "Uncommon", chance = 30.0 },
    { rarity = "Common", chance = 42.9 },
}

-- Base stats for level 10 Unique units
local baseStats = {
    Vanguard = { Strength = 80, Vitality = 110, Agility = 60, Intelligence = 40, Wisdom = 70, Dexterity = 50 },
    Spearsman = { Strength = 60, Vitality = 90, Agility = 80, Intelligence = 50, Wisdom = 50, Dexterity = 60 },
    Swordsman = { Strength = 75, Vitality = 75, Agility = 70, Intelligence = 50, Wisdom = 50, Dexterity = 100 },
    Marksman = { Strength = 60, Vitality = 70, Agility = 100, Intelligence = 60, Wisdom = 50, Dexterity = 60 },
    Mage = { Strength = 40, Vitality = 60, Agility = 50, Intelligence = 100, Wisdom = 80, Dexterity = 70 },
    Cleric = { Strength = 40, Vitality = 80, Agility = 60, Intelligence = 80, Wisdom = 90, Dexterity = 50 },
    Wildling = { Strength = 90, Vitality = 90, Agility = 70, Intelligence = 30, Wisdom = 30, Dexterity = 90 },
}


-- Function to calculate stats, cost, and hidden Luck
local function calculateStatsAndCost(baseStats, rarity)
    local multiplier = rarityMultipliers[rarity]
    local scaledStats = {}
    local luck = math.random(2, 20) -- Hidden Luck stat

    local cost = 0

    for stat, value in pairs(baseStats) do
        scaledStats[stat] = math.floor(value * multiplier.stat)
    end


    -- Recruitment cost: Main stat, Luck, and multiplier
    local primaryStat = scaledStats.Strength or 0 -- Defaulting to Strength if primary stat is unclear
    cost = math.floor((primaryStat + luck * 2) * multiplier.cost)

    scaledStats.Luck = luck -- Include Luck in the unit's stats

    return scaledStats, cost
end

-- Function to select a rarity using weighted random
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

    return "Common" -- Fallback in case of rounding issues
end

return {
    baseStats = baseStats,
    rarityMultipliers = rarityMultipliers,
    calculateStatsAndCost = calculateStatsAndCost,
    selectRarity = selectRarity,
}
