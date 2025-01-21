-- colors.lua
local colors = {
    -- ANSI color codes
    rarityColors = {
        Common = "\27[90m",     -- Grey
        Uncommon = "\27[92m",   -- Green
        Epic = "\27[94m",       -- Blue
        Elite = "\27[95m",      -- Purple
        Unique = "\27[93m",     -- Gold
        Legendary = "\27[91m",  -- Red
    },
    reset = "\27[0m"
}

-- Function to color text based on rarity
function colors.colorize(text, rarity)
    local color = colors.rarityColors[rarity] or colors.reset
    return color .. text .. colors.reset
end

-- Function to color unit name and class
function colors.formatUnitName(rarity, class)
    return colors.colorize(rarity .. " " .. class, rarity)
end

return colors
