local destructible = {}
destructible.prototype = { name = '', value = 0, armor = 0, sprite = {} }
destructible.mt = {}

-- Constructor
function destructible.new(obj)
  obj = obj or {}
  local self = setmetatable(obj, destructible)
  return self
end

-- Used to allow for default values for constructor
destructible.mt.__index = function (table, key)
  return destructible.prototype[key]
end

--[[ Class definition
name = The name of the destructible.
value = How much to add to the score of the player when the object is destroyed (0+).
armor = How much armor the destructible has (0+). {used to calculate how much damage is caused to the player}
sprite = The sprite associated with this object.
]]
