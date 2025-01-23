-- test_enemies.lua
-- Import the enemies and colors modules
local enemies = require("src/enemies") -- Adjust the path if necessary
local colors = require("src.colors")  -- Adjust the path if necessary

-- Function to simulate rarity rolls
local function testRarityDistribution(simulations)
    local rarityCounts = {}
    local sortedRarities = {} -- To maintain the order of rarities

    -- Initialize rarity counts and sort rarities based on the order in rarityData
    for rarity, _ in pairs(enemies.rarityData) do
        rarityCounts[rarity] = 0
        table.insert(sortedRarities, rarity)
    end

    -- Sort rarities by their chance values
    table.sort(sortedRarities, function(a, b)
        return enemies.rarityData[a].chance > enemies.rarityData[b].chance
    end)

    -- Run the simulations
    for _ = 1, simulations do
        local rarity = enemies.getRandomRarity()
        rarityCounts[rarity] = rarityCounts[rarity] + 1
    end

    -- Print results in sorted order with colors
    print("Rarity Distribution after " .. simulations .. " simulations:")
    for _, rarity in ipairs(sortedRarities) do
        local count = rarityCounts[rarity]
        local percentage = (count / simulations) * 100
        local rarityNameColored = colors.colorize(rarity, rarity) -- Use the colorize function
        print(string.format("%s: %.2f%% (Expected: %.2f%%)", rarityNameColored, percentage, enemies.rarityData[rarity].chance))
    end
end

-- Run the test with 1,000,000 simulations
testRarityDistribution(1000000)
