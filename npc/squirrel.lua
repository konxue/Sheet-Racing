
-- create squirrel options
local options =
{
  frames = {
    { x = 19, y = 22, width = 53, height = 62}, -- 1 standing squirrel
    { x = 13, y = 107, width = 58, height = 61}, -- 2 Running animation of squirrel
    { x = 95, y = 104, width = 62, height = 64}, -- 3 Running animation of squirrel
    { x = 178, y = 120, width = 60, height = 48}, -- 4 Running animation of squirrel
    { x = 262, y = 108, width = 62, height = 57}, -- 5 Running animation of squirrel
    { x = 346, y = 104, width = 61, height = 63}, -- 6 Running animation of squirrel
    { x = 430, y = 104, width = 61, height = 64}, -- 7 Running animation of squirrel
    { x = 518, y = 113, width = 57, height = 53}, -- 8 Running animation of squirrel
    { x = 602, y = 104, width = 55, height = 64}, -- 9 Running animation of squirrel
  }
}
-- create new image sheet
local sheet = graphics.newImageSheet( "npc/squirrel.png", options);

-- create new squence sequence for animation
local sequenceData = { name ="squirrel", start = 2, count = 8, time = 1000, loopCount = 0, loopDirection = "forward"}

-- create table to pass info
local squirrel = {
    sheet = sheet,
    sequenceData = sequenceData
};

return squirrel;
