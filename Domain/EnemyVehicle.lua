local Vehicle = require('Vehicle')

EnemyVehicle = Vehicle:new()

function EnemyVehicle:new(obj)
  local pv = obj or Vehicle:new()
  setmetatable( pv, self )
  self.__index = self;
  return pv
end

return EnemyVehicle
--[[ Class definition
hp = The health of the EnemyVehicle (0-100)
armor = Armor that the EnemyVehicle has (0+)
speed = How fast the EnemyVehicle's vehicle moves (0+) {based on rates, 1 = normal}
sprite = The sprite associated with this object.
]]
