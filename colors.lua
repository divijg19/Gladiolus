-- colors.lua

local colors = {}

-- ANSI color codes for rarities
colors.rarityColors = {
    Common = "\27[90m",     -- Grey
    Uncommon = "\27[92m",   -- Green
    Epic = "\27[94m",       -- Blue
    Elite = "\27[95m",      -- Purple
    Unique = "\27[93m",     -- Gold
    Legendary = "\27[91m",  -- Red
}

-- Reset ANSI color
colors.reset = "\27[0m"

-- Function to colorize text based on rarity
function colors.colorize(text, rarity)
    local color = colors.rarityColors[rarity] or colors.reset
    return color .. text .. colors.reset
end

-- Function to format unit name with rarity-based color
function colors.formatUnitName(rarity, name)
    return colors.colorize(name, rarity)
end

return colors
