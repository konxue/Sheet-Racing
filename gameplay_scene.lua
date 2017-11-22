local composer = require("composer")
local PlayerVehicle = require("Domain.PlayerVehicle")
local soundTable = require("sounds.soundTable")
local Car = require("vehicle.Car")
local NPC = require("npc.npc")
local SQUIRREL = require("npc.squirrel")
local scene = composer.newScene()
local widget = require("widget")
local physics = require("physics")
local Game = require("Domain.Game")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- start and setup physics
physics:start()
physics.setDrawMode("hybrid")
physics.setGravity(0, 0) -- no gravity

local game
-- local carGroup = display.newGroup();
-- local car1;
-- local car2;
-- local v = 3; -- velocity of the car
-- --local carStop = false;

-- local left = display.newRect(0,0, 110, display.actualContentHeight + 350);
-- local right = display.newRect(display.contentWidth,0 ,110,display.actualContentHeight + 350);
-- physics.addBody( left, "static" );
-- left.myName = "Left wall";
-- right.myName = "Right wall";
-- physics.addBody( right, "static" );

-- -- this function will handle the moving of the fish
-- local  function onMove(event)
--     if event.phase == "began" then
-- 		event.target.markX = event.target.x;
-- 	 elseif event.phase == "moved" then
-- 		local x = (event.x - event.xStart) + event.target.markX;
--     if (x < 50 or x > display.contentWidth - 50) then
--       return
--     end
-- 		event.target.x = x;

-- 	end
-- end

-- local function carMaker()
--     local car1 = display.newImage (sheetCar, 1, display.contentWidth/2, display.contentWidth/2+533);
--     physics.addBody(car1)
-- end

-- local function onLocalCollision( event )

--     if ( event.phase == "began" ) then
--       --blood animation
--       event.target:removeSelf();
--       --event.target = nil;
--         --print( event.target.myName .. " got hit by " .. event.other.myName )
--       --  audio.play( soundTable["hurt"] );
--         -- do what it suppose to do, decrease hp, gain money... etc....
--     end
-- end

-- function addScrollableBg()
--     local bg1Image = { type="image", filename="scrolling_bg/1.png" }
--     local bg2Image = { type="image", filename="scrolling_bg/2.png" }

--     bg1 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
--     bg1.fill = bg1Image
--     bg1.x = display.contentCenterX
--     bg1.y = display.contentCenterY

--     bg2 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
--     bg2.fill = bg2Image
--     bg2.x = display.contentCenterX
--     bg2.y = display.contentCenterY - display.actualContentHeight * 2

--     bg3 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
--     bg3.fill = bg2Image
--     bg3.x = display.contentCenterX
--     bg3.y = display.contentCenterY - display.actualContentHeight
-- end

-- local scrollSpeed = 15

-- local function moveBg(dt)
--     bg1.y = bg1.y + scrollSpeed * dt
--     bg2.y = bg2.y + scrollSpeed * dt
--     bg3.y = bg3.y + scrollSpeed * dt

--     if (bg3.y - display.contentHeight / 2) > display.actualContentHeight then
--       bg3:translate(0, -bg2.contentHeight * 2)
--     end
--     if (bg2.y - display.contentHeight / 2) > display.actualContentHeight then
--       bg2:translate(0, -bg2.contentHeight * 2)
--     end
-- end

-- local runtime = 0

-- local function getDeltaTime()
--    local temp = system.getTimer()
--    local dt = (temp-runtime) / (1000/60)
--    runtime = temp
--    return dt
-- end

-- local function enterFrame()
--     local dt = getDeltaTime()
--     moveBg(dt)
-- end

-- function init()
--     addScrollableBg()
--     Runtime:addEventListener("enterFrame", enterFrame)
-- end
--  --end

-- local function carMaker()
--     local car1 = display.newImage (sheetCar, 1, display.contentWidth/2, display.contentWidth/2+150);
--     physics.addBody(car1, { density=1, friction=0.1, bounce=0.2 });
--     car1.myName = "Your car";
--     car1:addEventListener( "touch", onMove);
--     car1.collision = onLocalCollision
--     car1:addEventListener( "collision" )
--     function moveCar()
--       car1.y = car1.y - v;
--     end

--     timer.performWithDelay( 30,
--     --function ()
--     moveCar
--   --  end
--     , 50)
-- end

