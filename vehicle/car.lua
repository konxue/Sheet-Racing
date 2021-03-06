
-- create car options
local options =
{
  frames = {
    { x = 193, y = 39, width = 98, height = 214},   -- 1 Audi
    { x = 351, y = 33, width = 107, height = 220},  -- 2 BlackViper
    { x = 521, y = 42, width = 92, height = 218},   -- 3 OrangeCar
    { x = 660, y = 48, width = 111, height = 204},  -- 4 Blue Minitruck
    { x = 819, y = 53, width = 93, height = 196},   -- 5 MiniVan
    { x = 189, y = 288, width = 116, height = 234}, -- 6 Taxi
    { x = 351, y = 305, width = 144, height = 292}, -- 7 Truck
    { x = 41, y = 42, width = 102, height = 207},   -- 8 Ambulance still
    { x = 41, y = 301, width = 102, height = 207},  -- 9 Ambulance animation xxo
    { x = 41, y = 558, width = 102, height = 207},  -- 10 Ambulance animation xox
    { x = 193, y = 558, width = 102, height = 207}, -- 11 Ambulance animation oxx
    { x = 521, y = 324, width = 98, height = 214},  -- 12 Police still
    { x = 521, y = 558, width = 98, height = 214},  -- 13 Police Animation oxx
    { x = 686, y = 558, width = 98, height = 214},  -- 14 Police Animation oxo
    { x = 845, y = 558, width = 98, height = 214},  -- 15 Police Animation xxo
  }
}
-- create new image sheet
local sheet = graphics.newImageSheet( "vehicle/car.png", options );
-- create new sequence data
local sequenceData = {
	{ name = "ambulance", start = 9, count = 3, time = 600,  loopCount = 0, loopDirection = "forward"},
	{ name = "police", start = 13, count = 3, time = 600, loopCount = 0, loopDirection = "forward"}
  };

-- create table to pass vehicles info
local car = {
    sheet = sheet,
    sequenceData = sequenceData
};

return car;
