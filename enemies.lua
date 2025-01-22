local enemies = {}

enemies.list = {
    -- Wild Animals
    {
        name = "Monkey",
        class = "Monkey",
        rarity = "Common",
        level = 1,
        stats = {
            Strength = 5,
            Vitality = 8,
            Agility = 12,
            Intelligence = 6,
            Wisdom = 5,
            Dexterity = 10,
            Luck = 5
        },
        alive = true
    },
    {
        name = "Snake",
        class = "Snake",
        rarity = "Common",
        level = 1,
        stats = {
            Strength = 4,
            Vitality = 6,
            Agility = 15,
            Intelligence = 5,
            Wisdom = 5,
            Dexterity = 12,
            Luck = 6
        },
        alive = true
    },
    {
        name = "Fox",
        class = "Fox",
        rarity = "Uncommon",
        level = 2,
        stats = {
            Strength = 6,
            Vitality = 10,
            Agility = 14,
            Intelligence = 8,
            Wisdom = 6,
            Dexterity = 13,
            Luck = 7
        },
        alive = true
    },
    {
        name = "Wolf",
        class = "Wolf",
        rarity = "Uncommon",
        level = 3,
        stats = {
            Strength = 10,
            Vitality = 15,
            Agility = 12,
            Intelligence = 7,
            Wisdom = 6,
            Dexterity = 10,
            Luck = 5
        },
        alive = true
    },
    {
        name = "Cub Bear",
        class = "Bear",
        rarity = "Epic",
        level = 2,
        stats = {
            Strength = 12,
            Vitality = 20,
            Agility = 8,
            Intelligence = 5,
            Wisdom = 4,
            Dexterity = 6,
            Luck = 5
        },
        alive = true
    },
    {
        name = "Adult Bear",
        class = "Bear",
        rarity = "Elite",
        level = 5,
        stats = {
            Strength = 18,
            Vitality = 30,
            Agility = 8,
            Intelligence = 5,
            Wisdom = 5,
            Dexterity = 7,
            Luck = 6
        },
        alive = true
    },
    {
        name = "Possessed Evil Bear",
        class = "Evil Bear",
        rarity = "Unique",
        level = 8,
        stats = {
            Strength = 25,
            Vitality = 50,
            Agility = 10,
            Intelligence = 12,
            Wisdom = 8,
            Dexterity = 10,
            Luck = 7
        },
        alive = true
    },

    -- Additional Enemies
    {
        name = "Forest Goblin",
        class = "Goblin",
        rarity = "Uncommon",
        level = 2,
        stats = {
            Strength = 6,
            Vitality = 8,
            Agility = 10,
            Intelligence = 7,
            Wisdom = 6,
            Dexterity = 9,
            Luck = 4
        },
        alive = true
    },
    {
        name = "Stone Golem",
        class = "Golem",
        rarity = "Epic",
        level = 6,
        stats = {
            Strength = 20,
            Vitality = 40,
            Agility = 4,
            Intelligence = 4,
            Wisdom = 4,
            Dexterity = 5,
            Luck = 3
        },
        alive = true
    },
    {
        name = "Shadow Stalker",
        class = "Assassin",
        rarity = "Elite",
        level = 10,
        stats = {
            Strength = 15,
            Vitality = 20,
            Agility = 25,
            Intelligence = 12,
            Wisdom = 10,
            Dexterity = 18,
            Luck = 10
        },
        alive = true
    },
    {
        name = "Mountain Troll",
        class = "Troll",
        rarity = "Epic",
        level = 4,
        stats = {
            Strength = 15,
            Vitality = 25,
            Agility = 6,
            Intelligence = 4,
            Wisdom = 5,
            Dexterity = 6,
            Luck = 5
        },
        alive = true
    },
    {
        name = "Fire Elemental",
        class = "Elemental",
        rarity = "Legendary",
        level = 7,
        stats = {
            Strength = 10,
            Vitality = 20,
            Agility = 8,
            Intelligence = 20,
            Wisdom = 15,
            Dexterity = 8,
            Luck = 6
        },
        alive = true
    },
    {
        name = "Ice Wraith",
        class = "Wraith",
        rarity = "Unique",
        level = 6,
        stats = {
            Strength = 8,
            Vitality = 15,
            Agility = 12,
            Intelligence = 15,
            Wisdom = 14,
            Dexterity = 10,
            Luck = 9
        },
        alive = true
    }
}

return enemies
