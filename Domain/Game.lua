local Player = require("Domain.PlayerVehicle")
local Enemy = require("Domain.EnemyVehicle")
local Destructible = require("Domain.destructible")
local Widget = require("widget")
local Game = {}
local p
local deltatime = 0
local runtime = 0
local speedInc = 5
local pStatText
local statFormat = "AR: %d | HP: %d | SP: %d | SC: %d | E: %d"
local enemies = {}
local dests = {}
local enemyCount = 4
local curEnemyCount = 4
local startPos = {
    {x = 140, y = 462}, -- 1 postion
    {x = 140, y = 113}, -- 2 postion
    {x = 460, y = 113}, -- 3 postion
    {x = 460, y = 456} -- 4 postion
}
local destTimerRef

-- Initializes a new instance of the Game class.
function Game:new(obj)
    local t = obj or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

local function Move(event)
    if event.phase == "began" then
        event.target.markX = event.target.x
        event.target.markY = event.target.y
    elseif event.phase == "moved" then
        local x = (event.x - event.xStart) + event.target.markX
        local y = (event.y - event.yStart) + event.target.markY
        event.target.x = x
        event.target.y = y
    elseif event.phase == "ended" then
        print(event.target.tag .. ": " .. event.target.x .. "," .. event.target.y)
    end
end

-- This function will track game time.
function getDeltaTime()
    -- Get current game time in m
    local temp = system.getTimer()

    -- 60 fps as base
    deltaTime = (temp - runtime) / (1000 / 60)

    -- Store game time
    runtime = temp
end

-- add event listener
Runtime:addEventListener("enterFrame", getDeltaTime)

-- This custom event will change the player stats text.
function onPlayerStatChanged(event)
    pStatText.text = string.format(statFormat, p.Armor, p.HP, p.Speed, p.Score, curEnemyCount)
end

-- This custom event will remove a dead enemy from the table.
function onRemove(event)
    if event.target ~= nil then
        event.target = nil
        curEnemyCount = curEnemyCount - 1
        print("removed enemy")
    end
end

-- This function will start all enemies moving relative to the player
function startEnemies()
    for i, v in ipairs(enemies) do
        v:Start()
    end
end

-- This custom event will move the player vehicle.
function onMove(event)
    -- get direction
    local dir = event.direction

    if dir == "up" then
        if p.Speed < p.TopSpeed then
            -- increase player speed
            p.Speed = p.Speed + speedInc

            -- update player stats
            Runtime:dispatchEvent({name = "onPlayerStatChanged"})
        end
    elseif dir == "down" then
        if p.Speed > 0 then
            -- decrease player speed
            p.Speed = p.Speed - speedInc

            -- update player stats
            Runtime:dispatchEvent({name = "onPlayerStatChanged"})
        end
    elseif dir == "left" then
        -- turn left
        p:Turn("left")
    elseif dir == "right" then
        -- turn right
        p:Turn("right")
    end
end

-- This function will listen for keyboard events to simulate multitouch.
function onKey(event)
    if event.phase == "down" then
        -- get key
        local key = event.keyName
        if key == "up" then
            -- increase player speed
            Runtime:dispatchEvent({name = "onMove", direction = "up"})
        elseif key == "down" then
            -- decrease player speed
            Runtime:dispatchEvent({name = "onMove", direction = "down"})
        elseif key == "right" then
            -- turn right
            Runtime:dispatchEvent({name = "onMove", direction = "right"})
        elseif key == "left" then
            -- turn left
            Runtime:dispatchEvent({name = "onMove", direction = "left"})
        end
    end
end

-- Create game background.
function Game:createBg(sceneGroup)
    -- create left and right walls
    local left = display.newRect(0, 0, 110, display.actualContentHeight + 350)
    local right = display.newRect(display.contentWidth, 0, 110, display.actualContentHeight + 350)
    sceneGroup:insert(left)
    sceneGroup:insert(right)

    -- set collision types and parent object
    left.Type = "Wall"
    left.pp = left
    right.Type = "Wall"
    right.pp = right

    -- add static physics
    physics.addBody(left, "static")
    physics.addBody(right, "static")

    -- set image options
    local bg1Image = {type = "image", filename = "scrolling_bg/1.png"}
    local bg2Image = {type = "image", filename = "scrolling_bg/2.png"}

    -- create background images
    bg1 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg1.fill = bg1Image
    bg1.x = display.contentCenterX
    bg1.y = display.contentCenterY
    sceneGroup:insert(bg1)

    bg2 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg2.fill = bg2Image
    bg2.x = display.contentCenterX
    bg2.y = display.contentCenterY - display.actualContentHeight * 2
    sceneGroup:insert(bg2)

    bg3 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg3.fill = bg2Image
    bg3.x = display.contentCenterX
    bg3.y = display.contentCenterY - display.actualContentHeight
    sceneGroup:insert(bg3)
end

