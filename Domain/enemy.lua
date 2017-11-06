local enemy = {}
enemy.prototype = { hp = 100, aromor = 0, speed = 1, recovery = 1, sprite = {} }
enemy.mt = {}

-- Constructor
function enemy.new(obj)
  obj = obj or {}
  local self = setmetatable(obj, enemy)
  return self
end

-- Used to allow for default values for constructor
enemy.mt.__index = function (table, key)
  return enemy.prototype[key]
end

--[[ Class definition
hp = The health of the enemy (0-100)
armor = Armor that the enemy has (0+)
speed = How fast the enemy's vehicle moves (0+) {based on rates, 1 = normal}
recovery = How fast the vehicle recovers from damage {question} {based on rates, 1 = normal}
sprite = The sprite associated with this object.
]]
