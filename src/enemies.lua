-- enemies.lua
local colors = require("src/colors")

local enemies = {
    rarityData = {
        Common = {multiplier = 0.2, chance = 39.895},
        Uncommon = {multiplier = 0.5, chance = 30},
        Epic = {multiplier = 0.8, chance = 20},
        Elite = {multiplier = 1.0, chance = 8},
        Unique = {multiplier = 2.0, chance = 2},
        Legendary = {multiplier = 3.0, chance = 0.1},
        Fabled = {multiplier = 5.0, chance = 0.005}
    },

    classStatRanges = {
        Goblin = {Strength = {3, 8}, Vitality = {5, 10}, Agility = {5, 12}, Intelligence = {3, 7}, Wisdom = {2, 5}, Dexterity = {4, 10}, Luck = {3, 6}},
        Orc = {Strength = {5, 12}, Vitality = {8, 15}, Agility = {4, 10}, Intelligence = {2, 5}, Wisdom = {2, 4}, Dexterity = {5, 12}, Luck = {2, 5}},
        Wraith = {Strength = {3, 7}, Vitality = {5, 10}, Agility = {5, 15}, Intelligence = {4, 10}, Wisdom = {3, 8}, Dexterity = {4, 10}, Luck = {2, 5}},
        Knight = {Strength = {6, 15}, Vitality = {10, 20}, Agility = {4, 10}, Intelligence = {3, 8}, Wisdom = {3, 7}, Dexterity = {5, 12}, Luck = {2, 5}},
        Bandit = {Strength = {4, 10}, Vitality = {6, 12}, Agility = {5, 15}, Intelligence = {3, 7}, Wisdom = {2, 5}, Dexterity = {4, 10}, Luck = {3, 6}},
        Assassin = {Strength = {5, 11}, Vitality = {7, 15}, Agility = {8, 18}, Intelligence = {4, 9}, Wisdom = {3, 7}, Dexterity = {6, 14}, Luck = {3, 7}},
        Guardian = {Strength = {8, 16}, Vitality = {12, 22}, Agility = {3, 8}, Intelligence = {4, 10}, Wisdom = {5, 12}, Dexterity = {4, 10}, Luck = {3, 6}},
        Elemental = {Strength = {4, 10}, Vitality = {6, 15}, Agility = {5, 12}, Intelligence = {8, 18}, Wisdom = {6, 14}, Dexterity = {4, 10}, Luck = {3, 7}}
    }
}


enemies.templates = {
    WildAnimals = {
            {name = "Monkey", class = "Monkey", rarity = "Common", level = 1, stats = {Strength = 5, Vitality = 8, Agility = 12, Intelligence = 6, Wisdom = 5, Dexterity = 10, Luck = 5}},
            {name = "Snake", class = "Snake", rarity = "Common", level = 2, stats = {Strength = 4, Vitality = 6, Agility = 15, Intelligence = 5, Wisdom = 5, Dexterity = 12, Luck = 6}},
            {name = "Fox", class = "Fox", rarity = "Uncommon", level = 3, stats = {Strength = 6, Vitality = 10, Agility = 14, Intelligence = 8, Wisdom = 6, Dexterity = 13, Luck = 7}},
            {name = "Wolf", class = "Wolf", rarity = "Uncommon", level = 4, stats = {Strength = 10, Vitality = 15, Agility = 12, Intelligence = 7, Wisdom = 6, Dexterity = 10, Luck = 5}},
            {name = "Cub Bear", class = "Bear", rarity = "Uncommon", level = 3, stats = {Strength = 12, Vitality = 20, Agility = 8, Intelligence = 5, Wisdom = 4, Dexterity = 6, Luck = 5}},
            {name = "Adult Bear", class = "Bear", rarity = "Epic", level = 6, stats = {Strength = 18, Vitality = 30, Agility = 8, Intelligence = 5, Wisdom = 5, Dexterity = 7, Luck = 6}},
            {name = "Alpha Wolf", class = "Wolf", rarity = "Elite", level = 7, stats = {Strength = 12, Vitality = 16, Agility = 14, Intelligence = 6, Wisdom = 5, Dexterity = 12, Luck = 7}},
            {name = "Great Bear", class = "Bear", rarity = "Elite", level = 7, stats = {Strength = 18, Vitality = 30, Agility = 10, Intelligence = 8, Wisdom = 7, Dexterity = 8, Luck = 6}},
            {name = "Razorback Boar", class = "Boar", rarity = "Elite", level = 6, stats = {Strength = 22, Vitality = 34, Agility = 12, Intelligence = 6, Wisdom = 5, Dexterity = 10, Luck = 7}},
            {name = "Possessed Evil Bear", class = "Bear", rarity = "Unique", level = 9, stats = {Strength = 25, Vitality = 50, Agility = 10, Intelligence = 12, Wisdom = 8, Dexterity = 10, Luck = 7}}
        },
        Supernatural = {
            {name = "Shadow Stalker", class = "Assassin", rarity = "Elite", level = 6, stats = {Strength = 15, Vitality = 20, Agility = 25, Intelligence = 12, Wisdom = 10, Dexterity = 18, Luck = 10}},
            {name = "Ice Wraith", class = "Wraith", rarity = "Unique", level = 8, stats = {Strength = 8, Vitality = 15, Agility = 12, Intelligence = 15, Wisdom = 14, Dexterity = 10, Luck = 9}},
            {name = "Phantom Shade", class = "Wraith", rarity = "Unique", level = 7, stats = {Strength = 10, Vitality = 18, Agility = 20, Intelligence = 22, Wisdom = 19, Dexterity = 15, Luck = 12}},
            {name = "Fire Elemental", class = "Elemental", rarity = "Legendary", level = 11, stats = {Strength = 10, Vitality = 20, Agility = 8, Intelligence = 20, Wisdom = 15, Dexterity = 8, Luck = 6}},
            {name = "Flame Titan", class = "Elemental", rarity = "Legendary", level = 10, stats = {Strength = 25, Vitality = 50, Agility = 12, Intelligence = 30, Wisdom = 25, Dexterity = 15, Luck = 10}},
            {name = "Celestial Warden", class = "Guardian", rarity = "Fabled", level = 12, stats = {Strength = 40, Vitality = 60, Agility = 20, Intelligence = 35, Wisdom = 30, Dexterity = 18, Luck = 15}},
            {name = "Soul Reaper", class = "Reaper", rarity = "Fabled", level = 13, stats = {Strength = 50, Vitality = 100, Agility = 40, Intelligence = 30, Wisdom = 25, Dexterity = 35, Luck = 20}}
        },
        GiantsAndBeasts = {
            {name = "Stone Golem", class = "Golem", rarity = "Epic", level = 5, stats = {Strength = 20, Vitality = 40, Agility = 4, Intelligence = 4, Wisdom = 4, Dexterity = 5, Luck = 3}},
            {name = "Mountain Troll", class = "Troll", rarity = "Epic", level = 6, stats = {Strength = 15, Vitality = 25, Agility = 6, Intelligence = 4, Wisdom = 5, Dexterity = 6, Luck = 5}},
            {name = "Mountain Colossus", class = "Golem", rarity = "Unique", level = 8, stats = {Strength = 30, Vitality = 60, Agility = 8, Intelligence = 10, Wisdom = 10, Dexterity = 10, Luck = 8}},
            {name = "Nightmare Hydra", class = "Hydra", rarity = "Legendary", level = 10, stats = {Strength = 35, Vitality = 55, Agility = 12, Intelligence = 20, Wisdom = 15, Dexterity = 12, Luck = 10}},
            {name = "Thunder Wyvern", class = "Dragon", rarity = "Legendary", level = 11, stats = {Strength = 50, Vitality = 80, Agility = 20, Intelligence = 25, Wisdom = 20, Dexterity = 18, Luck = 15}},
            {name = "Thunder Roc", class = "Roc", rarity = "Legendary", level = 10, stats = {Strength = 30, Vitality = 50, Agility = 20, Intelligence = 10, Wisdom = 12, Dexterity = 18, Luck = 10}},
            {name = "Ancient Hydra", class = "Hydra", rarity = "Fabled", level = 14, stats = {Strength = 60, Vitality = 120, Agility = 30, Intelligence = 20, Wisdom = 15, Dexterity = 25, Luck = 15}}
        }
}

