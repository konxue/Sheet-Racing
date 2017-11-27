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
    if (event.target.DisplayObject.Type == "human" or event.target.DisplayObject.Type == "squirrel") then
        -- armor image found at http://www.iconarchive.com/show/blue-bits-icons-by-icojam/shield-icon.html
        timer.performWithDelay(1000, audio.play(soundTable["hurt"])) -- play sound
        local blood = display.newSprite(Blood["sheet"], Blood["sequenceData"]) -- display blood effect
        blood:setSequence("blood") -- animation sequence for blood
        blood.x = event.target.DisplayObject.x -- blood'x
        blood.y = event.target.DisplayObject.y -- blood'y
        display.remove(event.target.DisplayObject) -- remove destructible
        event.target.DisplayObject = nil
        blood:play() -- play blood animation
        timer.performWithDelay( -- remove after 0.2 s
            200,
            function()
                blood:removeSelf()
                blood = nil
            end,
            1
        )
    elseif (event.target.DisplayObject.Type == "armor") then
        timer.performWithDelay(1000, audio.play(soundTable["hp"])) -- play sound
        local ARMORpowerup =
            display.newImage("effects/AM.png", event.target.DisplayObject.x, event.target.DisplayObject.y) -- display armor pic
        display.remove(event.target.DisplayObject) -- remove destructible
        event.target.DisplayObject = nil
        timer.performWithDelay( -- remove after 0.2 s
            200,
            function()
                ARMORpowerup:removeSelf()
                ARMORpowerup = nil
            end
        )
    elseif (event.target.DisplayObject.Type == "heart") then
        timer.performWithDelay(1000, audio.play(soundTable["hp"])) -- play sound
        local HPpowerup = display.newImage("effects/hp.png", event.target.DisplayObject.x, event.target.DisplayObject.y) -- display heart effect
        display.remove(event.target.DisplayObject) -- remove
        event.target.DisplayObject = nil
        timer.performWithDelay( -- remove after 0.2 s
            200,
            function()
                HPpowerup:removeSelf()
                HPpowerup = nil
            end
        )
    end
end

