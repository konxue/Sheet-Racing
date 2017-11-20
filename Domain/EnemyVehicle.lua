local Vehicle = require('Domain.Vehicle');
local Car = require('vehicle.car');

EnemyVehicle = Vehicle:new();
EnemyVehicle.Type = "EnemyVehicle";

-- Initializes a new EnemyVehicle object.
function EnemyVehicle:new(obj)
  local pv = obj or Vehicle:new();
  setmetatable( pv, self );
  self.__index = self;
  return pv;
end

-- Spawns the vehicle to the given x and y coordinates.
-- Also adds the physics to the object
function EnemyVehicle:SpawnRandom(x, y)
  result = math.random(6) + 1;
  self.DisplayObject = display.newImage(Car.sheet, result, x, y);
  self.DisplayObject.pp = self; -- Parent Object
  physics.addBody(self.DisplayObject, { density=1, friction=0.1, bounce=0.2 });
end

return EnemyVehicle
--[[ Class definition
hp = The health of the EnemyVehicle (0-100)
armor = Armor that the EnemyVehicle has (0+)
speed = How fast the EnemyVehicle's vehicle moves (0+) {based on rates, 1 = normal}
sprite = The sprite associated with this object.
]]
