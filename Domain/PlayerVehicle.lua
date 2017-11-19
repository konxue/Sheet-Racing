local Vehicle = require('Domain.Vehicle')
local Physics = require('physics')

PlayerVehicle = Vehicle:new()
PlayerVehicle.Score = 0

local optionsCar =
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

function onDeath(event)
  event.target.DisplayObject:removeSelf();
  event.target.DisplayObject = nil;
end

-- Private function that handles collision events for player vehicles
local function onCollision(event)
  local this = event.target.pp
  if (event.phase == "began") then
    if (math.random(100) > this.Armor) then -- You take damage
      this.HP = this.HP - 10;
    else -- Armor saved you! You only lose armor, no HP
      this.Armor = this.Armor - 1;
    end

    print(this.HP);

    if (this.HP <= 0) then
        Runtime:dispatchEvent({ name = "onDeath", target = this });
    end
  end
end

local function onMove(event)
  if event.phase == "began" then
    event.target.markX = event.target.x;
  elseif event.phase == "moved" then
    local x = (event.x - event.xStart) + event.target.markX;
    if (x < 50 or x > display.contentWidth - 50) then
      return
    end
    event.target.x = x;
  end
end

-- Creates a new PlayerVehicle object.
function PlayerVehicle:new(obj)
  local pv = obj or Vehicle:new({Score = 0})
  setmetatable( pv, self )
  self.__index = self;
  return pv
end

-- Spawns the vehicle to the given x and y coordinates.
-- Also adds the physics to the object and sets up collission events
function Vehicle:Spawn(x, y)
  local sheetCar = graphics.newImageSheet( "car.png", optionsCar );
  self.DisplayObject = display.newImage(sheetCar, 1, x, y);
  self.DisplayObject.pp = self; -- Parent Object
  physics.addBody(self.DisplayObject, "kinematic", { density=1, friction=0.1, bounce=0.2 });
  self.DisplayObject:addEventListener("collision", onCollision);
  self.DisplayObject:addEventListener("touch", onMove);
  Runtime:addEventListener("onDeath", onDeath);
end

return PlayerVehicle
--[[ Class definition
name = Name of the PlayerVehicle (a string)
score = The current score of the PlayerVehicle
hp = The health of the PlayerVehicle (0-100)
armor = Armor that the PlayerVehicle has (0+)
speed = How fast the PlayerVehicle's vehicle moves (0+) {based on rates, 1 = normal}
recovery = How fast the vehicle recovers from damage {question} {based on rates, 1 = normal}
sprite = The sprite associated with this object.
]]
