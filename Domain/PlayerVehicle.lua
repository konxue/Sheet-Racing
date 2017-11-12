local Vehicle = require('Vehicle')

PlayerVehicle = Vehicle:new()
PlayerVehicle.Score = 0

function PlayerVehicle:new(obj)
  local pv = obj or Vehicle:new({Score = 0})
  setmetatable( pv, self )
  self.__index = self;
  return pv
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
