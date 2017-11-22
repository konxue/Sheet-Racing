
-- create explosion options
local options = {
    frames = {
        {x = 92, y = 56, width = 74, height = 70},      -- 1
        {x = 351, y = 35, width = 129, height = 111},   -- 2
        {x = 28, y = 239, width = 202, height = 152},   -- 3
        {x = 312, y = 240, width = 205, height = 149},  -- 4
        {x = 577, y = 244, width = 208, height = 143},  -- 5
        {x = 19, y = 439, width = 220, height = 177},   -- 6
        {x = 287, y = 422, width = 258, height = 211},  -- 7
        {x = 557, y = 453, width = 230, height = 157},  -- 8
        {x = 298, y = 671, width = 240, height = 128},  -- 9
    }
}

-- create new image sheet
local sheet = graphics.newImageSheet("effects/explosion.png", options);

-- create new sequence data
local sequenceData = {
    {name = "explosion", start = 1, count = 9, time = 700, loopCount = 1}
};

-- create table to pass explosion info
local explosion = {
    sheet = sheet,
    sequenceData = sequenceData
};

return explosion;
