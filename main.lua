display.setStatusBar( display.HiddenStatusBar )
local composer = require('composer')
--[[
local bg = display.newImageRect("bg.jpg", 1600 , 2600);
bg.isVisible = true;
local widget = require('widget')
local carGroup = display.newGroup();
local car1;
local carStop = false;
-- this function will handle the moving of the fish
]]
local  function onMove(event)
    if event.phase == "began" then
		event.target.markX = event.target.x;
		event.target.markY = event.target.y;
	 elseif event.phase == "moved" then
		local x = (event.x - event.xStart) + event.target.markX;
		local y = (event.y - event.yStart) + event.target.markY;
		event.target.x = x;
		event.target.y = y;

    print ("x: ".. event.target.x .. " y: " .. event.target.y);

    print("x: ".. event.target.x .. " y: " .. event.target.y);

    print("x: ".. event.target.x .. " y: " .. event.target.y);

	end
end

  -----------------------------background--------------------------------

  local optionsMap =
{
  frames = {
      { x = 119, y = 122, width = 533, height = 533}, -- Vertical tile 1
      { x = 783, y = 122, width = 533, height = 533}, -- Horizontal tile 2
      { x = 119, y = 771, width = 533, height = 533}, -- Start tile 3
      { x = 783, y = 771, width = 533, height = 533}, -- Finish tile 4
      { x = 2297, y = 122, width = 533, height = 533}, -- Left tile 5
      { x = 1643, y = 122, width = 533, height = 533}, -- Right tile 6
      { x = 1643, y = 771, width = 533, height = 533}, -- left up tile 7
      { x = 2297, y = 771, width = 533, height = 533}, -- Right up tile 8
  }
};
  local sheetMap = graphics.newImageSheet( "map.png", optionsMap );

local optionsCar =
{
  frames = {
    { x = 193, y = 39, width = 98, height = 214},   -- 1 Audi
    { x = 351, y = 33, width = 107, height = 220},  -- 2 BlackViper
    { x = 521, y = 42, width = 92, height = 218},   -- 3 OrangeCar
    { x = 41, y = 42, width = 102, height = 207},   -- 4 Ambulance still
    { x = 41, y = 301, width = 102, height = 207},  -- 5 Ambulance animation xxo
    { x = 41, y = 558, width = 102, height = 207},  -- 6 Ambulance animation xox
    { x = 193, y = 558, width = 102, height = 207}, -- 7 Ambulance animation oxx
    { x = 660, y = 48, width = 111, height = 204},  -- 8 Blue Minitruck
    { x = 819, y = 53, width = 93, height = 196},   -- 9 MiniVan
    { x = 189, y = 288, width = 116, height = 234}, -- 10 Taxi
    { x = 351, y = 305, width = 144, height = 292}, -- 11 Truck
    { x = 521, y = 324, width = 98, height = 214},  -- 12 Police still
    { x = 521, y = 358, width = 98, height = 214},  -- 13 Police Animation oxx
    { x = 686, y = 558, width = 98, height = 214},  -- 14 Police Animation oxo
    { x = 845, y = 558, width = 98, height = 214},  -- 15 Police Animation xxo
  }
}
  local sheetCar = graphics.newImageSheet( "car.png", optionsCar );

  -- each map block is 533 x 533 size,
  -- Bottom one: contentWidth/2, contentWidth/2 + 530
--[[
local function mapMaker ()
    local map1 = display.newImage (sheetMap, 3, display.contentWidth/2, display.contentWidth/2+533);
    local map2 = display.newImage (sheetMap, 6, display.contentWidth/2, display.contentWidth/2);
    local map3 = display.newImage (sheetMap, 8, display.contentWidth/2+533, display.contentWidth/2);
 end
 ]]


  local function carMaker()
  car1 = display.newImage (sheetCar, 1, display.contentWidth/2, display.contentWidth/2+533);
  --car1:addEventListener( "touch", onMove);
  end

function carMove(event) -- move upward 10 pixel every 1/10 second
  event.target.y = event.target.y-10;
 end
--timer.performWithDelay( 1000, car1:carMove, 20 );
  --mapMaker();
  --carMaker();
  --local function carOFF()
  --carStop = true;
  --end

--car1:addEventListener("tap", carMove);
  --while (carStop == false) do
  -- carMove(car1),3)
  --carMove(car1)
  --end

local function carMaker()
    local car1 = display.newImage (sheetCar, 1, display.contentWidth/2, display.contentWidth/2+533);
end

--local function mapMaker ()
  --[[
    local map1 = display.newImage (sheetMap, 3, display.contentWidth/2, display.contentWidth/2+533);
    local map2 = display.newImage (sheetMap, 6, display.contentWidth/2, display.contentWidth/2);
    local map3 = display.newImage (sheetMap, 8, display.contentWidth/2+533, display.contentWidth/2);
    ]]
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

local scrollSpeed = 25

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
    local car1 = display.newImage (sheetCar, 1, display.contentWidth/2, display.contentWidth/2);


    car1:addEventListener( "touch", onMove);
end


-- mapMaker();
-- carMaker();

--mapMaker();



--init()
--carMaker();

composer.gotoScene( 'title_scene' )
