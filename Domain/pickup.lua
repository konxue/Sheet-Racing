Pickup = {Name = '', Harmful = false, AffectedAttribute = 'HP', Value = 0, DisplayObject = {}, Type = "Pickup"}

function Pickup:new(obj)
  local v = obj or {}
  setmetatable( v, self )
  self.__index = self
  return v
end

return Pickup
--[[ Class definition
name = The name of the Pickup.
harmful = Whether or not the Pickup hurts the player or not (true or false).
affected_attribute = The attribute that is affected by the Pickup (core, hp, armor, speed, recovery).
value = The value that the affected_attribute is affected by (> 0).
sprite = The sprite associated with this object.
]]
