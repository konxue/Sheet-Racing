local NPC = require("npc.npc")
local SQUIRREL = require("npc.squirrel")
local Blood = require("effects.blood")
local soundTable = require("sounds.soundTable")
local Destructible = {
    Name = "",
    Value = 1,
    Armor = 0,
    DisplayObject = {},
    HP = 1,
    Type = "Destructible",
    SpeedX = 10,
    SpeedY = 0
}

function Destructible:new(obj)
    local v = obj or {}
    setmetatable(v, self)
    self.__index = self
    return v
end

-- Event handler for when the vehicle dies
function onDestruct(event)
    timer.performWithDelay( 500, function()
      audio.play(soundTable["hurt"]);
    end);
    local blood = display.newSprite(Blood["sheet"], Blood["sequenceData"])
    blood:setSequence("blood")
    blood.x = event.target.DisplayObject.x
    blood.y = event.target.DisplayObject.y
    display.remove(event.target.DisplayObject)
    event.target.DisplayObject = nil
    blood:play()
    timer.performWithDelay(
        200,
        function()
            blood:removeSelf()
            blood = nil
        end,
        1
    )
end

-- Private function that handles collision events for destructibles.
local function onCollision(event)
    local this = event.target.pp
    local that = event.other.pp
    if (event.phase == "began") then
        if (that.Type == "PlayerVehicle") then
            this.HP = this.HP - 1 -- reduce destructible health
            that.Score = that.Score + this.Value -- increase players score
        end
        if (that.Type == "EnemyVehicle") then
            this.HP = this.HP - 1
        end

        if (this.HP <= 0) then
            transition.cancel(this.DisplayObject)
            this.DisplayObject:dispatchEvent({name = "onDestruct", target = this})
        end
    end
end

-- This function will move the destructible.
function Destructible:Move()
    if self.DisplayObject == nil then
        return
    end

    local x = 0
    local y = 0

    -- walk based on the direction
    if self.DisplayObject.direction == "left" then
        x = self.DisplayObject.x - self.SpeedX
    else
        x = self.DisplayObject.x + self.SpeedX
    end
    y = self.DisplayObject.y + self.SpeedY

    -- we walked off screen, so remove thyself
    if x < 0 or x > display.contentWidth then
        transition.cancel(self.DisplayObject)
        self.DisplayObject:removeEventListener("collision", onCollision)
        self.DisplayObject:removeEventListener("onDestruct", onDestruct)
        display.remove(self.DisplayObject)
        self.DisplayObject = nil
        return
    end

    transition.to(
        self.DisplayObject,
        {
            time = 100,
            x = x,
            y = y,
            onComplete = function()
                self:Move()
            end
        }
    )
end

-- Spawns the destructibles to the given x and y coordinates.
-- Also adds the physics to the object
function Destructible:SpawnRandom(x, y)
    local num = math.random(0, 7);
    local object1;
    if num < 4 then
        if num == 0 then
            object1 = display.newSprite(NPC.sheetNpc1, NPC.sequenceData)
            object1:setSequence("npc1_walk_left")
            object1.direction = "left"
            object1.x = display.contentWidth
        elseif num == 1 then
            object1 = display.newSprite(NPC.sheetNpc1, NPC.sequenceData)
            object1:setSequence("npc1_walk_right")
            object1.direction = "right"
            object1.x = 0
        elseif num == 2 then
            object1 = display.newSprite(NPC.sheetNpc2, NPC.sequenceData)
            object1:setSequence("npc2_walk_left")
            object1.direction = "left"
            object1.x = display.contentWidth
        elseif num == 3 then
            object1 = display.newSprite(NPC.sheetNpc2, NPC.sequenceData)
            object1:setSequence("npc2_walk_right")
            object1.direction = "right"
            object1.x = 0
        end
    elseif num == 4 then
        object1 = display.newSprite(SQUIRREL.sheet, SQUIRREL.sequenceData)
        object1:setSequence("squirrel")
        object1.direction = "left"
        object1.x = display.contentWidth
    elseif num == 5 then
      object1 = display.newImage(NPC.sheetNpc1, 1, display.contentWidth / 2 + math.random(-100, 100), -380)
      self.SpeedX = 0;
    elseif num == 6 then
      object1 = display.newImage(NPC.sheetNpc2, 1, display.contentWidth / 2 + math.random(-100, 100), -380)
      self.SpeedX = 0;
    elseif num == 7 then
      object1 = display.newImage(SQUIRREL.sheet, 1, display.contentWidth / 2 + math.random(-100, 100), -380)
      self.SpeedX = 0;
    end

    if num < 5 then
      object1:play()
      object1.y = y
    end

    self.DisplayObject = object1
    self.DisplayObject.pp = self -- Parent Object
    physics.addBody(self.DisplayObject, {isSensor = true})
    self.DisplayObject:addEventListener("collision", onCollision)
    self.DisplayObject:addEventListener("onDestruct", onDestruct)
    self.DisplayObject:toBack()
    self:Move()
end

return Destructible
--[[ Class definition
name = The name of the Destructible.
value = How much to add to the score of the player when the object is destroyed (0+).
armor = How much armor the Destructible has (0+). {used to calculate how much damage is caused to the player}
sprite = The sprite associated with this object.
]]
