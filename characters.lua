-- Import character classes
local characters = require("src/characters")

-- Function to display character stats
local function displayCharacterStats(className, stats)
    print("\nClass: " .. className)
    print("  Strength: " .. stats.Strength)
    print("  Vitality: " .. stats.Vitality)
    print("  Agility: " .. stats.Agility)
    print("  Intelligence: " .. stats.Intelligence)
    print("  Wisdom: " .. stats.Wisdom)
    print("  Dexterity: " .. stats.Dexterity)
end

-- Function to calculate recruitment cost
local baseCosts = {
    Vanguard = 50,
    Spearsman = 40,
    Swordsman = 35,
    Marksman = 30,
    Mage = 25,
    Cleric = 30,
    Wildling = 60,
}

local rarityMultipliers = {
    Common = 0.2,
    Uncommon = 0.5,
    Epic = 0.8,
    Elite = 1.0,
    Unique = 2.0,
    Legendary = 3.0,
}

local function calculateCost(class, stats, rarity)
    local baseCost = baseCosts[class]
    local vitalityWeight = stats.Vitality * 0.5
    local mainStatWeight = stats.MainStat * 0.3
    local multiplier = rarityMultipliers[rarity]

    return math.floor((baseCost + vitalityWeight + mainStatWeight) * multiplier)
end

-- Function to recruit a character
local function recruitCharacter()
    print("\nChoose a character class to recruit:")
    for className, _ in pairs(characters) do
        if className ~= "Wildling" then
            print("- " .. className)
        end
    end

    local selectedClass = io.read()
    if characters[selectedClass] and selectedClass ~= "Wildling" then
        local recruitedCharacter = characters[selectedClass]
        print("\nYou have recruited a " .. selectedClass .. "!")
        displayCharacterStats(selectedClass, recruitedCharacter)
        return recruitedCharacter
    else
        print("\nInvalid selection. Please try again.")
        return recruitCharacter() -- Retry recruitment
    end
end

-- Introduction to the game
local function gameIntroduction()
    print([[Welcome to **The Crown's Blade**!
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

print("To begin, you must recruit your first character.")
local firstCharacter = recruitCharacter()

print("\nYour journey begins now!")
print("Lead your army to victory and restore the kingdom's honor.")
