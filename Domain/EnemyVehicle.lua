local Vehicle = require("Domain.Vehicle")
local Car = require("vehicle.car")
local Explosion = require("effects.explosion")
local soundTable = require("sounds.soundTable")

EnemyVehicle = Vehicle:new({HP = 10, TopSpeed = 50})
EnemyVehicle.Type = "EnemyVehicle"

-- Initializes a new EnemyVehicle object.
function EnemyVehicle:new(obj)
    local pv = obj or Vehicle:new()
    setmetatable(pv, self)
    self.__index = self
    return pv
end

-- Event handler for when the vehicle dies
function onDeath(event)
    local explode = display.newSprite(Explosion["sheet"], Explosion["sequenceData"])
    explode:setSequence("explosion")
    explode.x = event.target.DisplayObject.x
    explode.y = event.target.DisplayObject.y
    explode:play()
    audio.play(soundTable["explosion"])
    timer.performWithDelay(
        500,
        function()
            display.remove(event.target.DisplayObject)
            event.target.DisplayObject = nil
            explode:removeSelf()
            explode = nil
        end
    )
end

-- Private function that handles collision events for enemy vehicles
local function onCollision(event)
    local this = event.target.pp
    local that = event.other.pp
    if (event.phase == "began") then
        if (that.Type == "PlayerVehicle") then
            if (math.random(100) > this.Armor) then -- enemy take damage
                this.HP = this.HP - (1 * this.DmgRatio)
            else -- Armor saved enemy! enemy only lose armor, no HP
                this.Armor = this.Armor - 1
            end
        end

        if (that.Type == "EnemyVehicle" or that.Type == "Wall") then
            if (math.random(100) > this.Armor) then -- enemy take damage
                this.HP = this.HP - 1
            else -- Armor saved enemy! enemy only lose armor, no HP
                this.Armor = this.Armor - 1
            end
        end

        if (this.HP <= 0) then
            this.DisplayObject:dispatchEvent({name = "onDeath", target = this})
        end
    end
end

-- Spawns the vehicle to the given x and y coordinates.
-- Also adds the physics to the object
function EnemyVehicle:SpawnRandom(x, y)
    result = math.random(1, 6)
    self.DisplayObject = display.newImage(Car.sheet, result, x, y)
    self.DisplayObject.pp = self -- Parent Object
    physics.addBody(self.DisplayObject, {density = 1, friction = 0.1, bounce = 0.2})
    self.DisplayObject:addEventListener("collision", onCollision)
    self.DisplayObject:addEventListener("onDeath", onDeath)
end

-- this function will start the enemy car moving.
function EnemyVehicle:Start()
    
end

return EnemyVehicle
--[[ Class definition
hp = The health of the EnemyVehicle (0-100)
armor = Armor that the EnemyVehicle has (0+)
speed = How fast the EnemyVehicle's vehicle moves (0+) {based on rates, 1 = normal}
sprite = The sprite associated with this object.
]]
