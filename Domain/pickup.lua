local pickup = {}
pickup.prototype = { name = '', harmful = false, affected_attribute = '', value = 0, sprite = {} }
pickup.mt = {}

-- Constructor
function pickup.new(obj)
  obj = obj or {}
  local self = setmetatable(obj, pickup)
  return self
end

-- Used to allow for default values for constructor
pickup.mt.__index = function (table, key)
  return pickup.prototype[key]
end

--[[ Class definition
name = The name of the pickup.
harmful = Whether or not the pickup hurts the player or not (true or false).
affected_attribute = The attribute that is affected by the pickup (core, hp, armor, speed, recovery).
value = The value that the affected_attribute is affected by (> 0).
sprite = The sprite associated with this object.
]]
