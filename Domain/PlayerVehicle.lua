local Vehicle = require("Domain.Vehicle")
local Explosion = require("effects.explosion")
local Physics = require("physics")
local Car = require("vehicle.car")
local soundTable = require("sounds.soundTable")

PlayerVehicle = Vehicle:new({PlayerDmg = 10, Armor = 50})
PlayerVehicle.Score = 0
PlayerVehicle.Type = "PlayerVehicle"

-- Event handler for when the vehicle dies
function onPlayerDeath(event)
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

-- Private function that handles collision events for player vehicles
local function onCollision(event)
    local this = event.target.pp
    local that = event.other.pp
    if (event.phase == "began") then
        if this.HP <= 0 then
            return
        end

        audio.play(soundTable["whack"])

        -- send player stat change event
        Runtime:dispatchEvent({name = "onPlayerStatChanged"})

        if (that.Type == "EnemyVehicle") then
            -- slow down vehicle
            if (this.Speed > 0) then
                this.Speed = this.Speed - this.SpeedInc
            end

             -- You take damage
            if (math.random(100) > this.Armor) then
                if this.HP < this.PlayerDmg then
                    this.HP = 0
                else
                    this.HP = this.HP - this.PlayerDmg
                end
            else -- Armor saved you! You only lose armor, no HP
                if this.Armor > 5 then
                    this.Armor = this.Armor - 5
                elseif this.Armor <= 5 then
                    this.Armor = 0
                end
            end
        end

        if (this.HP <= 0) then
            Runtime:dispatchEvent({name = "onPlayerDeath", target = this})
        end
    end
end

-- Creates a new PlayerVehicle object.
function PlayerVehicle:new(obj)
    local pv = obj or {}
    setmetatable(pv, self)
    self.__index = self
    return pv
end

-- Spawns the vehicle to the given x and y coordinates.
-- Also adds the physics to the object and sets up collision events
function PlayerVehicle:Spawn(x, y)
    self.DisplayObject = display.newImage(Car.sheet, 1, x, y)
    self.DisplayObject.pp = self -- Parent Object
    physics.addBody(self.DisplayObject, "kinematic", {density = 1, friction = 0.1, bounce = 0.2})
    self.DisplayObject:addEventListener("collision", onCollision)
    Runtime:addEventListener("onPlayerDeath", onPlayerDeath)
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
