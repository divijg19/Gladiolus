-- colors.lua
local colors = {}

-- ANSI color codes for rarities with reset functionality
colors.rarityColors = {
    Common = "\27[38;5;246m",     -- Grey
    Uncommon = "\27[92m",         -- Green
    Epic = "\27[38;5;33m",        -- Blue
    Elite = "\27[38;5;201m",      -- Purple
    Unique = "\27[38;5;220m",     -- Gold
    Legendary = "\27[91m",        -- Red
    Fabled = "\27[38;5;51m",      -- Bright Turquoise
    Unknown = "\27[35m"           -- Magenta
}

-- Color reset code
colors.reset = "\27[0m"

-- Function to colorize enemy name based on rarity
function colors.colorizeEnemy(enemyName, rarity)
    local colorCode = colors.rarityColors[rarity] or colors.rarityColors.Common
    return colorCode .. enemyName .. colors.reset
end

-- Generic colorize function
function colors.colorize(text, rarity)
    local colorCode = colors.rarityColors[rarity] or colors.rarityColors.Common
    return colorCode .. text .. colors.reset
end

-- Function to get color code for a specific rarity
function colors.getColorForRarity(rarity)
    return colors.rarityColors[rarity] or colors.rarityColors.Common
end

-- Function to format unit name with color based on rarity
function colors.formatUnitName(rarity, className)
    local colorCode = colors.rarityColors[rarity] or colors.rarityColors.Unknown
    return colorCode .. className .. colors.reset
end

return colors