-- Private function that handles collision events for destructibles.
local function onCollision(event)
    local this = event.target.pp
    local that = event.other.pp
    --print (this.DisplayObject.Type .. " got hit by ".. that.Type);
    if (event.phase == "began") then
        -- we hit heart
        if that.Type == "PlayerVehicle" and this.DisplayObject.Type == "heart" then
            -- we hit armor
            this.HP = this.HP - 1 -- reduce destructible health
            that.HP = that.HP + 21 -- increase our health when hit heart as the powerup~
            that.Score = that.Score + this.Value -- increase players score
        elseif that.Type == "PlayerVehicle" and this.DisplayObject.Type == "armor" then
            -- when we hit human or squirrel
            this.HP = this.HP - 1 -- reduce destructible health
            if that.Armor <= 95 then --  only when armor is lesser than or equal to 95
                that.Armor = that.Armor + 5 -- increase our armor when hit shield as the powerup~
            elseif that.Armor > 95 then
                that.Armor = 100 -- max cap for armor is 100
            end
            that.Score = that.Score + this.Value -- increase players score
        elseif
            that.Type == "PlayerVehicle" and
                (this.DisplayObject.Type == "human" or this.DisplayObject.Type == "squirrel")
         then
            this.HP = this.HP - 1
            that.Score = that.Score + this.Value -- increase players score
        end

        -- enemy hits destructible
        if that.Type == "EnemyVehicle" then
            this.HP = this.HP - 1 -- reduce destructible health
        end

        -- when destructible is dying
        if this.HP <= 0 then
            transition.cancel(this.DisplayObject)
            this.DisplayObject:dispatchEvent({name = "onDestruct", target = this})
        end

        -- send player stat change event
        Runtime:dispatchEvent({name = "onPlayerStatChanged"})
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
function Destructible:SpawnRandom()
    local rand = math.random(0, 100)
    -- only 10% chance will spwan a power up
    if rand < 10 then
        num = math.random(8, 9) -- powerups
    else
        num = math.random(0, 7) -- random destructibles
    end
    if num < 4 then
        if num == 0 then
            self.DisplayObject = display.newSprite(NPC.sheetNpc1, NPC.sequenceData)
            self.DisplayObject:setSequence("npc1_walk_left")
            self.DisplayObject.direction = "left"
            self.DisplayObject.x = display.contentWidth / 2 + math.random(150, 280)
            self.DisplayObject.Type = "human"
        elseif num == 1 then
            self.DisplayObject = display.newSprite(NPC.sheetNpc1, NPC.sequenceData)
            self.DisplayObject:setSequence("npc1_walk_right")
            self.DisplayObject.direction = "right"
            self.DisplayObject.x = 0
            self.DisplayObject.Type = "human"
        elseif num == 2 then
            self.DisplayObject = display.newSprite(NPC.sheetNpc2, NPC.sequenceData)
            self.DisplayObject:setSequence("npc2_walk_left")
            self.DisplayObject.direction = "left"
            self.DisplayObject.x = display.contentWidth / 2 + math.random(150, 280)
            self.DisplayObject.Type = "human"
        elseif num == 3 then
            self.DisplayObject = display.newSprite(NPC.sheetNpc2, NPC.sequenceData)
            self.DisplayObject:setSequence("npc2_walk_right")
            self.DisplayObject.direction = "right"
            self.DisplayObject.x = 0
            self.DisplayObject.Type = "human"
        end
    elseif num == 4 then
        self.DisplayObject = display.newSprite(SQUIRREL.sheet, SQUIRREL.sequenceData)
        self.DisplayObject:setSequence("squirrel")
        self.DisplayObject.direction = "left"
        self.DisplayObject.x = display.contentWidth / 2 + math.random(150, 280)
        self.DisplayObject.Type = "squirrel"
    elseif num == 5 then
        self.DisplayObject =
            display.newImage(
            NPC.sheetNpc1,
            1,
            display.contentWidth / 2 + math.random(-200, 200),
            math.random(-400, -350)
        )
        self.SpeedX = 0
        self.DisplayObject.Type = "human"
    elseif num == 6 then
        self.DisplayObject =
            display.newImage(
            NPC.sheetNpc2,
            1,
            display.contentWidth / 2 + math.random(-200, 200),
            math.random(-400, -350)
        )
        self.SpeedX = 0
        self.DisplayObject.Type = "human"
    elseif num == 7 then
        self.DisplayObject =
            display.newImage(
            SQUIRREL.sheet,
            1,
            display.contentWidth / 2 + math.random(-200, 200),
            math.random(-400, -350)
        )
        self.SpeedX = 0
        self.DisplayObject.Type = "squirrel"
    elseif num == 8 then
        -- heart picture found at https://commons.wikimedia.org/wiki/File:Love_Heart_SVG.svg
        self.DisplayObject =
            display.newImage(
            "npc/heart.png",
            display.contentWidth / 2 + math.random(-200, 200),
            math.random(-400, -350)
        )
        self.SpeedX = 0
        self.DisplayObject.Type = "heart"
    elseif num == 9 then
        -- armor picture found at https://www.vexels.com/png-svg/preview/129765/checked-shield-icon
        self.DisplayObject =
            display.newImage(
            "npc/armor.png",
            display.contentWidth / 2 + math.random(-200, 200),
            math.random(-400, -350)
        )
        self.SpeedX = 0
        self.DisplayObject.Type = "armor"
    end
    if num < 5 then
        self.DisplayObject.y = 0 - math.random(-300, 300)
        self.DisplayObject:play() -- play animation on the npc object
    end

    self.DisplayObject.pp = self -- Parent Object
    physics.addBody(self.DisplayObject, {isSensor = true}) -- adding physics
    self.DisplayObject:addEventListener("collision", onCollision) -- adding eventlistener on collision
    self.DisplayObject:addEventListener("onDestruct", onDestruct) -- adding eventlistener on destruct
    self.DisplayObject:toBack() -- put the back on the display order
    self:Move() -- make it move
end

return Destructible
--[[ Class definition
name = The name of the Destructible.
value = How much to add to the score of the player when the object is destroyed (0+).
armor = How much armor the Destructible has (0+). {used to calculate how much damage is caused to the player}
sprite = The sprite associated with this object.
]]