-- local function enemyMaker()
--   local num = math.random(2,9);
--   local car2;
--   local car2v;
--   if num <= 7 then
--     car2 = display.newImage (Car.sheet, num, display.contentWidth/2+math.random(-160,160), display.contentWidth/2+400);
--     car2v = 15;
--     if num == 2 then
--       car2.myName = "BlackViper";
--     elseif num == 3 then
--       car2.myName = "OrangeCar";
--     elseif mum == 4 then
--       car2.myName = "Blue Minitruck";
--     elseif num == 5 then
--       car2.myName = "Minivan";
--     elseif num == 6 then
--       car2.myName = "Taxi";
--     elseif num == 7 then
--       car2.myName = "Truck"
--     end
--   elseif num == 8 then
--     car2 = display.newSprite(Car.sheet, Car.sequenceData);
-- 	car2:setSequence("ambulance");
--     car2.x = display.contentWidth/2+math.random(-160,160);
--     car2.y = display.contentWidth/2+400;
--     car2v = 35;
--     car2:play();
--     car2.myName = "Ambulance";
--   elseif num == 9 then
--     car2 = display.newSprite(Car.sheet, Car.sequenceData);
-- 	car2:setSequence("police");
--     car2.x = display.contentWidth/2+math.random(-160,160);
--     car2.y = display.contentWidth/2+400;
--     car2v = 35;
--     car2:play();
--     car2.myName = "Police Car";
-- end
--     physics.addBody(car2, { density=1, friction=0.3, bounce=0.2 });

--     --car2.collision = onLocalCollision
--     --car2:addEventListener( "collision" )
--     function moveCar2()
--         car2.y = car2.y - car2v;
--     end
--     timer.performWithDelay( 30,
--     --function ()
--     moveCar2
--   --  end
--     , 100);
--     timer.performWithDelay( 8000, function()
--       car2:removeSelf();
--       car2 = nil;
--       end);
-- end

-- local function objectMaker()
--     local num = math.random(0,4);
--     local object1v = 5;
--     local object1;
--     if num < 4 then
--       if num == 0 then
--         object1 = display.newSprite(NPC.sheetNpc1, NPC.sequenceData);
--         object1:setSequence("npc1_walk_left");
--         object1.myName = "NPC1 left";
--       elseif num == 1 then
--         object1 = display.newSprite(NPC.sheetNpc1, NPC.sequenceData);
--         object1:setSequence("npc1_walk_right");
--         object1.myName = "NPC1 right";
--       elseif num == 2 then
--         object1 = display.newSprite(NPC.sheetNpc2, NPC.sequenceData);
--         object1:setSequence("npc2_walk_left");
--         object1.myName = "NPC2 left";
--       elseif num == 3 then
--         object1 = display.newSprite(NPC.sheetNpc2, NPC.sequenceData);
--         object1:setSequence("npc2_walk_right");
--         object1.myName = "NPC2 right";
--       end
--     else
--       object1 = display.newSprite(SQUIRREL.sheet, SQUIRREL.sequenceData);
--       object1:setSequence("squirrel");
--       object1.myName = "squirrel";
--     end
--       object1.x = display.contentWidth/2 + math.random(-50,50);
--       object1.y = display.contentWidth/2 - 800;
--       object1:play();
--       physics.addBody(object1, { density=1, friction=0.3, bounce=0.2 });
--       object1:addEventListener("collision", onLocalCollision);
--       -- error occured on collision, object is deleted by removeself in the onLocalCollision, but it still change its x, y to make it moves.
--       timer.performWithDelay( 50,
--       function ()
--         if object1 ~= nil then
--           if num == 1 or num == 3 then
--             object1.x = object1.x + object1v;
--           elseif num == 2 or num == 4 then
--             object1.x = object1.x - object1v;
--           end
--           object1.y = object1.y + object1v*3;
--         end
--       end
--     , 50)
-- end

--mapMaker();
-- Show countdown timer for round start

--init();
--player = PlayerVehicle:new();
--player:Spawn(display.contentWidth/2, display.contentWidth/2+150);
--carMaker();

-- local function randomObject()
--     timer.performWithDelay(
--         5000,
--         function()
--             enemyMaker()
--             if math.random(0, 100) < 50 then
--                 objectMaker()
--             end
--         end,
--         -- adding the objects to the screen every 10s, at random x,y
--         -- adding physics to the object
--         -- Make object moving downward
--         100
--     )
-- end

--randomObject();

-- to do list
-- collision handler
-- health points + on screen text
-- remove car after collision

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create(event)
    local sceneGroup = self.view

    -- create game class.
    game = Game:new()

    -- create game board
    game:create(sceneGroup)
end

-- "scene:show()"
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif (phase == "did") then
        -- start game
        game:start(sceneGroup)
    end
end

-- "scene:hide()"
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- stop game
        game:stop()
    elseif (phase == "did") then
    -- Called immediately after scene goes off screen.
    end
end

-- "scene:destroy()"
function scene:destroy(event)
    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

---------------------------------------------------------------------------------

return scene
