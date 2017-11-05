local player = {}
player.prototype = { name = '', score = 0, hp = 100, aromor = 0, speed = 1, recovery = 1, sprite = {} }
player.mt = {}

-- Constructor
function player.new(obj)
  obj = obj or {}
  local self = setmetatable(obj, player)
  return self
end

-- Used to allow for default values for constructor
player.mt.__index = function (table, key)
  return player.prototype[key]
end

--[[ Class definition
name = Name of the player (a string)
score = The current score of the player
hp = The health of the player (0-100)
armor = Armor that the player has (0+)
speed = How fast the player's vehicle moves (0+) {based on rates, 1 = normal}
recovery = How fast the vehicle recovers from damage {question} {based on rates, 1 = normal}
sprite = The sprite associated with this object.
]]
