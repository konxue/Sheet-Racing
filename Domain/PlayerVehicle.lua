-- TODO: Powerups
-- TODO: Points
-- TODO: (?) Advanced damage

local Vehicle = require('Domain.Vehicle');
local Explosion = require('effects.explosion');
local Physics = require('physics');
local Car = require('vehicle.car');
local soundTable = require('sounds.soundTable');

PlayerVehicle = Vehicle:new();
PlayerVehicle.Score = 0;

-- Event handler for when the vehicle dies
function onDeath(event)
  local explode = display.newSprite(Explosion["sheet"], Explosion["sequenceData"]);
  explode:setSequence("explosion");
  explode.x = event.target.DisplayObject.x;
  explode.y = event.target.DisplayObject.y;
  explode:play();
  audio.play( soundTable["explosion"] );
  timer.performWithDelay(
    500,
    function()
      event.target.DisplayObject:removeSelf();
      event.target.DisplayObject = nil;
      explode:removeSelf();
      explode = nil;
    end );

end

-- Private function that handles collision events for player vehicles
local function onCollision(event)
  local this = event.target.pp
  if (event.phase == "began") then
      audio.play( soundTable["whack"] );
    if (math.random(100) > this.Armor) then -- You take damage
      this.HP = this.HP - 100;
    else -- Armor saved you! You only lose armor, no HP
      this.Armor = this.Armor - 1;
    end

    print(this.HP);

    if (this.HP <= 0) then
        Runtime:dispatchEvent({ name = "onDeath", target = this });
    end
  end
end

-- Allows you to move the car with touch!
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
  self.DisplayObject = display.newImage(Car.sheet, 1, x, y);
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