-- Create player HUB.
function Game:createHud(sceneGroup)
    -- create gas
    local gas = display.newRoundedRect(183, 616, 60, 95, 12)
    gas.strokeWidth = 2
    gas:setFillColor(102 / 255, 102 / 255, 153 / 255, 0.4)
    gas:setStrokeColor(0, 0, 0)
    gas.alpha = 0.40
    gas.tag = "gas"
    gas:addEventListener(
        "tap",
        function(event)
            Runtime:dispatchEvent({name = "onMove", direction = "up"})
            return true
        end
    )
    sceneGroup:insert(gas)

    -- create brake
    local brake = display.newRoundedRect(98, 619, 75, 65, 12)
    brake.strokeWidth = 2
    brake:setFillColor(102 / 255, 102 / 255, 153 / 255, 0.4)
    brake:setStrokeColor(0, 0, 0)
    brake.alpha = 0.40
    brake.tag = "brake"
    brake:addEventListener(
        "tap",
        function(event)
            Runtime:dispatchEvent({name = "onMove", direction = "down"})
            return true
        end
    )
    sceneGroup:insert(brake)

    -- create left arrow
    local points = {-40, -40, 40, -40, 0, 40}
    local left = display.newPolygon(397, 623, points)
    left:rotate(90)
    left.strokeWidth = 2
    left:setFillColor(0, 0, 0, 0.4)
    left:setStrokeColor(1, 1, 1)
    left.alpha = 0.40
    left.tag = "left"
    left:addEventListener(
        "tap",
        function(event)
            Runtime:dispatchEvent({name = "onMove", direction = "left"})
            return true
        end
    )
    sceneGroup:insert(left)

    -- create right arrow
    local points = {-40, -40, 40, -40, 0, 40}
    local right = display.newPolygon(505, 623, points)
    right:rotate(-90)
    right.strokeWidth = 2
    right:setFillColor(0, 0, 0, 0.4)
    right:setStrokeColor(1, 1, 1)
    right.alpha = 0.40
    right.tag = "right"
    right:addEventListener(
        "tap",
        function(event)
            Runtime:dispatchEvent({name = "onMove", direction = "right"})
        end
    )
    sceneGroup:insert(right)

    -- player stats
    pStatText =
        display.newEmbossedText(
        string.format(statFormat, p.Armor, p.HP, p.Speed, p.Score, curEnemyCount),
        display.contentCenterX,
        -342,
        native.systemFont,
        32
    )
    pStatText:setFillColor(0.5, 0, 0)
    local color = {
        highlight = {0, 1, 1},
        shadow = {0, 1, 1}
    }
    pStatText:setEmbossColor(color)
    pStatText.tag = "stat"
    sceneGroup:insert(pStatText)
    pStatText:addEventListener("touch", Move)
end

-- Create player.
function Game:createPlayer(sceneGroup)
    -- create new player vehicle
    p = Player:new()
    p:Spawn(display.contentWidth / 2, display.contentWidth / 2 + 150)
    sceneGroup:insert(p.DisplayObject)
end

-- Create enemy vehicles.
function Game:createEnemies(sceneGroup)
    -- create random enemy cars
    for i = 1, enemyCount do
        -- create new enemy
        local e = Enemy:new()

        -- spawn random enemy car
        e:SpawnRandom(startPos[i].x, startPos[i].y)

        -- pass the player object to the enemy class
        e.Player = p

        -- add enemy to the table
        table.insert(enemies, e)

        -- pass enemies table
        e.Enemies = enemies
    end
end

-- Create gameboard.
function Game:create(sceneGroup)
    -- create road background
    self:createBg(sceneGroup)

    -- create player
    self:createPlayer(sceneGroup)

    -- create player HUD
    self:createHud(sceneGroup)

    -- create enemy vehicles
    self:createEnemies(sceneGroup)
end

-- Create destructables randomly.
function Game:createDest(sceneGroup)
    destTimerRef =
        timer.performWithDelay(
        1000,
        function()
            -- generate random number of npc's
                local d = Destructible:new()
                d:SpawnRandom()
                print (d.DisplayObject.Type .. " is created in game");
                sceneGroup:insert(d.DisplayObject)
                table.insert(dests, d)
        end,
        -1
    )
end

-- This function will move the background based on the delta game time.
function moveBg()
    local scrollSpeed = p.Speed

    -- advance backgrounds
    bg1.y = bg1.y + scrollSpeed * deltaTime
    bg2.y = bg2.y + scrollSpeed * deltaTime
    bg3.y = bg3.y + scrollSpeed * deltaTime

    if scrollSpeed > 0 then
        for i, v in ipairs(dests) do
            v.SpeedY = scrollSpeed
        end
    else
        for i, v in ipairs(dests) do
            v.SpeedY = 0
        end
    end
    -- translate each background
    if (bg3.y - display.contentHeight / 2) > display.actualContentHeight then
        bg3:translate(0, -bg2.contentHeight * 2)
    end
    if (bg2.y - display.contentHeight / 2) > display.actualContentHeight then
        bg2:translate(0, -bg2.contentHeight * 2)
    end
end

-- Start game play.
function Game:start(sceneGroup)
    -- add move background event
    Runtime:addEventListener("enterFrame", moveBg)

    -- add keyboard event
    Runtime:addEventListener("key", onKey)

    -- add custom on move event
    Runtime:addEventListener("onMove", onMove)

    -- add custom player stat changed event
    Runtime:addEventListener("onPlayerStatChanged", onPlayerStatChanged)

    -- start enemies
    startEnemies()

    -- start creating destructibles
    self:createDest(sceneGroup)

    -- add enemies death special function
    Runtime:addEventListener("onRemove", onRemove)

end

-- This function will stop the game
function Game:stop()
    -- stop destructible timer
    if destTimerRef ~= nil then
        timer.cancel(destTimerRef)
    end

    -- remove move background event
    Runtime:removeEventListener("enterFrame", moveBg)

    -- remove keyboard event
    Runtime:removeEventListener("key", onKey)

    -- remove custom on move event
    Runtime:removeEventListener("onMove", onMove)

    -- remove custom player stat changed event
    Runtime:removeEventListener("onPlayerStatChanged", onPlayerStatChanged)
    local options = { effect = "fade", time = 500 }
    composer.gotoScene( 'ending_scenece', options );


    -- remove enemies death special function
    Runtime:removeEventListener("onRemove", onRemove)
end

return Game
