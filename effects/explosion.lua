
-- create explosion options
local options = {
    frames = {
        {x = 6, y = 4, width = 48, height = 51},    -- 1
        {x = 59, y = 2, width = 63, height = 56},   -- 2
        {x = 124, y = 0, width = 62, height = 60},  -- 3
        {x = 188, y = 2, width = 68, height = 58},  -- 4
        {x = 0, y = 68, width = 58, height = 56},   -- 5
        {x = 61, y = 68, width = 60, height = 55},  -- 6
        {x = 130, y = 72, width = 55, height = 51}, -- 7
        {x = 195, y = 74, width = 51, height = 48} -- 8
    }
}

-- create new image sheet
local sheet = graphics.newImageSheet("effects/explosion.png", options);

-- create new sequence data
local sequenceData = {
    {name = "explosion", start = 1, count = 8, time = 200, loopCount = 1}
};

-- create table to pass explosion info
local explosion = { 
    sheet = sheet,
    sequenceData = sequenceData
};

return explosion;