Vehicle = {Name = '', HP = 100, Armor = 0, DisplayObject = {}}

-- Moves the vehicle by the given offset in the given time.
function Vehicle:Move(deltaX, deltaY, t)
    transition.to(self.DisplayObject, {x = self.DisplayObject.x + deltaX, y = self.DisplayObject.y + deltaY, time=t});
end

-- Initializes a new Vehicle object
function Vehicle:new(obj)
  local v = obj or {}
  setmetatable( v, self )
  self.__index = self
  return v
end

return Vehicle
--[[ Class definition
hp = The health of the Vehicle (0-100)
armor = Armor that the Vehicle has (0+)
speed = How fast the Vehicle's vehicle moves (0+) {based on rates, 1 = normal}
recovery = How fast the vehicle recovers from damage {question} {based on rates, 1 = normal}
sprite = The sprite associated with this object.
]]
