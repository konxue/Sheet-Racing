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
    SpeedX = 10,
    SpeedY = 0,
    Type = "Destructible"
}

function Destructible:new(obj)
    local v = obj or {}
    setmetatable(v, self)
    self.__index = self
    return v
end

-- Event handler for when the vehicle dies
function onDestruct(event)
    if (event.target.DisplayObject.Type == "human") then
      audio.play(soundTable["hurt"]);
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
    elseif (event.target.DisplayObject.Type == "squirrel") then
      audio.play(soundTable["hp"]);
      local HPpowerup = display.newImage("effects/hp.png", event.target.DisplayObject.x, event.target.DisplayObject.y);
      display.remove(event.target.DisplayObject);
      event.target.DisplayObject = nil;
      timer.performWithDelay(
          200,
          function()
              HPpowerup:removeSelf()
              HPpowerup = nil
          end)
    end
end


-- Private function that handles collision events for destructibles.
local function onCollision(event)
    local this = event.target.pp
    local that = event.other.pp
    --print (this.DisplayObject.Type .. " got hit by ".. that.Type);
    if (event.phase == "began") then
        -- we hit squirrel
        if that.Type == "PlayerVehicle" and this.DisplayObject.Type == "squirrel" then
            this.HP = this.HP - 1; -- reduce destructible health
            that.HP = that.HP + 6 -- increase our health when hit squirrel as the powerup~
            that.Score = that.Score + this.Value -- increase players score

        -- we hit human
        elseif that.Type == "PlayerVehicle" and this.DisplayObject.Type == "human" then
          that.Score = that.Score + this.Value -- increase players score
        end

        -- enemy hits squirrel
        if that.Type == "EnemyVehicle" then
            this.HP = this.HP - 1;
        end

        if this.HP <= 0 then
          transition.cancel(this.DisplayObject);
          this.DisplayObject:dispatchEvent({name = "onDestruct", target = this});
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
        self.DisplayObject:removeEventListener("onDestruct", onDestruct);
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
function Destructible:SpawnRandom()
    local num = 4--math.random(0, 7);
    if num < 4 then
        if num == 0 then
            self.DisplayObject = display.newSprite(NPC.sheetNpc1, NPC.sequenceData)
            self.DisplayObject:setSequence("npc1_walk_left")
            self.DisplayObject.direction = "left"
            self.DisplayObject.x = display.contentWidth + math.random(-100, 100);
            self.DisplayObject.Type = "human";
        elseif num == 1 then
            self.DisplayObject = display.newSprite(NPC.sheetNpc1, NPC.sequenceData)
            self.DisplayObject:setSequence("npc1_walk_right")
            self.DisplayObject.direction = "right"
            self.DisplayObject.x = 0  + math.random(-100, 100);
            self.DisplayObject.Type = "human";
        elseif num == 2 then
            self.DisplayObject = display.newSprite(NPC.sheetNpc2, NPC.sequenceData)
            self.DisplayObject:setSequence("npc2_walk_left")
            self.DisplayObject.direction = "left"
            self.DisplayObject.x = display.contentWidth + math.random(-100, 100);
            self.DisplayObject.Type = "human";
        elseif num == 3 then
            self.DisplayObject = display.newSprite(NPC.sheetNpc2, NPC.sequenceData)
            self.DisplayObject:setSequence("npc2_walk_right")
            self.DisplayObject.direction = "right"
            self.DisplayObject.x = 0 + math.random(-100, 100);
            self.DisplayObject.Type = "human";
        end
    elseif num == 4 then
        self.DisplayObject = display.newSprite(SQUIRREL.sheet, SQUIRREL.sequenceData)
        self.DisplayObject:setSequence("squirrel")
        self.DisplayObject.direction = "left"
        self.DisplayObject.x = display.contentWidth  + math.random(-100, 100);
        self.DisplayObject.Type = "squirrel";
    elseif num == 5 then
      self.DisplayObject = display.newImage(NPC.sheetNpc1, 1, display.contentWidth / 2 + math.random(-100, 100), -380)
      self.SpeedX = 0;
      self.DisplayObject.Type = "human";
    elseif num == 6 then
      self.DisplayObject = display.newImage(NPC.sheetNpc2, 1, display.contentWidth / 2 + math.random(-100, 100), -380)
      self.SpeedX = 0;
      self.DisplayObject.Type = "human";
    elseif num == 7 then
      self.DisplayObject = display.newImage(SQUIRREL.sheet, 1, display.contentWidth / 2 + math.random(-100, 100), -380)
      self.SpeedX = 0;
      self.DisplayObject.Type = "squirrel";
    end
      self.DisplayObject.y = - 380;
    if num < 5 then
      self.DisplayObject:play()
    end
    -- passing data from object1 to DisplayObject
    --self.DisplayObject.Type = object1.Type; -- sending
    self.DisplayObject.pp = self; -- Parent Object
    physics.addBody(self.DisplayObject, {isSensor = true})
    self.DisplayObject:addEventListener("collision", onCollision)
    self.DisplayObject:addEventListener("onDestruct", onDestruct);
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
