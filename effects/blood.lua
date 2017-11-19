
-- create blood options
local options = {
    frames = {
        {x = 155, y = 130, width = 208, height = 182}, -- 1
        {x = 655, y = 92, width = 245, height = 215},  -- 2
        {x = 1152, y = 66, width = 280, height = 241}, -- 3
        {x = 1660, y = 66, width = 294, height = 252}, -- 4
        {x = 2173, y = 65, width = 297, height = 269}, -- 5
        {x = 2684, y = 65, width = 306, height = 287}  -- 6
    }
};

-- create new image sheet
local sheet = graphics.newImageSheet("blood.png", options);

-- create new sequence data
local sequenceData = {
    {name = "blood", start = 1, count = 6, time = 200, loopCount = 0}
};

-- create table to pass blood info
local blood = { 
    sheet = sheet,
    sequenceData = sequenceData
};

return blood;