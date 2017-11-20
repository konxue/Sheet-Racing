-- create npc options
local options = {
    frames = {
        {x = 41, y = 15, width = 46, height = 98},     -- 1 npc 1 standing
        {x = 35, y = 269, width = 52, height = 96},   -- 2 npc 1 walk left
        {x = 163, y = 269, width = 52, height = 94},  -- 3 npc 1 walk left
        {x = 291, y = 269, width = 52, height = 96},  -- 4 npc 1 walk left
        {x = 425, y = 269, width = 52, height = 96},  -- 5 npc 1 walk right
        {x = 41, y = 397, width = 52, height = 94},   -- 6 npc 1 walk right
        {x = 169, y = 397, width = 52, height = 96},  -- 7 npc 1 walk right
        {x = 41, y = 14, width = 46, height = 99},     -- 8 npc 2 standing
        {x = 41, y = 273, width = 44, height = 92},    -- 9 npc 2 walk left
        {x = 169, y = 273, width = 44, height = 90},   -- 10 npc 2 walk left
        {x = 297, y = 273, width = 44, height = 92},   -- 11 npc 2 walk left
        {x = 427, y = 273, width = 44, height = 92},   -- 12 npc 2 walk right
        {x = 43, y = 401, width = 44, height = 90},    -- 13 npc 2 walk right
        {x = 171, y = 401, width = 44, height = 93},   -- 14 npc 2 walk right
    }
};

-- create new image sheet
local sheetNpc1 = graphics.newImageSheet("npc/npc1.png", options);
local sheetNpc2 = graphics.newImageSheet("npc/npc2.png", options);

-- create new sequence data
local sequenceData = {
    {name = "npc1_walk_left", frames = {2, 3, 4}, time = 200, loopCount = 0},
    {name = "npc1_walk_right", frames = {5, 6, 7}, time = 200, loopCount = 0},
    {name = "npc2_walk_left", frames = {9, 10, 11}, time = 200, loopCount = 0},
    {name = "npc2_walk_right", frames = {12, 13, 14}, time = 200, loopCount = 0},
};

-- create table to pass npc info
local npc = {
    sheetNpc1 = sheetNpc1,
    sheetNpc2 = sheetNpc2,
    sequenceData = sequenceData
};

return npc;
