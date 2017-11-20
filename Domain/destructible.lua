Destructible = {Name = '', Value = 0, Armor = 0, DisplayObject = {}, Type="Destructible"}

function Destructible:new(obj)
  local v = obj or {}
  setmetatable( v, self )
  self.__index = self
  return v
end

return Destructible
--[[ Class definition
name = The name of the Destructible.
value = How much to add to the score of the player when the object is destroyed (0+).
armor = How much armor the Destructible has (0+). {used to calculate how much damage is caused to the player}
sprite = The sprite associated with this object.
]]
