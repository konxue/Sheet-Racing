-- create npc options
local options = {
    frames = {
        {x = 82, y = 30, width = 92, height = 196},     -- 1 npc 1 standing
        {x = 70, y = 538, width = 104, height = 192},   -- 2 npc 1 walk left
        {x = 326, y = 538, width = 104, height = 188},  -- 3 npc 1 walk left
        {x = 582, y = 538, width = 104, height = 192},  -- 4 npc 1 walk left
        {x = 850, y = 538, width = 104, height = 192},  -- 5 npc 1 walk right
        {x = 82, y = 794, width = 104, height = 188},   -- 6 npc 1 walk right
        {x = 338, y = 794, width = 104, height = 192},  -- 7 npc 1 walk right
        {x = 81, y = 29, width = 94, height = 198},     -- 8 npc 2 standing
        {x = 81, y = 545, width = 90, height = 186},    -- 9 npc 2 walk left
        {x = 337, y = 545, width = 90, height = 182},   -- 10 npc 2 walk left
        {x = 593, y = 545, width = 90, height = 186},   -- 11 npc 2 walk left
        {x = 853, y = 545, width = 90, height = 186},   -- 12 npc 2 walk right
        {x = 85, y = 801, width = 90, height = 182},    -- 13 npc 2 walk right
        {x = 341, y = 801, width = 90, height = 186},   -- 14 npc 2 walk right
    }
};

-- create new image sheet
local sheetNpc1 = graphics.newImageSheet("npc/npc1.png", options);
local sheetNpc2 = graphics.newImageSheet("npc2.png", options);

-- create new sequence data
local sequenceData = {
    {name = "npc1_walk_left", frames = {2, 3, 4}, time = 200, loopCount = 1},
    {name = "npc1_walk_right", frames = {5, 6, 7}, time = 200, loopCount = 1},
    {name = "npc2_walk_left", frames = {9, 10, 11}, time = 200, loopCount = 1},
    {name = "npc2_walk_right", frames = {12, 13, 14}, time = 200, loopCount = 1},
};

-- create table to pass npc info
local npc = { 
    sheetNpc1 = sheetNpc1,
    sheetNpc2 = sheetNpc2,
    sequenceData = sequenceData
};

return npc;