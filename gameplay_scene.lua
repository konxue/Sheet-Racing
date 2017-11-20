local composer = require( "composer" )
local PlayerVehicle = require("Domain.PlayerVehicle");
local Car = require("vehicle.Car");
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

local widget = require('widget')
local physics = require("physics");
physics:start();
local carGroup = display.newGroup();
local car1;
local car2;
local v = 3; -- velocity of the car
--local carStop = false;

physics.setDrawMode("hybrid")

local left = display.newRect(0,0, 110, display.actualContentHeight + 350);
local right = display.newRect(display.contentWidth,0 ,110,display.actualContentHeight + 350);
physics.addBody( left, "static" );
left.myName = "Left wall";
right.myName = "Right wall";
physics.addBody( right, "static" );
physics.setGravity (0,0); -- no gravity

-- this function will handle the moving of the fish
local  function onMove(event)
    if event.phase == "began" then
		event.target.markX = event.target.x;
	 elseif event.phase == "moved" then
		local x = (event.x - event.xStart) + event.target.markX;
    if (x < 50 or x > display.contentWidth - 50) then
      return
    end
		event.target.x = x;

	end
end

local function carMaker()
    local car1 = display.newImage (sheetCar, 1, display.contentWidth/2, display.contentWidth/2+533);
    physics.addBody(car1)
end

local function onLocalCollision( self, event )

    if ( event.phase == "began" ) then
        print( self.myName .. " hits the " .. event.other.myName )
        -- makeing sounds
        -- do what it suppose to do, decrease hp, gain money... etc....
    elseif ( event.phase == "ended" ) then
        --print( "ended: " .. self.myName .. " hit the " .. event.other.myName )
    end
end

function addScrollableBg()
    local bg1Image = { type="image", filename="scrolling_bg/1.png" }
    local bg2Image = { type="image", filename="scrolling_bg/2.png" }

    bg1 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg1.fill = bg1Image
    bg1.x = display.contentCenterX
    bg1.y = display.contentCenterY

    bg2 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg2.fill = bg2Image
    bg2.x = display.contentCenterX
    bg2.y = display.contentCenterY - display.actualContentHeight * 2

    bg3 = display.newRect(0, 0, display.contentWidth, display.actualContentHeight)
    bg3.fill = bg2Image
    bg3.x = display.contentCenterX
    bg3.y = display.contentCenterY - display.actualContentHeight
end

local scrollSpeed = 15

local function moveBg(dt)
    bg1.y = bg1.y + scrollSpeed * dt
    bg2.y = bg2.y + scrollSpeed * dt
    bg3.y = bg3.y + scrollSpeed * dt

    if (bg3.y - display.contentHeight / 2) > display.actualContentHeight then
      bg3:translate(0, -bg2.contentHeight * 2)
    end
    if (bg2.y - display.contentHeight / 2) > display.actualContentHeight then
      bg2:translate(0, -bg2.contentHeight * 2)
    end
end

local runtime = 0

local function getDeltaTime()
   local temp = system.getTimer()
   local dt = (temp-runtime) / (1000/60)
   runtime = temp
   return dt
end

local function enterFrame()
    local dt = getDeltaTime()
    moveBg(dt)
end

function init()
    addScrollableBg()
    Runtime:addEventListener("enterFrame", enterFrame)
end
 --end


local function carMaker()
    local car1 = display.newImage (sheetCar, 1, display.contentWidth/2, display.contentWidth/2+150);
    physics.addBody(car1, { density=1, friction=0.1, bounce=0.2 });
    car1.myName = "Your car";
    car1:addEventListener( "touch", onMove);
    car1.collision = onLocalCollision
    car1:addEventListener( "collision" )
    function moveCar()
      car1.y = car1.y - v;
    end

    timer.performWithDelay( 30,
    --function ()
    moveCar
  --  end
    , 50)
end

local function enemyMaker()
  local num = math.random(2,9);
  local car2;
  local car2v;
  if num <= 7 then
    car2 = display.newImage (Car.sheet, num, display.contentWidth/2+math.random(-160,160), display.contentWidth/2+400);
    car2v = 15;
    if num == 2 then
      car2.myName = "BlackViper";
    elseif num == 3 then
      car2.myName = "OrangeCar";
    elseif mum == 4 then
      car2.myName = "Blue Minitruck";
    elseif num == 5 then
      car2.myName = "Minivan";
    elseif num == 6 then
      car2.myName = "Taxi";
    elseif num == 7 then
      car2.myName = "Truck"
    end
  elseif num == 8 then
    car2 = display.newSprite(Car.sheet, Car.sequenceData);
	car2:setSequence("ambulance");
    car2.x = display.contentWidth/2+math.random(-160,160);
    car2.y = display.contentWidth/2+400;
    car2v = 35;
    car2:play();
    car2.myName = "Ambulance";
  elseif num == 9 then
    car2 = display.newSprite(Car.sheet, Car.sequenceData);
	car2:setSequence("police");
    car2.x = display.contentWidth/2+math.random(-160,160);
    car2.y = display.contentWidth/2+400;
    car2v = 35;
    car2:play();
    car2.myName = "Police Car";
end
    physics.addBody(car2, { density=1, friction=0.3, bounce=0.2 });

    --car2.collision = onLocalCollision
    --car2:addEventListener( "collision" )
    function moveCar2()
        car2.y = car2.y - car2v;
    end
    timer.performWithDelay( 30,
    --function ()
    moveCar2
  --  end
    , 100)
    if car2.y < (display.contentWidth/2 - 100) then
      print (car2.myName .. " is removed");
      car2:removeSelf();
      car2 = nil;
    end
end






--mapMaker();
-- Show countdown timer for round start

init();
player = PlayerVehicle:new();
player:Spawn(display.contentWidth/2, display.contentWidth/2+150);
--carMaker();


local function randomObject()
  timer.performWithDelay( 5000,
  enemyMaker
  -- adding the objects to the screen every 10s, at random x,y
  -- adding physics to the object
  -- Make object moving downward
  , 100)
end



randomObject();

-- to do list
-- collision handler
-- health points + on screen text
-- remove car after collision




---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
