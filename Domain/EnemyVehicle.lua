local Vehicle = require("Domain.Vehicle")
local Car = require("vehicle.car")
local Explosion = require("effects.explosion")
local soundTable = require("sounds.soundTable")

EnemyVehicle = Vehicle:new({HP = 30, TopSpeed = 95, Value = 50, Enemies = {}})
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
            Runtime:dispatchEvent({name = "onRemove", target = event.target})
        end
    )
end

-- Stops all AI functionality
function EnemyVehicle:Stop()
    if self.moveTimer ~= nil then
        timer.cancel(self.moveTimer)
    end
end

-- Private function that handles collision events for enemy vehicles
local function onCollision(event)
    local this = event.target.pp
    local that = event.other.pp
    if (event.phase == "began") then
        if this.HP <= 0 then
            return
        end

        if (that.Type == "PlayerVehicle") then
            if (math.random(100) > this.Armor) then -- enemy take damage
                this.HP = this.HP - (1 * this.DmgRatio)
            else -- Armor saved enemy! enemy only lose armor, no HP
                this.Armor = this.Armor - 1
            end
            that.Score = that.Score + 1 -- increase players score
        end

        if (that.Type == "EnemyVehicle" or that.Type == "Wall") then
            if (math.random(100) > this.Armor) then -- enemy take damage
                this.HP = this.HP - 1
            else -- Armor saved enemy! enemy only lose armor, no HP
                this.Armor = this.Armor - 1
            end
        end

        -- slow down vehicle
        this.Speed = this.Speed - this.SpeedInc

        if (this.HP <= 0) then
            if that.Type == "PlayerVehicle" then
                that.Score = that.Score + this.Value -- increase players score
            end

            this:Stop()
            this.DisplayObject:dispatchEvent({name = "onDeath", target = this})
        end
    end
end

-- Spawns the vehicle to the given x and y coordinates.
-- Also adds the physics to the object
function EnemyVehicle:SpawnRandom(x, y)
    result = math.random(2, 7)
    self.DisplayObject = display.newImage(Car.sheet, result, x, y)
    self.DisplayObject.pp = self -- Parent Object
    physics.addBody(self.DisplayObject, {density = 1, friction = 0.1, bounce = 0.2})
    self.DisplayObject:addEventListener("collision", onCollision)
    self.DisplayObject:addEventListener("onDeath", onDeath)
end

-- this function will start the enemy car moving.
function EnemyVehicle:Start()
    transition.to(self, {time = 7000, Speed = self.TopSpeed, transition = easing.inBack})
    local num = 0

    self.moveTimer =
        timer.performWithDelay(
        1 / 60 * 1000,
        function()
            if (self.DisplayObject == nil or self.Player.DisplayObject == nil) then
                return
            end
            num = num + 1

            -- Handle relative movements based on velocity offsets
            dv = self.Player.Speed - self.Speed
            dt = (1000 / 60)

            self:Move(0, dv, dt)

            -- Handle catchup mechanic
            catchUp = 1
            if (self.Player.Speed - self.Speed > catchUp and self.Player.Speed > 0) then
                transition.to(self, {time = 1500, Speed = self.TopSpeed})
            end

            -- Handle Moving towards the Player position
            if (num % 120 == 0) then
                if self.Player.DisplayObject == nil then
                    if ((self.DisplayObject.x - self.Player.DisplayObject.x) > 0) then
                        self:Turn("left")
                    else
                        self:Turn("right")
                    end
                end
            end
        end,
        -1
    )
end

return EnemyVehicle
--[[ Class definition
hp = The health of the EnemyVehicle (0-100)
armor = Armor that the EnemyVehicle has (0+)
speed = How fast the EnemyVehicle's vehicle moves (0+) {based on rates, 1 = normal}
sprite = The sprite associated with this object.
]]