function enemies.getRandomRarity()
    local roll = math.random() * 100
    local cumulativeChance = 0

    for rarity, data in pairs(enemies.rarityData) do
        cumulativeChance = cumulativeChance + data.chance
        if roll <= cumulativeChance then
            return rarity
        end
    end

    return "Common"
end

local function applyRarityMultiplier(stats, rarity)
    local multiplier = enemies.rarityData[rarity].multiplier or 1.0
    local scaledStats = {}
    for stat, value in pairs(stats) do
        scaledStats[stat] = math.floor(value * (multiplier + math.random() * 0.2))
    end
    return scaledStats
end

function enemies.generateDynamicEnemy(level, enemyType)
    local rarity = enemies.getRandomRarity()
    local classes = {}
    for class, _ in pairs(enemies.classStatRanges) do
        table.insert(classes, class)
    end
    
    local class = enemyType or classes[math.random(#classes)]
    local statRanges = enemies.classStatRanges[class]

    local baseStats = {
        Strength = math.random(statRanges.Strength[1], statRanges.Strength[2]) * (1 + (level - 1) * 0.1),
        Vitality = math.random(statRanges.Vitality[1], statRanges.Vitality[2]) * (1 + (level - 1) * 0.1),
        Agility = math.random(statRanges.Agility[1], statRanges.Agility[2]) * (1 + (level - 1) * 0.1),
        Intelligence = math.random(statRanges.Intelligence[1], statRanges.Intelligence[2]) * (1 + (level - 1) * 0.1),
        Wisdom = math.random(statRanges.Wisdom[1], statRanges.Wisdom[2]) * (1 + (level - 1) * 0.1),
        Dexterity = math.random(statRanges.Dexterity[1], statRanges.Dexterity[2]) * (1 + (level - 1) * 0.1),
        Luck = math.random(statRanges.Luck[1], statRanges.Luck[2]) * (1 + (level - 1) * 0.1)
    }

    for stat, value in pairs(baseStats) do
        baseStats[stat] = math.floor(value)
    end
    local scaledStats = applyRarityMultiplier(baseStats, rarity)

    return {
        name = class,
        class = class,
        level = level,
        rarity = rarity,
        stats = scaledStats
    }
end

function enemies.generateDynamicEnemySquad(baseLevel, minUnits, maxUnits)
    local squadSize = math.random(minUnits or 1, maxUnits or 4)
    local enemySquad = {}

    for _ = 1, squadSize do
        local enemyLevel = baseLevel + math.random(-1, 1)
        table.insert(enemySquad, enemies.generateDynamicEnemy(enemyLevel))
    end

    return enemySquad
end

return enemies
